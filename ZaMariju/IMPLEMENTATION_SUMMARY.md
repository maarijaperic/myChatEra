# ✅ Firebase + RevenueCat Implementation Summary

## 🎉 Šta je Implementirano

### 1. ✅ Paketi Dodati
- `firebase_core: ^3.6.0`
- `cloud_firestore: ^5.4.0`
- `purchases_flutter: ^7.0.0`

### 2. ✅ Servisi Kreirani

#### `RevenueCatService` (`lib/services/revenuecat_service.dart`)
- Inicijalizacija RevenueCat-a
- Provera premium statusa
- Dobijanje tipa subscription-a
- Purchase flow
- Restore purchases

#### `AnalysisTracker` (`lib/services/analysis_tracker.dart`)
- Provera da li korisnik može generisati analizu
- Praćenje broja analiza u Firebase Firestore
- Povećanje brojača nakon generisanja
- Dobijanje preostalih analiza
- Reset mesečnih limita

### 3. ✅ Ekrani Ažurirani

#### `SubscriptionScreen`
- RevenueCat purchase flow integrisan
- Loading state tokom kupovine
- Error handling

#### `PremiumAnalyzingScreen`
- Provera limita pre generisanja analize
- Povećanje brojača nakon uspešne analize
- Error poruke za prekoračenje limita

#### `SocialSharingScreen`
- "Get Another Analysis" dugme dodato
- Automatska provera preostalih analiza
- Navigacija na login ili direktno na analizu

#### `main.dart`
- Firebase inicijalizacija
- RevenueCat inicijalizacija

---

## 📋 PLANOVI I CENE

### One-Time Purchase
- **Cena:** $3.99
- **Analize:** 1 analiza (lifetime)
- **Product ID:** `one_time_purchase`

### Monthly Subscription
- **Cena:** $6.99/mesec
- **Analize:** 5 analiza mesečno
- **Product ID:** `monthly_subscription`

### Yearly Subscription
- **Cena:** $39.99/godina
- **Analize:** 5 analiza mesečno
- **Product ID:** `yearly_subscription`

---

## 🔧 Šta Treba da Uradiš

### KORAK 1: Firebase Setup

1. **Kreiraj Firebase Projekat**
   - Idi na https://console.firebase.google.com
   - Klikni "Add project"
   - Unesi ime (npr. "GPT Wrapped")
   - Odaberi lokaciju

2. **Dodaj Android App**
   - Klikni Android ikonu
   - Unesi Package name (proveri u `android/app/build.gradle`)
   - Download `google-services.json`
   - Kopiraj u `ZaMariju/android/app/`

3. **Dodaj iOS App**
   - Klikni iOS ikonu
   - Unesi Bundle ID (proveri u `ios/Runner.xcodeproj`)
   - Download `GoogleService-Info.plist`
   - Kopiraj u `ZaMariju/ios/Runner/`

4. **Kreiraj Firestore Database**
   - Build → Firestore Database
   - "Create database" → "Start in test mode"
   - Odaberi lokaciju
   - Collection: `user_analyses`

