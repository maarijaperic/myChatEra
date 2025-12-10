# 📱 Kompletan Vodič: Build IPA i Upload na App Store

## ✅ PREDUSLOVI (već imaš):
- ✅ Apple Developer nalog
- ✅ Distribution sertifikat (u Keychain-u)
- ✅ Provisioning profile (u `~/Library/MobileDevice/Provisioning Profiles/`)
- ✅ Screenshot-ovi
- ✅ Logo aplikacije

---

## 🎨 KORAK 1: Dodaj Logo Aplikacije (ako nisi)

### 1.1. Generiši sve veličine logo-a
Koristi online tool: https://www.appicon.co/ ili https://appicon.build/

**Potrebne veličine:**
- **1024x1024** (App Store - OBAVEZNO!)
- 180x180 (60x60@3x)
- 120x120 (60x60@2x)
- 87x87 (29x29@3x)
- 58x58 (29x29@2x)
- 29x29 (29x29@1x)
- 80x80 (40x40@2x)
- 60x60 (40x40@3x)
- 40x40 (40x40@1x)
- 60x60 (20x20@3x)
- 40x40 (20x20@2x)
- 20x20 (20x20@1x)
- 152x152 (76x76@2x - iPad)
- 76x76 (76x76@1x - iPad)
- 167x167 (83.5x83.5@2x - iPad Pro)

### 1.2. Zameni fajlove
```bash
cd ~/Documents/myChatEra/ZaMariju/ios/Runner/Assets.xcassets/AppIcon.appiconset/

# Zameni sve ikone sa tvojim logo-om
# Najvažniji je Icon-App-1024x1024@1x.png (za App Store)
```

### 1.3. Verifikacija u Xcode
```bash
# Otvori Xcode projekat
open ~/Documents/myChatEra/ZaMariju/ios/Runner.xcworkspace

# U Xcode-u:
# 1. Klikni na "Runner" u Project Navigator (levo)
# 2. Izaberi "Runner" target
# 3. Idi na "General" tab
# 4. Proveri "App Icons and Launch Images"
# 5. Trebalo bi da vidiš sve ikone
```

---

## 🏗️ KORAK 2: Build IPA Fajla

### 2.1. Clean build
```bash
cd ~/Documents/myChatEra/ZaMariju
flutter clean
flutter pub get
```

### 2.2. Build IPA
```bash
# Build IPA sa ExportOptions.plist
flutter build ipa --export-options-plist=ios/ExportOptions.plist

# ILI direktno:
cd ios
xcodebuild -workspace Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -archivePath build/Runner.xcarchive \
  archive

xcodebuild -exportArchive \
  -archivePath build/Runner.xcarchive \
  -exportPath build/ipa \
  -exportOptionsPlist ExportOptions.plist
```

### 2.3. Verifikacija IPA
```bash
# Proveri da li je IPA kreiran
ls -lh ~/Documents/myChatEra/ZaMariju/build/ios/ipa/*.ipa

# Trebalo bi da vidiš nešto kao:
# Runner.ipa (oko 50-100MB)
```

**Lokacija IPA fajla:**
```
~/Documents/myChatEra/ZaMariju/build/ios/ipa/Runner.ipa
```

---

## 📤 KORAK 3: Upload na App Store Connect

### 3.1. Preko Terminala (Transporter ili altool)

**Opcija A: Apple Transporter (GUI)**
```bash
# 1. Download Apple Transporter (ako nemaš)
# https://apps.apple.com/us/app/transporter/id1450874784

# 2. Otvori Transporter
open -a "Transporter"

# 3. Drag & drop Runner.ipa u Transporter
# 4. Klikni "Deliver"
```

**Opcija B: Terminal (xcrun altool)**
```bash
# Upload IPA
xcrun altool --upload-app \
  --type ios \
  --file ~/Documents/myChatEra/ZaMariju/build/ios/ipa/Runner.ipa \
  --apiKey YOUR_API_KEY \
  --apiIssuer YOUR_ISSUER_ID

# ILI sa App-Specific Password:
xcrun altool --upload-app \
  --type ios \
  --file ~/Documents/myChatEra/ZaMariju/build/ios/ipa/Runner.ipa \
  --username mperic343@gmail.com \
  --password YOUR_APP_SPECIFIC_PASSWORD
```

