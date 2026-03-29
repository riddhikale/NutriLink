from langdetect import detect, DetectorFactory

DetectorFactory.seed = 0


def detect_language(text: str) -> str:
    """
    Detects whether the command is Hindi, Marathi or English.
    Returns: 'hi', 'mr', or 'en'
    """

    if not text:
        return "en"

    text = text.lower()

    # Strong Marathi indicators
    marathi_words = [
        "नवीन", "जोडा", "दाखवा", "आहे", "मुले", "बाळ",
        "जोखमी", "स्क्रीनिंग करा"
    ]

    # Strong Hindi indicators
    hindi_words = [
        "नया", "जोड़ो", "दिखाओ", "है", "बच्चा",
        "जोखिम", "स्क्रीनिंग"
    ]

    # Check Marathi indicators
    for word in marathi_words:
        if word in text:
            return "mr"

    # Check Hindi indicators
    for word in hindi_words:
        if word in text:
            return "hi"

    # Fallback to langdetect
    try:
        lang = detect(text)
    except:
        return "en"

    if lang in ["hi", "mr"]:
        return lang

    return "en"