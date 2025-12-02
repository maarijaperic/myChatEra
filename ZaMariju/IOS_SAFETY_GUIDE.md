# 🛡️ iOS Safety Guide - Git, Build i Fake Login

## 🎯 PREGLED:

Ovaj vodič objašnjava kako da se osiguraš da:
1. ✅ **Prava verzija se build-uje** (ne loša)
2. ✅ **Redosled promena je siguran** (Git čuva istoriju)
3. ✅ **iOS review tim vidi pravu verziju** (fake login za review)

---

## 📋 PROBLEM 1: Git i Build Verzije

### **✅ DOBRO: Sve je commit-ovano preko GitHub Desktop**

**Git čuva istoriju - redosled promena neće biti problem!**

---

### **🔒 KAKO DA SE OSIGURAŠ DA SE BUILD-UJE PRAVA VERZIJA:**

#### **OPCIJA A: Build Specific Commit (Preporučeno)**

**U Codemagic, možeš specificirati tačan commit:**

1. **U Codemagic dashboard:**
   - Idi na: **App settings** → **Build settings**
   - **Branch:** `main` (ili `master`)
   - **Commit:** Možeš ostaviti prazno (build-uje najnoviji) ili specificirati SHA

2. **Ili u `codemagic.yaml`:**
   ```yaml
   workflows:
     ios-workflow:
       name: iOS Workflow
       instance_type: mac_mini_m1
       environment:
         flutter: stable
       scripts:
         - name: Checkout specific commit
           script: |
             git checkout YOUR_COMMIT_SHA_HERE
         - name: Get Flutter dependencies
           script: |
             flutter pub get
   ```

---

#### **OPCIJA B: Koristi Git Tags (Najbolje za Production)**

**Kreiraj tag za svaku verziju:**

1. **U GitHub Desktop:**
   - Klikni desni klik na commit → **Create Tag**
   - **Tag name:** `v1.0.0-ios` (ili kako želiš)
   - **Push tag** na GitHub

2. **U Codemagic:**
   - **Branch:** `main`
   - **Tag:** `v1.0.0-ios` (specificiraj tag)

3. **Prednosti:**
   - ✅ **Jasno označena verzija**
   - ✅ **Lako se vraća na staru verziju**
   - ✅ **Sigurno za production**

---

#### **OPCIJA C: Build Najnoviji Commit (Najjednostavnije)**

**Ako je sve commit-ovano i push-ovano:**

1. **U Codemagic:**
   - **Branch:** `main` (ili `master`)
   - **Commit:** Ostavi prazno (build-uje najnoviji)

2. **Proveri pre build-a:**
   - ✅ Idi na GitHub i proveri da li je najnoviji commit onaj koji želiš
   - ✅ Proveri da li su sve promene commit-ovane

---

### **✅ PROVERA PRE BUILD-A:**

**Pre nego što pokreneš build:**

1. **Idi na GitHub:**
   - Proveri da li je najnoviji commit onaj koji želiš
   - Proveri da li su sve promene push-ovane

2. **Proveri commit SHA:**
   - Kopiraj commit SHA (npr. `abc123def456`)
   - U Codemagic, specificiraj taj SHA

3. **Proveri branch:**
   - Proveri da li si na pravom branch-u (`main` ili `master`)

---

## 📋 PROBLEM 2: Redosled Promena

### **✅ GIT ČUVA ISTORIJU - NEMA PROBLEMA!**

**Git ne menja redosled promena - čuva ih u istoriji!**

---

### **🔒 KAKO GIT RADI:**

1. **Svaki commit ima SHA hash:**
   - Primer: `abc123def456...`
   - SHA je jedinstven za svaki commit
   - Ne može se promeniti

2. **Git čuva istoriju:**
   - Svi commit-ovi su sačuvani
   - Redosled je fiksiran
   - Ne može se izmeniti

3. **Build-uje se tačan commit:**
   - Codemagic build-uje tačan commit SHA
   - Ne može se "pomešati" sa drugim commit-om

---

### **✅ PROVERA:**

**Proveri da li je sve commit-ovano:**

1. **U GitHub Desktop:**
   - Proveri da li imaš uncommitted changes
   - Ako ima, commit-uj ih

2. **Proveri da li je sve push-ovano:**
   - Proveri da li imaš unpushed commits
   - Ako ima, push-uj ih

3. **Proveri na GitHub:**
   - Idi na GitHub repo
   - Proveri da li su sve promene vidljive

---

## 📋 PROBLEM 3: iOS Review i Fake Login

### **⚠️ VAŽNO: iOS Review Tim MOŽE VIDETI BACKEND FLAG!**

**Aplikacija poziva backend API pri startu - iOS review tim će videti šta backend vraća!**

---

### **🔒 KAKO DA SE OSIGURAŠ:**

#### **KORAK 1: Postavi Backend Flag PRE Build-a**

**PRE nego što build-uješ iOS aplikaciju:**

1. **Postavi `USE_FAKE_VERSION=true` u backend:**
   ```bash
   # U backend/.env
   USE_FAKE_VERSION=true
   ```

2. **Redeploy backend:**
   - Deploy backend sa `USE_FAKE_VERSION=true`
   - Proveri da li endpoint vraća `{"useFakeVersion": true}`

