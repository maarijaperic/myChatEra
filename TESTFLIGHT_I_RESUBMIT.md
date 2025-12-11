# 🧪 TestFlight Testiranje & Resubmit iOS Aplikacije

## 📋 Šta treba da uradiš?

1. **Build IPA sa novim build number-om**
2. **Upload u TestFlight**
3. **Testiraj Firebase i RevenueCat**
4. **Resubmit za Review**

**Ukupno vreme: 1-2 sata** ✅

---

## 🔨 PART 1: BUILD IPA ZA TESTFLIGHT (10-15 min)

### Korak 1.1: Povećaj Build Number

1. **Otvori `pubspec.yaml`:**
   ```bash
   cd ~/Documents/myChatEra/ZaMariju
   open pubspec.yaml
   ```

2. **Promeni verziju:**
   - Pronađi liniju: `version: 1.0.0+1`
   - Promeni u: `version: 1.0.0+2` (ili veći broj)
   - Sačuvaj fajl

   **Primer:**
   ```yaml
   version: 1.0.0+2  # ← Povećaj broj posle +
   ```

### Korak 1.2: Build IPA

1. **Otvori Terminal i idi u projekat:**
   ```bash
   cd ~/Documents/myChatEra/ZaMariju
   ```

2. **Clean i build:**
   ```bash
   flutter clean
   flutter pub get
   flutter build ipa --export-options-plist=ios/ExportOptions.plist
   ```

3. **Sačekaj da se build završi** (~5-10 min)

4. **Proveri da li je IPA kreiran:**
   ```bash
   ls -lh ~/Documents/myChatEra/ZaMariju/build/ios/ipa/*.ipa
   ```
   
   **Trebalo bi da vidiš nešto kao:**
   ```
   -rw-r--r--  1 user  staff  51M ... Runner.ipa
   ```

---

## 📤 PART 2: UPLOAD U TESTFLIGHT (10-15 min)

### Korak 2.1: Instaliraj Apple Transporter (ako nemaš)

1. **Skini Apple Transporter:**
   - Otvori App Store na Mac-u
   - Traži "Transporter"
   - Ili idi na: https://apps.apple.com/us/app/transporter/id1450874784
   - Instaliraj aplikaciju

### Korak 2.2: Upload IPA

1. **Otvori Apple Transporter:**
   - Otvori aplikaciju "Transporter"

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

### Korak 2.3: Proveri u App Store Connect

1. **Otvori App Store Connect:**
   - Idi na: https://appstoreconnect.apple.com/
   - Uloguj se sa Apple ID-om

2. **Proveri build:**
   - Idi na "My Apps" → "GPT Wrapped"
   - Idi na "TestFlight" tab
   - Trebalo bi da vidiš novi build (1.0.0 (2))
   - Status: "Processing" → sačekaj (~10-30 min)
   - Kada je spreman, status će biti "Ready to Test"

---

## 🧪 PART 3: TESTIRANJE U TESTFLIGHT (30-45 min)

### Korak 3.1: Dodaj TestFlight Testera

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

### Korak 3.2: Instaliraj aplikaciju preko TestFlight

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

### Korak 3.3: Testiraj Firebase

1. **Pokreni aplikaciju:**
   - Otvori aplikaciju iz TestFlight-a
   - Proveri da li se aplikacija pokreće bez grešaka

2. **Proveri Firebase log-ove:**
   - Ako imaš Mac povezan sa iPhone-om:
     - Otvori Xcode
     - Window → Devices and Simulators
     - Izaberi tvoj iPhone
     - Klikni "Open Console"
     - Trebalo bi da vidiš:
       ```
       ✅ Firebase initialized
       ```

3. **Testiraj Firestore:**
   - Idi do premium analize u aplikaciji
   - Generiši premium analizu
   - U Firebase Console → Firestore Database:
     - Trebalo bi da vidiš `user_analyses` collection
     - Trebalo bi da vidiš dokument sa user ID-om

### Korak 3.4: Testiraj RevenueCat

1. **Proveri RevenueCat log-ove:**
   - U Xcode Console (ako imaš Mac):
     - Trebalo bi da vidiš:
       ```
       ✅ RevenueCat initialized
       ```

2. **Testiraj Products:**
   - Idi do subscription ekrana u aplikaciji
   - Proveri da li se prikazuju subscription opcije:
     - Monthly
     - Yearly
     - Lifetime (ako imaš)
   - U RevenueCat Dashboard → Products:
     - Proveri da li se products prikazuju

3. **Testiraj Purchase Flow (Sandbox):**
   - Klikni na subscription (npr. Monthly)
   - Apple će tražiti Sandbox account
   - **VAŽNO:** Ne kupuj stvarno! Klikni "Cancel"
   - U RevenueCat Dashboard → Customers:
     - Proveri da li se korisnik pojavio (može potrajati nekoliko minuta)

### Korak 3.5: Test Checklist

