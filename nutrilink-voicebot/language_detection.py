from langdetect import detect, DetectorFactory
import re

DetectorFactory.seed = 0

DEVANAGARI_PATTERN = re.compile(r'[\u0900-\u097F]')

MARATHI_SPECIFIC = [
    "उघडा", "उगडा", "उबडा", "दाखवा", "करा",
    "जोडा", "नोंदवा", "बाळ", "मुल", "मुलाचे",
    "मुलाची", "आहार", "नवीन", "नवी", "महिलांचे",
]

HINDI_SPECIFIC = [
    "जोड़ो", "दिखाओ", "बनाओ", "बच्चा", "नया",
    "डाइट", "गर्भवती", "लाभार्थी", "फॉलोअप्स",
]


TRANSLITERATED_ENGLISH = [
    "प्रोफाइल", "प्रोफाईल", "प्रोफाएल", "प्रुफाएल",
    "प्रोँप्टाल", "प्रोपाल", "प्रोपालिए", "प्रोँपाई",
    "उप्वाईल", "चुट्रोफाडल",
    "सेटिंग", "सेटिंग्स", "होम", "हिस्ट्री", "लिएस्ट्री",
    "रिस्क", "स्क्रीनिंग", "फॉलोअप्स", "फॉलोप्स",
    "बेनिफिशरी", "बनिफिशरी",
    "प्रगनेड", "वोमन",
]


def detect_language(text: str, whisper_lang: str = "en", whisper_confidence: float = 0.0) -> str:

    if not text:
        return "en"

    text_clean = text.lower().strip()


    if text_clean.isascii():
        if whisper_confidence >= 0.4 and whisper_lang in ["hi", "mr", "en"]:
            return whisper_lang
        return "en"


    if whisper_confidence >= 0.5 and whisper_lang in ["hi", "mr", "en"]:
        if whisper_lang == "en":

            for word in MARATHI_SPECIFIC:
                if word in text:
                    return "mr"
            for word in HINDI_SPECIFIC:
                if word in text:
                    return "hi"
        return whisper_lang


    if DEVANAGARI_PATTERN.search(text):


        temp = text_clean
        for word in TRANSLITERATED_ENGLISH:
            temp = temp.replace(word.lower(), "")

        if not DEVANAGARI_PATTERN.search(temp):
            return "en"

        for word in MARATHI_SPECIFIC:
            if word in text:
                return "mr"
        for word in HINDI_SPECIFIC:
            if word in text:
                return "hi"

        return "mr"  # default to Marathi (Maharashtra app)


    marathi_roman = ["kara", "ughada", "dakhva", "navin", "aahar"]
    hindi_roman   = ["karo", "dikhao", "naya", "bachcha", "jodo"]

    for word in marathi_roman:
        if word in text_clean:
            return "mr"
    for word in hindi_roman:
        if word in text_clean:
            return "hi"


    try:
        lang = detect(text)
        if lang in ["hi", "mr"]:
            return lang
    except Exception:
        pass

    return "en"