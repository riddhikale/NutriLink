from intent_detection import detect_intent
from language_detection import detect_language

from fastapi import FastAPI, UploadFile, File
from faster_whisper import WhisperModel

import shutil
import os
import time
import soundfile as sf
import librosa
import numpy as np

app = FastAPI()

model = WhisperModel(
    "small",
    device="cpu",
    compute_type="int8"
)

INITIAL_PROMPT = (
    "This is a voice command in Hindi, Marathi, or English. "
    "Commands include: register child, pregnant screening, add beneficiary, "
    "followups, meal plan, high risk, medium risk, low risk, home, profile, settings, work history. "
    "मुलाचे स्क्रीनिंग, गर्भवती महिला, नवीन लाभार्थी, फॉलोअप्स दाखवा, "
    "आहार योजना, होम उघडा, सेटिंग उघडा, हाय रिस्क, मीडियम रिस्क."
)

# Warmup librosa
_dummy = np.zeros(16000, dtype=np.float32)
sf.write("warmup.wav", _dummy, 16000)
librosa.load("warmup.wav", sr=16000, mono=True)
os.remove("warmup.wav")
print("✅ Librosa warmed up")


def is_hallucination(text: str) -> bool:
    if not text or len(text) < 5:
        return True
    words = text.split()
    if len(words) < 2:
        return False
    for word in set(words):
        if words.count(word) > 4:
            return True
    return False


@app.post("/transcribe")
async def transcribe_audio(file: UploadFile = File(...)):

    t_total = time.time()

    t = time.time()
    temp_audio = f"temp_{file.filename}"
    with open(temp_audio, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)
    print(f"⏱ File save:        {time.time() - t:.2f}s")

    t = time.time()
    converted_audio = "converted_audio.wav"
    try:
        audio, sr = librosa.load(temp_audio, sr=16000, mono=True)
        sf.write(converted_audio, audio, 16000)
    except Exception as e:
        print(f"❌ Audio conversion failed: {e}")
        os.remove(temp_audio)
        return {"error": "Audio conversion failed"}
    print(f"⏱ Audio convert:    {time.time() - t:.2f}s")

    t = time.time()
    segments, info = model.transcribe(
        converted_audio,
        beam_size=1,
        task="transcribe",
        initial_prompt=INITIAL_PROMPT,
        condition_on_previous_text=False,
        no_speech_threshold=0.6,
        compression_ratio_threshold=1.8,
        temperature=0.0,
    )
    segments = list(segments)
    transcription = "".join([s.text for s in segments]).lower().strip()
    print(f"⏱ Whisper:          {time.time() - t:.2f}s")
    print(f"   Transcription:   {transcription}")
    print(f"   Whisper lang:    {info.language} ({info.language_probability:.0%})")

    if is_hallucination(transcription):
        print("⚠️  Hallucination detected — returning unknown")
        os.remove(temp_audio)
        os.remove(converted_audio)
        return {
            "transcription": transcription,
            "language": "en",
            "language_confidence": 0.0,
            "intent": "unknown"
        }

    t = time.time()
    intent = detect_intent(transcription)
    print(f"⏱ Intent detect:    {time.time() - t:.2f}s  →  {intent}")

    t = time.time()
    # KEY FIX: pass Whisper's own language + confidence
    language = detect_language(
        transcription,
        whisper_lang=info.language,
        whisper_confidence=info.language_probability
    )
    print(f"⏱ Lang detect:      {time.time() - t:.2f}s  →  {language}")

    os.remove(temp_audio)
    os.remove(converted_audio)

    print(f"⏱ TOTAL:            {time.time() - t_total:.2f}s")

    return {
        "transcription": transcription,
        "language": language,
        "language_confidence": round(info.language_probability, 2),
        "intent": intent
    }