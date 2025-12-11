# 🚀 Fastlane Setup - Automatsko Kreiranje Sertifikata

## 🎯 REŠENJE:

**Koristimo Fastlane koji automatski kreira sertifikate koristeći App Store Connect API key!**

---

## 📋 KORAK 1: Instaliraj Fastlane

**U Terminal-u na Mac virtuelnoj mašini:**

```bash
cd ~/Desktop/GPTWrapped-1/ZaMariju/ios
sudo gem install fastlane
```

---

## 📋 KORAK 2: Inicijalizuj Fastlane

```bash
fastlane init
```

**Kada pita:**
- "What would you like to use fastlane for?" → Izaberi: **2** (Automate beta distribution to TestFlight)
- "Your Apple ID:" → Unesi tvoj Apple ID email
- "Password:" → Unesi App-Specific Password (ne običan password!)

**Ako nemaš App-Specific Password:**
1. Idi na: https://appleid.apple.com/
2. Sign In → App-Specific Passwords → Generate Password
3. Kopiraj password i koristi ga

---

## 📋 KORAK 3: Konfiguriši Fastlane sa App Store Connect API Key

**Otvori:** `ZaMariju/ios/fastlane/Appfile`

**Dodaj:**
```ruby
app_identifier("com.mychatera")
apple_id("tvoj@email.com")
team_id("522DMZ83DM")
```

---

## 📋 KORAK 4: Konfiguriši Fastfile

**Otvori:** `ZaMariju/ios/fastlane/Fastfile`

**Zameni sa:**
```ruby
default_platform(:ios)

platform :ios do
  desc "Build and upload to TestFlight"
  lane :beta do
    match(
      type: "appstore",
      app_identifier: "com.mychatera",
      readonly: false
    )
    
    build_app(
      workspace: "Runner.xcworkspace",
      scheme: "Runner",
      export_method: "app-store"
    )
    
    upload_to_testflight
  end
end
```

---

## 📋 KORAK 5: Dodaj App Store Connect API Key

**Kreiraj fajl:** `ZaMariju/ios/fastlane/.env`

**Dodaj:**
```
APP_STORE_CONNECT_API_KEY_KEY_ID=tvoj_key_id
APP_STORE_CONNECT_API_KEY_ISSUER_ID=tvoj_issuer_id
APP_STORE_CONNECT_API_KEY_KEY_FILEPATH=path/to/tvoj.p8
```

**Ili koristi environment variables:**
```bash
export APP_STORE_CONNECT_API_KEY_KEY_ID="tvoj_key_id"
export APP_STORE_CONNECT_API_KEY_ISSUER_ID="tvoj_issuer_id"
export APP_STORE_CONNECT_API_KEY_KEY_FILEPATH="/path/to/tvoj.p8"
```

---

## 📋 KORAK 6: Pokreni Fastlane

```bash
cd ~/Desktop/GPTWrapped-1/ZaMariju/ios
fastlane beta
```

**Fastlane će:**
- ✅ Automatski kreirati sertifikat koristeći App Store Connect API key
- ✅ Automatski kreirati provisioning profile
- ✅ Build-ovati IPA
- ✅ Upload-ovati u TestFlight

---

## ⚠️ VAŽNO:

**Fastlane koristi `match` koji automatski kreira sertifikate - ne treba ručno!**

---

**Sledi korake i pokreni `fastlane beta` - ovo bi trebalo da radi! 🚀**



