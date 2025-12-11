# 🔧 Fix Fetch Signing Files Syntax Error

## 🎯 PROBLEM:

Greška:
> "app-store-connect: error: unrecognized arguments: --api-key-id=******** --api-private-key=********"

**Problem:** `app-store-connect fetch-signing-files` ne prihvata eksplicitne argumente za API key!

---

## ✅ REŠENJE:

### **KORISTI ENVIRONMENT VARIABLES DIREKTNO!**

**Šta sam uradio:**
1. ✅ Uklonio eksplicitne argumente (`--api-key-id`, `--api-private-key`, `--issuer-id`)
2. ✅ `app-store-connect` automatski koristi environment variables
3. ✅ Ažurirao imena environment variables na standardne Codemagic imena

---

## 📋 ŠTA SAM URADIO:

### **1. Uprošćena Komanda:**

**Pre:**
```yaml
app-store-connect fetch-signing-files "com.mychatera" \
  --type IOS_APP_STORE \
  --create \
  --issuer-id=$APP_STORE_ISSUER_ID \
  --api-key-id=$APP_STORE_KEY_ID \
  --api-private-key="$APP_STORE_PRIVATE_KEY"
```

**Sada:**
```yaml
app-store-connect fetch-signing-files "com.mychatera" \
  --type IOS_APP_STORE \
  --create
```

**Zašto?**
- ✅ `app-store-connect` automatski koristi environment variables
- ✅ Ne treba eksplicitno prosleđivati API key kao argumente
- ✅ Jednostavnije i sigurnije

---

### **2. Ažurirao Imena Environment Variables:**

**Pre:**
```yaml
app_store_connect:
  api_key: $APP_STORE_PRIVATE_KEY
  key_id: $APP_STORE_KEY_ID
  issuer_id: $APP_STORE_ISSUER_ID
```

**Sada:**
```yaml
app_store_connect:
  api_key: $APP_STORE_CONNECT_PRIVATE_KEY
  key_id: $APP_STORE_CONNECT_KEY_IDENTIFIER
  issuer_id: $APP_STORE_CONNECT_ISSUER_ID
```

**Zašto?**
- ✅ Koristim standardne Codemagic imena environment variables
- ✅ `APP_STORE_CONNECT_KEY_IDENTIFIER` umesto `APP_STORE_KEY_ID`
- ✅ `APP_STORE_CONNECT_ISSUER_ID` umesto `APP_STORE_ISSUER_ID`
- ✅ `APP_STORE_CONNECT_PRIVATE_KEY` umesto `APP_STORE_PRIVATE_KEY`

---

## 📋 SLEDEĆI KORACI:

### **1. Ažuriraj Environment Variables u Codemagic Dashboard:**

**U Codemagic dashboard, promeni imena variables:**

#### **1. APP_STORE_CONNECT_PRIVATE_KEY** (umesto APP_STORE_PRIVATE_KEY)
- **Variable name:** `APP_STORE_CONNECT_PRIVATE_KEY`
- **Variable value:** Sadržaj tvog `.p8` fajla (ceo tekst)
- **Secret:** ✅ (označi kao secure)
- **Select group:** Izaberi tvoju grupu

#### **2. APP_STORE_CONNECT_KEY_IDENTIFIER** (umesto APP_STORE_KEY_ID)
- **Variable name:** `APP_STORE_CONNECT_KEY_IDENTIFIER`
- **Variable value:** Tvoj Key ID (npr. `ABC123XYZ`)
- **Secret:** ❌ (ne mora biti secure)
- **Select group:** Izaberi istu grupu

#### **3. APP_STORE_CONNECT_ISSUER_ID** (umesto APP_STORE_ISSUER_ID)
- **Variable name:** `APP_STORE_CONNECT_ISSUER_ID`
- **Variable value:** Tvoj Issuer ID (npr. `12345678-1234-1234-1234-123456789012`)
- **Secret:** ❌ (ne mora biti secure)
- **Select group:** Izaberi istu grupu

**ILI:**

**Ako već imaš stare variables:**
- Obriši stare (`APP_STORE_PRIVATE_KEY`, `APP_STORE_KEY_ID`, `APP_STORE_ISSUER_ID`)
- Dodaj nove sa standardnim imenima

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
   - ✅ Koristiti environment variables direktno
   - ✅ Automatski kreirati sertifikate i provisioning profile
   - ✅ Potpisati aplikaciju
   - ✅ Build-ovati IPA
   - ✅ Upload-ovati u TestFlight

---

## ⚠️ VAŽNO:

### **Standardna Codemagic Imena:**

**Codemagic koristi standardna imena za App Store Connect:**

- ✅ `APP_STORE_CONNECT_KEY_IDENTIFIER` (Key ID)
- ✅ `APP_STORE_CONNECT_ISSUER_ID` (Issuer ID)
- ✅ `APP_STORE_CONNECT_PRIVATE_KEY` (Private Key)

**NE koristi:**
- ❌ `APP_STORE_KEY_ID`
- ❌ `APP_STORE_ISSUER_ID`
- ❌ `APP_STORE_PRIVATE_KEY`

---

### **Kako `app-store-connect` Radi:**

**`app-store-connect fetch-signing-files` automatski:**
- ✅ Čita environment variables iz okruženja
- ✅ Ne treba eksplicitno prosleđivati kao argumente
- ✅ Koristi standardna imena (`APP_STORE_CONNECT_*`)

---

## 📋 CHECKLIST:

- [ ] ✅ `codemagic.yaml` je ažuriran (uprošćena komanda)
- [ ] ✅ Environment variables su ažurirani sa standardnim imenima
- [ ] ✅ `APP_STORE_CONNECT_PRIVATE_KEY` je dodat (umesto `APP_STORE_PRIVATE_KEY`)
- [ ] ✅ `APP_STORE_CONNECT_KEY_IDENTIFIER` je dodat (umesto `APP_STORE_KEY_ID`)
- [ ] ✅ `APP_STORE_CONNECT_ISSUER_ID` je dodat (umesto `APP_STORE_ISSUER_ID`)
- [ ] ✅ Promene su commit-ovane i push-ovane
- [ ] ✅ Pokrenut novi build
- [ ] ✅ Build je uspešan (nema sintaksnih grešaka)

---

## 🎯 REZIME:

**Problem:** `app-store-connect fetch-signing-files` ne prihvata eksplicitne argumente za API key

**Rešenje:**
1. ✅ **Uklonio eksplicitne argumente** - `app-store-connect` koristi environment variables direktno
2. ✅ **Ažurirao imena environment variables** na standardne Codemagic imena
3. ✅ **Uprošćena komanda** - samo `--type` i `--create` flag-ovi

---

**Ažuriraj environment variables sa standardnim imenima i pokreni build - trebalo bi da radi! 🚀**



