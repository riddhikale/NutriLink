<div align="center">

# NutriLink

### Smart Nutrition Screening & Monitoring System

![Tech](https://img.shields.io/badge/stack-Flutter%20%7C%20Node%20%7C%20React%20%7C%20Python-blue)

---

A full-stack system for **nutrition screening, tracking, and reporting**
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

## ⚡ Quick Start

1. Configure Firebase credentials
2. Set up environment variables
3. Start backend server
4. Run dashboard and mobile app
5. Login using registered credentials

---

## 🧩 Architecture

```text
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

```text
NutriLink/
│
├── nutrilink_app/              # Flutter mobile app
├── dashboard_supervisor/       # React dashboard
├── nutrilink-backend/          # Node.js backend
├── nutrilink-voicebot/         # Python voicebot (FastAPI)
├── supervisor_analytics/       # Python analytics
│
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

```bash
git clone https://github.com/riddhikale/NutriLink.git
cd NutriLink
```

---

### 🔹 Backend (Node.js)

```bash
cd nutrilink-backend
npm install
npm start
```

Runs on:

```
http://localhost:8080
```

---

### 🔹 Dashboard (React)

```bash
cd dashboard_supervisor
cd frontend
npm install
npm start
```

---

### 🔹 Voicebot (FastAPI)

```bash
cd nutrilink-voicebot

python -m venv venv
venv\Scripts\activate

pip install -r requirements.txt

uvicorn app:app --reload --port 8001
```

---

### 🔹 Analytics

```bash
cd supervisor_analytics

python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
```

---

### 🔹 Mobile App

```bash
cd nutrilink_app
flutter pub get
flutter run
```

---

## ⚙️ Environment Variables

Create a `.env` file inside `nutrilink-backend`:

```env
PORT=8080
JWT_SECRET=your_secret_key_here
```

---

## 🔐 Firebase Setup

This project uses Firebase Admin SDK.

### ⚠️ Important

The `serviceAccount.json` file is **not included in this repository**.

---

### Setup Steps:

1. Go to Firebase Console
2. Select your project
3. Navigate to:

```
Project Settings → Service Accounts
```

4. Click:

```
Generate new private key
```

5. Rename file to:

```
serviceAccount.json
```

6. Place it inside:

```
nutrilink-backend/
```

---

### 🔒 Security Note

* Never commit `serviceAccount.json`
* Ensure it is added to `.gitignore`

---

## 🔌 API

```text
GET  /api/dashboard-summary
GET  /api/trend-analysis
GET  /api/followups-due
POST /api/screening
POST /api/voice-command
POST /api/auth/login-test
POST /api/auth/register
```

---

## 🔄 Data Flow

```text
Mobile → Backend → Database → Analytics → Dashboard
```

---

## 🧪 Development Notes

* Backend acts as an API bridge between frontend and Python services
* Analytics generates processed data for dashboard consumption
* Voicebot runs independently using FastAPI
* Dashboard focuses on visualization only

---

## 📦 Requirements

```text
Node.js >= 18
Python >= 3.11
Flutter SDK
npm / pip
```

---

## ⚠️ Important Notes

* Backend must be running before frontend/mobile
* Ensure correct API endpoints (`/api/auth/login-test`)
* Firebase credentials must be configured properly
* Do not expose sensitive files (`.env`, `serviceAccount.json`)

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
