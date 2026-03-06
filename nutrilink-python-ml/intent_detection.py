# Multilingual intent dataset for NutriLink Voicebot

intents = {

    "add_beneficiary": [
        # English
        "create new beneficiary",
        "add new beneficiary",
        "register beneficiary",
        "register new child",

        # Hindi
        "नया लाभार्थी जोड़ो",
        "नया लाभार्थी रजिस्टर करो",
        "नया बच्चा जोड़ो",

        # Marathi
        "नवीन लाभार्थी जोडा",
        "नवीन लाभार्थी नोंदवा",
        "नवीन बाळ नोंदवा",

        # Mixed
        "नया beneficiary add करो",
        "beneficiary जोडा",
        "beneficiary add करा"
    ],


    "add_screening": [
        # English
        "add screening",
        "start screening",
        "record child screening",
        "start child screening",

        # Hindi
        "स्क्रीनिंग जोड़ो",
        "बच्चे की स्क्रीनिंग करो",
        "नई स्क्रीनिंग जोड़ो",

        # Marathi
        "स्क्रीनिंग करा",
        "मुलाची स्क्रीनिंग करा",
        "नवीन स्क्रीनिंग करा",

        # Mixed
        "child screening करा",
        "screening add करा"
    ],


    "view_followups": [
        # English
        "show followups",
        "show todays followups",
        "check followups",
        "view followups",

        # Hindi
        "followups दिखाओ",
        "आज के followups दिखाओ",
        "pending followups दिखाओ",

        # Marathi
        "followups दाखवा",
        "आजचे followups दाखवा",
        "pending followups दाखवा",

        # Mixed
        "आज के followups दाखवा",
        "followups check करा"
    ],


    "generate_meal_plan": [
        # English
        "generate meal plan",
        "create meal plan",
        "suggest diet plan",
        "nutrition plan",

        # Hindi
        "डाइट प्लान बनाओ",
        "पोषण योजना बनाओ",
        "बच्चे के लिए डाइट प्लान",

        # Marathi
        "आहार योजना तयार करा",
        "डायट प्लॅन तयार करा",
        "मुलासाठी आहार योजना",

        # Mixed
        "meal plan बनाओ",
        "diet plan तयार करा"
    ],


    "view_high_risk": [
        # English
        "show high risk children",
        "high risk cases",
        "show risk children",

        # Hindi
        "high risk बच्चे दिखाओ",
        "जोखिम वाले बच्चे दिखाओ",

        # Marathi
        "high risk मुले दाखवा",
        "जोखमीची मुले दाखवा",

        # Mixed
        "high risk cases दाखवा"
    ],


    "navigation_home": [
        "go to home",
        "open home",
        "होम पेज खोलो",
        "होम पेज उघडा"
    ],


    "navigation_followups": [
        "open followups",
        "followups page open",
        "followups पेज खोलो",
        "followups पेज उघडा"
    ]
}


def detect_intent(text):

    text = text.lower()

    for intent, phrases in intents.items():
        for phrase in phrases:
            if phrase in text:
                return intent

    return "I am NutriLink voicebot, I can help you with beneficiary screening, followup management, meal plan generation, and more."