**Opcija C: Xcode Organizer**
```bash
# 1. Otvori Xcode
open ~/Documents/myChatEra/ZaMariju/ios/Runner.xcworkspace

# 2. Xcode → Window → Organizer (Shift+Cmd+O)
# 3. Izaberi archive (Runner.xcarchive)
# 4. Klikni "Distribute App"
# 5. Izaberi "App Store Connect"
# 6. Klikni "Next" → "Upload"
```

---

## 📋 KORAK 4: Konfiguracija u App Store Connect

### 4.1. Prijava na App Store Connect
```
https://appstoreconnect.apple.com
```

### 4.2. Izaberi aplikaciju
- Klikni na "My Apps"
- Izaberi "GPT Wrapped" ili kreiraj novu aplikaciju

### 4.3. App Information (Osnovne informacije)
- **Name**: GPT Wrapped (ili kako želiš)
- **Primary Language**: English (ili Srpski)
- **Bundle ID**: com.mychatera (već postoji)
- **SKU**: GPT-Wrapped-001 (ili neki unique ID)

### 4.4. Pricing and Availability
- **Price**: Free ili Paid
- **Availability**: Svi zemlje ili odaberi

### 4.5. App Privacy (OBAVEZNO!)
- **Data Types Collected**: 
  - User Content (Chat conversations)
  - Usage Data (Analytics)
- **Data Linked to User**: Da/Ne
- **Data Used to Track You**: Da/Ne
- **Privacy Policy URL**: (moraš imati!)

### 4.6. Version Information

#### 4.6.1. Screenshots (OBAVEZNO!)
**iPhone 6.7" Display (iPhone 14 Pro Max, 15 Pro Max):**
- 1290 x 2796 pixels
- Minimum 1 screenshot, maksimum 10

**iPhone 6.5" Display (iPhone 11 Pro Max, XS Max):**
- 1242 x 2688 pixels
- Minimum 1 screenshot, maksimum 10

**iPhone 5.5" Display (iPhone 8 Plus):**
- 1242 x 2208 pixels
- Minimum 1 screenshot, maksimum 10

**iPad Pro 12.9" (3rd generation):**
- 2048 x 2732 pixels
- Opciono (ako podržava iPad)

**Kako dodati:**
1. Idi na "App Store" tab
2. Klikni na verziju (npr. "1.0.0")
3. Scroll do "Screenshots"
4. Drag & drop screenshot-ove u odgovarajuće sekcije

#### 4.6.2. App Preview (Opciono)
- Video preview aplikacije (maksimum 30 sekundi)
- Format: MOV ili MP4
- Rezolucija: Ista kao screenshots

#### 4.6.3. Description
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

#### 4.6.4. Keywords
```
chatgpt, wrapped, statistics, ai, analysis, insights, chat, review, 2025
```
(Maksimum 100 karaktera, odvojeno zarezom)

#### 4.6.5. Support URL
```
https://yourwebsite.com/support
```
(Mora biti validan URL!)

#### 4.6.6. Marketing URL (Opciono)
```
https://yourwebsite.com
```

#### 4.6.7. Promotional Text (Opciono)
```
New features and improvements in this update!
```

#### 4.6.8. What's New in This Version
```
Initial release of GPT Wrapped!

Features:
- Complete chat statistics
- Personalized AI insights
- Beautiful visualizations
- Share functionality
```

#### 4.6.9. App Icon
- **1024x1024 pixels**
- PNG format
- Bez alpha channel (bez transparentnosti)
- Bez rounded corners (Apple će dodati)

**Kako dodati:**
1. Idi na "App Store" tab
2. Scroll do "App Icon"
3. Upload `Icon-App-1024x1024@1x.png`

#### 4.6.10. Copyright
```
© 2025 MARIJA PERIC
```

