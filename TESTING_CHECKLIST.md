# Checklist za Testiranje i Izbacivanje Aplikacije

## 📋 PRE TESTIRANJA SA PRIJATELJIMA (DANAS)

### 1. Provera Proxy Servera
- [ ] Proxy server radi na računaru (`npm start` u `proxy-server` folderu)
- [ ] `.env` fajl ima validan `OPENAI_API_KEY`
- [ ] Server je dostupan na mreži (proveri IP adresu sa `ipconfig`)
- [ ] Firewall dozvoljava konekcije na port 3000

### 2. Provera Aplikacije
- [ ] Aplikacija se kompajlira bez grešaka
- [ ] Testiraj na svom telefonu - sve funkcioniše
- [ ] Besplatna analiza radi
- [ ] Premium analiza radi i prikazuje prave podatke (ne demo)
- [ ] Svi ekrani se prikazuju kako treba
- [ ] Navigacija radi (swipe levo/desno)
- [ ] SubscriptionScreen - samo "Continue" dugme navigira na premium

### 3. Priprema za Testiranje
- [ ] Ukloni sve debug print poruke (ili ih komentariši)
- [ ] Proveri da li ima hardkodovanih IP adresa koje treba promeniti
- [ ] Pripremi kratke instrukcije za prijatelje:
  - Kako da se povežu na proxy server
  - Kako da pronađu IP adresu računara
  - Kako da testiraju aplikaciju

---

## 🧪 TESTIRANJE SA PRIJATELJIMA (SUTRA)

### Instrukcije za Prijatelje:

1. **Povezivanje na Proxy Server:**
   ```
   - Uradiš: ipconfig u CMD-u
   - Pronađeš IPv4 adresu (npr. 192.168.0.12)
   - Otvoriš aplikaciju
   - Aplikacija će automatski koristiti proxy server
   ```

2. **Šta da Testiraju:**
   - [ ] Login sa ChatGPT nalogom
   - [ ] Čekanje dok se analiza izvršava
   - [ ] Prolazak kroz besplatne ekrane
   - [ ] Klik na "Continue" na SubscriptionScreen
   - [ ] Prolazak kroz premium ekrane
   - [ ] Proveri da li se prikazuju pravi podaci (ne demo)
   - [ ] Testiraj na različitim telefonima (Android verzije)

3. **Feedback koji Treba Prikupiti:**
   - [ ] Da li se aplikacija učitava brzo?
   - [ ] Da li su podaci tačni?
   - [ ] Da li ima bugova ili crash-ova?
   - [ ] Da li je UI lep i funkcionalan?
   - [ ] Da li ima problema sa navigacijom?
   - [ ] Da li proxy server radi stabilno?

---

## 🐛 NAKON TESTIRANJA - Popravke

### 1. Analiza Feedbacka
- [ ] Sastavi listu svih bugova
- [ ] Prioritetizuj bugove (critical, high, medium, low)
- [ ] Popravi sve critical i high bugove

### 2. Optimizacije
- [ ] Optimizuj performanse (ako je sporo)
- [ ] Popravi UI/UX probleme
- [ ] Dodaj error handling gde nedostaje
- [ ] Proveri da li sve animacije rade glatko

---

## 📱 PRE IZBACIVANJA APLIKACIJE

### 1. Finalne Provere
- [ ] Ukloni sve debug poruke
- [ ] Ukloni test podatke i hardkodovane vrednosti
- [ ] Proveri da li sve ekrane imaju error handling
- [ ] Testiraj na različitim veličinama ekrana
- [ ] Testiraj na različitim Android verzijama (minimalno API 21+)

### 2. Priprema za Production
- [ ] **Promeni API endpoint:**
  - Umesto lokalnog proxy servera, koristi production server
  - Ili koristi direktan OpenAI API poziv (sa backend serverom)
  
- [ ] **Environment Variables:**
  - Kreiraj production `.env` fajl
  - Koristi production API keys
  - Ne commit-uj API keys u git!

