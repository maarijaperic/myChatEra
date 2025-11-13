# Kako da Pošalješ Aplikaciju Prijateljima (Android)

## 📱 KORAK 1: Build APK Fajla

### 1.1. Build Debug APK (za testiranje)
```bash
# Otvori terminal u ZaMariju folderu
cd ZaMariju

# Build debug APK
flutter build apk --debug
```

**APK fajl će biti u:**
```
ZaMariju/build/app/outputs/flutter-apk/app-debug.apk
```

### 1.2. Build Release APK (bolje performanse)
```bash
# Build release APK
flutter build apk --release
```

**APK fajl će biti u:**
```
ZaMariju/build/app/outputs/flutter-apk/app-release.apk
```

**Preporuka:** Koristi `--release` za bolje performanse!

---

## 📤 KORAK 2: Pošalji APK Prijateljima

### Opcije za slanje:

1. **Email:**
   - Priloži APK fajl u email
   - Gmail ima limit od 25MB (APK je obično 20-30MB)
   - Ako je veći, koristi Google Drive

2. **Google Drive / Dropbox:**
   - Upload APK na Google Drive
   - Podeli link sa prijateljima
   - **VAŽNO:** Postavi link da može svako sa linkom da preuzme

3. **Telegram / WhatsApp:**
   - Pošalji direktno kroz chat
   - Telegram podržava do 2GB
   - WhatsApp ima limit od 100MB

4. **USB kabl:**
   - Kopiraj APK direktno na telefon
   - Najbrže ako su blizu

---

## ⚙️ KORAK 3: Instalacija na Prijateljevom Telefonu

### Instrukcije za Prijatelje:

#### 1. Dozvola za Instalaciju iz Nepoznatih Izvora

**Android 8.0+ (Oreo):**
1. Otvori **Settings** → **Apps** → **Special access** → **Install unknown apps**
2. Izaberi aplikaciju kroz koju ćeš instalirati (npr. Chrome, Gmail, Files)
3. Uključi **"Allow from this source"**

**Android 7.0 i starije:**
1. Otvori **Settings** → **Security**
2. Uključi **"Unknown sources"** ili **"Install unknown apps"**

#### 2. Preuzmi APK
- Otvori link/email sa APK fajlom
- Preuzmi fajl
- Kada se preuzme, otvori ga

#### 3. Instaliraj
- Telefon će pitati za dozvolu
- Klikni **"Install"**
- Sačekaj da se instalira
- Klikni **"Open"** ili pronađi aplikaciju u app drawer-u

---

## 🌐 KORAK 4: Proxy Server Setup (VAŽNO!)

### Problem:
Aplikacija trenutno koristi lokalni proxy server na tvom računaru. Da bi radila na prijateljevom telefonu, mora biti na **ISTOJ WiFi mreži** kao tvoj računar.

### Rešenje:

#### Opcija A: Ista WiFi Mreža (NAJLAKŠE)

1. **Na tvom računaru:**
   ```bash
   # Pokreni proxy server
   cd proxy-server
   npm start
   ```

2. **Pronađi IP adresu računara:**
   ```bash
   # Windows (CMD):
   ipconfig
   
   # Traži "IPv4 Address" (npr. 192.168.0.12)
   ```

3. **Proveri da li server radi:**
   - Otvori browser na telefonu
   - Idi na: `http://192.168.0.12:3000/health`
   - Trebalo bi da vidiš: `{"status":"ok"}`

4. **Ažuriraj aplikaciju:**
   - U `ZaMariju/lib/main.dart`, linija ~46:
   ```dart
   AIAnalyzer.setProxyUrl('http://192.168.0.12:3000'); // Zameni sa tvojom IP adresom!
   ```
   - Rebuild APK:
   ```bash
   flutter build apk --release
   ```

5. **Podeli novi APK prijateljima**

#### Opcija B: Različite WiFi Mreže (KOMPLIKOVANIJE)

Ako prijatelji nisu na istoj WiFi mreži, moraš deploy-ovati proxy server na internet.

