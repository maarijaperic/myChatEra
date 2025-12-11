# 📱 iOS Setup - Firebase & RevenueCat (SAMO iOS)

## ⏱️ Procena vremena: 2-4 sata

**Sve korake su za iOS aplikaciju!** ✅

---

## 🔥 PART 1: FIREBASE SETUP za iOS (30-45 min)

### Korak 1.1: Kreiranje Firebase projekta

1. **Idi na Firebase Console:**
   - Otvori: https://console.firebase.google.com/
   - Uloguj se sa Google nalogom

2. **Kreiraj novi projekat:**
   - Klikni "Add project" ili "Create a project"
   - **Project name:** `GPT Wrapped` (ili nešto slično)
   - Klikni "Continue"
   - **Google Analytics:** ✅ Enable (preporučeno)
   - Klikni "Create project"
   - Sačekaj da se projekat kreira (~30 sekundi)
   - Klikni "Continue"

### Korak 1.2: Dodavanje iOS aplikacije u Firebase

1. **Na Firebase Dashboard:**
   - Klikni na iOS ikonu (🍎) ili "Add app" → "iOS"

2. **Unesi podatke:**
   - **iOS bundle ID:** `com.mychatera` ⚠️ **MORA biti tačno!**
   - **App nickname (optional):** `GPT Wrapped iOS`
   - **App Store ID (optional):** Ostavi prazno za sada
   - Klikni "Register app"

3. **Download GoogleService-Info.plist:**
   - Klikni "Download GoogleService-Info.plist"
   - **SAČUVAJ FAJL!** Ne zatvaraj prozor još!

### Korak 1.3: Dodavanje GoogleService-Info.plist u Xcode

1. **Otvori Xcode:**
   ```bash
   cd ~/Documents/myChatEra/ZaMariju
   open ios/Runner.xcworkspace
   ```

2. **U Xcode Project Navigator (levo):**
   - Klikni desnim klikom na `Runner` folder
   - Izaberi "Add Files to Runner..."
   - Pronađi `GoogleService-Info.plist` fajl koji si skinuo
   - **VAŽNO:** ✅ Označi "Copy items if needed"
   - ✅ Označi "Add to targets: Runner"
   - Klikni "Add"

3. **Proveri:**
   - U Project Navigator trebalo bi da vidiš `GoogleService-Info.plist` u `Runner` folderu
   - Ako ne vidiš, povuci fajl direktno u `Runner` folder u Finder-u

### Korak 1.4: Omogućavanje Firestore Database

1. **U Firebase Console:**
   - Levo u meniju, klikni "Build" → "Firestore Database"
   - Klikni "Create database"

2. **Security rules:**
   - Izaberi "Start in test mode" (za sada)
   - Klikni "Next"

3. **Location:**
   - Izaberi najbližu lokaciju (npr. `europe-west1`)
   - Klikni "Enable"

