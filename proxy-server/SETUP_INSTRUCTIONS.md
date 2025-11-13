# 🔑 Kako dodati OpenAI API Key

## Lokalno testiranje (na tvom računaru)

### Korak 1: Kreiraj `.env` fajl

U `proxy-server` folderu kreiraj fajl sa imenom `.env` (bez ekstenzije!)

**Windows:**
1. Otvori `proxy-server` folder
2. Desni klik → New → Text Document
3. Nazovi ga `.env` (uključujući tačku na početku!)
4. Windows će upozoriti da će fajl biti bez ekstenzije - klikni "Yes"

**Mac/Linux:**
```bash
cd proxy-server
touch .env
```

### Korak 2: Dodaj API Key u `.env` fajl

Otvori `.env` fajl i dodaj:

```
OPENAI_API_KEY=sk-tvoj-api-kljuc-ovde
PORT=3000
```

**Primer:**
```
OPENAI_API_KEY=sk-proj-abc123xyz789...
PORT=3000
```

### Korak 3: Gde naći API Key?

1. Idi na: https://platform.openai.com/api-keys
2. Uloguj se (ili kreiraj nalog)
3. Klikni "Create new secret key"
4. Kopiraj ključ (počinje sa `sk-`)
5. **VAŽNO:** Sačuvaj ga negde sigurno - nećeš moći da ga vidiš ponovo!

### Korak 4: Pokreni server

```bash
cd proxy-server
npm install
npm start
```

Server će raditi na `http://localhost:3000`

---

## Production deployment (na internetu)

Kada deploy-uješ server na hosting (Railway, Render, Heroku, itd.):

### Railway (preporučeno - lako i besplatno)

1. Idi na https://railway.app
2. Sign up sa GitHub-om
3. "New Project" → "Deploy from GitHub repo"
4. Izaberi svoj repo
5. Klikni na servis → "Variables" tab
6. Dodaj environment variable:
   - **Name:** `OPENAI_API_KEY`
   - **Value:** `sk-tvoj-api-kljuc`
7. Deploy!

### Render

1. Idi na https://render.com
2. "New" → "Web Service"
3. Konektuj GitHub repo
4. U "Environment Variables" sekciji dodaj:
   - `OPENAI_API_KEY` = `sk-tvoj-api-kljuc`
5. Deploy!

### Heroku

1. Idi na https://heroku.com
2. Kreiraj novu app
3. U Settings → Config Vars dodaj:
   - `OPENAI_API_KEY` = `sk-tvoj-api-kljuc`
4. Deploy!

---

## ⚠️ VAŽNO - Security

**NIKAD:**
- ❌ Ne commit-uj `.env` fajl u Git
- ❌ Ne deli API key sa drugima
- ❌ Ne postavljaj API key direktno u kod

**UVEK:**
- ✅ Koristi `.env` fajl (lokalno)
- ✅ Koristi environment variables (production)
- ✅ Proveri da li je `.env` u `.gitignore`

---

## Testiranje

Nakon što pokreneš server, testiraj:

```bash
# U drugom terminalu
curl http://localhost:3000/health
```

Trebalo bi da vidiš:
```json
{"status":"ok","message":"OpenAI Proxy Server is running"}
```

---

## Troubleshooting

**"OPENAI_API_KEY is not set"**
- Proveri da li `.env` fajl postoji
- Proveri da li ima tačan format: `OPENAI_API_KEY=sk-...`
- Proveri da li nema razmaka oko `=`

**"Cannot find module 'dotenv'"**
- Pokreni `npm install` u `proxy-server` folderu

**"Port 3000 already in use"**
- Promeni `PORT=3001` u `.env` fajlu
- Ažuriraj URL u Flutter aplikaciji


