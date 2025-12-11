# 🚀 Production Ready Guide - Kako Sve Radi za Prodaju

## 🎯 Kako Funkcioniše Flow u Produkciji

### **Scenario 1: Korisnik Kupuje Monthly Subscription**

1. **Korisnik klikne "Monthly Subscription" u aplikaciji**
2. **Apple StoreKit prikazuje purchase dialog**
3. **Korisnik kupuje subscription** (stvarno plaća)
4. **RevenueCat automatski detektuje purchase:**
   - RevenueCat dobija notifikaciju od Apple-a
   - RevenueCat aktivira entitlement "premium"
   - RevenueCat povezuje korisnika sa subscription-om

5. **Aplikacija proverava premium status:**
   ```dart
   final isPremium = await RevenueCatService.isPremium();
   // Vraća true jer korisnik ima aktivnu subscription
   ```

6. **Aplikacija proverava limits:**
   ```dart
   final canGenerate = await AnalysisTracker.canGenerateAnalysis();
   // Proverava Firebase da li je korisnik iskoristio 5 analiza ovog meseca
   ```

7. **Ako može da generiše:**
   - Generiše analizu
   - Firebase čuva: `user_analyses/{userId}` sa `monthlyCounts: { "2025-12": 1 }`

8. **Ako je dostigao limit (5 analiza):**
   - Prikazuje "Monthly limit reached" poruku
   - Korisnik mora da sačeka sledeći mesec

---

### **Scenario 2: Korisnik Kupuje Yearly Subscription**

**Isti flow kao Monthly, samo:**
- RevenueCat aktivira entitlement "premium"
- Firebase prati `monthlyCounts` (5 analiza po mesecu)
- Korisnik ima 12 meseci premium pristupa

---

### **Scenario 3: Korisnik Kupuje One-Time Purchase**

1. **Korisnik klikne "Lifetime Purchase"**
2. **Apple StoreKit prikazuje purchase dialog**
3. **Korisnik kupuje** (stvarno plaća)
4. **RevenueCat aktivira entitlement "premium"**
5. **Aplikacija proverava:**
   ```dart
   final canGenerate = await AnalysisTracker.canGenerateAnalysis();
   // Proverava Firebase da li je korisnik već iskoristio one-time purchase
   ```

6. **Ako nije iskoristio:**
   - Generiše analizu
   - Firebase čuva: `user_analyses/{userId}` sa `oneTimeUsed: true`

7. **Ako je već iskoristio:**
   - Prikazuje poruku da je već iskoristio one-time purchase

---

## ✅ Šta Treba da Bude Gotovo Pre Production

### **1. Firebase Setup ✅**

- [x] Firebase projekat kreiran
- [x] iOS app dodat u Firebase
- [x] `GoogleService-Info.plist` dodat u Xcode
- [x] Firestore Database kreiran
- [x] Security Rules postavljene (production mode)

