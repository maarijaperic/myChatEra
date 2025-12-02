# 🔐 Kako da Kreiraš Keystore Ručno

## ⚠️ PROBLEM:

Google Play Console kaže:
> "Отпремили сте APK или Android App Bundle који је потписан у режиму за отклањање грешака. Морате да потпишете APK или Android App Bundle у режиму за објављивање."

**To znači:** Treba release signing, ne debug signing!

---

## ✅ REŠENJE: Kreiraj Keystore Ručno

### **METODA 1: Preko Command Prompt (Preporučeno)**

1. **Otvori Command Prompt** (ne PowerShell)
2. **Idi u folder:**
   ```cmd
   cd "C:\Users\Korisnik\Documents\GPTWrapped-1\ZaMariju\android\app"
   ```

3. **Pokreni komandu:**
   ```cmd
   keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload -storepass android123 -keypass android123 -dname "CN=GPT Wrapped, OU=Development, O=GPT Wrapped, L=Belgrade, ST=Serbia, C=RS"
   ```

4. **Proveri da li je kreiran:**
   ```cmd
   dir upload-keystore.jks
   ```

5. **Ako vidiš fajl → uspešno je kreiran!** ✅

---

### **METODA 2: Preko Batch Fajla**

1. **Dvoklikni na:** `ZaMariju/android/create_keystore.bat`
2. **Sačekaj da se završi**
3. **Proveri da li je keystore kreiran**

---

### **METODA 3: Preko Android Studio**

1. **Otvori Android Studio**
2. **Build → Generate Signed Bundle / APK**
3. **Odaberi "Android App Bundle"**
4. **Kreiraj novi keystore:**
   - Keystore path: `ZaMariju/android/app/upload-keystore.jks`
   - Password: `android123`
   - Alias: `upload`
   - Key password: `android123`

---

## 🔨 NAKON KREIRANJA KEYSTORE-A:

1. **Build signed AAB:**
   ```bash
   cd ZaMariju
   flutter clean
   flutter build appbundle --release
   ```

2. **Upload novi AAB u Google Play Console**

---

## ⚠️ VAŽNO:

- **Keystore password:** `android123`
- **Keystore fajl:** `ZaMariju/android/app/upload-keystore.jks`
- **Čuvaj keystore sigurno!** Ako ga izgubiš, nećeš moći da ažuriraš aplikaciju!

---

**Kreiraj keystore ručno i build-uj signed AAB! 🚀**
