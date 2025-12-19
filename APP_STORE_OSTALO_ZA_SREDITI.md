# 📋 ŠTA JOŠ OSTAJE ZA APP STORE - Kompletna Checklista

## 🎯 Pregled: Šta je već sredjeno vs. šta ostaje

### ✅ VEĆ SREDJENO (od mene):
- [x] IAP lokalizacije (Display Name i Description)
- [x] Subscription Group Display Name preporuke
- [x] Koraci za slanje binary-ja sa IAP-ovima
- [x] Firebase setup (GoogleService-Info.plist)
- [x] RevenueCat setup (Products, Entitlements)

### ⚠️ OSTAJE DA SREDIŠ (proveri svaki!):

---

## 1️⃣ APP INFORMATION (Osnovne informacije)

**Putanja:** App Store Connect → My Apps → Tvoja App → App Information

### Proveri da li su popunjeni:

- [ ] **Name:** Naziv aplikacije (npr. "MyChatEra AI" ili "GPT Wrapped")
- [ ] **Subtitle:** (Opciono, max 30 karaktera) - kratak opis
- [ ] **Primary Language:** English (ili Srpski ako je tvoj izbor)
- [ ] **Bundle ID:** `com.mychatera` (trebao bi da je već postavljen)
- [ ] **SKU:** Unique identifier (npr. "GPT-Wrapped-001")
- [ ] **Category:**
  - [ ] Primary Category (npr. Lifestyle, Entertainment, Utilities)
  - [ ] Secondary Category (opciono)
- [ ] **Content Rights:** Potvrdi da imaš prava na sadržaj

**Kako proveriti:**
1. Idi na App Store Connect → My Apps → Tvoja App
2. Klikni na "App Information" u levom meniju
3. Proveri da li su sva polja popunjena

---

## 2️⃣ PRICING AND AVAILABILITY

**Putanja:** App Store Connect → My Apps → Tvoja App → Pricing and Availability

### Proveri:

- [ ] **Price:** Free (jer koristiš in-app purchases)
- [ ] **Availability:** 
  - [ ] Sve zemlje (ili odaberi specifične)
- [ ] **Subscription Groups:** (ako su tamo navedene) - proveri status

**Kako proveriti:**
1. Idi na "Pricing and Availability"
2. Proveri da je cena postavljena na "Free"
3. Proveri da su zemlje izabrane

---

## 3️⃣ APP PRIVACY ⚠️ OBAVEZNO!

**Putanja:** App Store Connect → My Apps → Tvoja App → App Privacy

### Ovo je KRITIČNO - Apple zahteva detaljne privacy informacije!

- [ ] **Data Types Collected:**
  - [ ] User Content (Chat conversations) - Da li sakupljaš?
  - [ ] Usage Data (Analytics) - Da li koristiš analytics?
  - [ ] Diagnostics - Da li sakupljaš crash logs?
  - [ ] Identifiers - Da li sakupljaš user ID-eve?
  
- [ ] **Za svaki tip podataka, navedi:**
  - [ ] Da li se povezuje sa korisnikom? (Data Linked to User)
  - [ ] Da li se koristi za tracking? (Data Used to Track You)
  - [ ] Svrha sakupljanja (npr. App Functionality, Analytics, itd.)

- [ ] **Privacy Policy URL:** ⚠️ **MORA postojati!**
  - [ ] URL je validan (npr. `https://tvojwebsite.com/privacy`)
  - [ ] Privacy policy je dostupan na tom URL-u
  - [ ] Privacy policy objašnjava kako koristiš podatke

**Kako proveriti:**
1. Idi na "App Privacy"
2. Klikni "Get Started" ili "Edit"
3. Odgovori na pitanja o tipovima podataka
4. Unesi Privacy Policy URL

**VAŽNO:** Ako nemaš Privacy Policy URL, moraš da ga napraviš pre submission-a!

---

## 4️⃣ VERSION INFORMATION (App Store tab)

**Putanja:** App Store Connect → My Apps → Tvoja App → App Store tab → Verzija (npr. "1.0.0")

### 4.1 Screenshots ⚠️ OBAVEZNO!

**Za svaki device size, trebaš MINIMUM 1 screenshot:**

