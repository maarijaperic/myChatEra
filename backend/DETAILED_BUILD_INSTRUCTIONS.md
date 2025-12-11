# Detaljne Instrukcije: Kako da Build-uješ Backend

## 🎯 Problem
Ne možeš da pronađeš "CREATE BUILD" dugme u Cloud Build konzoli.

## ✅ Rešenje 1: Preko gcloud CLI (NAJLAKŠE - Preporučeno)

**Ovo je najlakše i najsigurnije!**

### Korak 1: Otvori PowerShell
1. Otvori PowerShell na Windows-u
2. Navigiraj do backend foldera:
```powershell
cd C:\Users\Korisnik\Documents\GPTWrapped-1\backend
```

### Korak 2: Build sa cloudbuild.yaml
```powershell
gcloud builds submit --config cloudbuild.yaml
```

**To je sve!** Build će trajati 1-2 minuta. Trebalo bi da vidiš:
- Progress u real-time
- "SUCCESS" kada završi

### Korak 3: Proveri Build Status
Možeš proveriti u browseru:
1. Idi na [Cloud Build History](https://console.cloud.google.com/cloud-build/builds)
2. Trebalo bi da vidiš najnoviji build sa statusom "SUCCESS"

---

## ✅ Rešenje 2: Preko Cloud Build Console (Alternativa)

### Korak 1: Otvori Cloud Build
1. Idi na [Cloud Build](https://console.cloud.google.com/cloud-build)
2. **Gledaj gore desno** - možda vidiš:
   - **"+"** ikonica (plus)
   - **"RUN"** dugme
   - **"TRIGGERS"** tab

### Korak 2: Ako vidiš "TRIGGERS" tab
1. Klikni na **"TRIGGERS"** tab (gore)
2. Ako imaš postojeći trigger:
   - Klikni na trigger
   - Klikni **"RUN"** dugme
3. Ako nemaš trigger:
   - Klikni **"CREATE TRIGGER"**
   - Source: "Cloud Source Repositories" ili "GitHub"
   - Build configuration: "Cloud Build configuration file"
   - Location: `backend/cloudbuild.yaml`
   - Klikni **"CREATE"**

### Korak 3: Ako vidiš "HISTORY" tab
1. Klikni na **"HISTORY"** tab
2. Gledaj **gore desno** - možda vidiš:
   - **"+"** ikonica
   - **"RUN"** dugme
   - Ili klikni na **"TRIGGERS"** tab pored "HISTORY"

---

## ✅ Rešenje 3: Preko Cloud Shell (U Browseru)

Ako ne možeš da pronađeš dugme, koristi Cloud Shell:

### Korak 1: Otvori Cloud Shell
1. Idi na [Google Cloud Console](https://console.cloud.google.com)
2. **Gore desno**, klikni na **Cloud Shell** ikonicu (terminal ikonica)
3. Sačekaj da se Cloud Shell otvori (može potrajati 30 sekundi)

### Korak 2: Upload Fajlove
U Cloud Shell-u:
```bash
# Kreiraj backend folder
mkdir -p backend
cd backend
```

Zatim:
1. U Cloud Shell-u, klikni na **"Upload file"** (gore desno, ikonica sa strelicom gore)
2. Upload ove fajlove:
   - `Dockerfile`
   - `main.py`
   - `requirements.txt`
   - `cloudbuild.yaml`
3. Ili upload ceo `backend` folder

### Korak 3: Build
```bash
gcloud builds submit --config cloudbuild.yaml
```

---

## ✅ Rešenje 4: Direktno Deploy Bez Build-a (Ako već imaš image)

Ako već imaš Docker image negde, možeš direktno deploy-ovati:

### Korak 1: Idi na Cloud Run
1. Idi na [Cloud Run](https://console.cloud.google.com/run)
2. Klikni na servis `openai-proxy-server`

### Korak 2: Edit Servis
1. Klikni **"EDIT & DEPLOY NEW REVISION"** (gore desno)
2. Scroll do **"Container"** sekcije
3. U **"Container image URL"**, možda već imaš image - samo dodaj environment varijablu

### Korak 3: Dodaj Environment Varijablu
1. Scroll do **"Variables & Secrets"** sekcije
2. Klikni **"ADD VARIABLE"**
3. Dodaj:
   - **Name:** `USE_FAKE_VERSION`
   - **Value:** `true`
4. Klikni **"DEPLOY"**

---

## 🎯 PREPORUČENO: Koristi gcloud CLI

**Najlakše i najsigurnije!**

U PowerShell-u:
```powershell
cd C:\Users\Korisnik\Documents\GPTWrapped-1\backend
gcloud builds submit --config cloudbuild.yaml
```

**To je sve!** Ne treba ti ništa u browseru.

---

## 📝 Nakon Build-a: Deploy na Cloud Run

### Korak 1: Idi na Cloud Run
1. Idi na [Cloud Run](https://console.cloud.google.com/run)
2. Klikni na servis `openai-proxy-server`

### Korak 2: Edit i Deploy
1. Klikni **"EDIT & DEPLOY NEW REVISION"** (gore desno, plavo dugme)
2. Scroll do **"Container"** sekcije
3. U **"Container image URL"**, klikni dropdown
4. Izaberi najnoviji image (verovatno će biti automatski izabran)
5. Scroll do **"Variables & Secrets"** sekcije
6. Klikni **"ADD VARIABLE"**
7. Dodaj:
   - **Name:** `USE_FAKE_VERSION`
   - **Value:** `true` (bez navodnika!)
8. Scroll dole i klikni **"DEPLOY"** (plavo dugme)

### Korak 3: Sačekaj Deploy
- Deploy će trajati 1-2 minuta
- Status će biti "Deploying..." pa "Active" kada završi

---

## ✅ Provera

Nakon deploy-a, otvori u browseru:
```
https://openai-proxy-server-301757777366.europe-west1.run.app/api/app-version
```

**Trebalo bi da vidiš:**
```json
{"useFakeVersion": true}
```

Ako vidiš `{"useFakeVersion": false}`, environment varijabla nije postavljena ili redeploy nije završen.

---

## 🆘 Troubleshooting

**Problem: "gcloud: command not found"**
- Proveri da li je Google Cloud SDK instaliran
- Restart-uj PowerShell

**Problem: "Permission denied"**
- Proveri da li si login-ovan: `gcloud auth login`
- Proveri projekat: `gcloud config set project 301757777366`

**Problem: "Build fails"**
- Proveri da li si u `backend` folderu
- Proveri da li `cloudbuild.yaml` postoji
- Proveri logs: `gcloud builds log [BUILD-ID]`

---

## 💡 Najlakše Rešenje

**Koristi samo ove 2 komande:**

```powershell
# 1. Build
cd C:\Users\Korisnik\Documents\GPTWrapped-1\backend
gcloud builds submit --config cloudbuild.yaml

# 2. Deploy (nakon build-a)
gcloud run deploy openai-proxy-server --image europe-west1-docker.pkg.dev/301757777366/openai-proxy-server/openai-proxy-server:latest --platform managed --region europe-west1 --allow-unauthenticated --update-env-vars USE_FAKE_VERSION=true --port 8000
```

**To je sve!** Ne treba ti ništa u browseru.