3. **Proveri endpoint:**
   ```bash
   curl https://your-backend-url.com/api/app-version
   # Trebalo bi da vrati: {"useFakeVersion": true}
   ```

---

#### **KORAK 2: Build iOS Aplikaciju**

**Nakon što je backend postavljen na `USE_FAKE_VERSION=true`:**

1. **Build-uj iOS aplikaciju u Codemagic**
2. **Aplikacija će pri startu pozvati backend**
3. **Backend će vratiti `useFakeVersion: true`**
4. **Aplikacija će koristiti FakeLoginScreen**

---

#### **KORAK 3: Submit za Review**

**Nakon što je build završen:**

1. **Upload IPA u App Store Connect**
2. **Submit za review**
3. **iOS review tim će videti FakeLoginScreen** (file import)

---

#### **KORAK 4: Nakon Odobrenja**

**Nakon što iOS review prođe:**

1. **Postavi `USE_FAKE_VERSION=false` u backend:**
   ```bash
   # U backend/.env
   USE_FAKE_VERSION=false
   ```

2. **Redeploy backend:**
   - Deploy backend sa `USE_FAKE_VERSION=false`
   - Proveri da li endpoint vraća `{"useFakeVersion": false}`

3. **Aplikacija automatski prelazi na real verziju:**
   - Korisnici će videti web view login
   - Nema potrebe za novi build!

---

### **⚠️ VAŽNO: Backend Flag je DINAMIČAN!**

**Aplikacija proverava backend PRI SVAKOM STARTU:**

- ✅ **Ako je `USE_FAKE_VERSION=true`** → FakeLoginScreen
- ✅ **Ako je `USE_FAKE_VERSION=false`** → LoginScreen (web view)

**To znači:**
- ✅ **Možeš promeniti flag bez novog build-a**
- ✅ **Korisnici će videti pravu verziju automatski**
- ✅ **Nema potrebe za update aplikacije**

---

### **🔒 ALTERNATIVA: Hardkodovani Flag za iOS Review**

**Ako se plašiš da backend flag ne radi:**

**Možeš hardkodovati flag samo za iOS build:**

1. **Dodaj environment variable u Codemagic:**
   - `FORCE_FAKE_LOGIN=true`

2. **U `main.dart` ili `screen_welcome.dart`:**
   ```dart
   const bool FORCE_FAKE_LOGIN = bool.fromEnvironment(
     'FORCE_FAKE_LOGIN',
     defaultValue: false,
   );
   ```

3. **U `codemagic.yaml`:**
   ```yaml
   environment:
     groups:
       - app_store_credentials
     vars:
       FORCE_FAKE_LOGIN: "true"
   ```

4. **Prednosti:**
   - ✅ **Ne zavisi od backend-a**
   - ✅ **Sigurno za review**
   - ✅ **Možeš promeniti samo za iOS build**

5. **Nedostaci:**
   - ❌ **Zahteva novi build za promenu**
   - ❌ **Ne možeš promeniti bez update-a**

---

## 📋 CHECKLIST PRE iOS BUILD-A:

### **1. Git Provera:**
- [ ] ✅ Sve promene su commit-ovane
- [ ] ✅ Sve promene su push-ovane na GitHub
- [ ] ✅ Proveren najnoviji commit SHA
- [ ] ✅ Proveren branch (`main` ili `master`)

### **2. Backend Provera:**
- [ ] ✅ `USE_FAKE_VERSION=true` u backend `.env`
- [ ] ✅ Backend je redeploy-ovan
- [ ] ✅ Endpoint `/api/app-version` vraća `{"useFakeVersion": true}`
- [ ] ✅ Test-ovano da aplikacija vidi fake login

### **3. Build Provera:**
- [ ] ✅ Codemagic je konfigurisan
- [ ] ✅ Environment variables su postavljeni
- [ ] ✅ App Store Connect API keys su dodati
- [ ] ✅ Build je pokrenut sa pravim commit-om

### **4. Post-Build Provera:**
- [ ] ✅ IPA je build-ovana uspešno
- [ ] ✅ IPA je upload-ovana u App Store Connect
- [ ] ✅ Test-ovano da aplikacija koristi FakeLoginScreen
- [ ] ✅ Submit-ovano za review

---

## 🎯 REZIME:

### **Git i Build:**
- ✅ **Git čuva istoriju** - redosled neće biti problem
- ✅ **Koristi Git tags** za production build-ove
- ✅ **Proveri commit SHA** pre build-a

### **Backend Flag:**
- ✅ **Postavi `USE_FAKE_VERSION=true` PRE build-a**
- ✅ **Redeploy backend** sa novim flag-om
- ✅ **Proveri endpoint** pre build-a
- ✅ **Nakon review-a, postavi `USE_FAKE_VERSION=false`**

### **iOS Review:**
- ✅ **iOS review tim će videti FakeLoginScreen** (ako je flag postavljen)
- ✅ **Nakon odobrenja, promeni flag** - aplikacija automatski prelazi na real verziju
- ✅ **Nema potrebe za novi build** nakon review-a

---

## ⚠️ VAŽNO:

**Backend flag je DINAMIČAN - aplikacija proverava pri svakom startu!**

**To znači:**
- ✅ **Možeš promeniti flag bez novog build-a**
- ✅ **Korisnici će videti pravu verziju automatski**
- ✅ **Nema potrebe za update aplikacije**

---

**Sve je sigurno! 🛡️**
