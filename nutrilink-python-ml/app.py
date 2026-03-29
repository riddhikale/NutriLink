from intent_detection import detect_intent
from fastapi import FastAPI, UploadFile, File
import whisper
import shutil
import os

# ffmpeg path
os.environ["PATH"] += os.pathsep + r"D:\ffmeg-ML\ffmpeg-8.0.1-essentials_build\bin"

app = FastAPI()

model = whisper.load_model("base")

@app.post("/transcribe")
async def transcribe_audio(file: UploadFile = File(...)):

    temp_audio = f"temp_{file.filename}"

    with open(temp_audio, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    result = model.transcribe(
        temp_audio,
        task="transcribe",
        language=None,
        temperature=0,
        initial_prompt="The speaker may speak English, Hindi or Marathi about beneficiaries, child screening, pregnant women, followups and nutrition."
    )

    # transcription text
    transcription = result["text"].strip()

    # detected language from whisper
    language = result["language"]

    print("Transcription:", transcription)
    print("Language:", language)

    intent = detect_intent(transcription)

    print("Intent:", intent)

    os.remove(temp_audio)

    return {
        "transcription": transcription,
        "intent": intent,
        "language": language
    }