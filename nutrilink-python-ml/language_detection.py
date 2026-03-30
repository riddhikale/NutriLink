from langdetect import detect, DetectorFactory
import re

DetectorFactory.seed = 0

# Matches any Devanagari Unicode character
DEVANAGARI_PATTERN = re.compile(r'[\u0900-\u097F]')

# Marathi-specific words that won't appear in standard Hindi
MARATHI_SPECIFIC = [
    "उघडा", "उगडा", "उबडा",   # open (all Whisper variants)
    "दाखवा",                    # show
    "करा",                      # do/imperative
    "जोडा",                     # add
    "नोंदवा",                   # register
    "बाळ",                      # child
    "मुल", "मुलाचे", "मुलाची",  # child variants
    "आहार",                     # food/meal
    "नवीन", "नवी",              # new
    "महिलांचे",                 # women's
]

# Hindi-specific words
HINDI_SPECIFIC = [
    "जोड़ो",
    "दिखाओ",
    "बनाओ",
    "बच्चा",
    "नया",
    "डाइट",
]


def detect_language(text: str) -> str:
    """
    Detect language of NutriLink voice commands.
    Priority: Devanagari script detection > keyword matching > langdetect
    """

    if not text:
        return "en"

    text_stripped = text.lower().strip()

    # --- Step 1: If Devanagari script is present, classify as hi or mr ---
    # This overrides Whisper's language guess which is unreliable for short clips
    if DEVANAGARI_PATTERN.search(text):

        # Check Marathi-specific words first
        for word in MARATHI_SPECIFIC:
            if word in text:
                return "mr"

        # Check Hindi-specific words
        for word in HINDI_SPECIFIC:
            if word in text:
                return "hi"

        # Devanagari present but no specific marker — default to Marathi
        # since your app is primarily used in Maharashtra
        return "mr"

    # --- Step 2: Roman script — check for Marathi/Hindi romanization ---

    marathi_roman = [
        "kara", "ughada", "dakhva", "dakhawa",
        "navin", "aahar", "yojana", "noondah", "nond",
    ]

    hindi_roman = [
        "karo", "dikhao", "naya", "bachcha",
        "baccha", "jodo", "banao",
    ]

    for word in marathi_roman:
        if word in text_stripped:
            return "mr"

    for word in hindi_roman:
        if word in text_stripped:
            return "hi"

    # --- Step 3: langdetect as last resort ---
    try:
        lang = detect(text)
        if lang in ["hi", "mr"]:
            return lang
    except Exception:
        pass

    return "en"