# 🔐 Codemagic Environment Variables Setup - Najlakše Rešenje

## 🎯 PROBLEM:

Ne možeš da nađeš "Code signing" opciju u Codemagic dashboard-u, ali već imaš App Store Connect API key.

---

## ✅ REŠENJE:

### **KORISTIĆEMO APP STORE CONNECT API KEY ZA AUTOMATSKI CODE SIGNING!**

**Najlakše rešenje:** Dodaj environment variables u Codemagic dashboard i ažuriraj `codemagic.yaml`!

---

## 📋 KORAK 1: Dodaj Environment Variables u Codemagic Dashboard

### **1.1. Idi na Codemagic Dashboard:**

1. **Otvori:** https://codemagic.io/apps
2. **Klikni na tvoju aplikaciju** (GPTWrapped-1)
3. **Idi na:** **Settings** (ili klikni na ikonicu zupčanika ⚙️)
4. **Idi na:** **Environment variables** (ili **Variables**)

---

### **1.2. Dodaj 4 Environment Variables:**

**Klikni:** **+ Add variable** za svaki od ovih:

#### **1. APP_STORE_PRIVATE_KEY**
- **Variable name:** `APP_STORE_PRIVATE_KEY`
- **Value:** Sadržaj tvog `.p8` fajla (ceo tekst, uključujući `-----BEGIN PRIVATE KEY-----` i `-----END PRIVATE KEY-----`)
- **Secure:** ✅ (označi kao secure)

#### **2. APP_STORE_KEY_ID**
- **Variable name:** `APP_STORE_KEY_ID`
- **Value:** Tvoj Key ID (npr. `ABC123XYZ`)
- **Secure:** ❌ (ne mora biti secure)

#### **3. APP_STORE_ISSUER_ID**
- **Variable name:** `APP_STORE_ISSUER_ID`
- **Value:** Tvoj Issuer ID (npr. `12345678-1234-1234-1234-123456789012`)
- **Secure:** ❌ (ne mora biti secure)

#### **4. APP_STORE_TEAM_ID**
- **Variable name:** `APP_STORE_TEAM_ID`
- **Value:** `522DMZ83DM` (tvoj Team ID)
- **Secure:** ❌ (ne mora biti secure)

---

### **1.3. Kako da Kopiraš Private Key:**

**Ako imaš `.p8` fajl:**

1. **Otvori `.p8` fajl** u text editor-u (Notepad, VS Code, itd.)
2. **Kopiraj ceo sadržaj**, uključujući:
   ```
   -----BEGIN PRIVATE KEY-----
   MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQg...
   ...
   -----END PRIVATE KEY-----
   ```
3. **Nalepi u Codemagic** kao vrednost za `APP_STORE_PRIVATE_KEY`

---

## 📋 KORAK 2: Proveri codemagic.yaml

**Već sam ažurirao `codemagic.yaml` sa:**

```yaml
app_store_connect:
  auth: integration
  api_key: $APP_STORE_PRIVATE_KEY
  key_id: $APP_STORE_KEY_ID
  issuer_id: $APP_STORE_ISSUER_ID
  submit_to_testflight: true
  submit_to_app_store: false

xcode_project:
  use_profiles: true
  team_id: $APP_STORE_TEAM_ID
```

**Ovo će automatski:**
- ✅ Koristiti App Store Connect API key za code signing
- ✅ Kreirati sertifikate i provisioning profile automatski
- ✅ Potpisati aplikaciju
- ✅ Upload-ovati u TestFlight

---

## 📋 KORAK 3: Commit-uj i Push-uj

1. **U GitHub Desktop:**
   - Commit-uj promene u `codemagic.yaml`
   - Push-uj na GitHub

---

## 📋 KORAK 4: Pokreni Build

1. **U Codemagic dashboard:**
   - Klikni: **Start new build**
   - **Select branch:** `main`
   - **Select file workflow:** `ios-workflow`
   - Klikni: **Start build**

2. **Build će sada:**
   - ✅ Koristiti environment variables za code signing
   - ✅ Automatski kreirati sertifikate i provisioning profile
   - ✅ Potpisati aplikaciju
   - ✅ Build-ovati IPA
   - ✅ Upload-ovati u TestFlight (ako je `submit_to_testflight: true`)

---

## ⚠️ VAŽNO:

### **Gde Naći Environment Variables u Codemagic:**

**Ako ne možeš da nađeš "Code signing" opciju:**

1. **Idi na:** **Settings** (ikona zupčanika ⚙️)
2. **Traži:** **Environment variables** ili **Variables**
3. **Ako ne vidiš:**
   - Možda je u **App settings** → **Environment variables**
   - Ili u **Workflow settings** → **Environment variables**

**Ako i dalje ne možeš da nađeš:**

- **Kontaktiraj Codemagic support** - možda imaš različitu verziju dashboard-a
- **Ili koristi:** **Settings** → **Secrets** (neki dashboard-i koriste "Secrets" umesto "Environment variables")

---

### **Team ID:**

- ✅ **Tvoj Team ID:** `522DMZ83DM`
- ✅ **Već sam dodao u `codemagic.yaml`** kao `$APP_STORE_TEAM_ID`

---

### **Bundle Identifier:**

- ✅ **Mora biti:** `com.mychatera`
- ✅ **Proveri da li je u Xcode projektu** (`project.pbxproj`)

---

## 📋 CHECKLIST:

- [ ] ✅ Dodao `APP_STORE_PRIVATE_KEY` u Codemagic environment variables
- [ ] ✅ Dodao `APP_STORE_KEY_ID` u Codemagic environment variables
- [ ] ✅ Dodao `APP_STORE_ISSUER_ID` u Codemagic environment variables
- [ ] ✅ Dodao `APP_STORE_TEAM_ID` u Codemagic environment variables (vrednost: `522DMZ83DM`)
- [ ] ✅ `codemagic.yaml` je ažuriran (već urađeno)
- [ ] ✅ Promene su commit-ovane i push-ovane
- [ ] ✅ Pokrenut novi build
- [ ] ✅ Build je uspešan (code signing radi)

---

## 🎯 REZIME:

**Problem:** Ne možeš da nađeš "Code signing" opciju u Codemagic dashboard-u

**Rešenje:**
1. ✅ **Dodaj environment variables u Codemagic dashboard**
2. ✅ **`codemagic.yaml` već koristi te varijable** (ažurirao sam ga)
3. ✅ **Codemagic će automatski koristiti App Store Connect API key za code signing**

---

## 🔗 KORISNI LINKOVI:

- **Codemagic Environment Variables:** https://docs.codemagic.io/variables/environment-variables/
- **Codemagic App Store Connect:** https://docs.codemagic.io/publishing-yaml/distribution/#app-store-connect
- **App Store Connect:** https://appstoreconnect.apple.com/

---

**Dodaj environment variables u Codemagic dashboard i pokreni build - trebalo bi da radi! 🚀**



