# 🔗 Kako Naći GitHub URL Repozitorijuma

## 🎯 ODGOVOR:

**Treba ti GitHub URL tvog repozitorijuma!**

---

## 📋 KAKO DA NAĐEŠ GITHUB URL:

### **OPCIJA 1: Preko GitHub Desktop-a**

1. **Otvori GitHub Desktop**
2. **Klikni na tvoj repo** (GPTWrapped-1)
3. **Klikni:** **"View on GitHub"** (ili desni klik → **"View on GitHub"**)
4. **Kopiraj URL iz browser-a:**
   - Primer: `https://github.com/tvoje-korisnicko-ime/GPTWrapped-1`
   - Ili: `https://github.com/tvoje-korisnicko-ime/GPTWrapped-1.git`

---

### **OPCIJA 2: Preko GitHub Web Sajta**

1. **Idi na:** https://github.com/
2. **Uloguj se** sa svojim account-om
3. **Pronađi repo:** `GPTWrapped-1` (ili tvoj repo)
4. **Klikni na repo**
5. **Klikni:** **"Code"** (zelena dugmad)
6. **Kopiraj URL:**
   - Primer: `https://github.com/tvoje-korisnicko-ime/GPTWrapped-1.git`
   - Ili: `https://github.com/tvoje-korisnicko-ime/GPTWrapped-1`

---

### **OPCIJA 3: Preko Terminal-a/PowerShell-a**

1. **Otvori PowerShell** u folderu `GPTWrapped-1`
2. **Pokreni:**
   ```powershell
   git remote -v
   ```
3. **Videćeš URL:**
   ```
   origin  https://github.com/tvoje-korisnicko-ime/GPTWrapped-1.git (fetch)
   origin  https://github.com/tvoje-korisnicko-ime/GPTWrapped-1.git (push)
   ```

---

## 📋 FORMAT URL-a:

**GitHub URL može biti:**

1. **HTTPS:**
   ```
   https://github.com/tvoje-korisnicko-ime/GPTWrapped-1.git
   ```
   Ili:
   ```
   https://github.com/tvoje-korisnicko-ime/GPTWrapped-1
   ```

2. **SSH (ako koristiš SSH key):**
   ```
   git@github.com:tvoje-korisnicko-ime/GPTWrapped-1.git
   ```

---

## ⚠️ VAŽNO:

### **Za Bitrise:**

**Bitrise prihvata:**
- ✅ HTTPS URL (preporučeno)
- ✅ SSH URL (ako imaš SSH key)

**Format koji Bitrise očekuje:**
```
https://github.com/tvoje-korisnicko-ime/GPTWrapped-1.git
```

---

## 🎯 REZIME:

**Šta treba da uradiš:**

1. ✅ **Otvori GitHub Desktop** ili idi na https://github.com/
2. ✅ **Pronađi repo:** `GPTWrapped-1`
3. ✅ **Kopiraj URL** (sa ili bez `.git` na kraju)
4. ✅ **Koristi taj URL u Bitrise** kada povezuješ repo

---

**Nađi GitHub URL i koristi ga u Bitrise! 🚀**



