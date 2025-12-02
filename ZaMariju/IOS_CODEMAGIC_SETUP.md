# 📱 iOS Build sa Codemagic - Detaljni Vodič

## 🎯 PREGLED:

Koristićemo **Codemagic** da build-ujemo iOS aplikaciju bez MacBook-a. Codemagic je CI/CD servis koji omogućava build iOS aplikacija u cloud-u.

---

## 📋 KORAK 1: Priprema iOS Projekta

### **1.1. Proveri Bundle Identifier**

✅ **Već je promenjeno na `com.mychatera`** u `project.pbxproj`

**Proveri:**
- Bundle identifier: `com.mychatera`
- Display name: `MyChatEra AI`

---

### **1.2. Proveri Info.plist**

✅ **Display name je već promenjen na "MyChatEra AI"**

**Proveri da li imaš sve potrebne dozvole:**
- Internet access (za Firebase i RevenueCat)
- File access (za file picker)

---

## 📋 KORAK 2: App Store Connect Setup

### **2.1. Kreiraj App ID u Apple Developer Portal**

1. **Idi na:** https://developer.apple.com/account/
2. **Klikni na:** **Certificates, Identifiers & Profiles**
3. **Idi na:** **Identifiers** → **+** (dodaj novi)
4. **Izaberi:** **App IDs** → **Continue**
5. **Unesi:**
   - **Description:** `MyChatEra AI`
   - **Bundle ID:** `com.mychatera` (eksplicitno)
   - **Capabilities:**
     - ✅ **In-App Purchase** (za RevenueCat)
     - ✅ **Push Notifications** (opciono, ako koristiš)
6. **Klikni:** **Continue** → **Register**

---

### **2.2. Kreiraj App u App Store Connect**

1. **Idi na:** https://appstoreconnect.apple.com/
2. **Klikni na:** **My Apps** → **+** (dodaj novu aplikaciju)
3. **Unesi:**
   - **Platform:** iOS
   - **Name:** `MyChatEra AI`
   - **Primary Language:** English (ili Serbian)
   - **Bundle ID:** `com.mychatera` (izaberi iz liste)
   - **SKU:** `mychatera-ios` (jedinstveni identifikator)
   - **User Access:** **Full Access** (za sve funkcionalnosti)
4. **Klikni:** **Create**

---

### **2.3. Kreiraj In-App Purchase Proizvode**

**Trebaju ti 3 proizvoda:**

#### **A. One-Time Purchase**

1. **U App Store Connect:**
   - Idi na: **My Apps** → **MyChatEra AI** → **Features** → **In-App Purchases**
   - Klikni: **+** → **Non-Consumable**
2. **Unesi:**
   - **Reference Name:** `One-Time Purchase`
   - **Product ID:** `one_time_purchase` (ISTO KAO NA ANDROIDU!)
   - **Price:** $9.99
   - **Display Name:** `Premium Lifetime`
   - **Description:** `Unlock all premium features forever`
3. **Klikni:** **Save**

#### **B. Monthly Subscription**

1. **Klikni:** **+** → **Auto-Renewable Subscription**
2. **Unesi:**
   - **Subscription Group:** Kreiraj novu grupu (npr. "Premium Subscriptions")
   - **Reference Name:** `Monthly Subscription`
   - **Product ID:** `monthly_subscription` (ISTO KAO NA ANDROIDU!)
   - **Price:** $4.99/month
   - **Display Name:** `Monthly Premium`
   - **Description:** `Unlock all premium features monthly`
3. **Klikni:** **Save**

#### **C. Yearly Subscription**

1. **U istoj Subscription Group:**
   - Klikni: **+** → **Auto-Renewable Subscription**
2. **Unesi:**
   - **Subscription Group:** Ista grupa kao Monthly
   - **Reference Name:** `Yearly Subscription`
   - **Product ID:** `yearly_subscription` (ISTO KAO NA ANDROIDU!)
   - **Price:** $19.99/year
   - **Display Name:** `Yearly Premium`
   - **Description:** `Unlock all premium features yearly`
3. **Klikni:** **Save**

**⚠️ VAŽNO:** Product ID-ovi moraju biti ISTI kao na Androidu!

---

## 📋 KORAK 3: Codemagic Setup

### **3.1. Kreiraj Codemagic Nalog**

