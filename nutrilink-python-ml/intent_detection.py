from sentence_transformers import SentenceTransformer, util

# Load multilingual embedding model
model = SentenceTransformer('paraphrase-multilingual-MiniLM-L12-v2')

# Intent examples
intents = {

    "add_beneficiary": [
        "create beneficiary",
        "add beneficiary",
        "register beneficiary",
        "add new child",
        "register new child",
        "नया लाभार्थी जोड़ो",
        "नवीन लाभार्थी जोडा"
    ],

    "add_screening": [
        "start screening",
        "add screening",
        "child screening",
        "record screening",
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
    ]
}


# Precompute embeddings
intent_embeddings = {}
for intent, phrases in intents.items():
    intent_embeddings[intent] = model.encode(phrases)


def detect_intent(text):

    text_embedding = model.encode(text)

    best_intent = "unknown"
    best_score = 0

    for intent, embeddings in intent_embeddings.items():

        similarity = util.cos_sim(text_embedding, embeddings)

        score = similarity.max().item()

        if score > best_score:
            best_score = score
            best_intent = intent

    # confidence threshold
    if best_score < 0.45:
        return "unknown"

    return best_intent