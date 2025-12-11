# ✅ Provera Ime Integracije

## 🎯 PROBLEM:

Ime integracije u `codemagic.yaml` možda nije tačno!

**U Codemagic dashboard:** Apple Developer Portal integration se zove "app-store-connect"

---

## ✅ REŠENJE:

**Ažurirao sam `codemagic.yaml` da koristi `app-store-connect` kao ime integracije!**

---

## 📋 ŠTA SAM URADIO:

### **1. Ažurirao Ime Integracije:**

**Pre:**
```yaml
integrations:
  app_store_connect: app_store_credentials
```

**Sada:**
```yaml
integrations:
  app_store_connect: app-store-connect
```

**Zašto?**
- ✅ Ime integracije mora biti tačno isto kao u Codemagic dashboard-u
- ✅ U dashboard-u se zove "app-store-connect"
- ✅ Mora biti tačno isto ime!

---

## 📋 SLEDEĆI KORACI:

### **1. Proveri Ime Integracije u Dashboard-u:**

**U Codemagic dashboard:**
- Idi na: **Team settings** → **Team integrations**
- Proveri **tačno ime** Apple Developer Portal integracije
- **Ako nije "app-store-connect":**
  - Promeni u `codemagic.yaml` na tačno ime iz dashboard-a

---

### **2. Commit-uj i Push-uj Promene:**

**U GitHub Desktop:**
- Commit-uj promene u `codemagic.yaml`
- Push-uj na GitHub

---

### **3. Pokreni Build:**

**U Codemagic dashboard:**
- Klikni: **Start new build**
- **Select branch:** `main`
- **Select file workflow:** `ios-workflow`
- Klikni: **Start build**

---

## ⚠️ VAŽNO:

### **Ime Integracije Mora Biti Tačno:**

**U `codemagic.yaml`:**
```yaml
integrations:
  app_store_connect: <TAČNO_IME_IZ_DASHBOARD_A>
```

**Proveri u Codemagic dashboard:**
- **Team settings** → **Team integrations** → **Apple Developer Portal**
- **Ime integracije** mora biti tačno isto kao u `codemagic.yaml`!

---

## 🎯 REZIME:

**Problem:** Ime integracije možda nije tačno

**Rešenje:**
1. ✅ **Ažurirao na `app-store-connect`** - proveri u dashboard-u da li je tačno!
2. ✅ **Ako nije tačno, promeni u `codemagic.yaml`** na tačno ime iz dashboard-a

---

**Proveri ime integracije u dashboard-u i ažuriraj `codemagic.yaml` ako treba! 🚀**