- [ ] **iPhone 6.7" Display** (iPhone 14 Pro Max, 15 Pro Max):
  - [ ] Rezolucija: 1290 x 2796 pixels
  - [ ] Minimum 1 screenshot (maksimum 10)
  
- [ ] **iPhone 6.5" Display** (iPhone 11 Pro Max, XS Max):
  - [ ] Rezolucija: 1242 x 2688 pixels
  - [ ] Minimum 1 screenshot (maksimum 10)

- [ ] **iPhone 5.5" Display** (iPhone 8 Plus) - Opciono:
  - [ ] Rezolucija: 1242 x 2208 pixels

**Kako napraviti screenshots:**
1. Instaliraj app na simulator ili fizički uređaj
2. Otvori app i napravi screenshots (Power + Volume Up na iPhone-u)
3. Koristi screenshot-e koji prikazuju glavne funkcionalnosti
4. Možeš koristiti i isti screenshot za različite veličine (resize-uj)

### 4.2 App Preview (Opciono, ali preporučeno)

- [ ] Video preview (max 30 sekundi)
- [ ] Format: MOV ili MP4
- [ ] Rezolucija: Ista kao screenshots

### 4.3 Description ⚠️ OBAVEZNO!

- [ ] **App Description:** (max 4000 karaktera)
  - [ ] Objašnjava šta app radi
  - [ ] Navodi glavne funkcionalnosti
  - [ ] Gramatički ispravan
  
**Primer:**
```
GPT Wrapped - Your 2025 in Review

Discover your ChatGPT journey with personalized insights, statistics, and AI-powered analysis. See your most used words, chat streaks, peak times, and much more!

Features:
- 📊 Detailed chat statistics
- 🎯 Personalized insights
- 📈 Monthly trends
- 🎨 Beautiful visualizations
- 📱 Share your wrapped results

Perfect for anyone who wants to understand their AI conversation patterns!
```

### 4.4 Keywords ⚠️ OBAVEZNO!

- [ ] Keywords (max 100 karaktera, odvojeni zarezom)
- [ ] Relevantni za tvoju aplikaciju
- [ ] Bez razmaka posle zareza

**Primer:**
```
chatgpt,wrapped,statistics,ai,analysis,insights,chat,review
```

### 4.5 Support URL ⚠️ OBAVEZNO!

- [ ] **Support URL:** Validan URL
  - [ ] Primer: `https://tvojwebsite.com/support`
  - [ ] ILI: `mailto:support@tvojemail.com` (email link)
  - [ ] Stranica mora postojati i biti dostupna

### 4.6 Marketing URL (Opciono)

- [ ] Marketing URL (ako imaš website)

### 4.7 Promotional Text (Opciono)

- [ ] Kratak tekst koji se prikazuje na App Store (max 170 karaktera)
- [ ] Možeš promeniti bez nova verzija

### 4.8 What's New in This Version ⚠️ OBAVEZNO za novu verziju!

- [ ] Release notes (max 4000 karaktera)
- [ ] Objašnjava šta je novo u ovoj verziji

**Za prvi release, primer:**
```
Initial release of GPT Wrapped!

Features:
- Complete chat statistics
- Personalized AI insights
- Beautiful visualizations
- Share functionality
- Premium features with in-app purchases
```

### 4.9 App Icon ⚠️ OBAVEZNO!

- [ ] **App Icon:** 1024 x 1024 pixels
- [ ] PNG format
- [ ] Bez alpha channel (bez transparentnosti)
- [ ] Bez rounded corners (Apple će dodati)
- [ ] Upload-ovan u App Store Connect

### 4.10 Copyright

- [ ] Copyright info (npr. "© 2025 Tvoje Ime")

### 4.11 Version Number

- [ ] Version: 1.0.0 (ili tvoja verzija)
- [ ] Build: Postavlja se automatski kada upload-uješ IPA

---

## 5️⃣ AGE RATING ⚠️ OBAVEZNO!

**Putanja:** App Store Connect → My Apps → Tvoja App → Age Rating

### Odgovori na pitanja:

