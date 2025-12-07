# Kako da Build-uješ Docker Image na Windows

## 📋 Preduslovi

### 1. Instaliraj Docker Desktop
- Download sa: [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)
- Instaliraj i pokreni Docker Desktop
- Proveri da li radi: otvori PowerShell i ukucaj `docker --version`

### 2. Instaliraj Google Cloud SDK
- Download sa: [https://cloud.google.com/sdk/docs/install](https://cloud.google.com/sdk/docs/install)
- Izaberi "Windows" i download installer
- Instaliraj i otvori novi PowerShell prozor

### 3. Login u Google Cloud
```powershell
gcloud auth login
gcloud config set project 301757777366
```

---

## 🚀 Korak po Korak: Build i Deploy

### Korak 1: Otvori PowerShell
- Otvori PowerShell (ili Command Prompt)
- Navigiraj do backend foldera:
```powershell
cd C:\Users\Korisnik\Documents\GPTWrapped-1\backend
```

### Korak 2: Build Docker Image
```powershell
# Build Docker image lokalno (test)
docker build -t openai-proxy-server .

# Build i push direktno na Google Container Registry
gcloud builds submit --tag gcr.io/301757777366/openai-proxy-server
```

**Opcija A: Samo build (test)**
```powershell
docker build -t openai-proxy-server .
```

**Opcija B: Build i push na Google Container Registry (PREPORUČENO)**
```powershell
gcloud builds submit --tag gcr.io/301757777366/openai-proxy-server
```

### Korak 3: Deploy na Cloud Run
```powershell
gcloud run deploy openai-proxy-server `
  --image gcr.io/301757777366/openai-proxy-server `
  --platform managed `
  --region europe-west1 `
  --allow-unauthenticated `
  --set-env-vars USE_FAKE_VERSION=true,OPENAI_API_KEY=sk-tvoj-api-key-ovde `
  --port 8000
```

**VAŽNO:** 
- Zameni `sk-tvoj-api-key-ovde` sa tvojim stvarnim OpenAI API key-om!
- Koristi backtick (`) na kraju svake linije u PowerShell (ili stavi sve u jednu liniju)

---

## 🎯 Brzi Put (Sve u Jednom)

### Opcija 1: Build i Deploy odjednom
```powershell
cd C:\Users\Korisnik\Documents\GPTWrapped-1\backend

# Build i push
gcloud builds submit --tag gcr.io/301757777366/openai-proxy-server

# Deploy sa environment varijablama
gcloud run deploy openai-proxy-server --image gcr.io/301757777366/openai-proxy-server --platform managed --region europe-west1 --allow-unauthenticated --set-env-vars USE_FAKE_VERSION=true,OPENAI_API_KEY=sk-TVOJ-KEY-OVDE --port 8000
```

### Opcija 2: Preko Google Cloud Console (NAJLAKŠE)

1. **Build preko Cloud Build:**
   - Idi na [Cloud Build](https://console.cloud.google.com/cloud-build)
   - Klikni "TRIGGERS" → "CREATE TRIGGER"
   - Ili koristi postojeći trigger
   - Ili klikni "HISTORY" → "RUN" → izaberi build

2. **Ili build direktno:**
   - Idi na [Cloud Build](https://console.cloud.google.com/cloud-build)
   - Klikni "CREATE BUILD"
   - Source: "Cloud Source Repositories" ili "GitHub"
   - Build configuration: "Cloud Build configuration file (yaml or json)"
   - Location: `backend/cloudbuild.yaml`
   - Klikni "CREATE"

3. **Deploy na Cloud Run:**
   - Kada build završi, idi na [Cloud Run](https://console.cloud.google.com/run)
   - Klikni na servis → "EDIT & DEPLOY NEW REVISION"
   - U "Container image URL", izaberi novi image
   - Dodaj `USE_FAKE_VERSION=true` u environment varijable
   - Klikni "DEPLOY"

---

## 🔍 Provera da li je Build Uspesan

### Proveri Docker Image Lokalno
```powershell
docker images
```
Trebalo bi da vidiš `openai-proxy-server` u listi.

### Proveri u Google Container Registry
1. Idi na [Container Registry](https://console.cloud.google.com/gcr)
2. Trebalo bi da vidiš `openai-proxy-server` image

### Proveri Build History
1. Idi na [Cloud Build History](https://console.cloud.google.com/cloud-build/builds)
2. Trebalo bi da vidiš najnoviji build

---

## ⚠️ Troubleshooting

### Problem: "docker: command not found"
- Proveri da li je Docker Desktop pokrenut
- Proveri da li je Docker u PATH-u
- Restart-uj PowerShell

### Problem: "gcloud: command not found"
- Proveri da li je Google Cloud SDK instaliran
- Proveri da li je u PATH-u
- Restart-uj PowerShell

### Problem: "Permission denied"
```powershell
gcloud auth login
gcloud config set project 301757777366
```

### Problem: "Build fails"
- Proveri da li si u `backend` folderu
- Proveri da li `Dockerfile` postoji
- Proveri da li `main.py` postoji
- Proveri logs u Cloud Build

### Problem: "Image not found"
- Proveri da li je build završen uspešno
- Proveri da li je image push-ovan u Container Registry
- Proveri project ID u URL-u

---

## 📝 Kompletan Primer

```powershell
# 1. Navigiraj do backend foldera
cd C:\Users\Korisnik\Documents\GPTWrapped-1\backend

# 2. Login u Google Cloud (samo prvi put)
gcloud auth login

# 3. Postavi projekat (samo prvi put)
gcloud config set project 301757777366

# 4. Build i push Docker image
gcloud builds submit --tag gcr.io/301757777366/openai-proxy-server

# 5. Deploy na Cloud Run sa environment varijablama
gcloud run deploy openai-proxy-server `
  --image gcr.io/301757777366/openai-proxy-server `
  --platform managed `
  --region europe-west1 `
  --allow-unauthenticated `
  --set-env-vars "USE_FAKE_VERSION=true,OPENAI_API_KEY=sk-tvoj-key-ovde" `
  --port 8000
```

---

## ✅ Provera Nakon Deploy-a

1. **Test endpoint:**
   ```
   https://openai-proxy-server-301757777366.europe-west1.run.app/api/app-version
   ```
   Trebalo bi: `{"useFakeVersion": true}`

2. **Test health:**
   ```
   https://openai-proxy-server-301757777366.europe-west1.run.app/health
   ```
   Trebalo bi: `{"status":"ok","message":"OpenAI Proxy Server is running"}`

---

## 💡 Tips

- **Koristi Cloud Build** - automatski build-uje i push-uje
- **Sačuvaj API key** - ne commit-uj ga u git!
- **Proveri logs** - ako nešto ne radi, proveri Cloud Build i Cloud Run logs

---

**Sada bi trebalo da radi! 🚀**


