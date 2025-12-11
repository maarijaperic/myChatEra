# Kako da Redeploy-uješ Backend sa USE_FAKE_VERSION

## 🎯 Cilj
Ažurirati backend da koristi `USE_FAKE_VERSION=true` environment varijablu.

## 📋 Opcija 1: Preko Google Cloud Console (NAJLAKŠE)

### Korak 1: Otvori Google Cloud Console
1. Idi na [Google Cloud Console](https://console.cloud.google.com)
2. Login-uj se sa svojim Google nalogom
3. Izaberi projekat (project ID: `301757777366` ili tvoj projekat)

### Korak 2: Idi na Cloud Run
1. U meniju sa leve strane, klikni na **"Cloud Run"**
2. Pronađi servis `openai-proxy-server` (ili tvoj naziv servisa)
3. Klikni na naziv servisa

### Korak 3: Ažuriraj Environment Varijable
1. Klikni na **"EDIT & DEPLOY NEW REVISION"** (gore desno)
2. Scroll do **"Variables & Secrets"** sekcije
3. Pronađi postojeće environment varijable
4. Klikni **"ADD VARIABLE"** i dodaj:
   - **Name:** `USE_FAKE_VERSION`
   - **Value:** `true`
5. Klikni **"DEPLOY"** (dole)
6. Sačekaj 1-2 minuta da se deploy završi

### Korak 4: Proveri da li radi
1. Nakon deploy-a, kopiraj URL servisa
2. Otvori u browseru: `https://tvoj-url.run.app/api/app-version`
3. Trebalo bi da vidiš: `{"useFakeVersion": true}`

---

## 📋 Opcija 2: Preko gcloud CLI (Command Line)

### Korak 1: Instaliraj Google Cloud SDK
Ako već nemaš instaliran:
- Windows: Download sa [cloud.google.com/sdk/docs/install](https://cloud.google.com/sdk/docs/install)
- Mac: `brew install google-cloud-sdk`
- Linux: Prati [zvanične instrukcije](https://cloud.google.com/sdk/docs/install)

### Korak 2: Login i Setup
```bash
# Login u Google Cloud
gcloud auth login

# Postavi projekat (zameni sa tvojim project ID)
gcloud config set project 301757777366
```

### Korak 3: Redeploy sa novom environment varijablom
```bash
cd backend

# Redeploy sa USE_FAKE_VERSION=true
gcloud run deploy openai-proxy-server \
  --image gcr.io/301757777366/openai-proxy-server \
  --platform managed \
  --region europe-west1 \
  --allow-unauthenticated \
  --set-env-vars USE_FAKE_VERSION=true,OPENAI_API_KEY=sk-tvoj-api-key-ovde \
  --port 8000
```

**VAŽNO:** Zameni `sk-tvoj-api-key-ovde` sa tvojim stvarnim OpenAI API key-om!

### Korak 4: Proveri
```bash
# Test endpoint
curl https://openai-proxy-server-301757777366.europe-west1.run.app/api/app-version
```

Trebalo bi da vidiš: `{"useFakeVersion": true}`

---

## 📋 Opcija 3: Preko Google Cloud Build (Automatski)

Ako koristiš Cloud Build za automatski deploy:

### Korak 1: Ažuriraj environment varijable u Cloud Build
1. Idi na [Cloud Build Settings](https://console.cloud.google.com/cloud-build/settings)
2. Izaberi projekat
3. Idi na **"Substitutions"** tab
4. Dodaj:
   - **USE_FAKE_VERSION** = `true`

### Korak 2: Trigger build
```bash
cd backend
gcloud builds submit --config cloudbuild.yaml
```

---

## ✅ Provera da li radi

### Test 1: Health Check
```bash
curl https://openai-proxy-server-301757777366.europe-west1.run.app/health
```
Trebalo bi: `{"status":"ok","message":"OpenAI Proxy Server is running"}`

### Test 2: App Version Endpoint
```bash
curl https://openai-proxy-server-301757777366.europe-west1.run.app/api/app-version
```
Trebalo bi: `{"useFakeVersion": true}`

### Test 3: U Flutter aplikaciji
1. Postavi `FORCE_FAKE_LOGIN = false` u `screen_welcome.dart`
2. Pokreni aplikaciju
3. Klikni "Get Your Wrapped"
4. Trebalo bi da vidiš FakeLoginScreen (import fajla)

---

## 🔄 Vraćanje na Real Login

Kada želiš da se vratiš na real login:

### Preko Cloud Console:
1. Idi na Cloud Run servis
2. **EDIT & DEPLOY NEW REVISION**
3. U **Variables & Secrets**, promeni:
   - `USE_FAKE_VERSION` = `false`
4. **DEPLOY**

### Preko CLI:
```bash
gcloud run services update openai-proxy-server \
  --update-env-vars USE_FAKE_VERSION=false \
  --region europe-west1
```

---

## ⚠️ VAŽNE NAPOMENE

1. **Ne zaboravi da redeploy-uješ** - promene u `.env` fajlu lokalno ne utiču na Cloud Run!
2. **Sačuvaj OPENAI_API_KEY** - kada redeploy-uješ, moraš ponovo postaviti i `OPENAI_API_KEY`
3. **Region** - proveri da li je region `europe-west1` ili neki drugi
4. **Service name** - proveri tačan naziv servisa u Cloud Run

---

## 🆘 Troubleshooting

**Problem: "Service not found"**
- Proveri da li je service name tačan
- Proveri da li si u pravom projektu

**Problem: "Permission denied"**
- Proveri da li si login-ovan: `gcloud auth login`
- Proveri da li imaš dozvole za Cloud Run

**Problem: Environment variable ne radi**
- Proveri da li je ime tačno: `USE_FAKE_VERSION` (velika slova)
- Proveri da li je vrednost: `true` (mala slova, bez navodnika)
- Redeploy servis nakon promene

**Problem: Endpoint vraća false**
- Proveri da li je redeploy završen (može potrajati 1-2 minuta)
- Proveri da li je environment varijabla postavljena u Cloud Run
- Proveri logs: `gcloud run services logs read openai-proxy-server --region europe-west1`

---

## 📝 Quick Reference

**Service URL:** `https://openai-proxy-server-301757777366.europe-west1.run.app`  
**Project ID:** `301757777366` (ili tvoj)  
**Region:** `europe-west1`  
**Service Name:** `openai-proxy-server`

**Environment Variables:**
- `OPENAI_API_KEY` - tvoj OpenAI API key
- `USE_FAKE_VERSION` - `true` ili `false`
- `PORT` - `8000` (opciono)