5. **Firestore Security Rules**
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /user_analyses/{userId} {
         allow read, write: if true; // Privremeno - zameni sa pravim pravilima
       }
     }
   }
   ```

### KORAK 2: RevenueCat Setup

1. **Kreiraj RevenueCat Nalog**
   - Idi na https://app.revenuecat.com
   - Registruj se
   - Kreiraj novi projekat

2. **Poveži Google Play Console**
   - Integrations → Google Play
   - Connect Google Play
   - Odaberi projekat

3. **Poveži App Store Connect**
   - Integrations → App Store
   - Connect App Store
   - Odaberi projekat

4. **Kreiraj Proizvode u Google Play Console**
   - Monetize → Products → Subscriptions
   - Kreiraj 3 proizvoda:
     - `one_time_purchase` ($3.99, One-time)
     - `monthly_subscription` ($6.99, Monthly)
     - `yearly_subscription` ($39.99, Yearly)

5. **Kreiraj Proizvode u App Store Connect**
   - My Apps → [Tvoja app] → Features → In-App Purchases
   - Kreiraj 3 proizvoda (isti ID-ovi)

6. **Kreiraj Entitlement**
   - RevenueCat Dashboard → Entitlements
   - Identifier: `premium`
   - Poveži sve 3 proizvoda sa `premium` entitlement-om

7. **Dobij API Ključeve**
   - RevenueCat Dashboard → API Keys
   - Kopiraj **Public SDK Key**

### KORAK 3: Konfiguracija u Kodu

1. **Ažuriraj `main.dart`**
   - Zameni `YOUR_REVENUECAT_PUBLIC_KEY_HERE` sa tvojim RevenueCat Public SDK Key
   - Ili koristi environment variable:
     ```dart
     flutter run --dart-define=REVENUECAT_API_KEY=your_key_here
     ```

2. **Android Setup**
   - Proveri da li je `google-services.json` u `android/app/`
   - Ažuriraj `android/build.gradle`:
     ```gradle
     buildscript {
         dependencies {
             classpath 'com.google.gms:google-services:4.4.2'
         }
     }
     ```
   - Ažuriraj `android/app/build.gradle`:
     ```gradle
     apply plugin: 'com.google.gms.google-services'
     ```

3. **iOS Setup**
   - Proveri da li je `GoogleService-Info.plist` u `ios/Runner/`
   - U Xcode, desni klik na `Runner` → "Add Files to Runner"
   - Odaberi `GoogleService-Info.plist`
   - Pokreni: `cd ios && pod install && cd ..`

4. **Instaliraj Pakete**
   ```bash
   cd ZaMariju
   flutter pub get
   ```

---

## 🧪 Testiranje

### Test Scenariji

1. **One-Time Purchase**
   - Kupi one-time subscription
   - Generiši analizu
   - Pokušaj da generišeš drugu → treba da blokira

2. **Monthly Subscription**
   - Kupi monthly subscription
   - Generiši 5 analiza
   - Pokušaj da generišeš 6. → treba da blokira
   - Sačekaj novi mesec → treba da resetuje

3. **Yearly Subscription**
   - Isto kao monthly, samo sa godišnjim periodom

4. **Get Another Analysis**
   - Klikni "Get Another Analysis" na SocialSharingScreen
   - Proveri da li ide na login ili direktno na analizu
   - Proveri da li se brojač ažurira

---

## 📊 Firebase Firestore Struktura

### Collection: `user_analyses`

#### Document Structure:
```json
{
  "userId": "abc123",  // RevenueCat User ID
  "oneTimeUsed": false,  // Za one-time korisnike
  "monthlyCounts": {
    "2025-01": 3,  // 3 analize u januaru
    "2025-02": 1   // 1 analiza u februaru
  },
  "lastAnalysis": "2025-01-15T10:30:00Z",
  "lastUpdated": "2025-01-15T10:30:00Z"
}
```

---

## ⚠️ VAŽNE NAPOMENE

1. **RevenueCat API Key**
   - Zameni `YOUR_REVENUECAT_PUBLIC_KEY_HERE` u `main.dart`
   - Koristi Public SDK Key (ne Secret Key)

2. **Firebase Security Rules**
   - Trenutno su postavljene na `allow read, write: if true`
   - Za produkciju, koristi Firebase Authentication ili backend validaciju

3. **Test Mode**
   - RevenueCat ima test mode za testiranje bez stvarnih plaćanja
   - Firebase Firestore je u test mode-u (za početak)

4. **Product ID-ovi**
   - Proveri da li su product ID-ovi tačni u Google Play/App Store
   - Mora da se poklapaju sa onima u kodu

---

## 🐛 Troubleshooting

### Firebase:
- **"Default FirebaseApp is not initialized"**
  → Proveri da li si pozvao `Firebase.initializeApp()` u `main()`

- **"google-services.json not found"**
  → Proveri da li je fajl u `android/app/` folderu

### RevenueCat:
- **"Product not found"**
  → Proveri da li su proizvodi kreirani u Google Play/App Store
  → Proveri da li su product ID-ovi tačni

- **"Invalid API key"**
  → Proveri da li koristiš Public SDK Key (ne Secret Key)

### Analysis Tracking:
- **"Error checking if can generate analysis"**
  → Proveri Firebase konekciju
  → Proveri da li je Firestore Database kreiran
  → Proveri da li je collection `user_analyses` kreirana

---

## ✅ Checklist

### Firebase:
- [ ] Firebase projekat kreiran
- [ ] Android app dodat (`google-services.json`)
- [ ] iOS app dodat (`GoogleService-Info.plist`)
- [ ] Firestore Database kreiran
- [ ] Collection `user_analyses` kreirana
- [ ] Security rules postavljene

### RevenueCat:
- [ ] RevenueCat nalog kreiran
- [ ] Google Play Console povezan
- [ ] App Store Connect povezan
- [ ] Proizvodi kreirani u Google Play Console
- [ ] Proizvodi kreirani u App Store Connect
- [ ] Entitlement `premium` kreiran
- [ ] API ključ dobijen i dodat u `main.dart`

### Flutter:
- [ ] Paketi instalirani (`flutter pub get`)
- [ ] `google-services.json` dodat
- [ ] `GoogleService-Info.plist` dodat
- [ ] Android build.gradle ažuriran
- [ ] iOS pod install pokrenut
- [ ] RevenueCat API key dodat u `main.dart`

### Testiranje:
- [ ] One-time purchase testiran
- [ ] Monthly subscription testiran
- [ ] Yearly subscription testiran
- [ ] "Get Another Analysis" testiran
- [ ] Limit enforcement testiran

---

## 🚀 Sledeći Koraci

1. **Završi Firebase i RevenueCat setup** (koraci gore)
2. **Testiraj sve funkcionalnosti**
3. **Ažuriraj Firebase Security Rules** za produkciju
4. **Objavi aplikaciju** na Play Store i App Store
5. **Monitoruj Firebase i RevenueCat dashboard-e**

---

**Srećno! 🎉**

Sve je implementirano i spremno za testiranje. Samo treba da završiš Firebase i RevenueCat setup korake!






