from intent_detection import detect_intent
from language_detection import detect_language

from fastapi import FastAPI, UploadFile, File
from faster_whisper import WhisperModel

import shutil
import os
import subprocess

os.environ["PATH"] += os.pathsep + r"D:\ffmeg-ML\ffmpeg-8.0.1-essentials_build\bin"

app = FastAPI()

model = WhisperModel(
    "small",
    device="cpu",
    compute_type="int8"
)

# Biases Whisper toward Indic + English mixed speech without forcing a language
INITIAL_PROMPT = (
    "This is a voice command in Hindi, Marathi, or English. "
    "Commands include: register child, pregnant screening, add beneficiary, "
    "followups, meal plan, high risk, home, profile, settings, work history. "
    "मुलाचे स्क्रीनिंग, गर्भवती महिला, नवीन लाभार्थी, फॉलोअप्स दाखवा, "
    "आहार योजना, होम उघडा, सेटिंग उघडा."
)


@app.post("/transcribe")
async def transcribe_audio(file: UploadFile = File(...)):

    temp_audio = f"temp_{file.filename}"

    with open(temp_audio, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    converted_audio = "converted_audio.wav"

    subprocess.run([
        "ffmpeg",
        "-y",
        "-i", temp_audio,
        "-ac", "1",
        "-ar", "16000",
        converted_audio
    ], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

    # No forced language — let Whisper auto-detect
    # initial_prompt biases toward your domain vocabulary
    segments, info = model.transcribe(
        converted_audio,
        beam_size=1,
        task="transcribe",
        initial_prompt=INITIAL_PROMPT,
        vad_filter=True,
        vad_parameters=dict(min_silence_duration_ms=500)
    )

    transcription = "".join([s.text for s in segments]).lower().strip()

    print(f"Transcription: {transcription}")
    print(f"Whisper detected language: {info.language} ({info.language_probability:.0%} confidence)")

    intent = detect_intent(transcription)

    # Whisper's detection as primary, text-based as fallback
    if info.language in ["hi", "mr", "en"]:
        language = info.language
    else:
        language = detect_language(transcription)

    print(f"Intent: {intent}")
    print(f"Language: {language}")

    os.remove(temp_audio)
    os.remove(converted_audio)

    return {
        "transcription": transcription,
        "language": language,
        "language_confidence": round(info.language_probability, 2),
        "intent": intent
    }