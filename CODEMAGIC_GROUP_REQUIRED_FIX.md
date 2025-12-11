# 🔧 Codemagic Group Required - Kako Kreirati Grupu

## 🎯 PROBLEM:

Codemagic zahteva da izabereš grupu za environment variables - "group is required".

**Problem:** Ne možeš da ostaviš prazno polje za grupu!

---

## ✅ REŠENJE:

### **KREIRAJ GRUPU I DODAJ JE U CODEMAGIC.YAML!**

**Šta treba da uradiš:**
1. ✅ Kreiraj grupu u Codemagic dashboard
2. ✅ Dodaj variables u tu grupu
3. ✅ Dodaj grupu u `codemagic.yaml`

---

## 📋 KORAK 1: Kreiraj Grupu u Codemagic Dashboard

### **1.1. Idi na Codemagic Dashboard:**

1. **Otvori:** https://codemagic.io/apps
2. **Klikni na tvoju aplikaciju** (GPTWrapped-1)
3. **Idi na:** **Settings** (ikona zupčanika ⚙️)
4. **Idi na:** **Environment variables**

---

### **1.2. Kreiraj Novu Grupu:**

**Ako već imaš grupu:**
- ✅ Koristi postojeću grupu (npr. `app_store_credentials`)
- ✅ Zapamti ime grupe!

**Ako nemaš grupu:**
1. **Klikni:** **+ Add variable**
2. **Variable name:** Unesi bilo koje ime (npr. `APP_STORE_PRIVATE_KEY`)
3. **Variable value:** Unesi bilo koju vrednost (možeš promeniti kasnije)
4. **Secret:** Označi ako je osetljivo
5. **Select group:** Klikni na dropdown i izaberi **"Create new group"** (ili **"+ New group"**)
6. **Ime grupe:** Unesi ime (npr. `app_store_credentials`)
7. **Klikni:** **Save**

**Sada imaš grupu!**

---

## 📋 KORAK 2: Dodaj Variables u Grupu

### **2.1. Dodaj 3 Variables u Grupu:**

**Klikni:** **+ Add variable** za svaki:

#### **1. APP_STORE_PRIVATE_KEY**
- **Variable name:** `APP_STORE_PRIVATE_KEY`
- **Variable value:** Sadržaj tvog `.p8` fajla (ceo tekst)
- **Secret:** ✅ (označi kao secure)
- **Select group:** Izaberi tvoju grupu (npr. `app_store_credentials`)

#### **2. APP_STORE_KEY_ID**
- **Variable name:** `APP_STORE_KEY_ID`
- **Variable value:** Tvoj Key ID (npr. `ABC123XYZ`)
- **Secret:** ❌ (ne mora biti secure)
- **Select group:** Izaberi istu grupu (npr. `app_store_credentials`)

#### **3. APP_STORE_ISSUER_ID**
- **Variable name:** `APP_STORE_ISSUER_ID`
- **Variable value:** Tvoj Issuer ID (npr. `12345678-1234-1234-1234-123456789012`)
- **Secret:** ❌ (ne mora biti secure)
- **Select group:** Izaberi istu grupu (npr. `app_store_credentials`)

---

### **2.2. Klikni Save:**

**Nakon što dodaš sve 3 variables, klikni:** **Save**

---

## 📋 KORAK 3: Dodaj Grupu u codemagic.yaml

### **3.1. Proveri Ime Grupe:**

**Zapamti ime grupe** (npr. `app_store_credentials`)

---

### **3.2. Ažuriraj codemagic.yaml:**

**Već sam ažurirao `codemagic.yaml` sa:**

```yaml
environment:
  flutter: stable
  xcode: latest
  cocoapods: default
  groups:
    - app_store_credentials  # Zameni sa imenom tvoje grupe ako je drugačije!
```

**Ako je tvoja grupa drugačije ime:**
- Otvori `codemagic.yaml`
- Zameni `app_store_credentials` sa imenom tvoje grupe

---

## 📋 KORAK 4: Commit-uj i Push-uj

1. **U GitHub Desktop:**
   - Commit-uj promene u `codemagic.yaml`
   - Push-uj na GitHub

---

## 📋 KORAK 5: Pokreni Build

1. **U Codemagic dashboard:**
   - Klikni: **Start new build**
   - **Select branch:** `main`
   - **Select file workflow:** `ios-workflow`
   - Klikni: **Start build**

2. **Build će sada:**
   - ✅ Koristiti variables iz grupe
   - ✅ Automatski kreirati sertifikate i provisioning profile
   - ✅ Potpisati aplikaciju
   - ✅ Build-ovati IPA
   - ✅ Upload-ovati u TestFlight

---

## ⚠️ VAŽNO:

### **Ime Grupe:**

- ✅ **Mora biti isti** u Codemagic dashboard i `codemagic.yaml`
- ✅ **Case-sensitive** - `app_store_credentials` ≠ `App_Store_Credentials`
- ✅ **Bez razmaka** - koristi `_` umesto razmaka

---

### **Ako Ne Vidiš Grupu:**

**U Codemagic dashboard:**
1. Idi na: **Settings** → **Environment variables**
2. Proveri da li vidiš svoju grupu u listi
3. Ako ne vidiš, možda je kreirana na team level-u

**Team-Level Grupe:**
- Idi na: **Team settings** → **Global variables and secrets**
- Proveri da li je grupa tamo

---

## 📋 CHECKLIST:

- [ ] ✅ Grupa je kreirana u Codemagic dashboard
- [ ] ✅ Variables su dodati u grupu (`APP_STORE_PRIVATE_KEY`, `APP_STORE_KEY_ID`, `APP_STORE_ISSUER_ID`)
- [ ] ✅ Ime grupe je zapamćeno (npr. `app_store_credentials`)
- [ ] ✅ Grupa je dodata u `codemagic.yaml` (već urađeno)
- [ ] ✅ Ime grupe u `codemagic.yaml` se poklapa sa imenom u dashboard-u
- [ ] ✅ Promene su commit-ovane i push-ovane
- [ ] ✅ Pokrenut novi build
- [ ] ✅ Build je uspešan (variables su dostupni)

---

## 🎯 REZIME:

**Problem:** Codemagic zahteva da izabereš grupu - "group is required"

**Rešenje:**
1. ✅ **Kreiraj grupu** u Codemagic dashboard (ili koristi postojeću)
2. ✅ **Dodaj variables u grupu** (`APP_STORE_PRIVATE_KEY`, `APP_STORE_KEY_ID`, `APP_STORE_ISSUER_ID`)
3. ✅ **Dodaj grupu u `codemagic.yaml`** (već urađeno - samo proveri ime!)

---

**Kreiraj grupu, dodaj variables i pokreni build - trebalo bi da radi! 🚀**



