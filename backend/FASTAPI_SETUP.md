# FastAPI Backend Setup Guide

## Lokalno testiranje

### 1. Instaliraj Python dependencies

```bash
cd backend
python -m venv venv

# Windows
venv\Scripts\activate

# Mac/Linux
source venv/bin/activate

pip install -r requirements.txt
```

### 2. Kreiraj .env fajl

Kreiraj `backend/.env` fajl:
```
OPENAI_API_KEY=sk-tvoj-api-kljuc-ovde
PORT=8000
```

### 3. Pokreni server

```bash
python main.py
```

Server će raditi na `http://localhost:8000`

### 4. Testiraj

**Health check:**
```
http://localhost:8000/health
```

**Test API poziv:**
```bash
curl -X POST http://localhost:8000/api/chat \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-4o-mini",
    "messages": [
      {"role": "user", "content": "Hello!"}
    ]
  }'
```

## Testiranje sa Flutter aplikacijom

### Za Android Emulator:
- Koristi: `http://10.0.2.2:8000`
- Ažuriraj `main.dart`:
  ```dart
  defaultValue: 'http://10.0.2.2:8000',
  ```

### Za iOS Simulator:
- Koristi: `http://localhost:8000`
- Ažuriraj `main.dart`:
  ```dart
  defaultValue: 'http://localhost:8000',
  ```

### Za fizički telefon (isti WiFi):
1. Pronađi svoju lokalnu IP adresu:
   - Windows: `ipconfig` (traži IPv4 Address)
   - Mac/Linux: `ifconfig` (traži inet)
2. Koristi: `http://192.168.x.x:8000`
3. Ažuriraj `main.dart`:
   ```dart
   defaultValue: 'http://192.168.x.x:8000',
   ```

## Docker

### Build Docker image:
```bash
cd backend
docker build -t openai-proxy-server .
```

### Run Docker container:
```bash
docker run -p 8000:8000 --env-file .env openai-proxy-server
```

## Google Cloud Run Deployment

### 1. Instaliraj Google Cloud SDK

```bash
# Windows: Download from https://cloud.google.com/sdk/docs/install
# Mac: brew install google-cloud-sdk
# Linux: Follow official docs
```

### 2. Login i setup projekta

```bash
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
```

### 3. Enable APIs

```bash
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable containerregistry.googleapis.com
```

### 4. Build i push Docker image

```bash
cd backend

# Set variables
export PROJECT_ID=your-project-id
export SERVICE_NAME=openai-proxy-server
export REGION=us-central1

# Build and push
gcloud builds submit --tag gcr.io/$PROJECT_ID/$SERVICE_NAME
```

### 5. Deploy na Cloud Run

```bash
gcloud run deploy $SERVICE_NAME \
  --image gcr.io/$PROJECT_ID/$SERVICE_NAME \
  --platform managed \
  --region $REGION \
  --allow-unauthenticated \
  --set-env-vars OPENAI_API_KEY=sk-tvoj-api-kljuc-ovde \
  --port 8000
```

### 6. Dobij URL

Cloud Run će dati URL:
```
https://openai-proxy-server-xxxx-xx.a.run.app
```

### 7. Ažuriraj Flutter aplikaciju

U `main.dart`, zameni:
```dart
defaultValue: 'https://openai-proxy-server-xxxx-xx.a.run.app',
```

## Troubleshooting

**Problem: Server ne vidi OPENAI_API_KEY**
- Proveri da li je `.env` fajl u `backend/` folderu
- Proveri da li je API key tačan (počinje sa `sk-`)

**Problem: CORS errors**
- FastAPI već ima CORS middleware koji dozvoljava sve origin-e
- Ako i dalje ima problema, proveri da li server radi

**Problem: Docker build fails**
- Proveri da li si u `backend/` folderu kada pokrećeš `docker build`
- Proveri da li `Dockerfile` postoji u `backend/` folderu

**Problem: Cloud Run deployment fails**
- Proveri da li si login-ovan u Google Cloud (`gcloud auth login`)
- Proveri da li je projekt ID tačan
- Proveri da li su API-ji omogućeni


