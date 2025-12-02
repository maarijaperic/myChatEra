# 🔐 Kako da Konfigurišeš App Signing - Google Play Console (Srpski)

## 🎯 ŠTA TREBA DA URADIŠ:

Google Play Console zahteva da aplikacija bude potpisana (signed) pre upload-a. Evo koraka:

---

## ✅ NAJLAKŠI NAČIN: Google Play App Signing (Preporučeno)

**Google Play može automatski da generiše signing key za tebe!** Ovo je najlakše rešenje.

---

## 📋 KORAK 1: Idi na App Signing

### **1.1. Pronađi App Signing u Meniju**

1. **U Google Play Console, u meniju sa leve strane traži:**
   - **"Setup"** (Podešavanje)
   - **"App signing"** (Potpisivanje aplikacije)
   - **"App integrity"** (Integritet aplikacije)
   - **"Podešavanje"** (Setup)

2. **Klikni na to**

### **1.2. Alternativno: Preko URL-a**

1. **Kada si u Google Play Console, u URL-u dodaј:**
   ```
   /app-signing
   ```

2. **Ili traži u meniju:**
   - **"Setup"** → **"App signing"**

---

## 📋 KORAK 2: Konfiguriši Play App Signing

### **2.1. Kada otvoriš App Signing stranicu:**

**Videćeš opcije:**

1. **"Koristi Play App Signing"** (Use Play App Signing) ← **ODABERI OVO!**
2. **"Upravljaj sopstvenim ključevima"** (Manage your own keys)

### **2.2. Odaberi "Koristi Play App Signing"**

1. **Klikni na "Koristi Play App Signing"** ili **"Omogući Play App Signing"**
2. **Pročitaćeš informacije o Play App Signing**
3. **Klikni "Potvrdi"** (Confirm) ili **"Sačuvaj"** (Save)

**Google će automatski generisati signing key za tebe!** ✅

---

## 📋 KORAK 3: Sign Tvoj AAB sa Upload Key

**Sada treba da sign-uješ AAB sa upload key-jem:**

### **3.1. Generiši Upload Keystore (Ako već nemaš)**

**Ako već imaš keystore, preskoči ovaj korak.**

1. **Otvori terminal/command prompt:**
   ```bash
   cd ZaMariju/android
   ```

2. **Generiši keystore:**
   ```bash
   keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

3. **Unesi informacije:**
   - **Password:** (zapamti ga!)
   - **Ime i prezime:** (tvoje ime)
   - **Organizacija:** (tvoja organizacija)
   - **Grad:** (tvoj grad)
   - **Država:** (tvoja država)

4. **Keystore će biti kreiran u:** `ZaMariju/android/upload-keystore.jks`

### **3.2. Konfiguriši Flutter da koristi Keystore**

**Kreiraj fajl:** `ZaMariju/android/key.properties`

```properties
storePassword=tvoj_password
keyPassword=tvoj_password
keyAlias=upload
storeFile=upload-keystore.jks
```

**Zameni `tvoj_password` sa password-om koji si uneo!**

### **3.3. Ažuriraj build.gradle.kts**

**Fajl:** `ZaMariju/android/app/build.gradle.kts`

**Dodaj na početak fajla:**

```kotlin
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}
```

**Ažuriraj `buildTypes` sekciju:**

```kotlin
buildTypes {
    release {
        signingConfig = signingConfigs.getByName("debug") // Privremeno
        // Zameni sa:
        // signingConfig = signingConfigs.getByName("release")
    }
}
```

**Dodaj `signingConfigs` sekciju:**

```kotlin
signingConfigs {
    release {
        keyAlias = keystoreProperties['keyAlias']
        keyPassword = keystoreProperties['keyPassword']
        storeFile = keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
        storePassword = keystoreProperties['storePassword']
    }
}
```

### **3.4. Build Signed AAB**

```bash
cd ZaMariju
flutter build appbundle --release
```

**AAB će biti automatski sign-ovan sa upload key-jem!**

---

## 📋 KORAK 4: Upload Signed AAB

1. **Vrati se na Google Play Console**
2. **Idi na: Тестирање → Затворено тестирање**
3. **Klikni "Kreiraj novo izdanje"**
4. **Upload signed AAB**
5. **Google Play će automatski koristiti Play App Signing!**

---

## ⚠️ ALTERNATIVA: Ako Ne Možeš da Nađeš App Signing

**Možda Google Play Console automatski koristi Play App Signing:**

1. **Samo upload-uj AAB** (čak i ako nije sign-ovan)
2. **Google Play Console će automatski sign-ovati** ako je Play App Signing omogućen
3. **Proveri da li postoji opcija "App signing" u Setup sekciji**

---

## 📋 CHECKLIST:

- [ ] ⏳ Pronađi "App signing" u Setup sekciji
- [ ] ⏳ Omogući "Play App Signing"
- [ ] ⏳ Generiši upload keystore (ako već nemaš)
- [ ] ⏳ Konfiguriši Flutter da koristi keystore
- [ ] ⏳ Build signed AAB
- [ ] ⏳ Upload signed AAB u Google Play Console

---

## 🆘 ŠTA AKO NE MOŽEŠ DA NAĐEŠ APP SIGNING?

**Probaj ovo:**

1. **Screenshot:** Pošalji mi screenshot Google Play Console interfejsa (Setup sekcija)
2. **Ili opiši:** Šta vidiš u Setup sekciji?
3. **Ili probaj:**
   - Upload-uj AAB bez sign-ovanja
   - Google Play Console možda automatski koristi Play App Signing

---

**Sledeći korak: Pronađi "App signing" u Setup sekciji i omogući Play App Signing! 🔐**
