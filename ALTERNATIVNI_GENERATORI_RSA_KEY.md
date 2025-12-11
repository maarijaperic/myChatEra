# 🔐 Alternativni Načini da Generišeš RSA Private Key

## 🎯 PROBLEM:

Online generator (8gwifi.org) ne radi - 404 not found!

---

## ✅ REŠENJE:

### **IMAŠ NEKOLIKO ALTERNATIVA!**

---

## 📋 OPCIJA 1: Online Generatori (Preporučeno)

### **1. JWK Set Generator:**
- **Link:** https://jwkset.com/generate
- **Kako:**
  1. Idi na link
  2. Klikni **Generate**
  3. Kopiraj **Private Key (PKCS#8)** deo
  4. Nalepi u Codemagic

---

### **2. Gray-wolf Tools RSA Key Generator:**
- **Link:** https://thegraywolf.online/tools/security/rsa-key-generator/
- **Kako:**
  1. Idi na link
  2. Izaberi **Key Size:** `2048`
  3. Izaberi **Format:** `PKCS#8`
  4. Klikni **Generate**
  5. Kopiraj **Private Key**
  6. Nalepi u Codemagic

---

### **3. Modern Web Tools RSA Generator:**
- **Link:** https://www.modernwebtools.com/en/tools/encryption/rsa
- **Kako:**
  1. Idi na link
  2. Izaberi **Key Size:** `2048`
  3. Klikni **Generate Key Pair**
  4. Kopiraj **Private Key**
  5. Nalepi u Codemagic

---

## 📋 OPCIJA 2: PowerShell (Ako Imaš Git Bash)

### **Ako imaš Git instaliran:**

1. **Otvori Git Bash** (ne PowerShell!)
2. **Pokreni:**
   ```bash
   ssh-keygen -t rsa -b 2048 -m PEM -f cert_key -q -N ""
   ```
3. **Otvori fajl:**
   ```bash
   cat cert_key
   ```
4. **Kopiraj ceo sadržaj**
5. **Nalepi u Codemagic**

---

## 📋 OPCIJA 3: Online RSA Key Generator (Najlakše)

### **1. Idi na:** https://www.devglan.com/online-tools/rsa-encryption-decryption

**ILI**

### **2. Idi na:** https://www.csfieldguide.org.nz/en/interactives/rsa-key-generator/

**ILI**

### **3. Idi na:** https://www.javainuse.com/rsagenerator

**Kako:**
1. Idi na bilo koji od ovih linkova
2. Generiši RSA 2048-bit key
3. Kopiraj **Private Key**
4. Nalepi u Codemagic

---

## 📋 OPCIJA 4: Koristi Online RSA Generator sa Google-om

**Pretraži na Google-u:**
- "RSA private key generator online"
- "PKCS#8 private key generator"
- "2048 bit RSA key generator"

**Pronaći ćeš mnogo opcija!**

---

## ⚠️ VAŽNO:

### **Format Private Key-a:**

**Može biti u jednom od formata:**

**Format 1: PKCS#8**
```
-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC...
-----END PRIVATE KEY-----
```

**Format 2: PKCS#1 (RSA)**
```
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA...
-----END RSA PRIVATE KEY-----
```

**Oba formata rade!**

---

### **Kopiraj CELO:**

- ✅ **Kopiraj sve linije** - od `-----BEGIN` do `-----END`
- ✅ **Može biti dugačak** - to je normalno (RSA 2048-bit key)
- ✅ **Uključi sve linije** - ne samo prvu i poslednju!

---

## 📋 CHECKLIST:

- [ ] ✅ Otvoren jedan od online generatora
- [ ] ✅ Generisan RSA 2048-bit key
- [ ] ✅ Kopiran ceo Private Key (sve linije!)
- [ ] ✅ Dodato u Codemagic kao `CERTIFICATE_PRIVATE_KEY`
- [ ] ✅ Označeno kao Secret
- [ ] ✅ Dodato u grupu (`app_store_credentials`)

---

## 🎯 REZIME:

**Problem:** Online generator ne radi (404)

**Rešenje:**
1. ✅ **Koristi alternativne online generatore** (jwkset.com, thegraywolf.online, modernwebtools.com)
2. ✅ **ILI koristi Git Bash** sa `ssh-keygen` komandom
3. ✅ **ILI pretraži Google** za "RSA private key generator online"

---

**Koristi bilo koji od ovih načina i dodaj key u Codemagic! 🚀**