**Proveri Security Rules:**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /user_analyses/{userId} {
      // Korisnik može da čita samo svoje podatke
      allow read: if request.auth != null && request.auth.uid == userId;
      // Korisnik može da piše samo svoje podatke
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

**VAŽNO:** Ako koristiš RevenueCat User ID (ne Firebase Auth), možda treba drugačije rules. Proveri!

---

### **2. RevenueCat Setup ✅**

- [x] RevenueCat projekat kreiran
- [x] iOS app dodat u RevenueCat
- [x] App Store Connect API Key (P8) upload-ovan
- [x] Products kreirani (monthly, yearly, one_time)
- [x] Entitlement "premium" kreiran
- [x] Products attach-ovani na entitlement
- [x] API Key dodat u `main.dart`

**Proveri RevenueCat Dashboard:**
- Products → Trebalo bi da vidiš 3 products
- Entitlements → Trebalo bi da vidiš "premium" entitlement
- Products attach-ovani na entitlement

---

### **3. App Store Connect Setup ✅**

- [x] In-App Purchases kreirani
- [x] Subscriptions kreirani
- [x] Metadata popunjen (description, price, screenshot)
- [x] Subscription Group kreiran
- [x] Localization dodata

**Proveri App Store Connect:**
- In-App Purchases → Status: "Ready to Submit"
- Subscriptions → Status: "Ready to Submit"
- Nema "Missing Metadata" grešaka

---

### **4. Code Setup ✅**

- [x] Firebase inicijalizovan u `main.dart`
- [x] RevenueCat inicijalizovan u `main.dart`
- [x] `AnalysisTracker` implementiran
- [x] `RevenueCatService` implementiran
- [x] TEST_MODE isključen (`ENABLE_TEST_MODE = false`)

---

## 🔄 Finalni Test Pre Production

### **Test 1: Sandbox Purchase (Testiranje sa Stvarnim Purchase-om)**

1. **Kreiraj Sandbox Tester Account:**
   - App Store Connect → Users and Access → Sandbox Testers
   - Klikni "+" → Kreiraj novi account

2. **Testiraj Purchase Flow:**
   - U aplikaciji → Klikni na subscription
   - Apple će tražiti Sandbox account
   - Unesi Sandbox credentials
   - **Klikni "Buy"** (neće naplatiti stvarno!)

3. **Proveri RevenueCat:**
   - RevenueCat Dashboard → Customers
   - Trebalo bi da vidiš korisnika sa premium subscription-om

4. **Proveri Firebase:**
   - Firebase Console → Firestore Database
   - Trebalo bi da vidiš `user_analyses` collection
   - Trebalo bi da vidiš dokument sa user ID-om

5. **Testiraj Limits:**
   - Generiši 5 analiza (monthly limit)
   - Proveri da li se prikazuje "Monthly limit reached"
   - Proveri Firebase da li se broji ispravno

---

### **Test 2: One-Time Purchase**

1. **Kupuj One-Time Purchase** (Sandbox)
2. **Generiši analizu**
3. **Pokušaj ponovo** → Trebalo bi da vidiš poruku da je već iskorišćeno

---

### **Test 3: Subscription Renewal**

1. **Kupuj Monthly Subscription** (Sandbox)
2. **Generiši 5 analiza**
3. **Sačekaj sledeći mesec** (ili promeni datum u Firebase-u za testiranje)
4. **Proveri da li se limit reset-uje**

---

## 🚀 Finalni Checklist Pre Production

### **Firebase:**
- [ ] Security Rules postavljene (production mode)
- [ ] Firestore Database radi
- [ ] `GoogleService-Info.plist` u Xcode projektu

### **RevenueCat:**
- [ ] API Key dodat u `main.dart`
- [ ] Products attach-ovani na entitlement
- [ ] P8 Key upload-ovan

### **App Store Connect:**
- [ ] In-App Purchases "Ready to Submit"
- [ ] Subscriptions "Ready to Submit"
- [ ] Nema "Missing Metadata" grešaka

### **Code:**
- [ ] TEST_MODE isključen (`ENABLE_TEST_MODE = false`)
- [ ] Build number povećan
- [ ] IPA build-ovan
- [ ] Testiran sa Sandbox purchase-om

### **Testiranje:**
- [ ] Sandbox purchase radi
- [ ] RevenueCat detektuje purchase
- [ ] Firebase čuva podatke
- [ ] Limits rade ispravno
- [ ] One-time purchase radi
- [ ] Monthly/yearly subscriptions rade

---

## 📋 Kada Isključiš TEST_MODE - Šta Se Dešava

### **Pre (TEST_MODE = true):**
```dart
// Bypass-uje RevenueCat provere
if (ENABLE_TEST_MODE) {
  return true; // Uvek dozvoljava
}
```

### **Posle (TEST_MODE = false):**
```dart
// Proverava RevenueCat
final isPremium = await RevenueCatService.isPremium();
if (!isPremium) {
  return false; // Ne dozvoljava ako nije premium
}

// Proverava Firebase limits
final canGenerate = await _canGenerateMonthly(userId);
return currentMonthCount < 5; // Dozvoljava samo ako je manje od 5
```

---

## 🎯 Kako Funkcioniše u Produkciji

### **Korisnik bez Premium:**
1. Pokušava da generiše premium analizu
2. `AnalysisTracker.canGenerateAnalysis()` → `false` (nije premium)
3. Prikazuje se poruka da treba premium subscription

### **Korisnik sa Premium (Monthly/Yearly):**
1. Pokušava da generiše premium analizu
2. `AnalysisTracker.canGenerateAnalysis()` → proverava Firebase
3. Ako je `monthlyCounts["2025-12"] < 5` → `true` (može)
4. Ako je `monthlyCounts["2025-12"] >= 5` → `false` (limit dostignut)

### **Korisnik sa Premium (One-Time):**
1. Pokušava da generiše premium analizu
2. `AnalysisTracker.canGenerateAnalysis()` → proverava Firebase
3. Ako je `oneTimeUsed == false` → `true` (može)
4. Ako je `oneTimeUsed == true` → `false` (već iskorišćeno)

---

## ⚠️ VAŽNO: Security Rules

**Ako koristiš RevenueCat User ID (ne Firebase Auth):**

Možda treba da promeniš Security Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /user_analyses/{userId} {
      // Dozvoljava čitanje i pisanje bez auth (jer koristiš RevenueCat User ID)
      allow read, write: if true;
    }
  }
}
```

**ILI ako želiš da budeš sigurniji:**

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /user_analyses/{userId} {
      // Dozvoljava samo ako je userId validan (RevenueCat format)
      allow read, write: if userId.matches('^[a-zA-Z0-9_-]+$');
    }
  }
}
```

---

## 🎯 REZIME

1. **Kada korisnik kupi** → RevenueCat aktivira entitlement
2. **Aplikacija proverava** → `isPremium()` → `true`
3. **Aplikacija proverava limits** → Firebase → `monthlyCounts` ili `oneTimeUsed`
4. **Ako može** → Generiše analizu → Firebase čuva podatke
5. **Ako ne može** → Prikazuje poruku o limit-u

**Sve automatski radi kada isključiš TEST_MODE! 🚀**

---

**Spremno za production! 🎉**