**Najlakše rešenje - Railway (besplatno):**
1. Registruj se na [railway.app](https://railway.app)
2. Kreiraj novi projekat
3. Deploy `proxy-server` folder
4. Postavi `OPENAI_API_KEY` u environment variables
5. Railway će dati URL (npr. `https://your-app.railway.app`)
6. Ažuriraj aplikaciju:
   ```dart
   AIAnalyzer.setProxyUrl('https://your-app.railway.app');
   ```
7. Rebuild APK i pošalji prijateljima

---

## ✅ KORAK 5: Testiranje

### Instrukcije za Prijatelje:

1. **Instaliraj aplikaciju** (korak 3)
2. **Poveži se na istu WiFi mrežu kao tvoj računar**
3. **Proveri da li proxy server radi:**
   - Otvori browser
   - Idi na: `http://[TVOJA_IP_ADRESA]:3000/health`
   - Trebalo bi da vidiš: `{"status":"ok"}`
4. **Otvori aplikaciju**
5. **Login-uj se sa ChatGPT nalogom**
6. **Testiraj sve funkcionalnosti**

---

## 🐛 REŠAVANJE PROBLEMA

### Problem 1: "App not installed" ili "Package appears to be invalid"

**Rešenje:**
- Proveri da li je dozvoljena instalacija iz nepoznatih izvora
- Pokušaj ponovo da preuzmeš APK (možda je korumpiran)
- Proveri da li telefon ima dovoljno prostora

### Problem 2: Aplikacija se ne učitava / "Network error"

**Rešenje:**
- Proveri da li su na istoj WiFi mreži
- Proveri da li proxy server radi na računaru
- Proveri IP adresu u aplikaciji
- Proveri firewall na računaru (dozvoli port 3000)

### Problem 3: "Connection refused" ili "Cannot connect to server"

**Rešenje:**
- Proveri da li je proxy server pokrenut
- Proveri IP adresu (može se promeniti ako se WiFi rešava)
- Proveri firewall:
  ```bash
  # Windows Firewall - dozvoli port 3000
  # Settings → Network & Internet → Windows Firewall → Advanced settings
  # Inbound Rules → New Rule → Port → 3000 → Allow
  ```

### Problem 4: Aplikacija crash-uje

**Rešenje:**
- Proveri Android verziju (minimalno Android 5.0 / API 21)
- Proveri da li ima dovoljno RAM memorije
- Proveri logove:
  ```bash
  # Na računaru, poveži telefon preko USB
  adb logcat | grep flutter
  ```

---

## 📋 CHECKLIST PRE SLANJA

- [ ] Build-ovao si APK (`flutter build apk --release`)
- [ ] Proverio si IP adresu računara
- [ ] Ažurirao si IP adresu u `main.dart`
- [ ] Rebuild-ovao si APK sa novom IP adresom
- [ ] Testirao si APK na svom telefonu
- [ ] Proxy server radi na računaru
- [ ] Pripremio si instrukcije za prijatelje
- [ ] Prijatelji znaju da moraju biti na istoj WiFi mreži

---

## 💡 PREPORUKE

1. **Koristi Release Build:**
   - Brži i stabilniji
   - Manji fajl
   - Bolje performanse

2. **Testiraj Prvo na Svom Telefonu:**
   - Pre nego što pošalješ prijateljima
   - Proveri da li sve radi

3. **Pripremi Kratke Instrukcije:**
   - Kako da instaliraju APK
   - Kako da se povežu na WiFi
   - Šta da testiraju

4. **Bud Spreman za Probleme:**
   - WiFi mreža može biti problem
   - IP adresa se može promeniti
   - Proxy server može pasti

---

## 🚀 BRZI PUTOKAZ

```bash
# 1. Build APK
cd ZaMariju
flutter build apk --release

# 2. Pronađi IP adresu
ipconfig  # Windows
# Zapiši IPv4 Address (npr. 192.168.0.12)

# 3. Ažuriraj main.dart sa IP adresom
# AIAnalyzer.setProxyUrl('http://192.168.0.12:3000');

# 4. Rebuild APK
flutter build apk --release

# 5. APK je u: build/app/outputs/flutter-apk/app-release.apk
# Pošalji prijateljima!

# 6. Pokreni proxy server
cd proxy-server
npm start
```

---

## ⚠️ VAŽNO!

**Aplikacija će raditi SAMO ako:**
- ✅ Prijatelji su na **ISTOJ WiFi mreži** kao tvoj računar
- ✅ Proxy server je **POKRENUT** na računaru
- ✅ IP adresa u aplikaciji je **TAČNA**
- ✅ Firewall dozvoljava konekcije na port 3000

**Ako prijatelji nisu na istoj WiFi mreži:**
- Moraju deploy-ovati proxy server na internet (Railway, Heroku, itd.)
- Ili koristiti VPN da se povežu na tvoju mrežu

---

**Srećno sa testiranjem! 🎉**

