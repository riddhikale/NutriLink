from sentence_transformers import SentenceTransformer, util

# Load multilingual model
model = SentenceTransformer("paraphrase-multilingual-MiniLM-L12-v2")


# ================= TEXT NORMALIZATION ================= #

def normalize_text(text):

    text = text.lower()

    replacements = {

        # Marathi romanization fixes
        "mulache": "mul",
        "mulachi": "mul",
        "mulacha": "mul",
        "bala": "bal",
        "bal": "child",
        "mul": "child",

        # Hindi romanization
        "bachcha": "child",
        "baccha": "child",
        "bachche": "child",

        # Marathi STT variations
        "navin": "new",
        "noond": "register",
        "noondah": "register",
        "nond": "register",

        # Screening variants
        "screening kara": "screening",
        "screening karah": "screening",
        "screen kara": "screening",

        # Pregnant variants
        "garbhavati": "pregnant",
        "garbhava": "pregnant",
        "garbohoti": "pregnant"
    }

    for k, v in replacements.items():
        text = text.replace(k, v)

    return text


# ================= INTENTS ================= #

intents = {

    "add_child_screening": [
        "child screening",
        "add child",
        "register child",
        "new child",
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
        "नई स्क्रीनिंग",
        "स्क्रीनिंग जोड़ो",
        "स्क्रीनिंग करा"
    ],

    "view_followups": [
        "show followups",
        "check followups",
        "view followups",
        "today followups",
        "followups दिखाओ",
        "followups दाखवा"
    ],

    "generate_meal_plan": [
        "generate meal plan",
        "create diet plan",
        "nutrition plan",
        "diet plan",
        "डाइट प्लान बनाओ",
        "आहार योजना तयार करा"
    ],

    "view_high_risk": [
        "show high risk children",
        "risk cases",
        "high risk children",
        "जोखिम वाले बच्चे दिखाओ",
        "जोखमीची मुले दाखवा"
    ],

    "navigation_home": [
        "open home",
        "go to home",
        "home screen",
        "होम उघडा"
    ],

    "navigation_profile": [
        "open profile",
        "go to profile",
        "profile screen",
        "प्रोफाइल उघडा"
    ],

    "navigation_settings": [
        "open settings",
        "go to settings",
        "settings screen",
        "सेटिंग उघडा"
    ],

    "navigation_work_history": [
        "open work history",
        "show work history",
        "history screen",
        "वर्क हिस्ट्री दाखवा"
    ],
}


# ================= KEYWORD RULES ================= #

keyword_rules = {

    "add_child_screening": ["child", "mul", "bal", "बच्चा", "बाळ"],

    "add_pregnant_screening": ["pregnant", "गर्भवती"],

    "add_beneficiary": ["beneficiary", "लाभार्थी"],

    "add_screening": ["screening", "screen", "स्क्रीनिंग"],

    "view_followups": ["followup", "followups"],

    "generate_meal_plan": ["meal", "diet", "nutrition", "आहार", "डाइट"],

    "view_high_risk": ["risk", "जोखिम", "जोखमी"],

    "navigation_home": ["home", "होम"],

    "navigation_profile": ["profile", "प्रोफाइल"],

    "navigation_settings": ["settings", "सेटिंग"],

    "navigation_work_history": ["history", "हिस्ट्री"]
}


# ================= EMBEDDINGS ================= #

intent_embeddings = {}

for intent, phrases in intents.items():
    intent_embeddings[intent] = model.encode(
        phrases,
        convert_to_tensor=True
    )


# ================= DETECTION FUNCTION ================= #

def detect_intent(text):

    text = normalize_text(text)

    # -------- PRIORITY RULES -------- #

    if any(word in text for word in keyword_rules["add_child_screening"]):
        if "screen" in text or "screening" in text:
            return "add_child_screening"

    if any(word in text for word in keyword_rules["add_pregnant_screening"]):
        return "add_pregnant_screening"


    # -------- SEMANTIC MATCH -------- #

    text_embedding = model.encode(
        text,
        convert_to_tensor=True
    )

    best_intent = "unknown"
    best_score = 0

    for intent, embeddings in intent_embeddings.items():

        similarity = util.cos_sim(text_embedding, embeddings)
        score = similarity.max().item()

        if score > best_score:
            best_score = score
            best_intent = intent


    if best_score >= 0.45:
        return best_intent


    # -------- KEYWORD FALLBACK -------- #

    for intent, keywords in keyword_rules.items():
        for word in keywords:
            if word in text:
                return intent

    return "unknown"