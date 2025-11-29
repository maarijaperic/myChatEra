# 💰 RevenueCat Pricing & Objava Aplikacije - Kompletan Vodič

## 🔄 PRAVILAN REDOSLED - ŠTA PRVO, ŠTA POSLE?

### ✅ **NAJBOLJI REDOSLED:**

1. **PRVO: Google Play Console + App Store Connect** 
   - Kreiraj Developer account-e ($25 + $99)
   - Kreiraj aplikaciju u oba store-a
   - **KREIRAJ PROIZVODE (Products)** u store-ovima
   - ⚠️ **VAŽNO:** Proizvodi moraju da postoje u store-ovima pre nego što ih RevenueCat može da detektuje!

2. **DRUGO: RevenueCat Setup**
   - Kreiraj RevenueCat account (besplatno)
   - Kreiraj projekat u RevenueCat-u
   - **POVEŽI** Google Play Console sa RevenueCat-om
   - **POVEŽI** App Store Connect sa RevenueCat-om
   - RevenueCat će **AUTOMATSKI DETEKTOVATI** proizvode koje si kreirao u store-ovima
   - Kreiraj Entitlements i attach-uj ih na proizvode

3. **TREĆE: Flutter Kod**
   - Dodaj RevenueCat API keys u kod
   - Implementiraj PaymentService
   - Testiraj purchase flow

**Zašto ovaj redosled?**
- RevenueCat **čita** proizvode iz Google Play/App Store
- Ne može da detektuje proizvode koji ne postoje
- Lakše je: prvo kreiraš proizvode, pa ih RevenueCat automatski vidi

**Mogu li da radim paralelno?**
- ✅ Možeš da kreiraš RevenueCat account i projekat pre nego što kreiraš proizvode u store-ovima
- ❌ Ali **ne možeš** da povežeš store-ove sa RevenueCat-om dok proizvodi ne postoje
- ✅ Najbolje: prvo sve proizvode u store-ovima, pa onda RevenueCat connection

---

## 📊 REVENUECAT PRICING - DA LI SE PLAĆA?

### ✅ **BESPLATNO za početak!**

**RevenueCat Pro Plan (Besplatno):**
- ✅ **$0 za aplikacije do $2,500 mesečnog prihoda (MTR)**
- ✅ **Sve osnovne funkcionalnosti uključene:**
  - Native paywalls
  - A/B testing (Experiments)
  - Analytics i dashboard
  - Entitlements management
  - Webhooks
  - Cross-platform support (Android + iOS)
  - Customer support
  - Receipt validation
  - Subscription management

**Nakon $2,500/mesečno:**
- 💰 **1% od ukupnog mesečnog prihoda** (MTR)
- Primer: Ako zaradiš $3,000/mesečno → plaćaš $30/mesečno (1% od $3,000)
- Primer: Ako zaradiš $10,000/mesečno → plaćaš $100/mesečno (1% od $10,000)

**Šta to znači za tebe:**
- ✅ Ako imaš **0-250 premium korisnika/mesec** (po $9.99 one-time) → **BESPLATNO**
- ✅ Ako imaš **~250 monthly subscriptions** (po $4.99) → **BESPLATNO**
- ✅ Ako zaradiš više od $2,500 → plaćaš samo 1% (što je jako malo)

**Zaključak:** RevenueCat je **BESPLATAN** dok ne zaradiš ozbiljne pare! 🎉

---

## 📱 KORACI ZA OBJAVU APLIKACIJE - DETALJNO

### **FAZA 1: PRIprema Pre Objave (1-2 dana)**

#### 1.1 Finalizuj Aplikaciju ✅
- [ ] Testiraj sve funkcionalnosti
- [ ] Testiraj RevenueCat integraciju
- [ ] Ukloni sve debug print-ove
- [ ] Optimizuj performance
- [ ] Testiraj na različitim uređajima (Android + iOS)
- [ ] Proveri da li svi ekrani rade kako treba

#### 1.2 Pripremi Assets (Ikone, Screenshotovi, itd.)
**Za Google Play:**
- [ ] App ikona (512x512 PNG)
- [ ] Feature graphic (1024x500 PNG)
- [ ] Screenshotovi (minimum 2, preporučeno 4-8):
  - Phone: 16:9 ili 9:16, minimum 320px, maksimum 3840px
  - Tablet: minimum 320px, maksimum 3840px
