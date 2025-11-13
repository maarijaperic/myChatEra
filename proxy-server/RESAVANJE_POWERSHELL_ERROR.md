# 🔧 Rešavanje PowerShell Execution Policy Error-a

## Problem

Kada pokušavaš da pokreneš `npm install` u PowerShell-u, vidiš grešku:
```
npm.ps1 cannot be loaded. The file is not digitally signed.
```

## ✅ Rešenje 1: Koristi Command Prompt (CMD) umesto PowerShell-a (NAJLAKŠE)

**Najlakše rešenje je da koristiš CMD umesto PowerShell-a:**

1. Otvori **Command Prompt** (CMD):
   - Pritisni `Win + R`
   - Ukucaj: `cmd`
   - Pritisni Enter

2. Idi u `proxy-server` folder:
   ```cmd
   cd "C:\Users\Korisnik\Documents\GPTWrapped-1\proxy-server"
   ```

3. Pokreni npm komande:
   ```cmd
   npm install
   npm start
   ```

**CMD ne koristi execution policy, tako da će raditi bez problema! ✅**

---

## ✅ Rešenje 2: Promeni Execution Policy za trenutnu sesiju

Ako želiš da koristiš PowerShell:

1. Otvori PowerShell
2. Pokreni ovu komandu (samo za trenutnu sesiju):
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
   ```

3. Sada možeš pokrenuti:
   ```powershell
   npm install
   ```

**Napomena:** Ovo važi samo za trenutnu PowerShell sesiju. Kada zatvoriš PowerShell, moraš ponovo pokrenuti komandu.

---

## ✅ Rešenje 3: Promeni Execution Policy trajno (zahteva Administrator)

**⚠️ Oprez:** Ovo menja sigurnosne postavke sistema.

1. Otvori PowerShell **kao Administrator**:
   - Desni klik na Start meni
   - Izaberi "Windows PowerShell (Admin)" ili "Terminal (Admin)"

2. Pokreni:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

3. Kada te pita da potvrdiš, ukucaj: `Y` i pritisni Enter

4. Zatvori i ponovo otvori PowerShell

5. Sada možeš pokrenuti:
   ```powershell
   npm install
   ```

---

## ✅ Rešenje 4: Zaobiđi problem sa `--bypass` flagom

Možeš pokrenuti npm komande sa `--bypass` flagom:

```powershell
powershell -ExecutionPolicy Bypass -Command "npm install"
```

Ili kreiraj batch fajl:

1. Kreiraj fajl `install.bat` u `proxy-server` folderu:
   ```batch
   @echo off
   powershell -ExecutionPolicy Bypass -Command "npm install"
   ```

2. Pokreni `install.bat` duplim klikom

---

## 🎯 Preporučeno rešenje

**Za najlakše rešenje, koristi CMD (Command Prompt) umesto PowerShell-a!**

1. Otvori CMD (`Win + R` → `cmd`)
2. `cd "C:\Users\Korisnik\Documents\GPTWrapped-1\proxy-server"`
3. `npm install`
4. `npm start`

**Gotovo! ✅**

---

## 📝 Objašnjenje

PowerShell ima sigurnosnu funkciju koja sprečava pokretanje nepotpisanih skripti. Ovo je dobra sigurnosna praksa, ali može biti problematično za npm.

- **CMD** ne koristi execution policy, tako da je najlakše rešenje
- **PowerShell** zahteva promenu execution policy-a

---

## ❓ Još problema?

Ako i dalje imaš probleme:
1. Proveri da li je Node.js instaliran: `node --version`
2. Proveri da li je npm instaliran: `npm --version` (u CMD-u)
3. Restartuj terminal nakon instalacije Node.js

