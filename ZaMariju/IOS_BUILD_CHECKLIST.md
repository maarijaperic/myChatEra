# ✅ iOS Build Checklist - Pre Build-a

## 🎯 KORAK PO KORAK:

### **1. Git Provera (5 minuta)**

- [ ] **Otvori GitHub Desktop**
- [ ] **Proveri da li imaš uncommitted changes**
  - Ako ima → Commit-uj ih
- [ ] **Proveri da li imaš unpushed commits**
  - Ako ima → Push-uj ih
- [ ] **Idi na GitHub i proveri najnoviji commit**
  - Kopiraj commit SHA (npr. `abc123def456`)
  - Proveri da li su sve promene vidljive

---

### **2. Backend Setup (10 minuta)**

- [ ] **Idi na backend folder**
- [ ] **Otvori `.env` fajl**
- [ ] **Postavi `USE_FAKE_VERSION=true`**
  ```bash
  USE_FAKE_VERSION=true
  ```
- [ ] **Redeploy backend**
  - Google Cloud Run ili gde god je deployed
- [ ] **Proveri endpoint:**
  ```bash
  curl https://your-backend-url.com/api/app-version
  ```
  - Trebalo bi da vrati: `{"useFakeVersion": true}`

---

### **3. Codemagic Setup (15 minuta)**

- [ ] **Idi na Codemagic dashboard**
- [ ] **Proveri app settings:**
  - Branch: `main` (ili `master`)
  - Commit: (ostavi prazno ili specificiraj SHA)
- [ ] **Proveri environment variables:**
  - `APP_STORE_CONNECT_KEY_IDENTIFIER`
  - `APP_STORE_CONNECT_ISSUER_ID`
  - `APP_STORE_CONNECT_PRIVATE_KEY`
  - `REVENUECAT_API_KEY` (iOS)
- [ ] **Proveri code signing:**
  - Automatic code signing je omogućen
  - Bundle identifier: `com.mychatera`

---

### **4. Build (30-60 minuta)**

- [ ] **Klikni "Start new build" u Codemagic**
- [ ] **Izaberi iOS workflow**
- [ ] **Klikni "Start build"**
- [ ] **Sačekaj da build završi**
- [ ] **Proveri da li je build uspešan**

---

### **5. Post-Build Provera (10 minuta)**

- [ ] **Preuzmi IPA fajl** (ako nije automatski upload-ovan)
- [ ] **Proveri da li je IPA upload-ovana u App Store Connect**
- [ ] **Test-uj aplikaciju** (ako imaš TestFlight)
  - Proveri da li koristi FakeLoginScreen
  - Proveri da li sve funkcionalnosti rade

---

### **6. App Store Connect (20 minuta)**

- [ ] **Idi na App Store Connect**
- [ ] **Proveri da li je build vidljiv**
- [ ] **Proveri da li su In-App Purchase proizvodi kreirani**
- [ ] **Popuni Store Listing** (ako nije)
- [ ] **Submit za review**

---

## ⚠️ VAŽNO PRE BUILD-A:

### **Backend Flag:**
- ✅ **MORA biti `USE_FAKE_VERSION=true` PRE build-a**
- ✅ **MORA biti redeploy-ovan PRE build-a**
- ✅ **MORA vratiti `{"useFakeVersion": true}`**

### **Git:**
- ✅ **Sve promene MORAJU biti commit-ovane**
- ✅ **Sve promene MORAJU biti push-ovane**
- ✅ **Proveri commit SHA pre build-a**

---

## 🎯 NAKON REVIEW-A:

### **1. Promeni Backend Flag:**

- [ ] **Postavi `USE_FAKE_VERSION=false` u backend**
- [ ] **Redeploy backend**
- [ ] **Proveri endpoint:**
  ```bash
  curl https://your-backend-url.com/api/app-version
  ```
  - Trebalo bi da vrati: `{"useFakeVersion": false}`

### **2. Aplikacija Automatski Prelazi:**

- [ ] **Korisnici će videti web view login** (bez novog build-a!)
- [ ] **Nema potrebe za update aplikacije**
- [ ] **Sve radi automatski**

---

## 📋 QUICK CHECKLIST:

**Pre Build-a:**
- [ ] Git: Sve commit-ovano i push-ovano
- [ ] Backend: `USE_FAKE_VERSION=true` i redeploy-ovan
- [ ] Codemagic: Environment variables postavljeni
- [ ] Codemagic: Code signing konfigurisan

**Nakon Build-a:**
- [ ] IPA build-ovana uspešno
- [ ] IPA upload-ovana u App Store Connect
- [ ] Test-ovano da koristi FakeLoginScreen
- [ ] Submit-ovano za review

**Nakon Review-a:**
- [ ] Backend: `USE_FAKE_VERSION=false` i redeploy-ovan
- [ ] Provereno da aplikacija koristi web view login

---

**Sve je spremno! 🚀**