- [ ] Promo video (opciono, do 2GB)

**Za App Store:**
- [ ] App ikona (1024x1024 PNG, bez alpha channel)
- [ ] Screenshotovi za sve podržane iPhone/iPad veličine:
  - iPhone 6.7" (1290x2796)
  - iPhone 6.5" (1284x2778)
  - iPhone 5.5" (1242x2208)
  - iPad Pro (2048x2732)
- [ ] App preview video (opciono, 15-30 sekundi)

#### 1.3 Pripremi Tekstualne Materijale
**Za oba store-a:**
- [ ] App naziv (max 30 karaktera za Google Play, 30 za App Store)
- [ ] Kratak opis (max 80 karaktera za Google Play, subtitle za App Store)
- [ ] Puni opis (max 4000 karaktera)
- [ ] Keywords/Keywords (Google Play: max 4000 karaktera, App Store: do 100 karaktera)
- [ ] Privacy Policy URL (obavezno!)
- [ ] Support URL (opciono ali preporučeno)
- [ ] Marketing URL (opciono)

#### 1.4 Pripremi Privacy Policy
**Obavezno mora da sadrži:**
- [ ] Koje podatke prikupljaš (ChatGPT conversations)
- [ ] Kako koristiš podatke (analiza, AI processing)
- [ ] Da li deliš podatke sa trećim stranama (OpenAI, RevenueCat)
- [ ] Kako čuvaš podatke (lokalno na telefonu)
- [ ] Kako korisnici mogu obrisati podatke
- [ ] Kontakt informacije

**Gde da hostuješ Privacy Policy:**
- Besplatno: GitHub Pages, Notion (public page), Google Sites
- Plaćeno: Tvoja web stranica

---

### **FAZA 2: GOOGLE PLAY CONSOLE SETUP (1 dan)**

