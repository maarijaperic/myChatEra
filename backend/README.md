# OpenAI Proxy Server (FastAPI)

FastAPI backend server koji proxy-uje OpenAI API pozive, sakrivajući API key od klijentske aplikacije.

## Instalacija

1. **Kreiraj virtual environment:**
```bash
python -m venv venv
source venv/bin/activate  # Na Windows: venv\Scripts\activate
```

2. **Instaliraj dependencies:**
```bash
pip install -r requirements.txt
```

3. **Kreiraj `.env` fajl:**
```bash
cp .env.example .env
```

4. **Dodaj OpenAI API key u `.env`:**
```
OPENAI_API_KEY=sk-tvoj-api-kljuc-ovde
```

## Pokretanje

### Lokalno (Development)
```bash
python main.py
```

Ili sa uvicorn direktno:
```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

Server će raditi na `http://localhost:8000`

### Testiranje

**Health check:**
```bash
curl http://localhost:8000/health
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

## Docker

### Build Docker image:
```bash
docker build -t openai-proxy-server .
```

### Run Docker container:
```bash
docker run -p 8000:8000 --env-file .env openai-proxy-server
```

## Google Cloud Run Deployment

1. **Build i push Docker image:**
```bash
# Set your project ID
export PROJECT_ID=your-project-id
export SERVICE_NAME=openai-proxy-server

# Build image
docker build -t gcr.io/$PROJECT_ID/$SERVICE_NAME .

# Push to Google Container Registry
docker push gcr.io/$PROJECT_ID/$SERVICE_NAME
```

2. **Deploy na Cloud Run:**
```bash
gcloud run deploy $SERVICE_NAME \
  --image gcr.io/$PROJECT_ID/$SERVICE_NAME \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars OPENAI_API_KEY=sk-tvoj-api-kljuc-ovde
```

3. **Dobij URL:**
Cloud Run će dati URL (npr. `https://openai-proxy-server-xxxx.run.app`)

## Endpoints

- `GET /health` - Health check
- `POST /api/chat` - Proxy za OpenAI API
- `GET /` - Root endpoint sa informacijama

## Environment Variables

- `OPENAI_API_KEY` - OpenAI API key (required)
- `PORT` - Server port (default: 8000)

## CORS

Trenutno dozvoljava sve origin-e (`allow_origins=["*"]`). U production-u, ograniči na domen tvoje Flutter aplikacije.


