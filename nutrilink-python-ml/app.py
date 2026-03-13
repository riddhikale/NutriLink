from unittest import result

from intent_detection import detect_intent
from fastapi import FastAPI, UploadFile, File
import whisper
import shutil
import os

# add ffmpeg to PATH
os.environ["PATH"] += os.pathsep + r"D:\ffmeg-ML\ffmpeg-8.0.1-essentials_build\bin"

app = FastAPI()

model = whisper.load_model("tiny")

@app.post("/transcribe")
async def transcribe_audio(file: UploadFile = File(...)):

    temp_audio = f"temp_{file.filename}"

    with open(temp_audio, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    result = model.transcribe(temp_audio)

    transcription = result["text"]

    intent = detect_intent(transcription)

    os.remove(temp_audio)

    return {
        "transcription": transcription,
        "intent": intent
    }