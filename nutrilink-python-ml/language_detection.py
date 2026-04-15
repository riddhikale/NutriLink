from langdetect import detect, DetectorFactory
import re

DetectorFactory.seed = 0

DEVANAGARI_PATTERN = re.compile(r'[\u0900-\u097F]')

# Words that are genuinely Marathi (not transliterated English)
MARATHI_SPECIFIC = [
    "उघडा", "उगडा", "उबडा",
    "दाखवा", "करा", "जोडा", "नोंदवा",
    "बाळ", "मुल", "मुलाचे", "मुलाची",
    "आहार", "नवीन", "नवी", "महिलांचे",
]

# Words that are genuinely Hindi (not transliterated English)
HINDI_SPECIFIC = [
    "जोड़ो", "दिखाओ", "बनाओ", "बच्चा", "नया", "डाइट",
    "गर्भवती", "लाभार्थी", "स्क्रीनिंग", "फॉलोअप्स",
]

# These are English words Whisper wrote in Devanagari — NOT Indic language
TRANSLITERATED_ENGLISH = [
    "प्रोफाइल", "प्रोफाईल", "प्रोफाएल", "प्रोँप्टाल",
    "प्रोपाल", "प्रोपालिए", "प्रोँपाई", "उप्वाईल",
    "सेटिंग", "सेटिंग्स", "होम", "हिस्ट्री",
    "रिस्क", "स्क्रीनिंग", "फॉलोअप्स",
    "बेनिफिशरी", "बनिफिशरी",
]


def detect_language(text: str, whisper_lang: str = "en", whisper_confidence: float = 0.0) -> str:
    """
    Detect language using a combination of Whisper's detection and script analysis.
    whisper_lang and whisper_confidence come directly from Whisper's info object.
    """

    if not text:
        return "en"

    text_clean = text.lower().strip()

    # --- Step 1: If Whisper is reasonably confident, trust it ---
    if whisper_confidence >= 0.5 and whisper_lang in ["hi", "mr", "en"]:
        # But verify: if Whisper says "en" but there are genuine Indic words, override
        if whisper_lang == "en":
            for word in MARATHI_SPECIFIC:
                if word in text:
                    return "mr"
            for word in HINDI_SPECIFIC:
                if word in text:
                    return "hi"
        return whisper_lang

    # --- Step 2: Low confidence — use script + keyword analysis ---
    has_devanagari = bool(DEVANAGARI_PATTERN.search(text))

    if has_devanagari:
        # Check if ALL Devanagari is just transliterated English
        temp = text
        for word in TRANSLITERATED_ENGLISH:
            temp = temp.replace(word, "")
        remaining_devanagari = bool(DEVANAGARI_PATTERN.search(temp))

        if not remaining_devanagari:
            # Only transliterated English remains — this was an English command
            return "en"

        # Genuine Indic script — classify as mr or hi
        for word in MARATHI_SPECIFIC:
            if word in text:
                return "mr"
        for word in HINDI_SPECIFIC:
            if word in text:
                return "hi"

        # Devanagari present, no specific marker — default Marathi (Maharashtra app)
        return "mr"

    # --- Step 3: Pure Roman script ---
    marathi_roman = ["kara", "ughada", "dakhva", "navin", "aahar"]
    hindi_roman   = ["karo", "dikhao", "naya", "bachcha", "jodo"]

    for word in marathi_roman:
        if word in text_clean:
            return "mr"
    for word in hindi_roman:
        if word in text_clean:
            return "hi"

    # --- Step 4: langdetect fallback ---
    try:
        lang = detect(text)
        if lang in ["hi", "mr"]:
            return lang
    except Exception:
        pass

    return "en"