# 🔧 Codemagic Environment Variables - Kako Pravilno Dodati

## 🎯 PROBLEM:

Dodao/la si environment variables u Codemagic dashboard, ali ne vidiš ih u build-u.

**Problem:** Variables su dodati u grupu, ali ta grupa nije importovana u `codemagic.yaml`!

---

## ✅ REŠENJE:

### **IMAŠ 2 OPCIJE:**

**OPCIJA 1: Dodaj variables BEZ grupe (najlakše)**
**OPCIJA 2: Dodaj grupu u `codemagic.yaml`**

---

## 📋 OPCIJA 1: Dodaj Variables BEZ Grupe (Preporučeno)

### **1.1. Idi na Codemagic Dashboard:**

1. **Otvori:** https://codemagic.io/apps
2. **Klikni na tvoju aplikaciju** (GPTWrapped-1)
3. **Idi na:** **Settings** (ikona zupčanika ⚙️)
4. **Idi na:** **Environment variables**

---

### **1.2. Dodaj Variables BEZ Grupe:**

**Klikni:** **+ Add variable**

**Za svaki variable:**
- **Variable name:** Unesi ime (npr. `APP_STORE_PRIVATE_KEY`)
- **Variable value:** Unesi vrednost
- **Secret:** ✅ Označi ako je osetljivo (za private key)
- **Select group:** ❌ **OSTAVI PRAZNO** (ne dodavaj u grupu!)

**Dodaj ove 3 variables:**

#### **1. APP_STORE_PRIVATE_KEY**
- **Variable name:** `APP_STORE_PRIVATE_KEY`
- **Variable value:** Sadržaj tvog `.p8` fajla (ceo tekst)
- **Secret:** ✅ (označi kao secure)
- **Select group:** ❌ **OSTAVI PRAZNO**

#### **2. APP_STORE_KEY_ID**
- **Variable name:** `APP_STORE_KEY_ID`
- **Variable value:** Tvoj Key ID (npr. `ABC123XYZ`)
- **Secret:** ❌ (ne mora biti secure)
- **Select group:** ❌ **OSTAVI PRAZNO**

#### **3. APP_STORE_ISSUER_ID**
- **Variable name:** `APP_STORE_ISSUER_ID`
- **Variable value:** Tvoj Issuer ID (npr. `12345678-1234-1234-1234-123456789012`)
- **Secret:** ❌ (ne mora biti secure)
- **Select group:** ❌ **OSTAVI PRAZNO**

---

### **1.3. Klikni Save:**

**Nakon što dodaš sve 3 variables, klikni:** **Save**

**Sada će variables biti dostupni u build-u!**

---

## 📋 OPCIJA 2: Koristi Grupe (Ako Već Imaš Grupu)

### **2.1. Ako Već Imaš Grupu sa Variables:**

**Ako si već dodao/la variables u neku grupu (npr. `app_store_credentials`):**

1. **Zapamti ime grupe** (npr. `app_store_credentials`)

2. **Ažuriraj `codemagic.yaml`:**

```yaml
environment:
  flutter: stable
  xcode: latest
  cocoapods: default
  groups:
    - app_store_credentials  # Dodaj ime tvoje grupe ovde!
```

---

### **2.2. Ažuriraj codemagic.yaml:**

**Već sam ažurirao `codemagic.yaml` da koristi grupu ako je dodaš!**

**Samo zameni `app_store_credentials` sa imenom tvoje grupe!**

---

## 📋 KAKO DA PROVERIŠ DA LI RADI:

### **1. Proveri Variables u Codemagic:**

1. **U Codemagic dashboard:**
   - Idi na: **Settings** → **Environment variables**
   - Proveri da li vidiš svoje variables

---

### **2. Proveri Build Log-ove:**

**Kada pokreneš build, proveri log-ove:**

**Traži:**
- `Fetch signing files` step
- Trebalo bi da vidiš da koristi `$APP_STORE_ISSUER_ID`, `$APP_STORE_KEY_ID`, itd.

**Ako vidiš grešku:**
- `APP_STORE_ISSUER_ID: command not found` → Variable nije dostupan
- `No such variable` → Variable nije pravilno dodat

---

## ⚠️ VAŽNO:

### **Razlika Između App-Level i Group-Level:**

**App-Level Variables (bez grupe):**
- ✅ Dostupni automatski u build-u
- ✅ Ne treba dodavati u `codemagic.yaml`
- ✅ Najlakše za početak

**Group-Level Variables (sa grupom):**
- ✅ Moraju biti dodati u `codemagic.yaml` sa `groups:`
- ✅ Korisno ako imaš više aplikacija koje dele iste variables
- ✅ Komplikovanije za početak

---

### **Zašto Ne Vidiš Variables:**

**Ako si dodao/la variables u grupu:**
- ❌ **Problem:** Grupa nije importovana u `codemagic.yaml`
- ✅ **Rešenje:** Dodaj grupu u `codemagic.yaml` ILI dodaj variables bez grupe

**Ako si dodao/la variables bez grupe:**
- ✅ **Trebalo bi da radi automatski!**
- ❌ **Ako ne radi:** Proveri da li si kliknuo **Save** nakon dodavanja

---

## 📋 CHECKLIST:

- [ ] ✅ Variables su dodati u Codemagic dashboard
- [ ] ✅ Variables su dodati **BEZ grupe** (OPCIJA 1) ILI **sa grupom** (OPCIJA 2)
- [ ] ✅ Ako koristiš grupu, dodao/la si je u `codemagic.yaml`
- [ ] ✅ Kliknuo/la si **Save** nakon dodavanja variables
- [ ] ✅ Pokrenuo/la si build
- [ ] ✅ Build log-ovi pokazuju da variables su dostupni

---

## 🎯 REZIME:

**Problem:** Variables su dodati u grupu, ali grupa nije importovana u `codemagic.yaml`

**Rešenje:**
1. ✅ **OPCIJA 1:** Dodaj variables **BEZ grupe** (najlakše)
2. ✅ **OPCIJA 2:** Dodaj grupu u `codemagic.yaml` (ako već koristiš grupe)

---

**Dodaj variables BEZ grupe i pokreni build - trebalo bi da radi! 🚀**



