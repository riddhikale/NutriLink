from sentence_transformers import SentenceTransformer, util

# Load multilingual model
model = SentenceTransformer('paraphrase-multilingual-MiniLM-L12-v2')

# ================= INTENTS ================= #

intents = {

    # 🔥 SPECIFIC (HIGH PRIORITY FIRST)
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

    # 🔥 GENERAL (LOWER PRIORITY)
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
        "होम पेज खोलो",
        "होम पेज उघडा"
    ],

    "navigation_followups": [
        "open followups",
        "go to followups",
        "followups page",
        "followups पेज खोलो",
        "followups पेज उघडा"
    ],

    "navigation_profile": [
        "open profile",
        "go to profile",
        "profile page",
        "प्रोफाइल खोलो",
        "प्रोफाइल उघडा"
    ],

    "navigation_settings": [
        "open settings",
        "go to settings",
        "settings page",
        "सेटिंग्स खोलो",
        "सेटिंग्स उघडा"
    ],

    "navigation_work_history": [
        "open work history",
        "show work history",
        "work history page",
        "वर्क हिस्ट्री दिखाओ",
        "वर्क हिस्ट्री दाखवा"
    ],
}

# ================= KEYWORD RULES ================= #

keyword_rules = {

    # 🔥 SPECIFIC FIRST (IMPORTANT)
    "add_child_screening": ["child", "बच्चा", "बाळ"],

    "add_pregnant_screening": ["pregnant", "गर्भवती"],

    # GENERAL
    "add_beneficiary": ["beneficiary", "लाभार्थी"],

    "add_screening": ["screening", "स्क्रीनिंग"],

    "view_followups": ["followup", "followups"],

    "generate_meal_plan": ["meal", "diet", "nutrition", "आहार", "डाइट"],

    "view_high_risk": ["risk", "जोखिम", "जोखमी"],

    "navigation_home": ["home", "होम"],

    "navigation_profile": ["profile", "प्रोफाइल"],

    "navigation_settings": ["settings", "सेटिंग"],

    "navigation_work_history": ["history", "हिस्ट्री"],
}

# ================= EMBEDDINGS ================= #

intent_embeddings = {}
for intent, phrases in intents.items():
    intent_embeddings[intent] = model.encode(phrases)


# ================= DETECTION FUNCTION ================= #

def detect_intent(text):

    text = text.lower()

    # ✅ STEP 1: KEYWORD MATCH (FAST)
    for intent, keywords in keyword_rules.items():
        for word in keywords:
            if word in text:
                return intent

    # ✅ STEP 2: ML MATCH (SMART FALLBACK)
    text_embedding = model.encode(text)

    best_intent = "unknown"
    best_score = 0

    for intent, embeddings in intent_embeddings.items():
        similarity = util.cos_sim(text_embedding, embeddings)
        score = similarity.max().item()

        if score > best_score:
            best_score = score
            best_intent = intent

    if best_score < 0.35:
        return "unknown"

    return best_intent