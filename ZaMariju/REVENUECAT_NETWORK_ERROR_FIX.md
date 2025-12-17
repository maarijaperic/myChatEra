# 🔧 RevenueCat Network Error Fix Guide

## ⚠️ Problem: Network Errors (-1005, -1017)

Greške koje vidiš:
- `-1005`: "The network connection was lost"
- `-1017`: "cannot parse response"

Ovo su tipične greške koje se dešavaju kada StoreKit Configuration File nije pravilno podešen.

---

## 🎯 KORAK 1: Proveri StoreKit Configuration u Xcode

### 1.1. Otvori Xcode

1. Otvori `ios/Runner.xcworkspace` (NE `.xcodeproj`!)
2. Ako ne postoji workspace, kreiraj ga:
   ```bash
   cd ios
   pod install
   cd ..
   ```

### 1.2. Podesi StoreKit Configuration

1. U Xcode, klikni na **Product** → **Scheme** → **Edit Scheme...**
2. U levoj strani, izaberi **Run**
3. U gornjem delu, klikni na **Options** tab
4. Pronađi **StoreKit Configuration**
5. U dropdown-u, izaberi **Products.storekit**
6. Ako ne vidiš fajl, klikni **+** i dodaj `ios/Runner/Products.storekit`
7. Klikni **Close**

### 1.3. Proveri da li je Fajl Dodat u Projekat

1. U Xcode Project Navigator, proveri da li vidiš `Products.storekit`
2. Ako ne vidiš, desni klik na `Runner` folder → **Add Files to "Runner"...**
3. Izaberi `ios/Runner/Products.storekit`
4. ✅ Proveri **"Copy items if needed"**
5. ✅ Proveri da je **"Add to targets: Runner"** označeno
6. Klikni **Add**

---

## 🎯 KORAK 2: Proveri RevenueCat Dashboard

### 2.1. Proveri Products Sync

1. Idi na https://app.revenuecat.com
2. Odaberi tvoj projekat
3. Idi na **Products**
4. Proveri da li su svi proizvodi sinhronizovani:
   - `one_time_purchase`
   - `monthly_subscription`
   - `yearly_subscription`

### 2.2. Proveri Offerings

1. Idi na **Offerings**
2. Proveri da li postoji **Current Offering**
3. Proveri da li su svi paketi dodati u offering

---

## 🎯 KORAK 3: Proveri App Store Connect

### 3.1. Proveri In-App Purchases

1. Idi na https://appstoreconnect.apple.com
2. Odaberi tvoju aplikaciju
3. Idi na **Features** → **In-App Purchases**
4. Proveri da li su svi proizvodi:
   - ✅ Kreirani
   - ✅ "Ready to Submit" ili "Approved"
   - ✅ Product ID-ovi se poklapaju sa onima u kodu

---

## 🎯 KORAK 4: Test na Fizičkom Uređaju

### 4.1. StoreKit Configuration File radi samo u Simulatoru

- **Simulator:** Koristi `Products.storekit` (test mode)
- **Fizički uređaj:** Koristi App Store Connect (sandbox)

### 4.2. Test na Fizičkom Uređaju

1. Poveži iPhone/iPad preko USB
2. U Xcode, izaberi tvoj uređaj kao target
3. Pokreni aplikaciju
4. Prijavi se sa **Sandbox Test Account** (kreiraj ga u App Store Connect)
5. Pokušaj da kupiš

---

## 🎯 KORAK 5: Proveri Network Connectivity

### 5.1. Proveri Internet Konekciju

- Proveri da li imaš stabilnu internet konekciju
- Pokušaj sa WiFi umesto mobilnih podataka (ili obrnuto)

### 5.2. Proveri Firewall/VPN

- Ako koristiš VPN, probaj bez njega
- Proveri da li firewall blokira RevenueCat API

---

## 🎯 KORAK 6: Clean Build

### 6.1. Očisti Build Folder

1. U Xcode: **Product** → **Clean Build Folder** (Shift+Cmd+K)
2. Ili u terminalu:
   ```bash
   cd ios
   rm -rf build
   pod deintegrate
   pod install
   cd ..
   flutter clean
   flutter pub get
   ```

### 6.2. Rebuild

```bash
flutter run
```

---

## 🐛 Troubleshooting

### Problem: "cannot parse response" (-1017)

**Uzrok:** RevenueCat ne može da parsira odgovor od App Store-a

**Rešenje:**
1. Proveri StoreKit Configuration u Xcode Scheme
2. Proveri da li su proizvodi pravilno konfigurisani u `Products.storekit`
3. Proveri RevenueCat Dashboard → Products sync

### Problem: "connection lost" (-1005)

**Uzrok:** Mrežna konekcija je prekinuta

**Rešenje:**
1. Proveri internet konekciju
2. Pokušaj ponovo nakon nekoliko sekundi
3. Proveri da li VPN/firewall blokira konekciju

### Problem: Sve retry-ovi ne rade

**Uzrok:** StoreKit Configuration nije podešen ili proizvodi nisu sinhronizovani

**Rešenje:**
1. **HITNO:** Proveri Xcode Scheme → Run → Options → StoreKit Configuration
2. Proveri RevenueCat Dashboard → Products
3. Proveri App Store Connect → In-App Purchases

---

## ✅ Checklist

- [ ] StoreKit Configuration je podešen u Xcode Scheme
- [ ] Products.storekit je dodat u Xcode projekat
- [ ] RevenueCat Dashboard → Products su sinhronizovani
- [ ] App Store Connect → In-App Purchases su "Ready to Submit"
- [ ] Testirano na fizičkom uređaju sa Sandbox account
- [ ] Clean build je urađen
- [ ] Internet konekcija je stabilna

---

## 📝 Napomene

- StoreKit Configuration File (`Products.storekit`) radi **samo u Simulatoru**
- Za fizički uređaj, koristi **App Store Connect Sandbox**
- Retry logika u kodu bi trebalo da reši privremene mrežne probleme
- Ako problem i dalje postoji, verovatno je problem sa StoreKit Configuration