1. **Idi na:** https://codemagic.io/
2. **Klikni:** **Sign up** (ili **Log in** ako već imaš)
3. **Prijavi se sa:**
   - GitHub (preporučeno)
   - GitLab
   - Bitbucket
   - Email

---

### **3.2. Poveži GitHub Repo**

1. **U Codemagic dashboard:**
   - Klikni: **Add application**
   - Izaberi: **GitHub** (ili drugi Git provider)
   - Autorizuj pristup
   - Izaberi repo: `GPTWrapped-1` (ili kako se zove tvoj repo)
   - Klikni: **Add application**

---

### **3.3. Konfiguriši iOS Build**

1. **U Codemagic dashboard:**
   - Klikni na tvoju aplikaciju
   - Klikni: **Configure build**
   - Izaberi: **iOS** platform

2. **Codemagic će automatski detektovati Flutter projekat**

---

### **3.4. Dodaj iOS Certifikate i Provisioning Profile**

**Codemagic može automatski da kreira sertifikate, ali možeš i ručno:**

#### **OPCIJA A: Automatski (Preporučeno)**

1. **U Codemagic build settings:**
   - Idi na: **Code signing**
   - Izaberi: **Automatic code signing**
   - **Apple Developer Team ID:** Unesi svoj Team ID (naći ćeš ga u Apple Developer Portal)
   - **Bundle identifier:** `com.mychatera`

2. **Codemagic će automatski:**
   - Kreirati sertifikate
   - Kreirati provisioning profile
   - Konfigurisati sve potrebno

#### **OPCIJA B: Ručno (Ako imaš već sertifikate)**

1. **Preuzmi sertifikate sa Mac-a:**
   - Export-uj `.p12` sertifikat
   - Export-uj `.mobileprovision` provisioning profile

2. **U Codemagic:**
   - Idi na: **Code signing**
   - Upload-uj sertifikate
   - Dodaj provisioning profile

---

### **3.5. Konfiguriši Build Script**

**Codemagic će automatski generisati `codemagic.yaml` fajl, ali možeš i ručno:**

1. **Kreiraj `codemagic.yaml` u root-u projekta:**

```yaml
workflows:
  ios-workflow:
    name: iOS Workflow
    max_build_duration: 120
    instance_type: mac_mini_m1
    environment:
      flutter: stable
      xcode: latest
      cocoapods: default
    scripts:
      - name: Get Flutter dependencies
        script: |
          flutter pub get
      - name: Install CocoaPods dependencies
        script: |
          cd ios && pod install
      - name: Set up code signing settings on Xcode project
        script: |
          xcode-project use-profiles
      - name: Build ipa for distribution
        script: |
          flutter build ipa --release \
            --build-name=1.0.0 \
            --build-number=2
    artifacts:
      - build/ios/ipa/*.ipa
    publishing:
      email:
        recipients:
          - your-email@example.com
        notify:
          success: true
          failure: false
      app_store_connect:
        auth:
          key_id: $APP_STORE_CONNECT_KEY_IDENTIFIER
          issuer_id: $APP_STORE_CONNECT_ISSUER_ID
          key: $APP_STORE_CONNECT_PRIVATE_KEY
        submit_to_testflight: true
        beta_groups:
          - group name 1
          - group name 2
```

---

### **3.6. Dodaj App Store Connect API Key**

**Za automatski upload u App Store Connect:**

1. **Kreiraj App Store Connect API Key:**
   - Idi na: https://appstoreconnect.apple.com/
   - Idi na: **Users and Access** → **Keys** → **App Store Connect API**
   - Klikni: **+** (generate API key)
   - **Name:** `Codemagic iOS`
   - **Access:** **App Manager** (ili **Admin**)
   - Klikni: **Generate**
   - **Preuzmi `.p8` fajl** (možeš samo jednom!)
   - **Zapamti:**
     - **Key ID** (npr. `ABC123XYZ`)
     - **Issuer ID** (npr. `12345678-1234-1234-1234-123456789012`)

2. **Dodaj u Codemagic:**
   - Idi na: **App settings** → **Environment variables**
   - Dodaj:
     - `APP_STORE_CONNECT_KEY_IDENTIFIER` = Key ID
     - `APP_STORE_CONNECT_ISSUER_ID` = Issuer ID
     - `APP_STORE_CONNECT_PRIVATE_KEY` = Sadržaj `.p8` fajla (kopiraj ceo tekst)

