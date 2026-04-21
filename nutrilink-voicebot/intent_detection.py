from sentence_transformers import SentenceTransformer, util
import re

model = SentenceTransformer("paraphrase-multilingual-MiniLM-L12-v2")


def normalize_text(text):

    text = text.lower().strip()
    text = re.sub(r'\s+', ' ', text)
    text = re.sub(r'[,\.।\?\!]+', ' ', text)
    text = re.sub(r'\s+', ' ', text).strip()

    replacements = {

        "रजिस्टर": "register",
        "रजीस्टर": "register",
        "वेजिस्टर": "register",
        "निव": "new",
        "निएव": "new",
        "नवीन": "new",
        "नवी": "new",
        "नया": "new",


        "चाएल्ड": "child",
        "चाल्ड": "child",
        "चाल": "child",
        "चालिल्द": "child",
        "चाएलद": "child",
        "चालिल": "child",
        "बाळ": "child",
        "बच्चा": "child",
        "मुलाचे": "child",
        "मुलाची": "child",


        "बनिविश्व्रीव": "beneficiary",
        "लाभार्थी": "beneficiary",
        "भीच्छरी": "beneficiary",
        "बनिप्षरीव": "beneficiary",
        "बनिफिशरी": "beneficiary",
        "बेनिफिशरी": "beneficiary",


        "गर्बवती": "pregnant",
        "गर्भवती": "pregnant",
        "गर्भ्वती": "pregnant",
        "प्रगनेड": "pregnant",
        "प्रेगनेंट": "pregnant",
        "प्रेग्नेंट": "pregnant",


        "महीराज्क्": "woman",
        "महिला": "woman",
        "वोमन": "woman",
        "वुमन": "woman",


        "स्क्रीनिंकरा": "screening",
        "स्क्रीनिंग": "screening",
        "स्क्रीनिं": "screening",
        "आद्स्क्रीनिंग": "add screening",


        "फो लोबस": "followups",
        "फोलोबस": "followups",
        "फॉलोअप्स": "followups",
        "फोलोअप्स": "followups",
        "फॉलोप्स": "followups",
        "फोलोप्स": "followups",
        "फॉलोउप्स": "followups",


        "सेट्टिंग्स": "settings",
        "सेटिंग्स": "settings",
        "सेटिंग्ष": "settings",
        "सेटिंगष": "settings",
        "सेट्टिंग": "settings",
        "सेटिंग": "settings",


        "स्खोलो": "open",
        "खोलो": "open",
        "उघडा": "open",
        "उगडा": "open",
        "उबडा": "open",
        "उग़़ा": "open",
        "उग़डा": "open",
        "उग्डडा": "open",
        "उग्डा": "open",
        "उग़ा": "open",


        "होम": "home",
        "तो": "",


        "अपन्प्रोफाद": "profile",
        "प्रोँफाईल": "profile",
        "प्रोप्पाल": "profile",
        "प्रुफाएल": "profile",
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
        "चुट्रोफाडल": "profile",
        "ट्रोफाएल": "profile",
        "प्रोफाद": "profile",


        "हिस्ट्री": "history",
        "हिस्टरी": "history",
        "लिएस्ट्री": "history",
        "लिएख़िस्ट्री": "history",
        "इस्ट्री": "history",
        "वर्ख": "work",
        "वर्क": "work",
        "आज़ीजना": "history",
        "अपन्वार्ख": "work",


        "हाय रिस्क": "high risk",
        "हाई रिस्क": "high risk",
        "शो हाय रिस्क": "show high risk",
        "शो हाई रिस्क": "show high risk",
        "मीडियम रिस्क": "medium risk",
        "मीडिअम रिस्क": "medium risk",
        "लो रिस्क": "low risk",
        "लोव रिस्क": "low risk",
        "शो लो रिस्क": "show low risk",
        "ठाए रिस्क": "high risk",
        "राए रिस्क": "high risk",
        "एडिस": "high risk",
        "रिस्क": "risk",
        "जोखमीची": "high risk",
        "जोखिम": "high risk",
        "मीचे मुले": "high risk children",
        "चोकि": "show",


        "शो": "show",
        "चेख": "check",
        "गो": "go",
        "दाखवा": "show",
        "डाखवा": "show",
        "दिखाओ": "show",
        "दिकाो": "show",


        "जोड़ो": "add",
        "जोडो": "add",
        "जोडा": "add",


        "ख्रीएड": "create",
        "क्रिएट": "create",


        "करा": "",
        "है": "",
        "पन्जिकरंग": "register",
        "अपन्": "",
        "अपन": "",
        "अपना": "",


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


        "bachcha": "child",
        "baccha": "child",
        "bachche": "child",
    }


    for k, v in sorted(replacements.items(), key=lambda x: len(x[0]), reverse=True):
        text = text.replace(k, v)

    text = re.sub(r'([a-z]+)([\u0900-\u097F]+)', r'\1', text)

    text = re.sub(r'\s+', ' ', text).strip()
    return text




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
        "open profile", "go to profile", "profile screen",
        "profile open", "profile", "प्रोफाइल उघडा"
    ],
    "navigation_settings": [
        "open settings", "go to settings", "settings screen",
        "settings open", "सेटिंग उघडा"
    ],
    "navigation_work_history": [
        "open work history", "show work history", "work history",
        "history screen", "वर्क हिस्ट्री दाखवा"
    ],
}



keyword_rules = [
    ("add_child_screening",     ["child"]),
    ("add_pregnant_screening",  ["pregnant"]),
    ("add_beneficiary",         ["beneficiary"]),
    ("view_high_risk",          ["high risk", "medium risk", "low risk", "risk"]),
    ("view_followups",          ["followup", "check"]),
    ("generate_meal_plan",      ["meal", "diet", "nutrition"]),
    ("navigation_home",         ["home"]),
    ("navigation_profile",      ["profile"]),
    ("navigation_settings",     ["settings", "setting"]),
    ("navigation_work_history", ["history", "work"]),
    ("add_screening",           ["screening"]),
]


intent_embeddings = {}
for intent, phrases in intents.items():
    intent_embeddings[intent] = model.encode(phrases, convert_to_tensor=True)

_ = model.encode("warmup", convert_to_tensor=True)
print("✅ Intent model warmed up")


def detect_intent(text):

    normalized = normalize_text(text)
    print(f"Normalized text: '{normalized}'")

    # Priority rules
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