#### 4.6.11. Version Number
- **Version**: 1.0.0 (ili kako želiš)
- **Build**: 1 (ili veći broj za svaki upload)

#### 4.6.12. Age Rating
- Odgovori na pitanja:
  - **Unrestricted Web Access**: Ne (ako ne koristiš browser)
  - **Gambling**: Ne
  - **Contests**: Ne
  - **Medical/Treatment Information**: Ne
  - **Alcohol, Tobacco, or Drugs**: Ne
  - **Mature/Suggestive Themes**: Ne
  - **Violence**: Ne
  - **Horror/Fear Themes**: Ne
  - **Profanity or Crude Humor**: Ne
  - **Sexual Content or Nudity**: Ne

**Očekivani rating**: 4+ (svi uzrasti)

---

## ✅ KORAK 5: Submit za Review

### 5.1. Proveri sve sekcije
- ✅ App Information
- ✅ Pricing and Availability
- ✅ App Privacy
- ✅ Version Information
- ✅ Screenshots (minimum 1 za svaki device)
- ✅ Description
- ✅ Keywords
- ✅ Support URL
- ✅ App Icon (1024x1024)
- ✅ Age Rating

### 5.2. Submit za Review
1. Klikni "Add for Review" (ili "Submit for Review")
2. Odgovori na pitanja:
   - **Export Compliance**: Ne (ako ne koristiš encryption)
   - **Advertising Identifier**: Ne (ako ne koristiš ads)
   - **Content Rights**: Potvrdi da imaš prava
3. Klikni "Submit"

### 5.3. Status
- **Waiting for Review**: Čekaš na review (1-7 dana)
- **In Review**: Apple pregleda aplikaciju (1-3 dana)
- **Ready for Sale**: ✅ Odobreno!
- **Rejected**: ❌ Treba da popraviš probleme

---

## 📝 CHECKLIST PRE SUBMIT-A

### Build & IPA
- [ ] Logo aplikacije dodat (sve veličine)
- [ ] IPA build uspešan
- [ ] IPA upload-ovan na App Store Connect

### App Store Connect
- [ ] App Information popunjeno
- [ ] Pricing and Availability konfigurisano
- [ ] App Privacy konfigurisano
- [ ] Screenshots dodati (minimum 1 za svaki device)
- [ ] Description napisan
- [ ] Keywords dodati
- [ ] Support URL validan
- [ ] App Icon (1024x1024) upload-ovan
- [ ] Age Rating popunjeno
- [ ] Version Number i Build Number postavljeni

### Test
- [ ] Aplikacija testirana na simulatoru
- [ ] Aplikacija testirana na fizičkom uređaju (ako imaš)
- [ ] Sve funkcionalnosti rade

---

## ⏱️ VREMENSKA PROCENA

- **Build IPA**: 15-30 min
- **Upload**: 5-10 min
- **Konfiguracija App Store Connect**: 30-60 min
- **Apple Review**: 1-7 dana (obično 2-5 dana)

**Ukupno**: ~1-2 sata rada + 2-5 dana čekanja

---

## 🆘 TROUBLESHOOTING

### Problem: "No such file or directory: ExportOptions.plist"
**Rešenje**: Proveri da li fajl postoji:
```bash
ls -la ~/Documents/myChatEra/ZaMariju/ios/ExportOptions.plist
```

### Problem: "Provisioning profile not found"
**Rešenje**: Proveri da li je profil u pravoj lokaciji:
```bash
ls -la ~/Library/MobileDevice/Provisioning\ Profiles/
```

### Problem: "Invalid Bundle"
**Rešenje**: Proveri Bundle ID u Info.plist:
```bash
cat ~/Documents/myChatEra/ZaMariju/ios/Runner/Info.plist | grep CFBundleIdentifier
```

### Problem: "Missing Compliance"
**Rešenje**: Odgovori na Export Compliance pitanja u App Store Connect

---

## 📞 PODRŠKA

Ako imaš problema:
1. Proveri Apple Developer Forums
2. Proveri App Store Connect Help
3. Kontaktiraj Apple Developer Support

---

**Srećno sa objavom! 🚀**


