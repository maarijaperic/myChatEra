# Kako da Pronađeš Build Opciju u Cloud Build

## 🔍 Opcija 1: Preko History/Triggers

### Korak 1: Idi na Cloud Build
1. Idi na [Cloud Build](https://console.cloud.google.com/cloud-build)
2. Gledaj **gore desno** - možda vidiš:
   - **"RUN"** dugme (ako imaš trigger)
   - **"HISTORY"** tab (već otvoren)
   - **"TRIGGERS"** tab

### Korak 2: Ako vidiš "TRIGGERS" tab
1. Klikni na **"TRIGGERS"** tab
2. Ako imaš postojeći trigger, klikni na njega
3. Klikni **"RUN"** dugme
4. Build će se pokrenuti automatski

### Korak 3: Ako nemaš trigger
1. Klikni **"CREATE TRIGGER"**
2. Konfiguriši trigger (možeš preskočiti ovo i koristiti direktan build)

---

## 🔍 Opcija 2: Preko History Tab

1. Idi na [Cloud Build History](https://console.cloud.google.com/cloud-build/builds)
2. Gledaj **gore desno** - možda vidiš:
   - **"RUN"** dugme
   - **"+"** ikonica
   - **"CREATE BUILD"** (možda je sakriveno)

---

## 🔍 Opcija 3: Preko gcloud CLI (NAJLAKŠE)

Ako ne možeš da pronađeš dugme, koristi CLI direktno:

```powershell
cd C:\Users\Korisnik\Documents\GPTWrapped-1\backend

# Build direktno sa cloudbuild.yaml
gcloud builds submit --config cloudbuild.yaml
```

Ovo će automatski:
- Build-ovati Docker image
- Push-ovati u Artifact Registry
- Sve sa dozvolama koje Cloud Build ima!

---

## 🔍 Opcija 4: Preko Cloud Shell (U Browseru)

1. Idi na [Google Cloud Console](https://console.cloud.google.com)
2. Gore desno, klikni na **Cloud Shell** ikonicu (terminal ikonica)
3. Kada se otvori Cloud Shell, ukucaj:
```bash
cd backend
gcloud builds submit --config cloudbuild.yaml
```

---

## 🎯 NAJLAKŠE: Koristi gcloud CLI

**Ne treba ti ništa u browseru!**

U PowerShell-u:
```powershell
cd C:\Users\Korisnik\Documents\GPTWrapped-1\backend
gcloud builds submit --config cloudbuild.yaml
```

Ovo će:
- ✅ Automatski build-ovati Docker image
- ✅ Push-ovati u Artifact Registry (sa dozvolama)
- ✅ Sve bez problema sa dozvolama!

---

## 📝 Nakon Build-a

Kada build završi:
1. Idi na [Cloud Run](https://console.cloud.google.com/run)
2. Klikni na servis → **"EDIT & DEPLOY NEW REVISION"**
3. U **"Container image URL"**, izaberi najnoviji image
4. Dodaj environment varijablu:
   - Name: `USE_FAKE_VERSION`
   - Value: `true`
5. Klikni **"DEPLOY"**

---

## ✅ Provera

```
https://openai-proxy-server-301757777366.europe-west1.run.app/api/app-version
```

Trebalo bi: `{"useFakeVersion": true}`



