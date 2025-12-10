# 🔥 Firebase + RevenueCat Setup Guide

## 📋 Pregled

Ova aplikacija koristi:
- **Firebase Firestore** - za praćenje broja analiza po korisniku
- **RevenueCat** - za upravljanje subscription-ima i plaćanjima

---

## 🎯 PLANOVI I CENE

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

## 🔥 KORAK 1: Firebase Setup

### 1.1. Kreiraj Firebase Projekat

1. Idi na https://console.firebase.google.com
2. Klikni "Add project" ili "Create a project"
3. Unesi ime projekta (npr. "GPT Wrapped")
4. Odaberi Google Analytics (opciono, možeš isključiti)
5. Klikni "Create project"

### 1.2. Dodaj Android App

1. U Firebase Console → Project Overview
2. Klikni Android ikonu (ili "Add app")
3. Unesi:
   - **Package name:** `com.example.gpt_wrapped2` (proveri u `android/app/build.gradle`)
   - **App nickname:** GPT Wrapped (opciono)
   - **Debug signing certificate:** (opciono za sada)
4. Klikni "Register app"
5. Download `google-services.json`
6. Kopiraj `google-services.json` u `ZaMariju/android/app/`

### 1.3. Dodaj iOS App

1. U Firebase Console → Project Overview
2. Klikni iOS ikonu
3. Unesi:
   - **Bundle ID:** `com.example.gptWrapped2` (proveri u `ios/Runner.xcodeproj`)
   - **App nickname:** GPT Wrapped (opciono)
4. Klikni "Register app"
5. Download `GoogleService-Info.plist`
6. Kopiraj `GoogleService-Info.plist` u `ZaMariju/ios/Runner/`

### 1.4. Setup Firestore Database

1. U Firebase Console → Build → Firestore Database
2. Klikni "Create database"
3. Odaberi "Start in test mode" (za početak)
4. Odaberi lokaciju (npr. `europe-west` ili `us-central`)
5. Klikni "Enable"

### 1.5. Kreiraj Firestore Collection

1. U Firestore Database → "Start collection"
2. Collection ID: `user_analyses`
3. Document ID: `auto-id` (za prvi dokument, posle ćeš koristiti User ID)
4. Dodaj polja:
   - `userId` (string) - RevenueCat User ID
   - `oneTimeUsed` (boolean) - da li je one-time analiza iskorišćena
   - `monthlyCounts` (map) - broj analiza po mesecu
     - Primer: `{"2025-01": 3, "2025-02": 1}`
   - `lastAnalysis` (timestamp) - datum poslednje analize
   - `lastUpdated` (timestamp) - poslednje ažuriranje

### 1.6. Firestore Security Rules

1. U Firestore Database → Rules
2. Zameni postojeće pravila sa:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Collection za praćenje analiza
    match /user_analyses/{userId} {
      // Dozvoli čitanje i pisanje samo za korisnika sa istim userId
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // ILI ako koristiš RevenueCat User ID (bez auth):
      // allow read, write: if true; // Privremeno - zameni sa pravim pravilima
    }
  }
}
```

**⚠️ VAŽNO:** Za produkciju, koristi Firebase Authentication ili backend validaciju!

### 1.7. Dobij Firebase Config

1. U Firebase Console → Project Settings (⚙️)
2. Scroll do "Your apps"
3. Kopiraj:
   - **Android:** `google-services.json` (već si ga download-ovao)
   - **iOS:** `GoogleService-Info.plist` (već si ga download-ovao)

---

## 💳 KORAK 2: RevenueCat Setup

### 2.1. Kreiraj RevenueCat Nalog

1. Idi na https://app.revenuecat.com
2. Registruj se (besplatno)
3. Klikni "New Project"
4. Unesi ime projekta (npr. "GPT Wrapped")

### 2.2. Poveži Google Play Console

1. U RevenueCat Dashboard → Integrations
2. Klikni "Google Play"
3. Klikni "Connect Google Play"
4. Prijavi se sa Google nalogom
5. Odaberi tvoj projekat
6. Klikni "Allow" / "Connect"

### 2.3. Poveži App Store Connect

1. U RevenueCat Dashboard → Integrations
2. Klikni "App Store"
3. Klikni "Connect App Store"
4. Prijavi se sa Apple ID-om
5. Odaberi tvoj projekat
6. Klikni "Allow" / "Connect"

### 2.4. Kreiraj Proizvode u Google Play Console

1. Google Play Console → Monetize → Products → Subscriptions
2. Klikni "Create subscription"
3. Kreiraj 3 proizvoda:

**One-Time:**
- Product ID: `one_time_purchase`
- Name: "One Time Purchase"
- Description: "Lifetime access with 1 analysis"
- Price: $3.99
- Billing period: One-time

**Monthly:**
- Product ID: `monthly_subscription`
- Name: "Monthly Subscription"
- Description: "5 analyses per month"
- Price: $6.99
- Billing period: Monthly

**Yearly:**
- Product ID: `yearly_subscription`
- Name: "Yearly Subscription"
- Description: "5 analyses per month"
- Price: $39.99
- Billing period: Yearly

4. RevenueCat će automatski detektovati proizvode (može potrajati nekoliko minuta)

### 2.5. Kreiraj Proizvode u App Store Connect

1. App Store Connect → My Apps → [Tvoja app] → Features → In-App Purchases
2. Klikni "+" → "Create"
3. Kreiraj 3 proizvoda (isti ID-ovi kao gore):
   - `one_time_purchase` ($3.99, Non-Consumable)
   - `monthly_subscription` ($6.99, Auto-Renewable Subscription)
   - `yearly_subscription` ($39.99, Auto-Renewable Subscription)

4. RevenueCat će automatski detektovati proizvode

### 2.6. Kreiraj Entitlements u RevenueCat

1. U RevenueCat Dashboard → Entitlements
2. Klikni "New entitlement"
3. Kreiraj entitlement:
   - **Identifier:** `premium`
   - **Display Name:** Premium Access
4. Poveži proizvode sa entitlement-om:
   - `one_time_purchase` → `premium`
   - `monthly_subscription` → `premium`
   - `yearly_subscription` → `premium`

### 2.7. Dobij API Ključeve

1. U RevenueCat Dashboard → API Keys
2. Kopiraj **Public SDK Key** (za Flutter app)
3. Kopiraj **Secret Key** (za backend, ako ga koristiš)

---

## 📱 KORAK 3: Flutter Setup

### 3.1. Dodaj Pakete

Dodaj u `pubspec.yaml`:

```yaml
dependencies:
  # Firebase
  firebase_core: ^3.6.0
  cloud_firestore: ^5.4.0
  
  # RevenueCat
  purchases_flutter: ^7.0.0