- [ ] **Unrestricted Web Access:** Ne (ako ne otvaraš browser u app-u)
- [ ] **Gambling:** Ne
- [ ] **Contests:** Ne
- [ ] **Medical/Treatment Information:** Ne
- [ ] **Alcohol, Tobacco, or Drugs:** Ne
- [ ] **Mature/Suggestive Themes:** Ne
- [ ] **Violence:** Ne
- [ ] **Horror/Fear Themes:** Ne
- [ ] **Profanity or Crude Humor:** Ne
- [ ] **Sexual Content or Nudity:** Ne

**Očekivani rating:** 4+ (svi uzrasti) za chat analysis app

---

## 6️⃣ APP REVIEW INFORMATION

**Putanja:** App Store Connect → My Apps → Tvoja App → App Store tab → App Review Information

### Proveri:

- [ ] **First Name:** Tvoje ime
- [ ] **Last Name:** Tvoje prezime
- [ ] **Phone Number:** Tvoj telefon
- [ ] **Email:** Tvoj email
- [ ] **Demo Account (ako je potrebno):**
  - [ ] Username
  - [ ] Password
  - [ ] Napomene (ako je potrebno objasniti Apple-u kako da testira)
- [ ] **Notes (opciono):**
  - [ ] Ako imaš nešto što treba Apple review timu da zna

---

## 7️⃣ BUILD I SUBMISSION

### 7.1 Build

- [ ] **Build je upload-ovan:**
  - [ ] IPA je upload-ovan preko Apple Transporter ili Xcode
  - [ ] Status: "Ready to Submit" (ne "Processing")
  
- [ ] **Build je izabran:**
  - [ ] U App Store tab-u, u "Build" sekciji
  - [ ] Izabran je build (npr. "1.0.0 (3)")

### 7.2 In-App Purchases

- [ ] **Sva tri IAP-a su navedena:**
  - [ ] `one_time_purchase` - Status: "Ready to Submit"
  - [ ] `monthly_subscription` - Status: "Ready to Submit"
  - [ ] `yearly_subscription` - Status: "Ready to Submit"
  
- [ ] **Subscription Group:**
  - [ ] Display Name je ispravan (npr. "MyChatEra Premium")
  - [ ] Status: "Ready to Submit"

### 7.3 Export Compliance

- [ ] Odgovorio si na Export Compliance pitanja:
  - [ ] "Does your app use encryption?" - Obično "No" za AI apps (osim ako koristiš specifične encryption metode)
  - [ ] Ako "Yes", moraš da dostaviš dodatne informacije

### 7.4 Advertising Identifier

- [ ] Odgovorio si na pitanje:
  - [ ] "Does this app use the Advertising Identifier (IDFA)?" - Obično "No" ako ne koristiš ads

### 7.5 Content Rights

- [ ] Potvrdio si da imaš prava na sav sadržaj u aplikaciji

---

## 8️⃣ FINALNA PROVERA PRE SUBMISSION-A

### Sve sekcije moraju biti popunjene:

- [ ] ✅ App Information - Sve popunjeno
- [ ] ✅ Pricing and Availability - Cena i zemlje postavljene
- [ ] ✅ App Privacy - Podaci i Privacy Policy URL
- [ ] ✅ Version Information - Screenshots, Description, Keywords, Support URL, App Icon
- [ ] ✅ Age Rating - Odgovoreno na sva pitanja
- [ ] ✅ App Review Information - Kontakt informacije
- [ ] ✅ Build - Izabran build
- [ ] ✅ In-App Purchases - Sva tri IAP-a navedena i "Ready to Submit"
- [ ] ✅ Export Compliance - Odgovoreno
- [ ] ✅ Advertising Identifier - Odgovoreno
- [ ] ✅ Content Rights - Potvrđeno

---

## 🚨 KRITIČNE STVARI KOJE MORAŠ IMATI:

### 1. Privacy Policy URL ⚠️
**Ovo je OBAVEZNO!** Apple će odbiti aplikaciju bez Privacy Policy URL-a.

**Opcije:**
- Kreiraj jednostavnu privacy policy stranicu na svom website-u
- ILI koristi generator (npr. privacypolicygenerator.info)
- ILI koristi GitHub Pages (besplatno)

### 2. Support URL ⚠️
**Ovo je OBAVEZNO!** 

**Opcije:**
- Kreiraj support stranicu na svom website-u
- ILI koristi email link: `mailto:support@tvojemail.com`
- ILI koristi GitHub Issues page (ako je open source)

