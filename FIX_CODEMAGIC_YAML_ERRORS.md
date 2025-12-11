# 🔧 Fix Codemagic YAML Errors

## 🎯 PROBLEM:

Greške u `codemagic.yaml`:
1. ❌ `Only one authentication method can be used` - koristiš i `auth: integration` i eksplicitne parametre
2. ❌ `xcode_project - extra fields not permitted` - `xcode_project` nije validno polje

---

## ✅ REŠENJE:

### **ISPRAVIO SAM GREŠKE!**

**Šta sam uradio:**
1. ✅ Uklonio `auth: integration` - koristim samo eksplicitne parametre
2. ✅ Uklonio `xcode_project` sekciju - Team ID se koristi u build komandi
3. ✅ Dodao Team ID u `flutter build ipa` komandu preko `export-options-plist`

---

## 📋 ŠTA SAM URADIO:

### **1. Uklonio `auth: integration`:**

**Pre:**
```yaml
app_store_connect:
  auth: integration  # ❌ Ne može sa eksplicitnim parametrima
  api_key: $APP_STORE_PRIVATE_KEY
  key_id: $APP_STORE_KEY_ID
  issuer_id: $APP_STORE_ISSUER_ID
```

**Sada:**
```yaml
app_store_connect:
  api_key: $APP_STORE_PRIVATE_KEY  # ✅ Samo eksplicitni parametri
  key_id: $APP_STORE_KEY_ID
  issuer_id: $APP_STORE_ISSUER_ID
```

**Zašto?**
- ✅ Možeš koristiti **ILI** `auth: integration` **ILI** eksplicitne parametre
- ✅ Koristim eksplicitne parametre jer već imaš environment variables

---

### **2. Uklonio `xcode_project` sekciju:**

**Pre:**
```yaml
xcode_project:  # ❌ Nije validno polje
  use_profiles: true
  team_id: $APP_STORE_TEAM_ID
```

**Sada:**
```yaml
# Team ID se koristi u flutter build ipa komandi
flutter build ipa --release \
  --export-options-plist=/dev/stdin <<EOF
  ...
  <key>teamID</key>
  <string>$APP_STORE_TEAM_ID</string>
  ...
EOF
```

**Zašto?**
- ✅ `xcode_project` nije validno polje u Codemagic YAML
- ✅ Team ID se prosleđuje kroz `export-options-plist` u build komandi
- ✅ `xcode-project use-profiles` automatski koristi sertifikate iz Codemagic

---

## 📋 SLEDEĆI KORACI:

### **1. Commit-uj i Push-uj:**

1. **U GitHub Desktop:**
   - Commit-uj promene u `codemagic.yaml`
   - Push-uj na GitHub

---

### **2. Proveri Environment Variables:**

**U Codemagic dashboard, proveri da li imaš:**

- ✅ `APP_STORE_PRIVATE_KEY` (sadržaj `.p8` fajla)
- ✅ `APP_STORE_KEY_ID` (Key ID)
- ✅ `APP_STORE_ISSUER_ID` (Issuer ID)
- ✅ `APP_STORE_TEAM_ID` (vrednost: `522DMZ83DM`)

---

### **3. Pokreni Novi Build:**

1. **U Codemagic dashboard:**
   - Klikni: **Start new build**
   - **Select branch:** `main`
   - **Select file workflow:** `ios-workflow`
   - Klikni: **Start build**

2. **Build će sada:**
   - ✅ Koristiti eksplicitne App Store Connect parametre
   - ✅ Koristiti Team ID iz environment variable
   - ✅ Automatski kreirati sertifikate i provisioning profile
   - ✅ Potpisati aplikaciju
   - ✅ Build-ovati IPA
   - ✅ Upload-ovati u TestFlight

---

## ⚠️ VAŽNO:

### **Authentication Metode:**

**Možeš koristiti SAMO JEDAN način:**

**OPCIJA 1: Integration (ako imaš API key u Codemagic integrations):**
```yaml
app_store_connect:
  auth: integration  # Koristi API key iz integrations
```

**OPCIJA 2: Eksplicitni parametri (ako koristiš environment variables):**
```yaml
app_store_connect:
  api_key: $APP_STORE_PRIVATE_KEY
  key_id: $APP_STORE_KEY_ID
  issuer_id: $APP_STORE_ISSUER_ID
```

**✅ Koristim OPCIJU 2** jer već imaš environment variables!

---

### **Team ID:**

- ✅ **Tvoj Team ID:** `522DMZ83DM`
- ✅ **Koristi se u `export-options-plist`** za code signing
- ✅ **Mora biti u environment variables** kao `APP_STORE_TEAM_ID`

---

## 📋 CHECKLIST:

- [ ] ✅ `codemagic.yaml` je ispravljen (uklonjen `auth: integration`)
- [ ] ✅ `codemagic.yaml` je ispravljen (uklonjen `xcode_project`)
- [ ] ✅ Team ID je dodat u build komandu
- [ ] ✅ Environment variables su dodati u Codemagic dashboard
- [ ] ✅ Promene su commit-ovane i push-ovane
- [ ] ✅ Pokrenut novi build
- [ ] ✅ Build je uspešan (nema YAML grešaka)

---

## 🎯 REZIME:

**Problem:**
1. Koristiš i `auth: integration` i eksplicitne parametre (ne može oba)
2. `xcode_project` nije validno polje

**Rešenje:**
1. ✅ **Uklonio `auth: integration`** - koristim samo eksplicitne parametre
2. ✅ **Uklonio `xcode_project`** - Team ID se koristi u build komandi
3. ✅ **Dodao Team ID u `export-options-plist`** za code signing

---

**Commit-uj promene i pokreni build - trebalo bi da radi! 🚀**



