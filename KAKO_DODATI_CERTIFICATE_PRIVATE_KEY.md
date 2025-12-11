# 🔐 Kako Dodati CERTIFICATE_PRIVATE_KEY u Codemagic

## 🎯 ODGOVOR:

**Variable name:** `CERTIFICATE_PRIVATE_KEY`  
**Select group:** `app_store_credentials` (tvoja grupa)

---

## 📋 KORAK PO KORAK:

### **1. Idi na Codemagic Dashboard:**

1. **Otvori:** https://codemagic.io/apps
2. **Klikni na tvoju aplikaciju** (GPTWrapped-1)
3. **Idi na:** **Settings** (ikona zupčanika ⚙️)
4. **Idi na:** **Environment variables**

---

### **2. Klikni "+ Add variable":**

**Na vrhu stranice, klikni:** **+ Add variable** (ili **Add**)

---

### **3. Popuni Formu:**

#### **Variable name:**
```
CERTIFICATE_PRIVATE_KEY
```

**VAŽNO:** 
- ✅ **Tačno ovako:** `CERTIFICATE_PRIVATE_KEY`
- ✅ **Velika slova**
- ✅ **Bez razmaka**
- ✅ **Sa donjom crtom `_`**

---

#### **Variable value:**
```
-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC...
(kopiraj ceo private key ovde - sve linije!)
...
-----END PRIVATE KEY-----
```

**VAŽNO:**
- ✅ **Kopiraj ceo private key** - sve linije!
- ✅ **Uključi `-----BEGIN PRIVATE KEY-----` i `-----END PRIVATE KEY-----`**
- ✅ **Može biti dugačak** - to je normalno!

---

#### **Secret:**
✅ **Označi kao Secret** (klikni checkbox ili toggle)

**Zašto?**
- ✅ Private key je osetljiv podatak
- ✅ Codemagic će ga enkriptovati
- ✅ Neće biti vidljiv u log-ovima

---

#### **Select group:**
**Izaberi iz dropdown-a:**
```
app_store_credentials
```

**VAŽNO:**
- ✅ **Ime grupe mora biti tačno isto** kao u `codemagic.yaml`
- ✅ U `codemagic.yaml` imaš: `groups: - app_store_credentials`
- ✅ **Mora biti isti naziv!**

---

### **4. Klikni "Save":**

**Nakon što popuniš sve, klikni:** **Save** (ili **Add**)

---

## ⚠️ VAŽNO:

### **Ime Variable-a:**

**MORA biti tačno:**
```
CERTIFICATE_PRIVATE_KEY
```

**NE koristi:**
- ❌ `certificate_private_key` (mala slova)
- ❌ `CERTIFICATE-PRIVATE-KEY` (crtica umesto donje crte)
- ❌ `CERTIFICATE PRIVATE KEY` (razmak)
- ❌ `CERTIFICATE_PRIVATE_KEY_` (donja crta na kraju)

---

### **Ime Grupe:**

**MORA biti tačno:**
```
app_store_credentials
```

**Proveri u `codemagic.yaml`:**
```yaml
groups:
  - app_store_credentials  # Ovo je ime tvoje grupe!
```

**Ako je drugačije ime u `codemagic.yaml`:**
- Koristi ime iz `codemagic.yaml`!

---

## 📋 CHECKLIST:

- [ ] ✅ Otvoren Codemagic dashboard → Settings → Environment variables
- [ ] ✅ Kliknuo "+ Add variable"
- [ ] ✅ Variable name: `CERTIFICATE_PRIVATE_KEY` (tačno ovako!)
- [ ] ✅ Variable value: Kopiran ceo private key (sve linije!)
- [ ] ✅ Secret: Označeno kao secure ✅
- [ ] ✅ Select group: `app_store_credentials` (ili tvoja grupa)
- [ ] ✅ Kliknuo "Save"
- [ ] ✅ Variable je dodat u listu

---

## 🎯 REZIME:

**Kako da nazoveš:**
- ✅ **Variable name:** `CERTIFICATE_PRIVATE_KEY`
- ✅ **Select group:** `app_store_credentials` (ili tvoja grupa iz `codemagic.yaml`)

**Kako da dodaš:**
1. ✅ **Settings** → **Environment variables**
2. ✅ **+ Add variable**
3. ✅ Popuni formu (ime, vrednost, secret, grupa)
4. ✅ **Save**

---

**Dodaj variable sa tačnim imenom i u pravu grupu! 🚀**