### 3. Screenshots ⚠️
**Minimum 1 screenshot za svaki device size koji planiraš da podržavaš.**

### 4. App Icon ⚠️
**1024x1024 pixels, PNG format, bez transparentnosti.**

### 5. Description ⚠️
**Moras imati opis aplikacije (minimalno nekoliko rečenica).**

---

## 📝 PRIORITETI (Šta prvo da uradiš):

### Visoki prioritet (MORA biti):
1. ✅ Privacy Policy URL (kreiraj ako nemaš)
2. ✅ Support URL (kreiraj ako nemaš)
3. ✅ App Icon (1024x1024)
4. ✅ Screenshots (minimum 1 za glavni device)
5. ✅ Description (osnovni opis)
6. ✅ Keywords
7. ✅ App Privacy (odgovori na pitanja)
8. ✅ Age Rating (odgovori na pitanja)

### Srednji prioritet:
9. ✅ App Information (osnovne informacije)
10. ✅ Pricing and Availability
11. ✅ Build selection
12. ✅ IAP proizvodi navedeni u submission-u

### Nizak prioritet (opciono, ali bolje da imaš):
13. ✅ App Preview (video)
14. ✅ Promotional Text
15. ✅ Marketing URL

---

## 🔍 KAKO DA PROVERIŠ ŠTA TI NEDOSTAJE:

1. **Idi na App Store Connect:**
   - https://appstoreconnect.apple.com/
   - My Apps → Tvoja App

2. **Idi na App Store tab:**
   - Klikni na "App Store" tab
   - Klikni na svoju verziju (npr. "1.0.0")

3. **Proveri sekcije:**
   - Scroll kroz sve sekcije
   - Sekcije koje su nepopunjene će imati crvene indikatore ili upozorenja
   - Sekcije sa ⚠️ znakom su kritične

4. **Proveri status:**
   - U gornjem desnom uglu, proveri status
   - Ako piše "Missing Metadata" ili "Ready to Submit", klikni da vidiš šta nedostaje

---

## ✅ FINALNI CHECKLIST - Proveri SVE:

### Obavezno (bez ovoga ne možeš submit-ovati):
- [ ] Privacy Policy URL postoji i radi
- [ ] Support URL postoji i radi
- [ ] App Icon (1024x1024) upload-ovan
- [ ] Minimum 1 screenshot upload-ovan
- [ ] Description napisan
- [ ] Keywords dodati
- [ ] App Privacy popunjeno
- [ ] Age Rating popunjeno
- [ ] App Review Information (kontakt) popunjeno
- [ ] Build izabran
- [ ] Export Compliance odgovoreno
- [ ] Advertising Identifier odgovoreno
- [ ] Content Rights potvrđeno

### IAP-ovi (već smo pokrili, ali proveri):
- [ ] Subscription Group Display Name: "MyChatEra Premium" (ili tvoj izbor)
- [ ] Monthly Premium Description ispravan
- [ ] Yearly Premium Description ispravan
- [ ] One Time Purchase Description ispravan
- [ ] Sva tri IAP-a su "Ready to Submit"
- [ ] Sva tri IAP-a su navedena u App Store submission-u

---

## 💡 SAVETI:

1. **Privacy Policy:** Ako nemaš website, koristi GitHub Pages ili jednostavan generator
2. **Support URL:** Email link (`mailto:`) je najjednostavniji, ali website je profesionalniji
3. **Screenshots:** Koristi najbolje ekrane aplikacije koji prikazuju glavne funkcionalnosti
4. **Description:** Budi jasan i direktan - korisnici moraju razumeti šta app radi za 10 sekundi
5. **Keywords:** Istraži šta konkurenti koriste, ali budi specifičan

---

## 🎯 FINALNI KORAK:

Kada su SVE sekcije popunjene:

1. **Proveri status:**
   - Status bi trebalo da kaže "Ready to Submit"

2. **Klikni "Submit for Review":**
   - Gornji desni ugao
   - Potvrdi submission

3. **Sačekaj review:**
   - Status: "Waiting for Review" → "In Review" → "Approved" ili "Rejected"
   - Obično traje 1-3 dana

---

**Srećno! 🚀 Proveri svaku sekciju pažljivo - bolje da prođe jednom nego da te vraćaju više puta!**