- [ ] Aplikacija se pokreće bez grešaka
- [ ] Firebase je inicijalizovan (log: ✅ Firebase initialized)
- [ ] RevenueCat je inicijalizovan (log: ✅ RevenueCat initialized)
- [ ] Firestore - proveri da li se kreiraju dokumenti
- [ ] RevenueCat Products - proveri da li se prikazuju opcije
- [ ] RevenueCat Customers - proveri da li se korisnici vide

---

## 📤 PART 4: RESUBMIT ZA REVIEW (15-30 min)

### Korak 4.1: Finalni Build za Resubmit

1. **Povećaj build number ponovo:**
   - Otvori `pubspec.yaml`
   - Promeni `version: 1.0.0+2` u `version: 1.0.0+3` (ili veći)
   - Sačuvaj fajl

2. **Build IPA:**
   ```bash
   cd ~/Documents/myChatEra/ZaMariju
   flutter clean
   flutter pub get
   flutter build ipa --export-options-plist=ios/ExportOptions.plist
   ```

3. **Proveri IPA:**
   ```bash
   ls -lh ~/Documents/myChatEra/ZaMariju/build/ios/ipa/*.ipa
   ```

### Korak 4.2: Upload IPA za Resubmit

1. **Upload IPA:**
   - Otvori Apple Transporter
   - Upload novi IPA fajl (1.0.0+3)
   - Sačekaj da se upload završi

2. **Proveri u App Store Connect:**
   - Idi na "My Apps" → "GPT Wrapped"
   - Idi na "App Store" tab
   - Trebalo bi da vidiš novi build (1.0.0 (3))

### Korak 4.3: Submit za Review

1. **U App Store Connect:**
   - Idi na "App Store" tab
   - Klikni na verziju (1.0.0)
   - Klikni "Submit for Review"

2. **Proveri sve sekcije:**
   - ✅ **App Information** - Proveri da li je sve popunjeno
   - ✅ **Pricing and Availability** - Proveri cenu
   - ✅ **App Privacy** - Proveri privacy informacije
   - ✅ **Version Information** - Proveri verziju i build
   - ✅ **Age Rating** - Proveri age rating
   - ✅ **App Review Information** - Proveri review notes
   - ✅ **Content Rights** - Proveri content rights

3. **Submit:**
   - Klikni "Submit for Review"
   - Sačekaj potvrdu
   - Status će biti "Waiting for Review"

### Korak 4.4: Proveri Status

1. **U App Store Connect:**
   - Idi na "App Store" tab
   - Proveri status aplikacije:
     - "Waiting for Review" - čeka review
     - "In Review" - u procesu review-a
     - "Ready for Sale" - odobreno! 🎉

2. **Sačekaj review:**
   - Apple obično review-uje za 24-48 sati
   - Možeš proveriti status u App Store Connect

---

## ✅ FINALNI CHECKLIST

### Pre TestFlight:
- [ ] Build number je povećan (`1.0.0+2`)
- [ ] IPA je build-ovan
- [ ] IPA je upload-ovan u Transporter
- [ ] Build je procesiran u App Store Connect

### TestFlight Testiranje:
- [ ] Tester je dodat
- [ ] Aplikacija je instalirana preko TestFlight
- [ ] Firebase je testiran
- [ ] RevenueCat je testiran
- [ ] Sve radi kako treba

### Pre Resubmit:
- [ ] Build number je povećan (`1.0.0+3`)
- [ ] IPA je build-ovan
- [ ] IPA je upload-ovan u Transporter
- [ ] Sve sekcije su proverene u App Store Connect

### Resubmit:
- [ ] Submit for Review je kliknut
- [ ] Status je "Waiting for Review"
- [ ] Sačekaj Apple review

---

## 🆘 TROUBLESHOOTING

### "Build processing failed" u TestFlight
- Proveri da li je bundle ID tačan (`com.mychatera`)
- Proveri da li je signing certificate validan
- Proveri da li je provisioning profile validan
- Proveri da li je IPA upload-ovan uspešno

### "Invalid Bundle" greška
- Proveri da li je `GoogleService-Info.plist` dodat u Xcode
- Proveri da li su svi fajlovi u projektu
- Proveri da li je build number povećan

### TestFlight ne prikazuje aplikaciju
- Proveri da li je build procesiran (može potrajati 10-30 min)
- Proveri da li je tester dodat
- Proveri da li je build dodat u testing

### "Submit for Review" ne radi
- Proveri da li su sve sekcije popunjene
- Proveri da li je build dodat u verziju
- Proveri da li su svi required fajlovi upload-ovani

---

## 📞 POMOĆ

Ako imaš problema:
1. Proveri log-ove u Xcode Console
2. Proveri Firebase Console → Firestore Database
3. Proveri RevenueCat Dashboard → Customers
4. Proveri App Store Connect → TestFlight status

---

**Srećno sa testiranjem i resubmit-om! 🚀📱**

