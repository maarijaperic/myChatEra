# 🚀 Šta Dalje Posle IPA Build-a - Kompletni Vodič

## 📋 Koraci:

1. **Upload IPA u Transporter** (10-15 min)
2. **Proveri u App Store Connect** (5 min)
3. **Dodaj TestFlight Testera** (5 min)
4. **Testiraj na iPhone-u** (30-45 min)
5. **Vidi Log-ove** (kako da vidiš šta radi)

---

## 📤 PART 1: UPLOAD IPA U TRANSPORTER

### Korak 1.1: Pronađi IPA fajl

```bash
# Proveri da li je IPA kreiran
ls -lh ~/Documents/myChatEra/ZaMariju/build/ios/ipa/*.ipa
```

**Trebalo bi da vidiš:**
```
-rw-r--r--  1 user  staff  51M ... Runner.ipa
```

### Korak 1.2: Otvori Apple Transporter

1. **Otvori Transporter aplikaciju:**
   - Ako nemaš, skini iz App Store: https://apps.apple.com/us/app/transporter/id1450874784

2. **Upload IPA:**
   - Klikni "+" ili "Deliver Your App"
   - Pronađi IPA fajl:
     ```
     ~/Documents/myChatEra/ZaMariju/build/ios/ipa/Runner.ipa
     ```
   - Ili povuci fajl direktno u Transporter prozor
   - Klikni "Deliver"
   - Unesi Apple ID i password (ako traži)
   - Sačekaj da se upload završi (~5-10 min)

3. **Proveri status:**
   - U Transporter-u trebalo bi da vidiš "Delivered successfully"
   - Ako vidiš grešku, proveri da li je bundle ID tačan

---

## 📱 PART 2: PROVERI U APP STORE CONNECT

### Korak 2.1: Proveri Build Status

1. **Otvori App Store Connect:**
   - Idi na: https://appstoreconnect.apple.com/
   - Uloguj se sa Apple ID-om

2. **Proveri build:**
   - Idi na "My Apps" → "GPT Wrapped" (ili kako se zove)
   - Idi na "TestFlight" tab
   - Trebalo bi da vidiš novi build (1.0.0 (2))
   - Status: "Processing" → sačekaj (~10-30 min)
   - Kada je spreman, status će biti "Ready to Test"

---

## 🧪 PART 3: DODAJ TESTFLIGHT TESTERA

### Korak 3.1: Dodaj Testera

1. **U App Store Connect:**
   - Idi na "TestFlight" tab
   - Klikni "Internal Testing" (ili "External Testing")
   - Klikni "+" da dodaš testera
   - Unesi email adresu testera (može biti tvoj email)
   - Klikni "Add"

2. **Dodaj build u testing:**
   - Klikni na build (1.0.0 (2))
   - Klikni "Add to Internal Testing" (ili "Add to External Testing")
   - Sačekaj da se build procesira

3. **Tester će dobiti email:**
   - Email će stići kada je build spreman
   - Email će imati link za TestFlight

---

## 📲 PART 4: INSTALIRAJ I TESTIRAJ NA IPHONE-U

### Korak 4.1: Instaliraj TestFlight App

1. **Na iPhone-u:**
   - Otvori App Store
   - Traži "TestFlight" i instaliraj (ako nemaš)

2. **Otvori TestFlight app:**
   - Otvori TestFlight aplikaciju
   - Prihvati pozivnicu (ako je potrebno)
   - Klikni "Accept" na email pozivnici

3. **Instaliraj aplikaciju:**
   - Trebalo bi da vidiš "GPT Wrapped" u TestFlight
   - Klikni "Install"
   - Sačekaj da se instalira

---

## 🔍 PART 5: KAKO DA VIDIŠ LOG-OVE

### Metoda 1: Xcode Console (Najbolje)

1. **Poveži iPhone sa Mac-om:**
   - Koristi USB kabl
   - Ili WiFi (ako je omogućeno)

2. **Otvori Xcode:**
   ```bash
   open -a Xcode
   ```

3. **Otvori Devices and Simulators:**
   - Window → Devices and Simulators
   - Ili: Cmd + Shift + 2

4. **Izaberi tvoj iPhone:**
   - Klikni na tvoj iPhone u listi

5. **Otvori Console:**
   - Klikni "Open Console"
   - Videćeš sve log-ove u realnom vremenu

6. **Filtriraj log-ove:**
   - U search polju unesi: `Firebase` ili `RevenueCat`
   - Videćeš samo relevantne log-ove

### Metoda 2: TestFlight Logs (Ograničeno)

1. **U TestFlight app-u:**
   - Otvori aplikaciju
   - Klikni na "GPT Wrapped"
   - Scroll dole → "View Crash Logs" (ako ima)

2. **Ograničeno:**
   - TestFlight pokazuje samo crash log-ove
   - Ne pokazuje sve log-ove kao Xcode