- [ ] **App Configuration:**
  - [ ] Proveri `android/app/build.gradle`:
    - `applicationId` - tvoj package name
    - `versionCode` - povećaj za svaki release
    - `versionName` - verzija aplikacije (npr. "1.0.0")
    - `minSdkVersion` - minimalna Android verzija
    - `targetSdkVersion` - target Android verzija

  - [ ] Proveri `android/app/src/main/AndroidManifest.xml`:
    - Internet permission (`<uses-permission android:name="android.permission.INTERNET"/>`)
    - App name, icon, theme

### 3. Build za Production
```bash
# U ZaMariju folderu:
flutter clean
flutter pub get
flutter build apk --release  # Za APK fajl
# ili
flutter build appbundle --release  # Za Google Play Store
```

### 4. Testiranje Production Build-a
- [ ] Instaliraj production APK na telefon
- [ ] Testiraj sve funkcionalnosti
- [ ] Proveri da li sve radi bez proxy servera (ako koristiš production backend)

---

## 🚀 IZBACIVANJE APLIKACIJE

### Google Play Store

#### 1. Priprema Materijala
- [ ] **App Icon:** 512x512px PNG (bez alpha channel)
- [ ] **Feature Graphic:** 1024x500px (za Google Play listing)
- [ ] **Screenshots:** 
  - Phone: min 2, max 8 (16:9 ili 9:16)
  - Tablet: opciono
- [ ] **Short Description:** Max 80 karaktera
- [ ] **Full Description:** Max 4000 karaktera
- [ ] **Privacy Policy URL:** Obavezno! (možeš koristiti GitHub Pages ili slično)

#### 2. Kreiranje Google Play Console Naloga
- [ ] Registruj se na [Google Play Console](https://play.google.com/console)
- [ ] Plati jednokratnu registracionu taksu ($25)
- [ ] Kreiraj novu aplikaciju

#### 3. Upload Aplikacije
- [ ] Upload AAB fajla (App Bundle)
- [ ] Popuni sve informacije (opis, screenshots, kategorija, itd.)
- [ ] Postavi Privacy Policy
- [ ] Postavi Content Rating (PEGI/ESRB)
- [ ] Odgovori na sve pitanja (data safety, target audience, itd.)

#### 4. Review Proces
- [ ] Submit za review
- [ ] Čekaj review (obično 1-3 dana)
- [ ] Ako ima problema, popravi i ponovo submit-uj

---

## 📝 DODATNI KORACI

### 1. Backend Server (Ako ne koristiš lokalni proxy)
- [ ] Deploy proxy server na hosting (Heroku, Railway, AWS, itd.)
- [ ] Postavi environment variables na serveru
- [ ] Testiraj da li server radi
- [ ] Ažuriraj Flutter app da koristi production URL

### 2. Analytics (Opciono)
- [ ] Dodaj Firebase Analytics (ili slično)
- [ ] Dodaj crash reporting (Firebase Crashlytics)

### 3. Marketing
- [ ] Pripremi social media postove
- [ ] Napravi landing page (opciono)
- [ ] Pripremi promo materijale

---

## ⚠️ VAŽNE NAPOMENE

1. **API Keys:**
   - NIKADA ne commit-uj API keys u git!
   - Koristi environment variables
   - Za production, koristi backend server (ne direktan API poziv iz app-a)

2. **Privacy Policy:**
   - Obavezno imaš Privacy Policy
   - Moraju biti jasno navedeni:
     - Koje podatke prikupljaš
     - Kako koristiš podatke
     - Da li deliš podatke sa trećim stranama

3. **Data Safety:**
   - Google Play zahteva da popuniš Data Safety formu
   - Budi iskren o tome šta aplikacija radi sa podacima

4. **Testing:**
   - Testiraj na što više različitih uređaja
   - Testiraj na različitim Android verzijama
   - Testiraj sa različitim količinama podataka

---

## 🎯 QUICK CHECKLIST PRE SUTRA

- [ ] Proxy server radi
- [ ] Aplikacija se kompajlira
- [ ] Testirao si na svom telefonu - sve radi
- [ ] Pripremio si kratke instrukcije za prijatelje
- [ ] Znaš svoju IP adresu za proxy server

**Srećno sa testiranjem! 🚀**

