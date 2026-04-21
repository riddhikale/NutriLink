<div align="center">

# 🌿 NutriLink

### Smart Nutrition Screening & Monitoring System

![Tech](https://img.shields.io/badge/stack-Flutter%20%7C%20Node%20%7C%20React%20%7C%20Python-blue)
![Status](https://img.shields.io/badge/status-Active-success)
![License](https://img.shields.io/badge/license-Academic-lightgrey)

---

A modular full-stack system for **nutrition screening, tracking, and reporting**
designed for community health workflows.

</div>

---

## ✨ Overview

NutriLink digitizes nutrition monitoring workflows by integrating:

* 📱 Mobile data collection
* ⚙️ Backend APIs
* 📊 Analytics processing
* 🖥️ Supervisor dashboard
* 🎙️ Voice-based interaction

The system focuses on **structured data flow and actionable insights**.

---

## 🧩 Architecture

```text id="6ewm1a"
Flutter App
   ↓
Node Backend
   ↓
Firestore
   ↓
Python Services (Analytics + Voicebot)
   ↓
React Dashboard
```

---

## 📁 Project Structure

```text id="z7b5fp"
NutriLink/
│
├── nutrilink_app/            # Flutter mobile app
├── supervisor_dashboard/     # React dashboard
├── nutrilink-backend/        # Node.js backend
├── nutrilink-voicebot/       # Python voicebot (FastAPI)
├── analytics/                # Python analytics
│
├── assets/
├── docs/
└── README.md
```

---

## 🚀 Features

* **Screening Module** — Structured data capture for each beneficiary
* **Risk Tagging** — Rule-based classification of risk levels
* **Follow-up Tracking** — Scheduled visit monitoring
* **Meal Recommendation** — Condition-based nutrition suggestions
* **Supervisor Dashboard** — Aggregated data visualization
* **Analytics Pipeline** — Data processing for insights
* **Voicebot Interface** — Command-driven interaction via speech

---

## 🛠️ Tech Stack

| Layer     | Technology             |
| --------- | ---------------------- |
| Mobile    | Flutter                |
| Backend   | Node.js (Express)      |
| Database  | Firebase Firestore     |
| Dashboard | React.js               |
| Analytics | Python (Pandas, NumPy) |
| Voicebot  | FastAPI + Python       |

---

## ⚙️ Setup

### 🔹 Clone

```bash id="o7hv8k"
git clone https://github.com/riddhikale/NutriLink.git
cd NutriLink
```

---

### 🔹 Backend

```bash id="v3vtd8"
cd nutrilink-backend
npm install
npm start
```

---

### 🔹 Dashboard

```bash id="2k5m1j"
cd supervisor_dashboard
npm install
npm start
```

---

### 🔹 Voicebot (FastAPI)

```bash id="r9x5q3"
cd nutrilink-voicebot

python -m venv venv
venv\Scripts\activate

pip install -r requirements.txt

uvicorn app:app --reload --port 8001
```

---

### 🔹 Analytics

```bash id="mb7tql"
cd analytics

python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
```

---

### 🔹 Mobile App

```bash id="j0bbld"
cd nutrilink_app
flutter pub get
flutter run
```

---

## 🔌 API

```text id="j0r0pl"
GET  /api/dashboard-summary
GET  /api/trend-analysis
GET  /api/followups-due
POST /api/screening
POST /api/voice-command
```

---

## 🔄 Data Flow

```text id="nh1y9l"
Mobile → Backend → Database → Analytics → Dashboard
```

---

## 🧪 Development Notes

* Backend acts as an API bridge between frontend and Python services
* Analytics generates JSON outputs for dashboard consumption
* Voicebot runs as an independent FastAPI service
* Dashboard only handles visualization (no heavy processing)

---

## 📦 Requirements

```text id="y8e13y"
Node.js >= 18
Python >= 3.11
Flutter SDK
npm / pip
```

---


## 🔮 Future Work

* Advanced analytics modules
* Improved automation workflows
* Extended voice capabilities

---

## 👩‍💻 Contributors

* Riddhi Kale
* Vedant Chaudhari
* Riddhi Chauhan

---


<div align="center">

⭐ If you found this useful, consider starring the repository!

</div>
