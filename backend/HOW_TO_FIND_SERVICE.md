# Kako da Pronađeš OpenAI Proxy Server na Google Cloud Console

## 📍 Korak po Korak Vodič

### 1. Otvori Google Cloud Console
- Idi na: [https://console.cloud.google.com](https://console.cloud.google.com)
- Login-uj se sa svojim Google nalogom

### 2. Izaberi Projekat
- Na vrhu stranice, levo od "Google Cloud", klikni na **dropdown sa nazivom projekta**
- Izaberi projekat (možda se zove `gpt-wrapped` ili ima project ID `301757777366`)

### 3. Otvori Cloud Run
**Opcija A: Preko menija (NAJLAKŠE)**
- Sa leve strane, klikni na **☰ (hamburger menu)**
- Scroll do sekcije **"Serverless"** ili **"Compute"**
- Klikni na **"Cloud Run"**

**Opcija B: Preko search bara**
- Na vrhu stranice, klikni na **🔍 (search)**
- Ukucaj: `cloud run`
- Klikni na **"Cloud Run"** iz rezultata

**Opcija C: Direktan link**
- Idi na: [https://console.cloud.google.com/run](https://console.cloud.google.com/run)

### 4. Pronađi Servis
- U listi servisa, traži:
  - `openai-proxy-server` (najverovatnije)
  - Ili neki drugi naziv koji si koristio
  - Može biti i samo `proxy-server` ili `gpt-proxy`

**Ako ne vidiš servis:**
- Proveri da li si u pravom projektu (gore levo)
- Proveri da li si u pravom regionu (možda je `europe-west1` ili `us-central1`)
- Klikni na **"All regions"** filter ako ne vidiš ništa

### 5. Klikni na Servis
- Klikni na naziv servisa (npr. `openai-proxy-server`)
- Otvoriće se stranica sa detaljima servisa

---

## 🎯 Šta Tražiš

Kada otvoriš Cloud Run, trebalo bi da vidiš:

```
┌─────────────────────────────────────────┐
│  Cloud Run                               │
├─────────────────────────────────────────┤
│  [All regions ▼]                        │
│                                          │
│  Service Name          Region    Status │
│  openai-proxy-server    europe-  ✅      │
│                         west1            │
└─────────────────────────────────────────┘
```

---

## 🔍 Ako Ne Možeš da Pronađeš Servis

### Proveri Projekat
1. Na vrhu stranice, proveri koji projekat je izabran
2. Ako nije pravi, klikni na dropdown i izaberi pravi projekat

### Proveri Region
1. U Cloud Run, proveri filter za region
2. Možda je servis u drugom regionu (npr. `us-central1`, `europe-west1`)

### Proveri da li Servis Postoji
1. Idi na [Cloud Run Services](https://console.cloud.google.com/run)
2. Ako lista je prazna, možda servis nije deploy-ovan
3. Proveri da li si u pravom projektu

### Pronađi Servis Preko URL-a
Ako znaš URL servisa (npr. `https://openai-proxy-server-301757777366.europe-west1.run.app`):
1. URL format: `https://SERVICE-NAME-PROJECT-ID.REGION.run.app`
2. Iz URL-a možeš videti:
   - **Service name:** `openai-proxy-server`
   - **Project ID:** `301757777366`
   - **Region:** `europe-west1`

---

## 📸 Vizuelni Vodič

```
Google Cloud Console
│
├── ☰ Menu (hamburger)
│   │
│   ├── Compute
│   │   └── Cloud Run  ← KLIKNI OVDE
│   │
│   └── Serverless
│       └── Cloud Run  ← ILI OVDE
│
└── Search Bar
    └── "cloud run" → Cloud Run
```

---

## 🆘 Troubleshooting

**Problem: "No services found"**
- Proveri da li si u pravom projektu
- Proveri da li je servis deploy-ovan
- Možda nemaš dozvole da vidiš servis

**Problem: "Access denied"**
- Proveri da li imaš dozvole za Cloud Run
- Kontaktiraj administratora projekta

**Problem: "Can't find the project"**
- Proveri da li si login-ovan sa pravim Google nalogom
- Proveri da li projekat postoji

---

## 💡 Brzi Put

1. **Direktan link:** [console.cloud.google.com/run](https://console.cloud.google.com/run)
2. **Izaberi projekat** (gore levo)
3. **Klikni na servis** iz liste

---

## 📝 Alternativni Način - Preko Search-a

1. Na vrhu Google Cloud Console, klikni na **🔍 (search)**
2. Ukucaj: `openai-proxy-server` ili `proxy server`
3. Ako servis postoji, pojaviće se u rezultatima
4. Klikni na servis da ga otvoriš

---

**Ako i dalje ne možeš da pronađeš, javi mi i pomoći ću ti! 🚀**
