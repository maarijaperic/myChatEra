# 🧪 Testiranje Premium Limits - Rešenje za "Monthly Limit" Problem

## 🔍 Problem: "Monthly Limit" Poruka

**Zašto se dešava:**
- U TestFlight-u, ako ne kupiš stvarno subscription (Sandbox), RevenueCat ne prepoznaje korisnika kao premium
- `AnalysisTracker` proverava da li je korisnik premium preko RevenueCat-a
- Ako nije premium → vraća `false` → prikazuje "monthly limit" poruku

---

## ✅ REŠENJE 1: TEST_MODE (Privremeno)

**Šta sam uradio:**
- Uključio sam `TEST_MODE` u `analysis_tracker.dart`
- Sada možeš da testiraš premium features bez stvarnog purchase-a

**VAŽNO:**
- **MORAŠ da isključiš TEST_MODE pre production release-a!**
- Pre build-a za App Store, promeni `ENABLE_TEST_MODE = false`

---

## 🔄 Kako da Testiraš Sada

### **Korak 1: Build Novi IPA**

```bash
cd ~/Documents/myChatEra/ZaMariju
flutter clean
flutter pub get
flutter build ipa --export-options-plist=ios/ExportOptions.plist
```

### **Korak 2: Upload Novi IPA**

- Upload u Transporter
- Sačekaj da se build procesira

### **Korak 3: Testiraj u TestFlight**

1. **Instaliraj novi build** preko TestFlight-a
2. **Pokreni aplikaciju**
3. **Idi do premium analize**
4. **Trebalo bi da možeš da generišeš analizu** (bez "monthly limit" poruke)

---

## 🧪 REŠENJE 2: Testiranje sa Sandbox Account-om (Pravilno)

**Ako želiš da testiraš pravilno sa RevenueCat-om:**

### **Korak 1: Kreiraj Sandbox Tester Account**

1. **App Store Connect:**
   - Users and Access → Sandbox Testers
   - Klikni "+" → Kreiraj novi Sandbox account
   - Unesi email i password

### **Korak 2: Testiraj Purchase Flow**

1. **U aplikaciji:**
   - Klikni na subscription (npr. Monthly)
   - Apple će tražiti Sandbox account
   - Unesi Sandbox account credentials
   - **Klikni "Buy"** (neće naplatiti stvarno!)

2. **Proveri RevenueCat Dashboard:**
   - RevenueCat Dashboard → Customers
   - Trebalo bi da vidiš korisnika sa premium subscription-om

3. **Proveri Firebase:**
   - Firebase Console → Firestore Database
   - Trebalo bi da vidiš `user_analyses` collection

---

## 🔍 Kako da Proveriš da li Sve Radi

### **1. Firebase Console**

1. **Otvori Firebase Console:**
   - https://console.firebase.google.com/
   - Izaberi projekat → Firestore Database

2. **Proveri dokumente:**
   - Idi do premium analize u aplikaciji
   - Generiši premium analizu
   - U Firebase Console → Firestore Database:
     - Trebalo bi da vidiš `user_analyses` collection
     - Trebalo bi da vidiš dokument sa user ID-om

**Ako vidiš dokumente → Firebase radi! ✅**

---

### **2. RevenueCat Dashboard**

1. **Otvori RevenueCat Dashboard:**
   - https://app.revenuecat.com/
   - Idi na tvoj projekat → iOS aplikaciju

2. **Proveri Customers:**
   - Idi na "Customers" tab
   - Ako vidiš korisnika → RevenueCat radi! ✅

3. **Proveri Products:**
   - Idi na "Products" tab
   - Proveri da li se products prikazuju

**Ako vidiš korisnika → RevenueCat radi! ✅**

---

### **3. Aplikacija Funkcionalnost**

1. **Testiraj direktno u aplikaciji:**
   - Pokreni aplikaciju
   - Proveri da li se aplikacija pokreće bez grešaka
   - Proveri da li premium features rade
   - Proveri da li subscription ekran se prikazuje

**Ako sve radi → sve je OK! ✅**

---

## ⚠️ VAŽNO: Pre Production Release-a

**MORAŠ da isključiš TEST_MODE!**

1. **Otvori `lib/services/analysis_tracker.dart`**
2. **Promeni:**
   ```dart
   static const bool ENABLE_TEST_MODE = false; // Set to false for production!
   ```
3. **Build novi IPA:**
   ```bash
   flutter clean
   flutter pub get
   flutter build ipa --export-options-plist=ios/ExportOptions.plist
   ```
4. **Upload novi IPA** u Transporter

---

## 📋 CHECKLIST

### **Testiranje sa TEST_MODE:**
- [ ] TEST_MODE je uključen (`ENABLE_TEST_MODE = true`)
- [ ] Build novi IPA
- [ ] Upload novi IPA
- [ ] Testiraj u TestFlight-u
- [ ] Proveri da li premium features rade

### **Provera Firebase:**
- [ ] Firebase Console → Firestore Database
- [ ] Proveri da li se kreiraju dokumenti
- [ ] Proveri da li se user ID pojavljuje

### **Provera RevenueCat:**
- [ ] RevenueCat Dashboard → Customers
- [ ] Proveri da li se korisnik pojavio (ako je kupio Sandbox)

### **Pre Production:**
- [ ] Isključi TEST_MODE (`ENABLE_TEST_MODE = false`)
- [ ] Build novi IPA
- [ ] Upload novi IPA

---

## 🎯 REZIME

1. **TEST_MODE je uključen** → možeš da testiraš bez purchase-a
2. **Build novi IPA** → upload u Transporter
3. **Testiraj u TestFlight-u** → proveri da li radi
4. **Proveri Firebase i RevenueCat** → dashboard-ovi
5. **Pre production** → isključi TEST_MODE!

---

**Srećno sa testiranjem! 🚀**

