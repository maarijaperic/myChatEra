# ✅ Brzi Checklist za Objavu Aplikacije

## 🎯 ODGOVORI NA PITANJA

### ✅ **Da li će besplatna i premium analiza biti dobra kada se vrati na web view login?**
**DA! Biće čak i BOLJE!** Web view login dobija SVE konverzacije direktno iz ChatGPT API-ja, dok fake login koristi samo ono što je u fajlu.

### ✅ **Da li je besplatna analiza sa web view loginom bolja nego sa fake loginom?**
**DA! ZNAČAJNO BOLJA!** Web view login = više podataka = bolja analiza.

---

## 💰 3 PLANA PLAĆANJA

### 1️⃣ **One-Time Purchase ($9.99)**
- Lifetime access
- Jednom iskorišćeno
- Product ID: `one_time_purchase`

### 2️⃣ **Monthly Subscription ($4.99/mesec)**
- 5 analiza mesečno
- Auto-renew
- Product ID: `monthly_subscription`

### 3️⃣ **Yearly Subscription ($19.99/godina)**
- 5 analiza mesečno
- 67% ušteda
- Product ID: `yearly_subscription`

---

## 📱 GOOGLE PLAY STORE - BRZI KORACI

1. ✅ **Kreiraj Developer account** ($25)
2. ✅ **Kreiraj aplikaciju** u Google Play Console
3. ✅ **Kreiraj 3 subscription proizvoda:**
   - `one_time_purchase` ($9.99)
   - `monthly_subscription` ($4.99)
   - `yearly_subscription` ($19.99)
4. ✅ **Build AAB:**
   ```bash
   flutter build appbundle --release
   ```
5. ✅ **Upload AAB** u Google Play Console
6. ✅ **Popuni Store listing** (screenshots, opis, itd.)
7. ✅ **Submit za review**

---

## 🍎 APP STORE - BRZI KORACI

1. ✅ **Kreiraj Developer account** ($99/godina)
2. ✅ **Kreiraj App ID** u Apple Developer Portal
3. ✅ **Kreiraj aplikaciju** u App Store Connect
4. ✅ **Kreiraj 3 in-app purchase proizvoda:**
   - `one_time_purchase` (Non-Consumable)
   - `monthly_subscription` (Auto-Renewable)
   - `yearly_subscription` (Auto-Renewable)
5. ✅ **Build iOS app:**
   ```bash
   flutter build ipa --release
   ```
6. ✅ **Upload IPA** preko Transporter ili Xcode
7. ✅ **Popuni App Store listing**
8. ✅ **Submit za review**

---

## 🔗 REVENUECAT SETUP

1. ✅ **Kreiraj RevenueCat nalog** (besplatno)
2. ✅ **Poveži Google Play Console**
3. ✅ **Poveži App Store Connect**
4. ✅ **Kreiraj Entitlement:** `premium`
5. ✅ **Poveži sve 3 proizvoda** sa `premium` entitlement-om
6. ✅ **Kopiraj Public SDK Key**
7. ✅ **Ažuriraj `main.dart`:**
   ```dart
   const String revenueCatApiKey = 'YOUR_PUBLIC_SDK_KEY_HERE';
   ```

---

## 🔥 FIREBASE SETUP

1. ✅ **Kreiraj Firebase projekat**
2. ✅ **Dodaj Android app** → Download `google-services.json`
3. ✅ **Dodaj iOS app** → Download `GoogleService-Info.plist`
4. ✅ **Kreiraj Firestore Database** (test mode)
5. ✅ **Kreiraj Collection:** `user_analyses`
6. ✅ **Postavi Security Rules** (privremeno `allow read, write: if true`)

---

## ⚙️ NAKON ODOBRENJA

1. ✅ **Postavi u backend `.env`:**
   ```bash
   USE_FAKE_VERSION=false
   ```
2. ✅ **Redeploy backend** (Google Cloud Run)
3. ✅ **App automatski prelazi na web view login!** 🎉

---

## 📋 FINALNI CHECKLIST

### Pre Slanja:
- [ ] Backend deployed (`USE_FAKE_VERSION=true`)
- [ ] AAB build-ovan
- [ ] IPA build-ovan
- [ ] Subscription proizvodi kreirani (oba store-a)
- [ ] RevenueCat povezan
- [ ] Firebase setup-ovan
- [ ] API keys dodati u kod
- [ ] Store listing kompletan
- [ ] Screenshots pripremljeni
- [ ] Privacy Policy postavljen

### Nakon Odobrenja:
- [ ] `USE_FAKE_VERSION=false` u backend
- [ ] Redeploy backend
- [ ] Testiraj web view login
- [ ] Testiraj besplatnu analizu
- [ ] Testiraj premium analizu
- [ ] Testiraj plaćanje

---

**Detaljne korake vidi u `COMPLETE_PUBLISH_GUIDE.md` 📖**
