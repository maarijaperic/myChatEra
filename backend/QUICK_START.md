# FastAPI Backend - Quick Start

## 🚀 Brzo pokretanje (5 minuta)

### 1. Instaliraj Python dependencies
```bash
cd backend
python -m venv venv
venv\Scripts\activate  # Windows
pip install -r requirements.txt
```

### 2. Kreiraj .env fajl
Kopiraj `env.example` u `.env` i dodaj svoj OpenAI API key:
```
OPENAI_API_KEY=sk-tvoj-api-kljuc-ovde
```

### 3. Pokreni server
```bash
python main.py
```

Server radi na `http://localhost:8000` ✅

### 4. Testiraj
Otvori u browseru: `http://localhost:8000/health`

Trebalo bi da vidiš: `{"status":"ok","message":"OpenAI Proxy Server is running"}`

## 📱 Testiranje sa Flutter aplikacijom

### Android Emulator:
```dart
// U main.dart
defaultValue: 'http://10.0.2.2:8000',
```

### iOS Simulator:
```dart
// U main.dart
defaultValue: 'http://localhost:8000',
```

### Fizički telefon (isti WiFi):
1. Pronađi IP: `ipconfig` (Windows) ili `ifconfig` (Mac/Linux)
2. Koristi: `http://192.168.x.x:8000`
3. Ažuriraj `main.dart` sa tom IP adresom

## 🐳 Docker

```bash
docker build -t openai-proxy-server .
docker run -p 8000:8000 --env-file .env openai-proxy-server
```

## ☁️ Google Cloud Run

Pogledaj `FASTAPI_SETUP.md` za detaljne korake.

## ✅ Sve je spremno!

Backend je spreman da prima zahteve od Flutter aplikacije i prosleđuje ih OpenAI API-ju sa tvojim API key-jem.


