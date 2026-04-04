from sentence_transformers import SentenceTransformer, util
import re

model = SentenceTransformer("paraphrase-multilingual-MiniLM-L12-v2")


# ================= TEXT NORMALIZATION ================= #

def normalize_text(text):

    text = text.lower().strip()
    text = re.sub(r'\s+', ' ', text)  # collapse spaces first

    replacements = {

        # ---- Whisper garbled Devanagari → English (from logs) ----
        "रजिस्टर": "register",
        "रजीस्टर": "register",
        "निव": "new",
        "निएव": "new",
        "नवीन": "new",
        "नवी": "new",
        "नया": "new",
        "चाल": "child",
        "चालिल्द": "child",
        "चाएलद": "child",
        "चालिल.": "child",       # from latest log: रजिस्टर निव चालिल.
        "फो लोबस": "followups",
        "फोलोबस": "followups",
        "फॉलोअप्स": "followups",
        "सेट्टिंग": "settings",
        "सेटिंग": "settings",
        "स्खोलो": "open",
        "खोलो": "open",
        "उघडा": "open",
        "उगडा": "open",
        "उबडा": "open",           # Whisper variant from logs
        "होम": "home",
        "प्रोफाइल": "profile",
        "प्रोफाईल": "profile",    # alternate spelling in logs
        "हिस्ट्री": "history",
        "स्क्रीनिंकरा": "screening",
        "स्क्रीनिं": "screening",
        "स्क्रीनिंग": "screening",
        "गर्बवती": "pregnant",
        "गर्भवती": "pregnant",
        "गर्भ्वती": "pregnant",
        "महीराज्क्": "woman",
        "महिला": "woman",
        "मुलाचे": "child",
        "मुलाची": "child",
        "बाळ": "child",
        "बच्चा": "child",
        "लाभार्थी": "beneficiary",
        "आहार": "meal",
        "योजना": "plan",
        "जोखमीची": "high risk",
        "जोखिम": "high risk",
        "दाखवा": "show",
        "दिखाओ": "show",
        "दिकाो": "show",          # garbled variant from logs
        "करा": "",
        "जोड़ो": "add",
        "जोडो": "add",            # from logs: नया लाभार्थी जोडो
        "जोडा": "add",
        "पन्जिकरंग": "register",  # garbled: लाभार्थी पन्जिकरंग from logs

        # ---- Marathi romanization ----
        "mulache": "child",
        "mulachi": "child",
        "mulacha": "child",
        "navin": "new",
        "nond": "register",
        "noond": "register",
        "noondah": "register",
        "screen kara": "screening",
        "screening kara": "screening",
        "screening karah": "screening",
        "garbhavati": "pregnant",
        "garbhava": "pregnant",
        "garbohoti": "pregnant",
        "ughada": "open",
        "dakhva": "show",
        "dakhawa": "show",

        # ---- Hindi romanization ----
        "bachcha": "child",
        "baccha": "child",
        "bachche": "child",
    }

    # Apply multi-word replacements first (longer keys first to avoid partial matches)
    sorted_replacements = sorted(replacements.items(), key=lambda x: len(x[0]), reverse=True)
    for k, v in sorted_replacements:
        text = text.replace(k, v)

    # Final cleanup
    text = re.sub(r'\s+', ' ', text).strip()

    return text


# ================= INTENTS ================= #