```

Zatim pokreni:
```bash
cd ZaMariju
flutter pub get
```

### 3.2. Android Setup

1. **Dodaj `google-services.json`:**
   - Kopiraj `google-services.json` u `android/app/`

2. **Ažuriraj `android/build.gradle`:**
   ```gradle
   buildscript {
       dependencies {
           classpath 'com.google.gms:google-services:4.4.2'
       }
   }
   ```

3. **Ažuriraj `android/app/build.gradle`:**
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```

### 3.3. iOS Setup

1. **Dodaj `GoogleService-Info.plist`:**
   - Kopiraj `GoogleService-Info.plist` u `ios/Runner/`
   - U Xcode, desni klik na `Runner` → "Add Files to Runner"
   - Odaberi `GoogleService-Info.plist`
   - ✅ "Copy items if needed"

2. **Ažuriraj `ios/Podfile`:**
   ```ruby
   platform :ios, '12.0'
   ```

3. **Pokreni:**
   ```bash
   cd ios
   pod install
   cd ..
   ```

---

## 🔧 KORAK 4: Konfiguracija u Kodu

### 4.1. Firebase Inicijalizacija

U `main.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicijalizuj Firebase
  await Firebase.initializeApp();
  
  // Inicijalizuj RevenueCat
  await Purchases.setDebugLogsEnabled(true); // Samo za development
  await Purchases.configure(
    PurchasesConfiguration('YOUR_REVENUECAT_PUBLIC_KEY')
      ..appUserID = null // RevenueCat će automatski generisati
  );
  
  runApp(const MyApp());
}
```

### 4.2. Environment Variables (Preporučeno)

Koristi `flutter_dotenv` za API ključeve:

```yaml
# pubspec.yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

Kreiraj `.env` fajl:
```
REVENUECAT_API_KEY=your_public_key_here
```

---

## ✅ Checklist

### Firebase:
- [ ] Firebase projekat kreiran
- [ ] Android app dodat (`google-services.json` u `android/app/`)
- [ ] iOS app dodat (`GoogleService-Info.plist` u `ios/Runner/`)
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
- [ ] API ključevi dobijeni

### Flutter:
- [ ] Paketi dodati u `pubspec.yaml`
- [ ] `flutter pub get` pokrenut
- [ ] `google-services.json` dodat
- [ ] `GoogleService-Info.plist` dodat
- [ ] Firebase inicijalizovan u `main.dart`
- [ ] RevenueCat inicijalizovan u `main.dart`

---

## 🚀 Sledeći Koraci

Nakon što završiš setup, implementiraj:
1. `AnalysisTracker` servis (sa Firebase)
2. `RevenueCatService` servis
3. Ažuriraj `SubscriptionScreen` sa purchase flow-om
4. Dodaj "Get Another Analysis" dugme u `SocialSharingScreen`
5. Ažuriraj `PremiumAnalyzingScreen` sa proverom limita

---

## 📞 Troubleshooting

### Firebase:
- **Error: "Default FirebaseApp is not initialized"**
  → Proveri da li si pozvao `Firebase.initializeApp()` u `main()`

- **Error: "google-services.json not found"**
  → Proveri da li je fajl u `android/app/` folderu

### RevenueCat:
- **Error: "Product not found"**
  → Proveri da li su proizvodi kreirani u Google Play/App Store
  → Proveri da li su product ID-ovi tačni

- **Error: "Invalid API key"**
  → Proveri da li koristiš Public SDK Key (ne Secret Key)

---

**Srećno! 🎉**






