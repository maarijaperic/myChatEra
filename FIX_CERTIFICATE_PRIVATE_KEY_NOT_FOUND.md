# 🔧 Fix CERTIFICATE_PRIVATE_KEY Not Found

## 🎯 PROBLEM:

Greška:
> "Cannot save Signing Certificates without certificate private key"

**Problem:** `CERTIFICATE_PRIVATE_KEY` environment variable nije dostupan ili nije pravilno konfigurisan!

---

## ✅ REŠENJE:

### **PROVERI DA LI JE VARIABLE DODAT U GRUPU!**

**Šta treba da uradiš:**
1. ✅ Proveri da li je `CERTIFICATE_PRIVATE_KEY` dodat u Codemagic dashboard
2. ✅ Proveri da li je u pravoj grupi (`app_store_credentials`)
3. ✅ Proveri da li je ime tačno (`CERTIFICATE_PRIVATE_KEY`)

---

## 📋 KORAK 1: Proveri Environment Variables u Codemagic Dashboard

### **1.1. Idi na Codemagic Dashboard:**

1. **Otvori:** https://codemagic.io/apps
2. **Klikni na tvoju aplikaciju** (GPTWrapped-1)
3. **Idi na:** **Settings** (ikona zupčanika ⚙️)
4. **Idi na:** **Environment variables**

---

### **1.2. Proveri da li Postoji CERTIFICATE_PRIVATE_KEY:**

**U listi variables, traži:**
- ✅ `CERTIFICATE_PRIVATE_KEY`

**Ako NE postoji:**
- Dodaj ga (vidi `KAKO_DODATI_CERTIFICATE_PRIVATE_KEY.md`)

**Ako POSTOJI:**
- Proveri da li je u grupi `app_store_credentials`
- Proveri da li je ime tačno (`CERTIFICATE_PRIVATE_KEY`)

---

## 📋 KORAK 2: Proveri Build Log-ove

### **2.1. Pokreni Build:**

1. **U Codemagic dashboard:**
   - Klikni: **Start new build**
   - **Select branch:** `main`
   - **Select file workflow:** `ios-workflow`
   - Klikni: **Start build**

---

### **2.2. Proveri Log-ove za "Fetch signing files":**

**Traži u log-ovima:**
```
Checking environment variables...
APP_STORE_CONNECT_ISSUER_ID: ...
APP_STORE_CONNECT_KEY_IDENTIFIER: ...
CERTIFICATE_PRIVATE_KEY exists: YES/NO
```

**Ako vidiš:**
- `CERTIFICATE_PRIVATE_KEY exists: NO` → Variable nije dostupan!
- `CERTIFICATE_PRIVATE_KEY exists: YES` → Variable je dostupan, ali možda ima problem sa formatom

---

## ⚠️ VAŽNO:

### **Proveri da li je Variable u Grupi:**

**U Codemagic dashboard:**
1. Idi na: **Settings** → **Environment variables**
2. Pronađi `CERTIFICATE_PRIVATE_KEY`
3. Proveri da li je u grupi `app_store_credentials`

**Ako NIJE u grupi:**
- Klikni na variable
- Promeni **Select group** na `app_store_credentials`
- Klikni **Save**

---

### **Proveri Ime Variable-a:**

**MORA biti tačno:**
```
CERTIFICATE_PRIVATE_KEY
```

**Proveri:**
- ✅ Velika slova
- ✅ Bez razmaka
- ✅ Sa donjom crtom `_`
- ✅ Bez dodatnih karaktera

---

## 📋 CHECKLIST:

- [ ] ✅ `CERTIFICATE_PRIVATE_KEY` je dodat u Codemagic dashboard
- [ ] ✅ Variable je u grupi `app_store_credentials`
- [ ] ✅ Ime je tačno (`CERTIFICATE_PRIVATE_KEY`)
- [ ] ✅ Variable value sadrži ceo private key (sve linije!)
- [ ] ✅ Variable je označen kao Secret
- [ ] ✅ Pokrenut novi build
- [ ] ✅ Provereni build log-ovi za "CERTIFICATE_PRIVATE_KEY exists"

---

## 🎯 REZIME:

**Problem:** `CERTIFICATE_PRIVATE_KEY` nije dostupan u build-u

**Rešenje:**
1. ✅ **Proveri da li je variable dodat** u Codemagic dashboard
2. ✅ **Proveri da li je u pravoj grupi** (`app_store_credentials`)
3. ✅ **Proveri build log-ove** da vidiš da li je variable dostupan

---

**Proveri variable u dashboard-u i pokreni build - videćemo u log-ovima šta se dešava! 🔍**