### Metoda 3: Flutter Logs (Ako imaš Mac povezan)

1. **Poveži iPhone sa Mac-om:**
   - USB kabl ili WiFi

2. **Pokreni Flutter app:**
   ```bash
   cd ~/Documents/myChatEra/ZaMariju
   flutter run -d [DEVICE_ID]
   ```

3. **Videćeš log-ove u terminalu:**
   - Svi `print()` i `debugPrint()` će se prikazati
   - Firebase i RevenueCat log-ove ćeš videti

---

## ✅ PART 6: ŠTA DA PROVERIŠ U LOG-OVIMA

### Firebase Log-ove:

Traži u log-ovima:
```
✅ Firebase initialized
```

Ako vidiš:
```
❌ Error initializing Firebase: ...
```
- Proveri da li je `GoogleService-Info.plist` u `ios/Runner/` folderu

### RevenueCat Log-ove:

Traži u log-ovima:
```
✅ RevenueCat initialized
```

Ako vidiš:
```
⚠️ RevenueCat API key not set - skipping initialization
```
- Proveri da li je API key dodat u `lib/main.dart`

### AnalysisTracker Log-ove:

Traži u log-ovima:
```
AnalysisTracker: User can generate analysis
```

Ako vidiš:
```
⚠️ AnalysisTracker: Firebase not initialized
```
- Proveri Firebase setup

---

## 🧪 PART 7: TESTIRANJE FUNKCIONALNOSTI

### Test 1: Firebase Firestore

1. **Pokreni aplikaciju**
2. **Idi do premium analize**
3. **Generiši premium analizu**
4. **Proveri u Firebase Console:**
   - Firebase Console → Firestore Database
   - Trebalo bi da vidiš `user_analyses` collection
   - Trebalo bi da vidiš dokument sa user ID-om

### Test 2: RevenueCat Products

1. **Pokreni aplikaciju**
2. **Idi do subscription ekrana**
3. **Proveri da li se prikazuju subscription opcije:**
   - Monthly
   - Yearly
   - Lifetime
4. **Proveri u RevenueCat Dashboard:**
   - RevenueCat Dashboard → Products
   - Proveri da li se products prikazuju

### Test 3: RevenueCat Purchase Flow (Sandbox)

1. **Klikni na subscription (npr. Monthly)**
2. **Apple će tražiti Sandbox account**
3. **VAŽNO:** Ne kupuj stvarno! Klikni "Cancel"
4. **Proveri u RevenueCat Dashboard:**
   - RevenueCat Dashboard → Customers
   - Proveri da li se korisnik pojavio (može potrajati nekoliko minuta)

---

## 📋 CHECKLIST

### Upload:
- [ ] IPA je build-ovan
- [ ] IPA je upload-ovan u Transporter
- [ ] Transporter pokazuje "Delivered successfully"

### App Store Connect:
- [ ] Build je vidljiv u TestFlight tab-u
- [ ] Build status je "Ready to Test" (ne "Processing")

### TestFlight:
- [ ] Tester je dodat
- [ ] Build je dodat u testing
- [ ] Tester je dobio email

### Testiranje:
- [ ] Aplikacija je instalirana preko TestFlight
- [ ] Aplikacija se pokreće bez grešaka
- [ ] Firebase log-ovi su vidljivi (✅ Firebase initialized)
- [ ] RevenueCat log-ovi su vidljivi (✅ RevenueCat initialized)
- [ ] Premium analiza radi
- [ ] Subscription ekran se prikazuje

---

## 🆘 TROUBLESHOOTING

### "Build processing failed"
- Proveri da li je bundle ID tačan (`com.mychatera`)
- Proveri da li je signing certificate validan
- Proveri da li je provisioning profile validan

### "No log-ove vidim"
- Proveri da li je iPhone povezan sa Mac-om
- Proveri da li si otvorio Xcode Console
- Proveri da li aplikacija koristi `print()` za log-ove

### "Firebase not initialized"
- Proveri da li je `GoogleService-Info.plist` u `ios/Runner/` folderu
- Proveri da li je Firebase inicijalizovan u `main.dart`

### "RevenueCat not initialized"
- Proveri da li je API key dodat u `lib/main.dart`
- Proveri da li je API key validan

---

## 🎯 REZIME

1. **Upload IPA:** Transporter → Upload → Deliver
2. **Proveri Build:** App Store Connect → TestFlight → Sačekaj "Ready to Test"
3. **Dodaj Testera:** TestFlight → Internal Testing → Add Tester
4. **Instaliraj:** TestFlight app → Install
5. **Vidi Log-ove:** Xcode → Devices → Console
6. **Testiraj:** Firebase, RevenueCat, Premium features

---

**Srećno sa testiranjem! 🚀**

