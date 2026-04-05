from intent_detection import detect_intent
from language_detection import detect_language

from fastapi import FastAPI, UploadFile, File
from faster_whisper import WhisperModel

import shutil
import os
import time
import soundfile as sf
import librosa

app = FastAPI()

model = WhisperModel(
    "small",
    device="cpu",
    compute_type="int8"
)

INITIAL_PROMPT = (
    "This is a voice command in Hindi, Marathi, or English. "
    "Commands include: register child, pregnant screening, add beneficiary, "
    "followups, meal plan, high risk, home, profile, settings, work history. "
    "मुलाचे स्क्रीनिंग, गर्भवती महिला, नवीन लाभार्थी, फॉलोअप्स दाखवा, "
    "आहार योजना, होम उघडा, सेटिंग उघडा."
)


@app.post("/transcribe")
async def transcribe_audio(file: UploadFile = File(...)):

    t_total = time.time()

    # ── 1. Save uploaded file ──────────────────────────────
    t = time.time()
    temp_audio = f"temp_{file.filename}"
    with open(temp_audio, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)
    print(f"⏱ File save:        {time.time() - t:.2f}s")

    # ── 2. Convert audio ───────────────────────────────────
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

    # ── 3. Transcribe ──────────────────────────────────────
    t = time.time()
    segments, info = model.transcribe(
        converted_audio,
        beam_size=1,
        task="transcribe",
        initial_prompt=INITIAL_PROMPT,

        # KEY FIXES for runaway latency spikes:
        condition_on_previous_text=False,  # stops hallucination loops
        no_speech_threshold=0.6,           # skip silent/noise segments fast
        compression_ratio_threshold=2.0,   # reject repetitive hallucinated output
        temperature=0.0,                   # greedy — no sampling randomness
    )
    segments = list(segments)  # force eager evaluation
    transcription = "".join([s.text for s in segments]).lower().strip()
    print(f"⏱ Whisper:          {time.time() - t:.2f}s")
    print(f"   Transcription:   {transcription}")
    print(f"   Whisper lang:    {info.language} ({info.language_probability:.0%})")

    # ── 4. Intent detection ────────────────────────────────
    t = time.time()
    intent = detect_intent(transcription)
    print(f"⏱ Intent detect:    {time.time() - t:.2f}s  →  {intent}")

    # ── 5. Language detection ──────────────────────────────
    t = time.time()
    language = detect_language(transcription)
    print(f"⏱ Lang detect:      {time.time() - t:.2f}s  →  {language}")

    # ── Cleanup ────────────────────────────────────────────
    os.remove(temp_audio)
    os.remove(converted_audio)

    print(f"⏱ TOTAL:            {time.time() - t_total:.2f}s")

    return {
        "transcription": transcription,
        "language": language,
        "language_confidence": round(info.language_probability, 2),
        "intent": intent
    }