# Rešenje: Permission Denied za Artifact Registry

## 🎯 Problem
Greška: `Permission "artifactregistry.repositories.uploadArtifacts" denied`

## ✅ Rešenje 1: Dodeli Dozvole (Preko Console)

### Korak 1: Dodeli Artifact Registry Writer Role
1. Idi na [IAM & Admin](https://console.cloud.google.com/iam-admin/iam)
2. Pronađi svoj email u listi
3. Klikni na **"Edit"** (ikonica olovke)
4. Klikni **"ADD ANOTHER ROLE"**
5. Izaberi: **"Artifact Registry Writer"**
6. Klikni **"SAVE"**

### Korak 2: Sačekaj 1-2 minuta
Dozvole mogu potrajati da se propagiraju.

### Korak 3: Pokušaj ponovo
```powershell
cd C:\Users\Korisnik\Documents\GPTWrapped-1\backend
gcloud builds submit --tag europe-west1-docker.pkg.dev/301757777366/openai-proxy-server/openai-proxy-server:latest
```

---

## ✅ Rešenje 2: Koristi Cloud Build Console (NAJLAKŠE - Preporučeno)

Cloud Build automatski ima sve potrebne dozvole! Ne treba ti ništa da konfigurišeš.

### Korak 1: Idi na Cloud Build
1. Idi na [Cloud Build](https://console.cloud.google.com/cloud-build)
2. Klikni **"CREATE BUILD"**

### Korak 2: Konfiguriši Build
**Opcija A: Upload fajlove direktno**
1. Klikni **"Upload files"** ili **"Browse"**
2. Upload `backend` folder (ili samo `Dockerfile`, `main.py`, `requirements.txt`, `cloudbuild.yaml`)
3. **Build configuration:** "Cloud Build configuration file (yaml or json)"
4. **Location:** `backend/cloudbuild.yaml` (ili samo `cloudbuild.yaml` ako si upload-ovao samo backend fajlove)
5. Klikni **"CREATE"**

**Opcija B: Poveži GitHub (ako imaš repo)**
1. Izaberi **"Connect repository"**
2. Poveži GitHub repo
3. **Build configuration:** "Cloud Build configuration file (yaml or json)"
4. **Location:** `backend/cloudbuild.yaml`
5. Klikni **"CREATE"**

### Korak 3: Sačekaj Build
- Build će trajati 1-2 minuta
- Možeš pratiti progress u real-time

### Korak 4: Deploy na Cloud Run
Kada build završi:
1. Idi na [Cloud Run](https://console.cloud.google.com/run)
2. Klikni na servis → **"EDIT & DEPLOY NEW REVISION"**
3. U **"Container image URL"**, izaberi najnoviji image
4. Dodaj environment varijablu:
   - Name: `USE_FAKE_VERSION`
   - Value: `true`
5. Klikni **"DEPLOY"**

---

## ✅ Rešenje 3: Dodeli Dozvole preko CLI

```powershell
# Dodeli Artifact Registry Writer role sebi
gcloud projects add-iam-policy-binding 301757777366 `
  --member="user:TVOJ-EMAIL@gmail.com" `
  --role="roles/artifactregistry.writer"
```

**Zameni `TVOJ-EMAIL@gmail.com` sa tvojim Google Cloud email-om!**

---

## 🎯 Preporuka

**Koristi Cloud Build Console** - najlakše je i ne treba ti ništa da konfigurišeš. Cloud Build automatski ima sve potrebne dozvole!

---

## 📝 Alternativa: Koristi Cloud Build Service Account

Ako i dalje imaš problema, proveri da li Cloud Build Service Account ima dozvole:

1. Idi na [IAM & Admin](https://console.cloud.google.com/iam-admin/iam)
2. Traži: `[PROJECT-NUMBER]@cloudbuild.gserviceaccount.com`
3. Proveri da li ima **"Artifact Registry Writer"** role
4. Ako nema, dodaj mu

---

## ✅ Provera Nakon Deploy-a

```
https://openai-proxy-server-301757777366.europe-west1.run.app/api/app-version
```

Trebalo bi: `{"useFakeVersion": true}`



