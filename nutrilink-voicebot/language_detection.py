from langdetect import detect, DetectorFactory
import re

DetectorFactory.seed = 0

DEVANAGARI_PATTERN = re.compile(r'[\u0900-\u097F]')

MARATHI_GENUINE = [
    "उघडा", "उगडा", "उबडा", "दाखवा",
    "जोडा", "नोंदवा", "बाळ", "मुलाचे", "मुलाची",
    "आहार", "नवीन", "महिलांचे", "गर्भवती",
    "लाभार्थी", "जोखमीची",
]

HINDI_GENUINE = [
    "जोड़ो", "दिखाओ", "बनाओ", "बच्चा",
    "नया", "डाइट", "फॉलोअप्स",
]

TRANSLITERATED_ENGLISH = [
    "प्रोफाइल", "प्रोफाईल", "प्रोफाएल", "प्रुफाएल",
    "प्रोँप्टाल", "प्रोपाल", "प्रोपालिए", "प्रोँपाई",
    "उप्वाईल", "चुट्रोफाडल", "अपन्ट्रोफाएल",
    "सेटिंग", "सेटिंग्स", "होम", "हिस्ट्री",
    "लिएस्ट्री", "लिएख़िस्ट्री",
    "रिस्क", "स्क्रीनिंग", "फॉलोअप्स", "फॉलोप्स",
    "बेनिफिशरी", "बनिफिशरी", "बनिविश्व्रीव",
    "प्रगनेड", "वोमन", "वुमन",
    "रजिस्टर", "रजीस्टर",
    "चेख", "शो", "गो",
    "अपन", "अपना", "अपन्ट्रोफाएल",
]


def detect_language(
        text: str,
        whisper_lang: str = "en",
        whisper_confidence: float = 0.0
) -> str:

    if not text:
        return "en"

    text_clean = text.lower().strip()

    if text_clean.isascii():
        return "en"


    for word in MARATHI_GENUINE:
        if word in text:
            return "mr"
    for word in HINDI_GENUINE:
        if word in text:
            return "hi"


    temp = text_clean
    for word in [w.lower() for w in TRANSLITERATED_ENGLISH]:
        temp = temp.replace(word, " ")
    temp = re.sub(r'\s+', ' ', temp).strip()

    remaining_devanagari = bool(DEVANAGARI_PATTERN.search(temp))

    if not remaining_devanagari:

        return "en"


    if whisper_lang in ["hi", "mr", "en"]:
        return whisper_lang


    try:
        lang = detect(text)
        if lang in ["hi", "mr"]:
            return lang
    except Exception:
        pass

    return "en"