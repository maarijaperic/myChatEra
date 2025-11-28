# OpenAI Proxy Server

Proxy server za sigurno pozivanje OpenAI API-ja bez izlaganja API ključa u klijentskoj aplikaciji.

## Instalacija

1. Instaliraj Node.js dependencies:
```bash
npm install
```

2. Kreiraj `.env` fajl:
```bash
cp .env.example .env
```

3. Dodaj svoj OpenAI API ključ u `.env`:
```
OPENAI_API_KEY=sk-tvoj-api-kljuc-ovde
```

## Pokretanje

### Development (sa auto-reload):
```bash
npm run dev
```

### Production:
```bash
npm start
```

Server će raditi na `http://localhost:3000` (ili portu koji si definisao u `.env`).

## Endpoints

### Health Check
```
GET /health
```

### Chat Completions (Proxy za OpenAI)
```
POST /api/chat
Content-Type: application/json

{
  "model": "gpt-4o-mini",
  "messages": [
    {
      "role": "system",
      "content": "You are a helpful assistant."
    },
    {
      "role": "user",
      "content": "Hello!"
    }
  ],
  "temperature": 0.7,
  "max_tokens": 500
}
```

## Deployment

Za production deployment (npr. na Heroku, Railway, Render, itd.):

1. Postavi `OPENAI_API_KEY` kao environment variable na hosting platformi
2. Server će automatski koristiti `PORT` environment variable (većina platformi to automatski postavlja)

### Railway
1. Push kod na GitHub
2. Konektuj repo na Railway
3. Dodaj `OPENAI_API_KEY` u environment variables
4. Deploy!

### Render
1. Kreiramo novi Web Service
2. Konektuj GitHub repo
3. Dodaj `OPENAI_API_KEY` u environment variables
4. Deploy!

## Security

- API ključ se nikad ne šalje klijentu
- Rate limiting: 100 zahteva po minuti po IP adresi
- CORS omogućen za sve domene (možeš ograničiti u production)

## Troubleshooting

- **Error: OPENAI_API_KEY is not set**: Proveri da li si kreirao `.env` fajl sa API ključem
- **Port already in use**: Promeni `PORT` u `.env` fajlu
- **CORS errors**: Proveri da li server radi i da li je CORS middleware omogućen



