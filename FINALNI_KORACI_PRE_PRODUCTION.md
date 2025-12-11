# 🚀 Finalni Koraci Pre Production - Step by Step

## 📋 PLAN: 3 Faze Testiranja

1. **FAZA 1:** Testiraj sa TEST_MODE = true (sada)
2. **FAZA 2:** Testiraj sa Sandbox purchase-om (bez TEST_MODE)
3. **FAZA 3:** Isključi TEST_MODE i build za production

---

## ✅ FAZA 1: Testiranje sa TEST_MODE = true (SADA)

### **Cilj:** Proveri da li sve radi (Firebase, UI, funkcionalnost)

### **Korak 1: Proveri da li je TEST_MODE uključen**

1. **Otvori `lib/services/analysis_tracker.dart`**
2. **Proveri:**
   ```dart
   static const bool ENABLE_TEST_MODE = true; // Trebalo bi da je true
   ```

### **Korak 2: Build i Upload IPA**

```bash
cd ~/Documents/myChatEra/ZaMariju
flutter clean
flutter pub get
flutter build ipa --export-options-plist=ios/ExportOptions.plist
```

**Upload u Transporter:**
- Otvori Apple Transporter
- Upload IPA
- Sačekaj da se build procesira (~10-30 min)

### **Korak 3: Testiraj u TestFlight-u**

1. **Instaliraj novi build** preko TestFlight-a
2. **Pokreni aplikaciju**
3. **Idi do premium analize**
4. **Trebalo bi da možeš da generišeš analizu** (bez "monthly limit" poruke)

### **Korak 4: Proveri Firebase**

1. **Firebase Console:**
   - https://console.firebase.google.com/
   - Firestore Database
   - Generiši premium analizu u aplikaciji
   - Proveri da li se kreira dokument u `user_analyses` collection

**Ako vidiš dokument → Firebase radi! ✅**

---

## ✅ FAZA 2: Testiranje sa Sandbox Purchase-om (BEZ TEST_MODE)

### **Cilj:** Proveri da li RevenueCat i purchase flow rade pravilno

### **Korak 1: Isključi TEST_MODE**

1. **Otvori `lib/services/analysis_tracker.dart`**
2. **Promeni:**
   ```dart
   static const bool ENABLE_TEST_MODE = false; // Isključi za Sandbox testiranje
   ```

### **Korak 2: Build Novi IPA**

```bash
cd ~/Documents/myChatEra/ZaMariju
flutter clean
flutter pub get
flutter build ipa --export-options-plist=ios/ExportOptions.plist
```

**Upload u Transporter:**
- Upload novi IPA
- Sačekaj da se build procesira

### **Korak 3: Kreiraj Sandbox Tester Account**

1. **App Store Connect:**
   - https://appstoreconnect.apple.com/
   - Users and Access → Sandbox Testers
   - Klikni "+" → Kreiraj novi account
   - Unesi email i password (može biti fake email)

### **Korak 4: Testiraj Purchase Flow**

1. **U aplikaciji:**
   - Klikni na subscription (npr. Monthly)
   - Apple će tražiti Sandbox account
   - Unesi Sandbox credentials
   - **Klikni "Buy"** (neće naplatiti stvarno!)

2. **Proveri RevenueCat:**
   - RevenueCat Dashboard → Customers
   - Trebalo bi da vidiš korisnika sa premium subscription-om

3. **Proveri Firebase:**
   - Firebase Console → Firestore Database
   - Trebalo bi da vidiš dokument sa user ID-om

4. **Testiraj Limits:**
   - Generiši 5 analiza (monthly limit)
   - Proveri da li se prikazuje "Monthly limit reached"
   - Proveri Firebase da li se broji ispravno

**Ako sve radi → RevenueCat i Firebase rade pravilno! ✅**

---

## ✅ FAZA 3: Production Build (FINALNI)

### **Cilj:** Spremi za App Store release

### **Korak 1: Proveri da li je TEST_MODE isključen**

1. **Otvori `lib/services/analysis_tracker.dart`**
2. **Proveri:**
   ```dart
   static const bool ENABLE_TEST_MODE = false; // MORA biti false za production!
   ```

### **Korak 2: Povećaj Build Number**

1. **Otvori `pubspec.yaml`**
2. **Povećaj build number:**
   ```yaml
   version: 1.0.0+7  # Povećaj broj (npr. +7 ako je poslednji bio +6)
   ```

### **Korak 3: Build Finalni IPA**

```bash
cd ~/Documents/myChatEra/ZaMariju
flutter clean
flutter pub get
flutter build ipa --export-options-plist=ios/ExportOptions.plist
```

### **Korak 4: Upload Finalni IPA**

- Upload u Transporter
- Sačekaj da se build procesira

### **Korak 5: Submit za Review**

1. **App Store Connect:**
   - My Apps → GPT Wrapped → App Store tab
   - Klikni na verziju (1.0.0)
   - Izaberi novi build (1.0.0 (7))
   - Klikni "Submit for Review"

---

## 📋 CHECKLIST

### **FAZA 1: TEST_MODE = true**
- [ ] TEST_MODE je uključen (`ENABLE_TEST_MODE = true`)
- [ ] Build IPA
- [ ] Upload IPA
- [ ] Testiraj u TestFlight-u
- [ ] Proveri Firebase (kreira se dokument)
- [ ] Proveri da li premium features rade

### **FAZA 2: Sandbox Purchase**
- [ ] TEST_MODE je isključen (`ENABLE_TEST_MODE = false`)
- [ ] Build novi IPA
- [ ] Upload novi IPA
- [ ] Kreiraj Sandbox Tester Account
- [ ] Testiraj purchase flow
- [ ] Proveri RevenueCat (korisnik se pojavio)
- [ ] Proveri Firebase (dokument se kreira)
- [ ] Testiraj limits (5 analiza → limit reached)

### **FAZA 3: Production**
- [ ] TEST_MODE je isključen (`ENABLE_TEST_MODE = false`)
- [ ] Build number povećan
- [ ] Build finalni IPA
- [ ] Upload finalni IPA
- [ ] Submit za Review

---

## 🎯 REZIME

### **Sada (FAZA 1):**
- ✅ TEST_MODE = true
- ✅ Build IPA
- ✅ Testiraj da li sve radi

### **Zatim (FAZA 2):**
- ✅ TEST_MODE = false
- ✅ Build novi IPA
- ✅ Testiraj sa Sandbox purchase-om

### **Na kraju (FAZA 3):**
- ✅ TEST_MODE = false
- ✅ Build finalni IPA
- ✅ Submit za Review

---

## ⚠️ VAŽNO

**MORAŠ da napraviš novi IPA build za svaku fazu!**

- **FAZA 1:** Build sa TEST_MODE = true
- **FAZA 2:** Build sa TEST_MODE = false (za Sandbox testiranje)
- **FAZA 3:** Build sa TEST_MODE = false (za production)

**Razlog:** Svaka promena u kodu zahteva novi build!

---

## 🚀 Sledeći Korak

**Počni sa FAZOM 1:**
1. Proveri da li je TEST_MODE = true
2. Build IPA
3. Upload i testiraj

**Javi kada završiš FAZU 1, pa nastavljamo sa FAZOM 2! 🎯**