4. **Firestore Rules (za produkciju):**
   - Klikni na "Rules" tab
   - Zameni sa:
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /user_analyses/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
     }
   }
   ```
   - Klikni "Publish"

### ✅ Firebase Provera:

```bash
# Proveri da li je fajl dodat
ls -la ~/Documents/myChatEra/ZaMariju/ios/Runner/GoogleService-Info.plist
```

**Trebalo bi da vidiš fajl!** ✅

---

## 💰 PART 2: REVENUECAT SETUP za iOS (1-2 sata)

### Korak 2.1: Kreiranje RevenueCat projekta

1. **Idi na RevenueCat Dashboard:**
   - Otvori: https://app.revenuecat.com/
   - Uloguj se ili kreiraj nalog (besplatno)

2. **Kreiraj novi projekat:**
   - Klikni "New Project" ili "Create Project"
   - **Project name:** `GPT Wrapped`
   - Klikni "Create"

### Korak 2.2: Dodavanje iOS aplikacije u RevenueCat

1. **U RevenueCat Dashboard:**
   - Klikni "Add new app" ili "Apps" → "New App"
   - **App name:** `GPT Wrapped iOS`
   - **Platform:** iOS ⚠️ **Izaberi iOS!**
   - **Bundle ID:** `com.mychatera` ⚠️ **MORA biti tačno!**
   - Klikni "Add"

### Korak 2.3: Povezivanje sa App Store Connect

1. **U RevenueCat Dashboard:**
   - Klikni na svoju aplikaciju
   - Idi na "App Store Connect" tab
   - Klikni "Connect App Store Connect"

2. **Autorizacija:**
   - RevenueCat će tražiti pristup App Store Connect-u
   - Klikni "Authorize" ili "Grant Access"
   - Uloguj se sa Apple ID-om koji koristiš za App Store Connect
   - Klikni "Allow" ili "Authorize"

3. **Izaberi aplikaciju:**
   - RevenueCat će prikazati listu aplikacija
   - Izaberi "GPT Wrapped" (ili kako se zove tvoja aplikacija)
   - Klikni "Continue" ili "Select"

### Korak 2.4: Kreiranje Products u RevenueCat

1. **U RevenueCat Dashboard:**
   - Idi na "Products" tab
   - Klikni "New Product" ili "Create Product"

2. **Kreiraj One-Time Purchase:**
   - **Product Identifier:** `one_time_purchase` ⚠️ **MORA biti tačno!**
   - **Type:** Non-Subscription
   - **Display Name:** `Premium Lifetime`
   - Klikni "Create"

3. **Kreiraj Monthly Subscription:**
   - Klikni "New Product"
   - **Product Identifier:** `monthly_subscription` ⚠️ **MORA biti tačno!**
   - **Type:** Subscription
   - **Display Name:** `Monthly Premium`
   - **Duration:** 1 Month
   - Klikni "Create"

4. **Kreiraj Yearly Subscription:**
   - Klikni "New Product"
   - **Product Identifier:** `yearly_subscription` ⚠️ **MORA biti tačno!**
   - **Type:** Subscription
   - **Display Name:** `Yearly Premium`
   - **Duration:** 1 Year
   - Klikni "Create"

### Korak 2.5: Kreiranje Entitlement

1. **U RevenueCat Dashboard:**
   - Idi na "Entitlements" tab
   - Klikni "New Entitlement" ili "Create Entitlement"

2. **Kreiraj Premium Entitlement:**
   - **Identifier:** `premium` ⚠️ **MORA biti tačno!**
   - **Display Name:** `Premium Access`
   - Klikni "Create"

3. **Poveži Products sa Entitlement:**
   - Klikni na "premium" entitlement
   - U "Products" sekciji, klikni "Add Product"
   - Dodaj sve tri products:
     - ✅ `one_time_purchase`
     - ✅ `monthly_subscription`
     - ✅ `yearly_subscription`
   - Klikni "Save"

### Korak 2.6: Dodavanje API Key u iOS aplikaciju

1. **U RevenueCat Dashboard:**
   - Idi na "API Keys" tab
   - Klikni na "Public SDK Key" (ne Private!)
   - **Kopiraj API Key** (počinje sa `appl_` ili `rc_`)

2. **Dodaj API Key u kod:**
   - Otvori `lib/main.dart`
   - Pronađi liniju 57-59:
   ```dart
   const String revenueCatApiKey = String.fromEnvironment(
     'REVENUECAT_API_KEY',
     defaultValue: 'YOUR_REVENUECAT_PUBLIC_KEY_HERE',
   );
   ```
   - Zameni `'YOUR_REVENUECAT_PUBLIC_KEY_HERE'` sa tvojim API key-om:
   ```dart
   const String revenueCatApiKey = String.fromEnvironment(
     'REVENUECAT_API_KEY',
     defaultValue: 'appl_TVOJ_API_KEY_OVDE',  // ← OVDE STAVI SVOJ API KEY
   );
   ```
   - Sačuvaj fajl

### ✅ RevenueCat Provera:

- [ ] Projekat je kreiran
- [ ] iOS aplikacija je dodata (`com.mychatera`)
- [ ] App Store Connect je povezan
- [ ] Products su kreirani (one_time, monthly, yearly)
- [ ] Entitlement je kreiran (`premium`)
- [ ] Products su povezani sa entitlement-om
- [ ] API Key je dodat u `lib/main.dart`

---

## 🧪 PART 3: TESTIRANJE U TESTFLIGHT (30-45 min)

### Korak 3.1: Build IPA za iOS TestFlight

1. **Povećaj build number:**
   - Otvori `pubspec.yaml`
   - Promeni `version: 1.0.0+1` u `version: 1.0.0+2`
   - Sačuvaj

2. **Build IPA:**
   ```bash
   cd ~/Documents/myChatEra/ZaMariju
   flutter clean
   flutter pub get
   flutter build ipa --export-options-plist=ios/ExportOptions.plist
   ```

3. **Proveri da li je IPA kreiran:**
   ```bash
   ls -lh ~/Documents/myChatEra/ZaMariju/build/ios/ipa/*.ipa
   ```

### Korak 3.2: Upload IPA u App Store Connect

1. **Otvori Apple Transporter:**
   - Ako nemaš, skini: https://apps.apple.com/us/app/transporter/id1450874784
   - Otvori Transporter

2. **Upload IPA:**
   - Klikni "+" ili "Deliver Your App"
   - Pronađi IPA fajl: `~/Documents/myChatEra/ZaMariju/build/ios/ipa/*.ipa`
   - Klikni "Deliver"
   - Sačekaj da se upload završi (~5-10 min)

3. **Proveri u App Store Connect:**
   - Idi na: https://appstoreconnect.apple.com/
   - Idi na "My Apps" → "GPT Wrapped"
   - Idi na "TestFlight" tab
   - Trebalo bi da vidiš novi build (1.0.0 (2))

### Korak 3.3: Dodavanje TestFlight testera

1. **U App Store Connect:**
   - Idi na "TestFlight" tab
   - Klikni "Internal Testing" ili "External Testing"
   - Klikni "+" da dodaš testera
   - Unesi email adresu testera
   - Klikni "Add"

2. **Sačekaj da se build procesira:**
   - Apple procesira build (~10-30 min)
   - Kada je spreman, tester će dobiti email

### Korak 3.4: Testiranje Firebase na iOS

1. **Instaliraj aplikaciju preko TestFlight:**
   - Na iPhone-u, otvori TestFlight app
   - Prihvati pozivnicu (ako je potrebno)
   - Instaliraj aplikaciju

2. **Proveri Firebase log-ove:**
   - Pokreni aplikaciju
   - Proveri Xcode Console ili Flutter log-ove:
   ```
   ✅ Firebase initialized
   ```

3. **Testiraj Firestore:**
   - Idi do premium analize
   - Generiši premium analizu
   - U Firebase Console → Firestore Database:
     - Trebalo bi da vidiš `user_analyses` collection
     - Trebalo bi da vidiš dokument sa user ID-om

### Korak 3.5: Testiranje RevenueCat na iOS

1. **Proveri RevenueCat log-ove:**
   - Pokreni aplikaciju
   - Proveri log-ove:
   ```
   ✅ RevenueCat initialized
   ```

2. **Testiraj Products:**
   - Idi do subscription ekrana
   - Proveri da li se prikazuju subscription opcije
   - U RevenueCat Dashboard → Products, proveri da li se products prikazuju

3. **Testiraj Purchase Flow (Sandbox):**
   - Klikni na subscription (npr. Monthly)
   - Apple će tražiti Sandbox account
   - Klikni "Cancel" (ne kupuj stvarno)
   - U RevenueCat Dashboard → Customers, proveri da li se korisnik pojavio

---

## 📤 PART 4: RESUBMIT iOS APLIKACIJE (15-30 min)

### Korak 4.1: Finalni Build za iOS

1. **Povećaj build number:**
   - Otvori `pubspec.yaml`
   - Promeni `version: 1.0.0+2` u `version: 1.0.0+3`
   - Sačuvaj

2. **Build IPA:**
   ```bash
   cd ~/Documents/myChatEra/ZaMariju
   flutter clean
   flutter pub get
   flutter build ipa --export-options-plist=ios/ExportOptions.plist
   ```

### Korak 4.2: Upload u App Store Connect

1. **Upload IPA:**
   - Otvori Apple Transporter
   - Upload novi IPA fajl
   - Sačekaj da se upload završi

### Korak 4.3: Submit za Review

1. **U App Store Connect:**
   - Idi na "My Apps" → "GPT Wrapped"
   - Idi na "App Store" tab
   - Klikni na verziju (1.0.0)
   - Klikni "Submit for Review"

2. **Proveri sve:**
   - ✅ App Information
   - ✅ Pricing and Availability
   - ✅ App Privacy
   - ✅ Version Information
   - ✅ Age Rating
   - ✅ App Review Information
   - ✅ Content Rights

3. **Submit:**
   - Klikni "Submit for Review"
   - Sačekaj potvrdu

---

## ✅ iOS CHECKLIST PRE SUBMIT-A

### Firebase:
- [ ] GoogleService-Info.plist je dodat u Xcode (`ios/Runner/`)
- [ ] Firebase je inicijalizovan u kodu (već je u `main.dart`)
- [ ] Firestore Database je kreiran
- [ ] Firestore Rules su postavljene
- [ ] Testirano u TestFlight - Firebase radi

### RevenueCat:
- [ ] RevenueCat projekat je kreiran
- [ ] iOS aplikacija je dodata u RevenueCat (`com.mychatera`)
- [ ] App Store Connect je povezan
- [ ] Products su kreirani (one_time, monthly, yearly)
- [ ] Entitlement je kreiran (`premium`) i povezan sa products
- [ ] API Key je dodat u `lib/main.dart` linija 59
- [ ] Testirano u TestFlight - RevenueCat radi

### TestFlight:
- [ ] Build je upload-ovan
- [ ] Build je procesiran
- [ ] Firebase je testiran na iOS
- [ ] RevenueCat je testiran na iOS

### App Store Connect:
- [ ] Build number je povećan (`1.0.0+3`)
- [ ] IPA je upload-ovan
- [ ] Sve sekcije su popunjene
- [ ] Submit za Review je kliknut

---

## 🆘 TROUBLESHOOTING za iOS

### Firebase greška: "GoogleService-Info.plist not found"
```bash
# Proveri da li postoji
ls -la ~/Documents/myChatEra/ZaMariju/ios/Runner/GoogleService-Info.plist

# Ako ne postoji, dodaj ga u Xcode
```

### RevenueCat greška: "API key not set"
- Proveri da li je API key dodat u `lib/main.dart` linija 59
- Proveri da li je API key validan (kopiraj iz RevenueCat Dashboard)

### RevenueCat greška: "Products not found"
- Proveri da li su products kreirani u RevenueCat Dashboard
- Proveri da li su products povezani sa entitlement-om
- Proveri da li su products kreirani u App Store Connect (RevenueCat će ih kreirati automatski)

### TestFlight: "Build processing failed"
- Proveri da li je bundle ID tačan (`com.mychatera`)
- Proveri da li je signing certificate validan
- Proveri da li je provisioning profile validan

---

## 📞 POMOĆ

Ako imaš problema:
1. Proveri log-ove u Xcode Console
2. Proveri Firebase Console → Firestore Database
3. Proveri RevenueCat Dashboard → Customers
4. Javi mi šta vidiš u log-ovima!

---

## 🎯 Ključne iOS informacije

- **Bundle ID:** `com.mychatera`
- **Product IDs:** `one_time_purchase`, `monthly_subscription`, `yearly_subscription`
- **Entitlement ID:** `premium`
- **Firebase Collection:** `user_analyses`

---

**Srećno sa iOS setup-om! 🚀📱**

