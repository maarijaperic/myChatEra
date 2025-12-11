# 🔐 Fix Code Signing - Automatsko Kreiranje Sertifikata

## 🎯 PROBLEM:

Greška:
> "No Accounts: Add a new account in Accounts settings."
> "No profiles for 'com.mychatera' were found"

**Problem:** Codemagic ne može da pronađe sertifikate i provisioning profile jer nisu kreirani.

---

## ✅ REŠENJE:

### **DODAO SAM AUTOMATSKO KREIRANJE SERTIFIKATA!**

**Šta sam uradio:**
1. ✅ Dodao `keychain initialize` - inicijalizuje keychain za code signing
2. ✅ Dodao `app-store-connect fetch-signing-files` - automatski kreira sertifikate i provisioning profile
3. ✅ Koristim `--create` flag da kreira nove sertifikate ako ne postoje

---

## 📋 ŠTA SAM URADIO:

### **1. Dodao Keychain Setup:**

```yaml
- name: Set up keychain to be used for code signing
  script: |
    keychain initialize
```

**Zašto?**
- ✅ Inicijalizuje keychain gde će se čuvati sertifikati
- ✅ Potrebno pre nego što dodamo sertifikate

---

### **2. Dodao Automatsko Kreiranje Sertifikata:**

```yaml
- name: Fetch signing files
  script: |
    app-store-connect fetch-signing-files "com.mychatera" \
      --type IOS_APP_STORE \
      --create \
      --issuer-id=$APP_STORE_ISSUER_ID \
      --api-key-id=$APP_STORE_KEY_ID \
      --api-private-key="$APP_STORE_PRIVATE_KEY"
```

**Zašto?**
- ✅ `fetch-signing-files` automatski kreira sertifikate i provisioning profile
- ✅ `--create` flag kreira nove sertifikate ako ne postoje
- ✅ `--type IOS_APP_STORE` specifikuje tip sertifikata (za App Store)
- ✅ Koristi App Store Connect API key za autentifikaciju

---

### **3. Koristim xcode-project use-profiles:**

```yaml
- name: Set up code signing settings on Xcode project
  script: |
    xcode-project use-profiles
```

**Zašto?**
- ✅ Konfiguriše Xcode projekat da koristi provisioning profile iz Codemagic
- ✅ Sertifikati su već kreirani i dodati u keychain

---

## 📋 SLEDEĆI KORACI:

### **1. Proveri Environment Variables:**

**U Codemagic dashboard, proveri da li imaš:**

- ✅ `APP_STORE_PRIVATE_KEY` (sadržaj `.p8` fajla)
- ✅ `APP_STORE_KEY_ID` (Key ID)
- ✅ `APP_STORE_ISSUER_ID` (Issuer ID)

**Team ID (`APP_STORE_TEAM_ID`) nije potreban** - automatski se detektuje iz sertifikata!

---

### **2. Commit-uj i Push-uj:**

1. **U GitHub Desktop:**
   - Commit-uj promene u `codemagic.yaml`
   - Push-uj na GitHub

---

### **3. Pokreni Novi Build:**

1. **U Codemagic dashboard:**
   - Klikni: **Start new build**
   - **Select branch:** `main`
   - **Select file workflow:** `ios-workflow`
   - Klikni: **Start build**

2. **Build će sada:**
   - ✅ Inicijalizovati keychain
   - ✅ Automatski kreirati sertifikate i provisioning profile (ako ne postoje)
   - ✅ Dodati sertifikate u keychain
   - ✅ Konfigurisati Xcode projekat sa provisioning profile-ima
   - ✅ Potpisati aplikaciju
   - ✅ Build-ovati IPA
   - ✅ Upload-ovati u TestFlight

---

## ⚠️ VAŽNO:

### **App Store Connect API Key:**

**Moraš imati:**
- ✅ **App Store Connect API key** (`.p8` fajl)
- ✅ **Key ID** i **Issuer ID**
- ✅ **Environment variables** u Codemagic dashboard

**Ako nemaš:**
1. Idi na: https://appstoreconnect.apple.com/
2. **Users and Access** → **Keys** → **App Store Connect API**
3. Klikni: **+** (generate API key)
4. Preuzmi `.p8` fajl i zapamti Key ID i Issuer ID

---

### **Bundle Identifier:**

- ✅ **Mora biti:** `com.mychatera`
- ✅ **Mora biti isti** kao u Apple Developer Portal i App Store Connect

---

### **Prvi Build:**

**Prvi put kada pokreneš build:**
- ✅ Codemagic će automatski kreirati sertifikate i provisioning profile
- ✅ Ovo može potrajati nekoliko minuta
- ✅ Sledeći build-ovi će biti brži (koriste postojeće sertifikate)

---

## 📋 CHECKLIST:

- [ ] ✅ `codemagic.yaml` je ažuriran (dodato automatsko kreiranje sertifikata)
- [ ] ✅ Environment variables su dodati u Codemagic dashboard
- [ ] ✅ `APP_STORE_PRIVATE_KEY` je dodat (sadržaj `.p8` fajla)
- [ ] ✅ `APP_STORE_KEY_ID` je dodat (Key ID)
- [ ] ✅ `APP_STORE_ISSUER_ID` je dodat (Issuer ID)
- [ ] ✅ Promene su commit-ovane i push-ovane
- [ ] ✅ Pokrenut novi build
- [ ] ✅ Build je uspešan (sertifikati su kreirani i aplikacija je potpisana)

---

## 🎯 REZIME:

**Problem:** Codemagic ne može da pronađe sertifikate i provisioning profile

**Rešenje:**
1. ✅ **Dodao `keychain initialize`** - inicijalizuje keychain
2. ✅ **Dodao `app-store-connect fetch-signing-files`** - automatski kreira sertifikate
3. ✅ **Koristim `--create` flag** - kreira nove sertifikate ako ne postoje

---

**Commit-uj promene i pokreni build - Codemagic će automatski kreirati sertifikate! 🚀**



