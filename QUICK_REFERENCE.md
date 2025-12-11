# 🚀 Quick Reference - Firebase & RevenueCat Setup za iOS

## 📱 SAMO iOS APLIKACIJA!

**Svi koraci su za iOS!** ✅

## ⚡ Brzi koraci (copy-paste)

### 1. Firebase - Download GoogleService-Info.plist
```
1. https://console.firebase.google.com/
2. Create project → Add iOS app
3. Bundle ID: com.mychatera
4. Download GoogleService-Info.plist
5. Dodaj u Xcode: Runner folder
```

### 2. RevenueCat - API Key
```
1. https://app.revenuecat.com/
2. Create project → Add iOS app
3. Bundle ID: com.mychatera
4. Connect App Store Connect
5. Create Products:
   - one_time_purchase (Non-Subscription)
   - monthly_subscription (Subscription, 1 Month)
   - yearly_subscription (Subscription, 1 Year)
6. Create Entitlement: premium
7. Link Products to Entitlement
8. Copy Public SDK Key
9. Dodaj u lib/main.dart linija 59
```

### 3. Build & TestFlight
```bash
# Povećaj build number
# U pubspec.yaml: version: 1.0.0+2

cd ~/Documents/myChatEra/ZaMariju
flutter clean
flutter pub get
flutter build ipa --export-options-plist=ios/ExportOptions.plist

# Upload u Apple Transporter
# TestFlight → Add tester → Test
```

### 4. Resubmit
```bash
# Povećaj build number
# U pubspec.yaml: version: 1.0.0+3

flutter clean
flutter pub get
flutter build ipa --export-options-plist=ios/ExportOptions.plist

# Upload u Apple Transporter
# App Store Connect → Submit for Review
```

---

## 🔑 Ključne informacije

### Bundle ID
```
com.mychatera
```

### Product IDs (RevenueCat)
```
one_time_purchase
monthly_subscription
yearly_subscription
```

### Entitlement ID
```
premium
```

### Firebase Collection
```
user_analyses
```

---

## 📝 Gde da dodam API Key?

**Fajl:** `lib/main.dart`  
**Linija:** 59  
**Zameni:** `'YOUR_REVENUECAT_PUBLIC_KEY_HERE'` sa tvojim API key-om

---

## ✅ Test Checklist

- [ ] Firebase initialized (log: ✅ Firebase initialized)
- [ ] RevenueCat initialized (log: ✅ RevenueCat initialized)
- [ ] Firestore - proveri da li se kreiraju dokumenti
- [ ] RevenueCat Products - proveri da li se prikazuju opcije
- [ ] RevenueCat Customers - proveri da li se korisnici vide

---

## 🆘 Ako nešto ne radi

1. **Firebase:** Proveri da li je `GoogleService-Info.plist` u `ios/Runner/` folderu
2. **RevenueCat:** Proveri da li je API key dodat u `main.dart`
3. **TestFlight:** Proveri da li je build procesiran (može trajati 10-30 min)

---

**Detaljne korake:** Vidi `iOS_SETUP_ONLY.md` ⭐

