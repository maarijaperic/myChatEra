# Kako da Popuniš Cloud Build Trigger Formu

## 📋 Detaljne Instrukcije

### 1. **Name**
```
openai-proxy-server-trigger
```
Ili bilo koje ime koje želiš (mora biti jedinstveno).

### 2. **Region**
```
global (Global)
```
Ostavi kako jeste - "global" je u redu.

### 3. **Description** (Opciono)
```
Builds and deploys OpenAI Proxy Server
```
Ili ostavi prazno.

### 4. **Tags** (Opciono)
Ostavi prazno - nije obavezno.

---

## 🎯 Event Sekcija

### Izaberi: **"Manual invocation"**
- ✅ Klikni na **"Manual invocation"**
- Ovo znači da ćeš moći da pokreneš build ručno kada želiš

**NE izaberi:**
- ❌ "Push to a branch" (zahteva GitHub repo)
- ❌ "Push new tag" (zahteva GitHub repo)
- ❌ "Pull request" (zahteva GitHub repo)

---

## 📦 Source Sekcija

### Repository service
**Izaberi: "Cloud Build repositories"**

### Repository generation
**Izaberi: "1st gen"** (prva opcija)

### Repository
**Klikni dropdown i izaberi:**
- Ako već imaš repository, izaberi ga
- Ako nemaš, klikni **"CREATE REPOSITORY"** i kreiraj novi

**Ili preskoči ovo i koristi "Inline" opciju (vidi ispod)**

---

## ⚙️ Configuration Sekcija

### Type
**Izaberi: "Cloud Build configuration file (yaml or json)"**

### Location
**Izaberi: "Inline"** (NAJLAKŠE - ne treba ti repo!)

Kada izabereš "Inline", pojaviće se editor gde možeš paste-ovati sadržaj `cloudbuild.yaml` fajla.

### Cloud Build configuration file location
**Ako si izabrao "Repository" umesto "Inline":**
- Location: `backend/cloudbuild.yaml`
- Ili samo: `cloudbuild.yaml` (ako si upload-ovao fajlove u root)

---

## 📝 Inline YAML (Ako si izabrao "Inline")

Paste-uj ovaj sadržaj u editor:

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

---

## 🔧 Advanced Sekcija

### Substitution variables
**Ostavi prazno** - nije potrebno.

### Approval
**NE čekiraj** - "Require approval before build executes"
- Ovo bi zahtevalo odobrenje pre svakog build-a

### Service account
**Ostavi default** - Cloud Build automatski koristi service account sa dozvolama.

---

## ✅ Finalni Koraci

1. **Proveri sve polja**
2. **Klikni "CREATE"** (dole)

---

## 🚀 Kako da Pokreneš Build

Nakon što kreiraš trigger:

1. Idi na [Cloud Build Triggers](https://console.cloud.google.com/cloud-build/triggers)
2. Pronađi trigger koji si kreirao
3. Klikni na **"RUN"** dugme (desno)
4. Build će se pokrenuti!

---

## ⚠️ VAŽNO: Problem sa Inline

Ako koristiš "Inline" opciju, možda nećeš moći da upload-uješ fajlove. U tom slučaju:

### Alternativa: Koristi gcloud CLI (NAJLAKŠE)

**Preskoči trigger i koristi direktno:**

```powershell
cd C:\Users\Korisnik\Documents\GPTWrapped-1\backend
gcloud builds submit --config cloudbuild.yaml
```

**To je sve!** Ne treba ti trigger.

---

## 💡 Preporuka

**Koristi gcloud CLI umesto trigger-a** - mnogo je lakše i ne zahteva konfiguraciju!

```powershell
cd C:\Users\Korisnik\Documents\GPTWrapped-1\backend
gcloud builds submit --config cloudbuild.yaml
```