#### 2.1 Kreiraj Google Play Developer Account
- [ ] Idi na [play.google.com/console](https://play.google.com/console)
- [ ] Plati jednokratnu registraciju: **$25** (jednokratno, nikad više!)
- [ ] Popuni developer profil:
  - Ime i prezime
  - Email
  - Telefon
  - Adresa
  - Payment info (za isplatu zarade)

#### 2.2 Kreiraj Aplikaciju u Google Play Console
- [ ] Klikni "Create app"
- [ ] Unesi:
  - App naziv: "GPT Wrapped" (ili tvoj izbor)
  - Default language: English
  - App type: App
  - Free ili Paid: Free (sa in-app purchases)

#### 2.3 Konfiguriši App Content
- [ ] **Privacy Policy:**
  - Idi na "Policy" → "Privacy Policy"
  - Unesi URL tvoje Privacy Policy (obavezno!)
  
- [ ] **Content Rating:**
  - Idi na "Content rating"
  - Popuni formular (kategorija, sadržaj, itd.)
  - Čekaš na odobrenje (obično 1-2 dana)

- [ ] **Target Audience:**
  - Idi na "Target audience"
  - Izaberi starosnu grupu

#### 2.4 Kreiraj Monetization (RevenueCat Products)
- [ ] Idi na "Monetize" → "Products" → "Subscriptions"
- [ ] Kreiraj 3 subscription proizvoda:

**Proizvod 1: Monthly Subscription**
- Product ID: `monthly_subscription`
- Naziv: "Monthly Premium"
- Opis: "Monthly access to all premium insights"
- Billing period: Monthly
- Price: $4.99 (ili lokalna cena)
- Free trial: None (ili 3 dana ako želiš)
- Grace period: 3 dana (ako korisnik ne plati, ima 3 dana)
- **SAVE!**

**Proizvod 2: Yearly Subscription**
- Product ID: `yearly_subscription`
- Naziv: "Yearly Premium"
- Opis: "Yearly access to all premium insights - Best Value!"
- Billing period: Yearly
- Price: $19.99
- Free trial: None (ili 7 dana ako želiš)
- **SAVE!**

**Proizvod 3: One-Time Purchase**
- Product ID: `one_time_purchase`
- Naziv: "Lifetime Premium"
- Opis: "Lifetime access to all premium insights"
- Product type: One-time product (ne subscription!)
- Price: $9.99
- **SAVE!**

⚠️ **VAŽNO:** 
- Proizvodi moraju biti aktivni pre nego što ih RevenueCat može da detektuje
- Status će biti "Draft" dok ne objaviš app (to je OK)

#### 2.5 Pripremi Store Listing
- [ ] Idi na "Store presence" → "Main store listing"
- [ ] Unesi:
  - App naziv
  - Kratak opis (80 karaktera)
  - Puni opis (4000 karaktera)
  - App ikona
  - Feature graphic
  - Screenshotovi
  - Promo video (opciono)
  - Kategorija: Lifestyle / Entertainment
  - Kontakt informacije

#### 2.6 Pripremi Release (Beta Testing)
- [ ] Idi na "Release" → "Production"
- [ ] Kreiraj novi release:
  - Upload AAB fajl (Android App Bundle)
  - Release notes: "Initial release" ili opiš šta je novo
- [ ] **SAVE (ali ne objavljuj još!)**

#### 2.7 Generiši AAB Fajl
```bash
# U terminalu:
cd ZaMariju
flutter build appbundle --release
```
- [ ] AAB fajl će biti u: `build/app/outputs/bundle/release/app-release.aab`
- [ ] Upload-uj ovaj fajl u Google Play Console

#### 2.8 Proveri Sve Pre Objave
- [ ] App content rating odobren?
- [ ] Privacy policy dodata?
- [ ] Product ID-ovi se poklapaju sa kodom?
- [ ] Screenshotovi i ikone dodati?
- [ ] Tekstovi su bez grešaka?
- [ ] AAB fajl upload-ovan?

#### 2.9 Objavi Aplikaciju
- [ ] Klikni "Review release"
- [ ] Pročitaj sve provere
- [ ] Ako sve prođe → klikni "Start rollout to Production"
- [ ] **Čekaš review (1-7 dana, obično 1-3 dana)**

---

### **FAZA 3: APP STORE CONNECT SETUP (1-2 dana)**

#### 3.1 Kreiraj Apple Developer Account
- [ ] Idi na [developer.apple.com](https://developer.apple.com)
- [ ] Registruj se (ili login ako već imaš nalog)
- [ ] Plati godišnju članarinu: **$99/godinu** (ponavlja se svake godine)
- [ ] Verifikuj nalog (email, telefon)

#### 3.2 Kreiraj App ID
- [ ] Idi na "Certificates, Identifiers & Profiles"
- [ ] "Identifiers" → "+" → "App IDs"
- [ ] Izaberi "App"
- [ ] Unesi:
  - Description: "GPT Wrapped"
  - Bundle ID: `com.yourname.gptwrapped` (mora biti unique!)
- [ ] Uključi "In-App Purchase" capability
- [ ] **REGISTER**

#### 3.3 Kreiraj In-App Purchase Products
- [ ] Idi na "App Store Connect" → [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
- [ ] Kreiraj novu aplikaciju:
  - Bundle ID: isti kao u koraku 3.2
  - App naziv: "GPT Wrapped"
  - Primary language: English
  - SKU: unique identifier

- [ ] Idi u "Features" → "In-App Purchases"
- [ ] Kreiraj 3 proizvoda:

**Proizvod 1: Auto-Renewable Subscription (Monthly)**
- Type: Auto-Renewable Subscription
- Reference name: "Monthly Premium"
- Product ID: `monthly_subscription`
- Subscription group: Create new group "Premium"
- Duration: 1 Month
- Price: $4.99
- Display name: "Monthly Premium"
- Description: "Monthly access to all premium insights"
- Review screenshot (opciono)

**Proizvod 2: Auto-Renewable Subscription (Yearly)**
- Type: Auto-Renewable Subscription
- Reference name: "Yearly Premium"
- Product ID: `yearly_subscription`
- Subscription group: "Premium" (isti kao monthly)
- Duration: 1 Year
- Price: $19.99
- Display name: "Yearly Premium - Best Value"
- Description: "Yearly access to all premium insights - Save 67%!"

**Proizvod 3: Non-Consumable (One-Time)**
- Type: Non-Consumable
- Reference name: "Lifetime Premium"
- Product ID: `one_time_purchase`
- Price: $9.99
- Display name: "Lifetime Premium"
- Description: "Lifetime access to all premium insights"

⚠️ **VAŽNO:**
- Status će biti "Ready to Submit" nakon što dodáš sve podatke
- Proizvodi moraju biti odobreni zajedno sa aplikacijom

#### 3.4 Pripremi App Store Listing
- [ ] Idi u "App Information"
- [ ] Unesi:
  - Name: "GPT Wrapped"
  - Subtitle: "AI Personality Insights" (max 30 karaktera)
  - Category: Lifestyle ili Entertainment
  - Content Rights: Da li imaš prava na sadržaj
  - Age rating: Popuni formular

- [ ] Idi u "Pricing and Availability"
- [ ] Izaberi cenu: Free (sa in-app purchases)
- [ ] Izaberi dostupne zemlje (ili sve)

- [ ] Idi u "1.0 Prepare for Submission"
- [ ] Screenshotovi za sve potrebne veličine
- [ ] App ikona (1024x1024)
- [ ] Description (max 4000 karaktera)
- [ ] Keywords (max 100 karaktera, odvojeni zarezima)
- [ ] Support URL
- [ ] Marketing URL (opciono)
- [ ] Privacy Policy URL (obavezno!)

#### 3.5 Build i Upload IPA Fajl
**Korak 1: Pripremi za iOS build**
```bash
cd ZaMariju
flutter build ios --release
```

**Korak 2: Otvori Xcode**
- [ ] Otvori `ios/Runner.xcworkspace` u Xcode-u
- [ ] Izaberi "Any iOS Device" kao build target
- [ ] Product → Archive
- [ ] Čekaš da se archive završi

**Korak 3: Upload u App Store Connect**
- [ ] U Xcode: Window → Organizer
- [ ] Izaberi archive
- [ ] Klikni "Distribute App"
- [ ] Izaberi "App Store Connect"
- [ ] Follow wizard → upload

**Alternativa: Koristi Flutter build ipa**
```bash
flutter build ipa --release
# IPA će biti u: build/ios/ipa/
# Upload-uj preko Xcode Organizer ili Transporter app
```

#### 3.6 Submit za Review
- [ ] U App Store Connect, idi u "1.0 Prepare for Submission"
- [ ] Build: Izaberi upload-ovani build
- [ ] Export Compliance: Odgovori na pitanja (obično "No" za AI apps)
- [ ] Advertising Identifier: Da li koristiš ads? (ako ne → "No")
- [ ] Content Rights: Potvrdi da imaš prava
- [ ] Klikni "Submit for Review"
- [ ] **Čekaš review (1-7 dana, obično 2-5 dana)**

---

### **FAZA 4: REVENUECAT SETUP (30-60 min)**

#### 4.1 Kreiraj RevenueCat Account
- [ ] Idi na [app.revenuecat.com](https://app.revenuecat.com)
- [ ] Registruj se (besplatno, ne treba credit card za početak)
- [ ] Potvrdi email

#### 4.2 Kreiraj Novi Projekat
- [ ] Klikni "New Project"
- [ ] Ime projekta: "GPT Wrapped"
- [ ] Platforme: Android + iOS

#### 4.3 Poveži Google Play Console
- [ ] Idi u "Integrations" → "Google Play"
- [ ] Klikni "Connect"
- [ ] Autorizuj RevenueCat pristup Google Play Console
- [ ] RevenueCat će automatski detektovati tvoje subscription proizvode
- [ ] Proveri da li su se pojavili:
  - `monthly_subscription`
  - `yearly_subscription`
  - `one_time_purchase`

#### 4.4 Poveži App Store Connect
- [ ] Idi u "Integrations" → "App Store"
- [ ] Klikni "Connect"
- [ ] Autorizuj RevenueCat pristup App Store Connect
- [ ] RevenueCat će automatski detektovati tvoje in-app purchase proizvode
- [ ] Proveri da li su se pojavili svi proizvodi

#### 4.5 Kreiraj Entitlements
- [ ] Idi u "Entitlements"
- [ ] Kreiraj 3 entitlement-a:

**Entitlement 1: Premium Monthly**
- Identifier: `premium_monthly`
- Attach products: `monthly_subscription` (Android + iOS)

**Entitlement 2: Premium Yearly**
- Identifier: `premium_yearly`
- Attach products: `yearly_subscription` (Android + iOS)

**Entitlement 3: Premium Lifetime**
- Identifier: `premium_lifetime`
- Attach products: `one_time_purchase` (Android + iOS)

#### 4.6 Dobij API Keys
- [ ] Idi u "API Keys"
- [ ] Kopiraj:
  - **Public SDK Key** (koristi u kodu)
  - **Apple App Store API Key** (za iOS)
  - **Google Play API Key** (za Android)

⚠️ **VAŽNO:** Ovi ključevi se koriste u `PaymentService.initialize()` u tvom Flutter kodu!

---

### **FAZA 5: TESTIRANJE (1-2 dana)**

#### 5.1 Test na Google Play (Internal Testing)
- [ ] U Google Play Console: "Testing" → "Internal testing"
- [ ] Kreiraj release sa test AAB fajlom
- [ ] Dodaj sebe kao tester (email)
- [ ] Download-uj aplikaciju sa Google Play (test verzija)
- [ ] Testiraj:
  - [ ] Da li se app pokreće
  - [ ] Da li RevenueCat radi
  - [ ] Da li se subscription proizvodi prikazuju
  - [ ] Da li se može kupiti (test purchase)
  - [ ] Da li se premium status proverava

#### 5.2 Test na App Store (TestFlight)
- [ ] U App Store Connect: "TestFlight"
- [ ] Dodaj build koji si upload-ovao
- [ ] Čekaj da se build procesira (10-30 min)
- [ ] Dodaj sebe kao Internal Tester
- [ ] Install TestFlight app na iPhone
- [ ] Download GPT Wrapped preko TestFlight
- [ ] Testiraj:
  - [ ] Da li se app pokreće
  - [ ] Da li RevenueCat radi
  - [ ] Da li se in-app purchases prikazuju
  - [ ] Da li se može kupiti (sandbox test account)

#### 5.3 RevenueCat Sandbox Test
- [ ] U RevenueCat dashboard: "Test Mode"
- [ ] Kreiraj test korisnike
- [ ] Simuliraj purchase-e
- [ ] Proveri da li se entitlements pravilno dodeljuju

---

### **FAZA 6: OBJAVA (Čekaš Review)**

#### 6.1 Google Play
- [ ] Pošalji app u review
- [ ] Čekaš 1-7 dana (obično 1-3 dana)
- [ ] Ako odobre → app je objavljen! 🎉
- [ ] Ako odbiju → popravi greške i pošalji ponovo

#### 6.2 App Store
- [ ] Pošalji app u review
- [ ] Čekaš 1-7 dana (obično 2-5 dana)
- [ ] Ako odobre → app je objavljen! 🎉
- [ ] Ako odbiju → popravi greške i pošalji ponovo

---

## 💰 UKUPNI TROŠKOVI

### **Jednokratni troškovi:**
- Google Play Developer: **$25** (jednokratno)
- App Store Developer: **$99** (godišnje)
- **Ukupno prva godina: $124**
- **Ukupno nakon prve godine: $99/godinu** (samo App Store)

### **Recurring troškovi:**
- RevenueCat: **$0** dok ne zaradiš $2,500/mesečno
- Nakon $2,500/mesečno: **1% od prihoda**

**Primer:**
- Ako zaradiš $3,000/mesečno → RevenueCat: $30/mesečno
- Ako zaradiš $10,000/mesečno → RevenueCat: $100/mesečno
- Ako zaradiš $50,000/mesečno → RevenueCat: $500/mesečno

---

## 📋 CHECKLIST PRE OBJAVE

### **Kod:**
- [ ] RevenueCat integracija implementirana
- [ ] PaymentService klasa funkcioniše
- [ ] Premium storage radi
- [ ] Access control implementiran
- [ ] Restore purchases funkcioniše
- [ ] Error handling je dobar
- [ ] Debug print-ovi uklonjeni

### **Assets:**
- [ ] App ikona (Android + iOS)
- [ ] Screenshotovi za sve veličine
- [ ] Feature graphic (Google Play)
- [ ] Privacy Policy URL

### **Store Listings:**
- [ ] App naziv
- [ ] Opisi (kratak + puni)
- [ ] Keywords
- [ ] Kategorije
- [ ] Kontakt informacije

### **Products:**
- [ ] 3 proizvoda kreirana u Google Play Console
- [ ] 3 proizvoda kreirana u App Store Connect
- [ ] Product ID-ovi se poklapaju sa kodom
- [ ] Cene su postavljene

### **RevenueCat:**
- [ ] Account kreiran
- [ ] Projekat kreiran
- [ ] Google Play povezan
- [ ] App Store povezan
- [ ] Entitlements kreirani
- [ ] API keys kopirani u kod

### **Testing:**
- [ ] Testirano na Android (Internal Testing)
- [ ] Testirano na iOS (TestFlight)
- [ ] Test purchase funkcioniše
- [ ] Restore purchases funkcioniše

---

## 🚀 TIMELINE - KOLIKO VREMENA TREBA?

### **Optimističan scenario (sve ide brzo):**
- Setup Google Play: **4-6 sati**
- Setup App Store: **6-8 sati**
- RevenueCat setup: **1 sat**
- Testing: **2-4 sata**
- **Ukupno aktivno rada: 13-19 sati (1.5-2.5 dana)**
- **Čekaš review: 2-7 dana**

### **Realističan scenario (sa problemima):**
- Setup Google Play: **1 dan**
- Setup App Store: **1-2 dana**
- RevenueCat setup: **2-3 sata**
- Testing: **1 dan**
- **Ukupno aktivno rada: 3-4 dana**
- **Čekaš review: 3-10 dana**

### **Ukupno vreme do objave:**
- **Minimum: 5-7 dana** (ako sve ide brzo)
- **Realno: 7-14 dana** (sa čekanjem na review)

---

## ⚠️ ČESTE GREŠKE I KAKO IZBEGNUTI

### **1. Product ID-ovi se ne poklapaju**
- **Problem:** Product ID u kodu ≠ Product ID u store-u
- **Rešenje:** Proveri da su identični (case-sensitive!)

### **2. RevenueCat ne detektuje proizvode**
- **Problem:** Proizvodi nisu aktivni u store-u
- **Rešenje:** Proveri status u Google Play Console / App Store Connect

### **3. App Store odbija zbog Privacy Policy**
- **Problem:** Privacy Policy nedostaje ili je nepotpuna
- **Rešenje:** Obavezno dodaj Privacy Policy URL!

### **4. Google Play odbija zbog Content Rating**
- **Problem:** Content rating nije odobren
- **Rešenje:** Popuni formular i sačekaj odobrenje (1-2 dana)

### **5. Build ne prolazi review**
- **Problem:** App crash-uje ili ima bug-ove
- **Rešenje:** Testiraj dobro pre nego što pošalješ!

---

## 📞 PODRŠKA I RESURSI

### **RevenueCat:**
- Dokumentacija: [docs.revenuecat.com](https://docs.revenuecat.com)
- Support: [support.revenuecat.com](https://support.revenuecat.com)
- Discord community: [discord.gg/revenuecat](https://discord.gg/revenuecat)

### **Google Play:**
- Dokumentacija: [developer.android.com/distribute](https://developer.android.com/distribute)
- Support: Google Play Console → Help

### **App Store:**
- Dokumentacija: [developer.apple.com/app-store](https://developer.apple.com/app-store)
- Support: App Store Connect → Help

---

## ✅ FINALNI CHECKLIST

Pre nego što klikneš "Submit for Review", proveri:

- [ ] **Kod:**
  - [ ] RevenueCat inicijalizovan sa pravim API key-om
  - [ ] Product ID-ovi se poklapaju sa store-ovima
  - [ ] Error handling je dobar
  - [ ] Debug kod je uklonjen

- [ ] **Store Setup:**
  - [ ] Privacy Policy URL dodat
  - [ ] Content rating odobren
  - [ ] Products su kreirani i aktivni
  - [ ] Screenshotovi i ikone dodati
  - [ ] Opisi su bez grešaka

- [ ] **RevenueCat:**
  - [ ] Projekat kreiran
  - [ ] Store-ovi povezani
  - [ ] Entitlements kreirani
  - [ ] Products su attached na entitlements

- [ ] **Testing:**
  - [ ] Testirano na Android
  - [ ] Testirano na iOS
  - [ ] Purchase flow radi
  - [ ] Restore purchases radi

**Sve provereno? → SUBMIT! 🚀**

---

## 🎉 NAKON OBJAVE

### **Šta da radiš nakon što objaviš:**

1. **Monitoriraj:**
   - Downloads
   - Revenue (Google Play Console / App Store Connect)
   - Reviews i ratings
   - Crash reports

2. **Odgovaraj na reviews:**
   - Google Play: Možeš odgovoriti direktno
   - App Store: Možeš odgovoriti na reviews

3. **Ažuriraj:**
   - Bug fixes
   - Nove funkcionalnosti
   - Optimizacija

4. **Marketiraj:**
   - Social media
   - Influencer collaborations
   - Paid ads (ako imaš budžet)

---

**Srećno sa objavom! 🚀🎉**
