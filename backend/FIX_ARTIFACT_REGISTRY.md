# Rešenje: Migracija na Artifact Registry

## 🎯 Problem
Google Container Registry (GCR) je deprecated. Treba koristiti **Artifact Registry**.

## ✅ Rešenje 1: Koristi Cloud Build (NAJLAKŠE - Preporučeno)

Cloud Build automatski koristi Artifact Registry. Ne treba ti ništa posebno!

### Korak 1: Build preko Cloud Build
1. Idi na [Cloud Build](https://console.cloud.google.com/cloud-build)
2. Klikni **"CREATE BUILD"**
3. Izaberi:
   - **Source:** "Cloud Source Repositories" ili "GitHub" (ako imaš repo)
   - **Build configuration:** "Cloud Build configuration file (yaml or json)"
   - **Location:** `backend/cloudbuild.yaml`
   - **Substitution variables:** (opciono)
4. Klikni **"CREATE"**

### Korak 2: Deploy na Cloud Run
Kada build završi:
1. Idi na [Cloud Run](https://console.cloud.google.com/run)
2. Klikni na servis → **"EDIT & DEPLOY NEW REVISION"**
3. U **"Container image URL"**, izaberi najnoviji image (automatski će biti iz Artifact Registry)
4. Dodaj environment varijablu:
   - Name: `USE_FAKE_VERSION`
   - Value: `true`
5. Klikni **"DEPLOY"**

---

## ✅ Rešenje 2: Kreiraj Artifact Registry Repository

### Korak 1: Kreiraj Artifact Registry Repository
```powershell
# Kreiraj repository u Artifact Registry
gcloud artifacts repositories create openai-proxy-server `
  --repository-format=docker `
  --location=europe-west1 `
  --description="OpenAI Proxy Server Docker images"
```

### Korak 2: Build i Push sa Artifact Registry
```powershell
cd C:\Users\Korisnik\Documents\GPTWrapped-1\backend

# Build i push na Artifact Registry
gcloud builds submit --tag europe-west1-docker.pkg.dev/301757777366/openai-proxy-server/openai-proxy-server:latest
```

### Korak 3: Deploy na Cloud Run
```powershell
gcloud run deploy openai-proxy-server `
  --image europe-west1-docker.pkg.dev/301757777366/openai-proxy-server/openai-proxy-server:latest `
  --platform managed `
  --region europe-west1 `
  --allow-unauthenticated `
  --set-env-vars USE_FAKE_VERSION=true,OPENAI_API_KEY=sk-tvoj-key-ovde `
  --port 8000
```

---

## ✅ Rešenje 3: Automatska Migracija (Preporučeno)

Google nudi automatsku migraciju:

```powershell
# Pokreni automatsku migraciju
gcloud artifacts docker upgrade migrate --projects=301757777366
```

Ovo će automatski migrirati sve iz GCR u Artifact Registry.

---

## 🎯 NAJLAKŠE REŠENJE: Cloud Build Console

**Ne treba ti ništa da instaliraš ili konfigurišeš!**

1. **Idi na:** [Cloud Build](https://console.cloud.google.com/cloud-build)
2. **Klikni:** "CREATE BUILD"
3. **Izaberi source:**
   - Ako imaš GitHub repo: poveži GitHub
   - Ako nemaš: upload fajlove direktno
4. **Build configuration:** 
   - "Cloud Build configuration file (yaml or json)"
   - Location: `backend/cloudbuild.yaml`
5. **Klikni:** "CREATE"
6. **Sačekaj** da build završi (1-2 minuta)
7. **Idi na Cloud Run** i deploy-uj novi image

---

## 📝 Ažuriraj cloudbuild.yaml (Opciono)

Ako želiš da eksplicitno koristiš Artifact Registry, ažuriraj `backend/cloudbuild.yaml`:

```yaml
steps:
  # Build the container image
  - name: 'gcr.io/cloud-builders/docker'
    args: ['build', '-t', 'europe-west1-docker.pkg.dev/$PROJECT_ID/openai-proxy-server/openai-proxy-server:latest', '.']
  # Push the container image to Artifact Registry
  - name: 'gcr.io/cloud-builders/docker'
    args: ['push', 'europe-west1-docker.pkg.dev/$PROJECT_ID/openai-proxy-server/openai-proxy-server:latest']
images:
  - 'europe-west1-docker.pkg.dev/$PROJECT_ID/openai-proxy-server/openai-proxy-server:latest'
```

Ali **nije potrebno** - Cloud Build automatski koristi Artifact Registry!

---

## ✅ Provera

Nakon deploy-a, testiraj:
```
https://openai-proxy-server-301757777366.europe-west1.run.app/api/app-version
```

Trebalo bi: `{"useFakeVersion": true}`

---

## 💡 Preporuka

**Koristi Cloud Build Console** - najlakše je i automatski koristi Artifact Registry. Ne treba ti ništa da konfigurišeš!
