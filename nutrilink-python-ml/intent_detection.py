from sentence_transformers import SentenceTransformer, util
import re

model = SentenceTransformer("paraphrase-multilingual-MiniLM-L12-v2")


# ================= TEXT NORMALIZATION ================= #

def normalize_text(text):

    text = text.lower().strip()
    text = re.sub(r'\s+', ' ', text)
    text = re.sub(r'[,\.।\?\!]+', ' ', text)
    text = re.sub(r'\s+', ' ', text).strip()

    replacements = {

        # ---- Register / new ----
        "रजिस्टर": "register",
        "रजीस्टर": "register",
        "निव": "new",
        "निएव": "new",
        "नवीन": "new",
        "नवी": "new",
        "नया": "new",

        # ---- Child ----
        "चाल": "child",
        "चालिल्द": "child",
        "चाएलद": "child",
        "चालिल": "child",
        "बाळ": "child",
        "बच्चा": "child",
        "मुलाचे": "child",
        "मुलाची": "child",

        # ---- Beneficiary ----
        "लाभार्थी": "beneficiary",
        "भीच्छरी": "beneficiary",
        "बनिप्षरीव": "beneficiary",
        "बनिफिशरी": "beneficiary",
        "बेनिफिशरी": "beneficiary",

        # ---- Pregnant — KEY FIX: added Devanagari transliterations ----
        "गर्बवती": "pregnant",
        "गर्भवती": "pregnant",
        "गर्भ्वती": "pregnant",
        "प्रगनेड": "pregnant",       # प्रगनेड वोमन स्क्रीनिंग from log
        "प्रेगनेंट": "pregnant",
        "प्रेग्नेंट": "pregnant",

        # ---- Woman ----
        "महीराज्क्": "woman",
        "महिला": "woman",
        "वोमन": "woman",             # Devanagari "woman"
        "वुमन": "woman",

        # ---- Screening ----
        "स्क्रीनिंकरा": "screening",
        "स्क्रीनिंग": "screening",
        "स्क्रीनिं": "screening",

        # ---- Followups — KEY FIX: added more garbled variants ----
        "फो लोबस": "followups",
        "फोलोबस": "followups",
        "फॉलोअप्स": "followups",
        "फोलोअप्स": "followups",
        "फॉलोप्स": "followups",      # शो फॉलोप्स from log
        "फोलोप्स": "followups",
        "फॉलोउप्स": "followups",

        # ---- Settings ----
        "सेट्टिंग्स": "settings",
        "सेटिंग्स": "settings",
        "सेट्टिंग": "settings",
        "सेटिंग": "settings",

        # ---- Open ----
        "स्खोलो": "open",
        "खोलो": "open",
        "उघडा": "open",
        "उगडा": "open",
        "उबडा": "open",
        "उग़़ा": "open",             # प्रोफाईल उग़़ा from log

        # ---- Home ----
        "होम": "home",

        # ---- Profile — KEY FIX: added all garbled variants ----
        "प्रुफाएल": "profile",       # अपन प्रुफाएल from log
        "प्रोँप्टाल": "profile",
        "प्रोफाइल": "profile",
        "प्रोफाईल": "profile",
        "प्रोफाएल": "profile",
        "प्रोँपाई": "profile",
        "प्रोपाल": "profile",
        "प्रोफाल": "profile",
        "प्रोपाइल": "profile",
        "प्रोपालिए": "profile",
        "उप्वाईल": "profile",
        "चुट्रोफाडल": "profile",     # गो चुट्रोफाडल from log — garbled "go to profile"

        # ---- History / work ----
        "हिस्ट्री": "history",
        "हिस्टरी": "history",
        "लिएस्ट्री": "history",      # वर्क लिएस्ट्री from log
        "लिएख़िस्ट्री": "history",   # अपन्वार्ख लिएख़िस्ट्री from log
        "वर्ख": "work",
        "आज़ीजना": "history",

        # ---- Risk levels ----
        "हाय रिस्क": "high risk",
        "हाई रिस्क": "high risk",
        "मीडियम रिस्क": "medium risk",
        "मीडिअम रिस्क": "medium risk",
        "लो रिस्क": "low risk",
        "लोव रिस्क": "low risk",
        "शो लो रिस्क": "show low risk",
        "शो हाय रिस्क": "show high risk",
        "रिस्क": "risk",
        "जोखमीची": "high risk",
        "जोखिम": "high risk",
        "है रिस्क": "risk",
        "है": "",

        # ---- Meal / diet ----
        "आहार": "meal",
        "योजना": "plan",
        "डाइट": "diet",

        # ---- Show / go ----
        "शो": "show",
        "गो": "go",
        "दाखवा": "show",
        "दिखाओ": "show",
        "दिकाो": "show",

        # ---- Add ----
        "जोड़ो": "add",
        "जोडो": "add",
        "जोडा": "add",

        # ---- Create ----
        "ख्रीएड": "create",
        "क्रिएट": "create",

        # ---- Misc ----
        "करा": "",
        "पन्जिकरंग": "register",
        "अपन्वार्ख": "work",         # अपन्वार्ख from log
        "अपन": "",
        "अपना": "",

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

    for k, v in sorted(replacements.items(), key=lambda x: len(x[0]), reverse=True):
        text = text.replace(k, v)

    text = re.sub(r'\s+', ' ', text).strip()
    return text


# ================= INTENTS ================= #

intents = {
    "add_child_screening": [
        "child screening", "add child", "register child",
        "new child", "register new child",
        "बच्चा जोड़ो", "मुलाचे स्क्रीनिंग करा", "नवीन बाळ नोंदवा"
    ],
    "add_pregnant_screening": [
        "pregnant screening", "pregnant woman",
        "add pregnant woman", "register pregnant woman",
        "गर्भवती महिला जोड़ो", "गर्भवती महिला स्क्रीनिंग",
        "गर्भवती महिलांचे स्क्रीनिंग करा"
    ],
    "add_beneficiary": [
        "create beneficiary", "add beneficiary",
        "register beneficiary", "new beneficiary", "beneficiary add",
        "नया लाभार्थी जोड़ो", "नवीन लाभार्थी जोडा"
    ],
    "add_screening": [
        "start screening", "add screening", "record screening", "new screening",
        "नई स्क्रीनिंग", "स्क्रीनिंग जोड़ो", "स्क्रीनिंग करा"
    ],
    "view_followups": [
        "show followups", "check followups", "view followups",
        "today followups", "followups show",
        "followups दिखाओ", "followups दाखवा"
    ],
    "generate_meal_plan": [
        "generate meal plan", "create diet plan", "nutrition plan",
        "diet plan", "meal plan",
        "डाइट प्लान बनाओ", "आहार योजना तयार करा"
    ],
    "view_high_risk": [
        "show high risk", "high risk cases", "high risk children",
        "high risk", "medium risk", "low risk", "risk children",
        "show low risk", "show medium risk",
        "जोखिम वाले बच्चे दिखाओ", "जोखमीची मुले दाखवा"
    ],
    "navigation_home": [
        "open home", "go to home", "home screen", "home open", "होम उघडा"
    ],
    "navigation_profile": [
        "open profile", "go to profile", "profile screen", "profile open",
        "profile", "प्रोफाइल उघडा"
    ],
    "navigation_settings": [
        "open settings", "go to settings", "settings screen", "settings open",
        "सेटिंग उघडा"
    ],
    "navigation_work_history": [
        "open work history", "show work history", "work history", "history screen",
        "वर्क हिस्ट्री दाखवा"
    ],
}


# ================= KEYWORD RULES ================= #

keyword_rules = [
    ("add_child_screening",     ["child"]),
    ("add_pregnant_screening",  ["pregnant"]),
    ("add_beneficiary",         ["beneficiary"]),
    ("view_high_risk",          ["high risk", "medium risk", "low risk", "risk"]),
    ("view_followups",          ["followup"]),
    ("generate_meal_plan",      ["meal", "diet", "nutrition"]),
    ("navigation_home",         ["home"]),
    ("navigation_profile",      ["profile"]),
    ("navigation_settings",     ["settings", "setting"]),
    ("navigation_work_history", ["history", "work"]),
    ("add_screening",           ["screening"]),
]


# ================= EMBEDDINGS ================= #

intent_embeddings = {}
for intent, phrases in intents.items():
    intent_embeddings[intent] = model.encode(phrases, convert_to_tensor=True)

_ = model.encode("warmup", convert_to_tensor=True)
print("✅ Intent model warmed up")


# ================= DETECT INTENT ================= #

def detect_intent(text):

    normalized = normalize_text(text)
    print(f"Normalized text: '{normalized}'")

    # Priority rules — order matters
    if "child" in normalized and ("screening" in normalized or "register" in normalized or "new" in normalized):
        return "add_child_screening"
    if "pregnant" in normalized:
        return "add_pregnant_screening"
    if "beneficiary" in normalized:
        return "add_beneficiary"
    if "high risk" in normalized or "medium risk" in normalized or "low risk" in normalized or "risk" in normalized:
        return "view_high_risk"
    if "followup" in normalized or "follow up" in normalized:
        return "view_followups"
    if "settings" in normalized or "setting" in normalized:
        return "navigation_settings"
    if "history" in normalized or "work" in normalized:
        return "navigation_work_history"
    if "home" in normalized:
        return "navigation_home"
    if "profile" in normalized:
        return "navigation_profile"
    if "meal" in normalized or "diet" in normalized or "nutrition" in normalized:
        return "generate_meal_plan"
    if "screening" in normalized:
        return "add_screening"

    # Semantic match
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

    for intent, keywords in keyword_rules:
        for word in keywords:
            if word in normalized:
                return intent

    return "unknown"