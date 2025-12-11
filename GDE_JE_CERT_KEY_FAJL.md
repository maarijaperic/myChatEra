# 📁 Gde Se Nalazi cert_key Fajl

## 🎯 ODGOVOR:

**`cert_key` fajl se kreira u trenutnom direktorijumu gde pokreneš komandu!**

---

## 📋 KAKO DA PRONAĐEŠ FAJL:

### **1. Otvori PowerShell:**

1. **Pritisni:** `Windows Key + X`
2. **Izaberi:** **Windows PowerShell** (ili **Terminal**)

---

### **2. Idi u Folder Gde Želiš da Kreiraš Fajl:**

**Primer:**
```powershell
cd C:\Users\Korisnik\Documents
```

**ILI idi direktno u tvoj projekat:**
```powershell
cd C:\Users\Korisnik\Documents\GPTWrapped-1
```

---

### **3. Pokreni Komandu:**

```powershell
ssh-keygen -t rsa -b 2048 -m PEM -f cert_key -q -N ""
```

**Ovo će kreirati:**
- ✅ `cert_key` - private key fajl (ovo ti treba!)
- ✅ `cert_key.pub` - public key fajl (ne treba ti)

---

### **4. Pronađi Fajl:**

**Fajl će biti u folderu gde si pokrenuo komandu!**

**Primer:**
- Ako si u `C:\Users\Korisnik\Documents`
- Fajl će biti: `C:\Users\Korisnik\Documents\cert_key`

---

### **5. Otvori Fajl:**

**Opcija 1: U PowerShell-u:**
```powershell
notepad cert_key
```

**Opcija 2: Ručno:**
1. Otvori **File Explorer**
2. Idi u folder gde si pokrenuo komandu
3. Pronađi `cert_key` fajl (bez ekstenzije!)
4. Desni klik → **Open with** → **Notepad**

---

### **6. Kopiraj Sadržaj:**

**Kopiraj ceo sadržaj fajla**, uključujući:
```
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA...
...
-----END RSA PRIVATE KEY-----
```

---

## 📋 ALTERNATIVNO: Koristi Online Generator

**Ako ne možeš da koristiš PowerShell:**

1. **Idi na:** https://8gwifi.org/rsagen.jsp
2. **Izaberi:**
   - **Key Size:** `2048`
   - **Key Format:** `PKCS#8` ili `PKCS#1`
3. **Klikni:** **Generate**
4. **Kopiraj Private Key** (deo sa `-----BEGIN PRIVATE KEY-----`)
5. **Nalepi u Codemagic** kao vrednost za `CERTIFICATE_PRIVATE_KEY`

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

## 📋 CHECKLIST:

- [ ] ✅ Otvoren PowerShell
- [ ] ✅ Pokrenuta komanda `ssh-keygen -t rsa -b 2048 -m PEM -f cert_key -q -N ""`
- [ ] ✅ Pronađen `cert_key` fajl u folderu
- [ ] ✅ Otvoren `cert_key` fajl u Notepad-u
- [ ] ✅ Kopiran ceo sadržaj (uključujući `-----BEGIN` i `-----END`)
- [ ] ✅ Dodato u Codemagic kao `CERTIFICATE_PRIVATE_KEY`

---

## 🎯 REZIME:

**Gde se nalazi `cert_key` fajl?**
- ✅ U folderu gde si pokrenuo `ssh-keygen` komandu
- ✅ Primer: `C:\Users\Korisnik\Documents\cert_key`
- ✅ Otvori ga sa `notepad cert_key` ili ručno u File Explorer-u

---

**Pronađi fajl, kopiraj sadržaj i dodaj u Codemagic! 🚀**