---

## 📋 KORAK 4: Build i Upload

### **4.1. Pokreni Build**

1. **U Codemagic dashboard:**
   - Klikni na tvoju aplikaciju
   - Klikni: **Start new build**
   - Izaberi: **iOS workflow**
   - Klikni: **Start build**

2. **Codemagic će:**
   - Klonirati repo
   - Install-ovati dependencies
   - Build-ovati IPA fajl
   - Upload-ovati u App Store Connect (ako je konfigurisano)

---

### **4.2. Preuzmi IPA (Ako ne upload-uje automatski)**

1. **Nakon što build završi:**
   - Klikni na build
   - Idi na: **Artifacts**
   - Preuzmi `.ipa` fajl

2. **Upload ručno u App Store Connect:**
   - Idi na: https://appstoreconnect.apple.com/
   - Idi na: **My Apps** → **MyChatEra AI** → **TestFlight** (ili **App Store**)
   - Klikni: **+** (dodaj build)
   - Upload-uj `.ipa` fajl

---

## 📋 KORAK 5: App Store Connect - Finalni Koraci

### **5.1. Popuni App Information**

1. **U App Store Connect:**
   - Idi na: **App Information**
   - **Category:** Productivity (ili kako odgovara)
   - **Privacy Policy URL:** (dodaj ako imaš)
   - **Support URL:** (dodaj ako imaš)

---

### **5.2. Popuni Store Listing**

1. **Idi na:** **App Store** → **1.0 Prepare for Submission**
2. **Popuni:**
   - **Screenshots** (obavezno za iPhone)
   - **Description** (engleski i srpski)
   - **Keywords**
   - **Support URL**
   - **Marketing URL** (opciono)
   - **App Icon** (1024x1024)

---

### **5.3. Submit za Review**

1. **Proveri sve:**
   - ✅ App Information
   - ✅ Store Listing
   - ✅ In-App Purchases
   - ✅ Build uploaded

2. **Klikni:** **Submit for Review**

3. **Sačekaj review** (obično 1-3 dana)

---

## ⚠️ VAŽNE NAPOMENE:

### **Bundle Identifier:**
- ✅ **Mora biti isti** kao na Androidu: `com.mychatera`
- ✅ **Mora biti kreiran** u Apple Developer Portal

### **Product ID-ovi:**
- ✅ **MORAJU biti isti** kao na Androidu:
  - `one_time_purchase`
  - `monthly_subscription`
  - `yearly_subscription`

### **Firebase:**
- ✅ **Dodaj iOS app** u Firebase Console
- ✅ **Preuzmi `GoogleService-Info.plist`**
- ✅ **Dodaj u `ios/Runner/` folder**

### **RevenueCat:**
- ✅ **Dodaj iOS app** u RevenueCat dashboard
- ✅ **Konfiguriši product ID-ove** (isti kao na Androidu)

---

## 📋 CHECKLIST:

- [ ] ✅ Promenjen bundle identifier na `com.mychatera`
- [ ] ✅ Promenjen display name na "MyChatEra AI"
- [ ] ✅ Kreiran App ID u Apple Developer Portal
- [ ] ✅ Kreirana aplikacija u App Store Connect
- [ ] ✅ Kreirani In-App Purchase proizvodi (3 proizvoda)
- [ ] ✅ Kreiran Codemagic nalog
- [ ] ✅ Povezan GitHub repo
- [ ] ✅ Konfigurisan iOS build
- [ ] ✅ Dodati App Store Connect API keys
- [ ] ✅ Build-ovana IPA
- [ ] ✅ Upload-ovana u App Store Connect
- [ ] ✅ Popunjen Store Listing
- [ ] ✅ Submit-ovana za review

---

## 🔗 KORISNI LINKOVI:

- **Codemagic:** https://codemagic.io/
- **Apple Developer Portal:** https://developer.apple.com/account/
- **App Store Connect:** https://appstoreconnect.apple.com/
- **Firebase Console:** https://console.firebase.google.com/
- **RevenueCat Dashboard:** https://app.revenuecat.com/

---

**Srećno sa iOS build-om! 🚀**
