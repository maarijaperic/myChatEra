# 🚀 START HERE - Firebase & RevenueCat Setup za iOS

## 📱 SAMO iOS APLIKACIJA!

**Svi koraci su za iOS!** ✅

## 📋 Šta treba da uradiš?

1. **Firebase Setup za iOS** (30-45 min)
2. **RevenueCat Setup za iOS** (1-2 sata)
3. **TestFlight Testiranje** (30-45 min)
4. **Resubmit iOS Aplikacije** (15-30 min)

**Ukupno vreme: 2-4 sata** ✅

---

## 📚 Dokumentacija

### 1. **iOS_SETUP_ONLY.md** ⭐ **POČNI OVDE!**
   - Detaljni koraci SAMO za iOS
   - Korak-po-korak instrukcije
   - Troubleshooting sekcija

### 2. **SETUP_GUIDE.md** - Detaljni koraci (opciono)
   - Korak-po-korak instrukcije
   - Screenshot uputstva
   - Troubleshooting sekcija

### 3. **QUICK_REFERENCE.md** - Brzi reference
   - Copy-paste komande
   - Ključne informacije
   - Test checklist

---

## 🎯 Brzi Start

### Korak 1: Firebase
```
1. https://console.firebase.google.com/
2. Create project → Add iOS app
3. Bundle ID: com.mychatera
4. Download GoogleService-Info.plist
5. Dodaj u Xcode: Runner folder
```

### Korak 2: RevenueCat
```
1. https://app.revenuecat.com/
2. Create project → Add iOS app
3. Bundle ID: com.mychatera
4. Connect App Store Connect
5. Create Products (one_time, monthly, yearly)
6. Create Entitlement (premium)
7. Copy API Key → Dodaj u lib/main.dart linija 59
```

### Korak 3: Build & Test
```bash
# Povećaj build number u pubspec.yaml: version: 1.0.0+2
cd ~/Documents/myChatEra/ZaMariju
flutter clean
flutter pub get
flutter build ipa --export-options-plist=ios/ExportOptions.plist
# Upload u Apple Transporter → TestFlight → Test
```

### Korak 4: Resubmit
```bash
# Povećaj build number u pubspec.yaml: version: 1.0.0+3
flutter clean
flutter pub get
flutter build ipa --export-options-plist=ios/ExportOptions.plist
# Upload u Apple Transporter → Submit for Review
```

---

## ✅ Checklist

### Firebase:
- [ ] GoogleService-Info.plist je dodat u Xcode
- [ ] Firebase je inicijalizovan (već je u kodu)
- [ ] Firestore Database je kreiran
- [ ] Testirano u TestFlight

### RevenueCat:
- [ ] Projekat je kreiran
- [ ] iOS app je dodata
- [ ] App Store Connect je povezan
- [ ] Products su kreirani
- [ ] Entitlement je kreiran
- [ ] API Key je dodat u kod
- [ ] Testirano u TestFlight

### App Store:
- [ ] Build number je povećan
- [ ] IPA je upload-ovan
- [ ] TestFlight testiranje je završeno
- [ ] Submit za Review je kliknut

---

## 🆘 Ako imaš problema

1. **Pročitaj SETUP_GUIDE.md** - Ima troubleshooting sekciju
2. **Proveri log-ove** - Xcode Console ili Flutter log-ovi
3. **Proveri Firebase Console** - Firestore Database
4. **Proveri RevenueCat Dashboard** - Customers, Products

---

## 📞 Pomoć

Ako nešto ne radi:
- Proveri da li je `GoogleService-Info.plist` u `ios/Runner/` folderu
- Proveri da li je RevenueCat API key dodat u `lib/main.dart` linija 59
- Proveri log-ove za greške

---

**Srećno sa iOS setup-om! 🚀📱**

**Detaljne korake:** Vidi `iOS_SETUP_ONLY.md` ⭐