intents = {

    "add_child_screening": [
        "child screening",
        "add child",
        "register child",
        "new child",
        "register new child",
        "बच्चा जोड़ो",
        "मुलाचे स्क्रीनिंग करा",
        "नवीन बाळ नोंदवा"
    ],

    "add_pregnant_screening": [
        "pregnant screening",
        "pregnant woman",
        "add pregnant woman",
        "register pregnant woman",
        "गर्भवती महिला जोड़ो",
        "गर्भवती महिला स्क्रीनिंग",
        "गर्भवती महिलांचे स्क्रीनिंग करा"
    ],

    "add_beneficiary": [
        "create beneficiary",
        "add beneficiary",
        "register beneficiary",
        "new beneficiary",
        "beneficiary add",
        "नया लाभार्थी जोड़ो",
        "नवीन लाभार्थी जोडा"
    ],

    "add_screening": [
        "start screening",
        "add screening",
        "record screening",
        "new screening",
        "नई स्क्रीनिंग",
        "स्क्रीनिंग जोड़ो",
        "स्क्रीनिंग करा"
    ],

    "view_followups": [
        "show followups",
        "check followups",
        "view followups",
        "today followups",
        "followups show",
        "followups दिखाओ",
        "followups दाखवा"
    ],

    "generate_meal_plan": [
        "generate meal plan",
        "create diet plan",
        "nutrition plan",
        "diet plan",
        "meal plan",
        "डाइट प्लान बनाओ",
        "आहार योजना तयार करा"
    ],

    "view_high_risk": [
        "show high risk children",
        "high risk cases",
        "high risk children",
        "risk children",
        "जोखिम वाले बच्चे दिखाओ",
        "जोखमीची मुले दाखवा"
    ],

    "navigation_home": [
        "open home",
        "go to home",
        "home screen",
        "home open",
        "होम उघडा"
    ],

    "navigation_profile": [
        "open profile",
        "go to profile",
        "profile screen",
        "profile open",
        "प्रोफाइल उघडा"
    ],

    "navigation_settings": [
        "open settings",
        "go to settings",
        "settings screen",
        "settings open",
        "सेटिंग उघडा"
    ],

    "navigation_work_history": [
        "open work history",
        "show work history",
        "work history",
        "history screen",
        "वर्क हिस्ट्री दाखवा"
    ],
}


# ================= KEYWORD RULES ================= #

keyword_rules = [
    ("add_child_screening",     ["child"]),
    ("add_pregnant_screening",  ["pregnant"]),
    ("add_beneficiary",         ["beneficiary"]),
    ("view_followups",          ["followup"]),
    ("generate_meal_plan",      ["meal", "diet", "nutrition"]),
    ("view_high_risk",          ["risk"]),
    ("navigation_home",         ["home"]),
    ("navigation_profile",      ["profile"]),
    ("navigation_settings",     ["settings", "setting"]),
    ("navigation_work_history", ["history"]),
    ("add_screening",           ["screening"]),
]


# ================= EMBEDDINGS ================= #

intent_embeddings = {}

for intent, phrases in intents.items():
    intent_embeddings[intent] = model.encode(
        phrases,
        convert_to_tensor=True
    )


# ================= DETECT INTENT ================= #

def detect_intent(text):

    normalized = normalize_text(text)
    print(f"Normalized text: '{normalized}'")

    # PRIORITY RULES — most specific combos first
    if "child" in normalized and ("screening" in normalized or "register" in normalized or "new" in normalized):
        return "add_child_screening"

    if "pregnant" in normalized:
        return "add_pregnant_screening"

    if "beneficiary" in normalized:
        return "add_beneficiary"

    if "followup" in normalized or "follow up" in normalized:
        return "view_followups"

    if "settings" in normalized or "setting" in normalized:
        return "navigation_settings"

    if "history" in normalized:
        return "navigation_work_history"

    if "home" in normalized:
        return "navigation_home"

    if "profile" in normalized:
        return "navigation_profile"

    if "high risk" in normalized or "risk" in normalized:
        return "view_high_risk"

    if "meal" in normalized or "diet" in normalized or "nutrition" in normalized:
        return "generate_meal_plan"

    # SEMANTIC MATCH
    text_embedding = model.encode(normalized, convert_to_tensor=True)

    best_intent = "unknown"
    best_score = 0

    for intent, embeddings in intent_embeddings.items():
        similarity = util.cos_sim(text_embedding, embeddings)
        score = similarity.max().item()

        if score > best_score:
            best_score = score
            best_intent = intent

    print(f"Best semantic match: {best_intent} (score: {best_score:.2f})")

    if best_score >= 0.55:
        return best_intent

    # KEYWORD FALLBACK
    for intent, keywords in keyword_rules:
        for word in keywords:
            if word in normalized:
                return intent

    return "unknown"