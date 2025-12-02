# 🔧 Kako da Rešiš "File is being used by another process" Grešku

## ⚠️ PROBLEM:

```
FileSystemException: classes.dex: The process cannot access the file because it is being used by another process
```

**Šta to znači:**
- Neki proces drži fajl otvorenim (Android Studio, antivirus, itd.)
- Gradle ne može da piše u fajl dok je u upotrebi

---

## ✅ REŠENJA:

### **METODA 1: Zatvori Android Studio (Preporučeno)**

1. **Zatvori Android Studio** (ako je otvoren)
2. **Zatvori sve Flutter/Dart procese** (ako su pokrenuti)
3. **Probaj build ponovo:**
   ```bash
   cd ZaMariju
   flutter clean
   flutter build appbundle --release
   ```

---

### **METODA 2: Obriši Build Folder**

1. **Zatvori sve procese** (Android Studio, VS Code, itd.)
2. **Obriši build folder:**
   ```bash
   cd ZaMariju
   flutter clean
   ```
3. **Probaj build ponovo:**
   ```bash
   flutter build appbundle --release
   ```

---

### **METODA 3: Restart Računara**

**Ako ništa ne pomaže:**

1. **Zatvori sve aplikacije**
2. **Restart računara**
3. **Probaj build ponovo**

---

### **METODA 4: Proveri Antivirus**

**Antivirus može blokirati pristup fajlovima:**

1. **Dodaj izuzetak za:**
   - `ZaMariju/build/` folder
   - `ZaMariju/android/` folder
2. **Ili privremeno isključi antivirus** (samo za build)

---

## 🔨 KORAK PO KORAK:

### **KORAK 1: Zatvori Sve Procese**

1. **Zatvori Android Studio** (ako je otvoren)
2. **Zatvori VS Code** (ako je otvoren)
3. **Zatvori sve Flutter/Dart procese**

### **KORAK 2: Clean Build**

```bash
cd ZaMariju
flutter clean
```

### **KORAK 3: Build Ponovo**

```bash
flutter build appbundle --release
```

---

## ⚠️ ALTERNATIVA: Ako i Dalje Ne Radi

**Probaj sa PowerShell kao Administrator:**

1. **Desni klik na PowerShell → "Run as Administrator"**
2. **Idi u folder:**
   ```powershell
   cd "C:\Users\Korisnik\Documents\GPTWrapped-1\ZaMariju"
   ```
3. **Clean:**
   ```powershell
   flutter clean
   ```
4. **Build:**
   ```powershell
   flutter build appbundle --release
   ```

---

## ✅ FINALNI REZULTAT:

- ✅ Zatvori sve procese
- ✅ Clean build folder
- ✅ Build ponovo
- ✅ AAB će biti kreiran!

---

**Zatvori Android Studio i sve procese, pa probaj build ponovo! 🔧**
