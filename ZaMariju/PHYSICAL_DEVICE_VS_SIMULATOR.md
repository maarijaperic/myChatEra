# 📱 Simulator vs Fizički Uređaj - Zašto Ne Radi?

## ✅ Radi na Simulatoru, ❌ Ne Radi na Fizičkom Uređaju

Ako radi na simulatoru ali ne na telefonu, ovo je normalno! Evo zašto:

---

## 🔍 Razlika Između Simulatora i Fizičkog Uređaja

### Simulator:
- ✅ Koristi **StoreKit Configuration File** (`Products.storekit`)
- ✅ Lokalni fajl u Xcode projektu
- ✅ Ne treba App Store Connect
- ✅ Ne treba Sandbox Test Account
- ✅ Radi odmah bez dodatne konfiguracije

### Fizički Uređaj:
- ❌ **NE koristi** `Products.storekit` fajl
- ✅ Koristi **App Store Connect Sandbox**
- ✅ Mora biti povezan sa internetom
- ✅ Moraš biti **sign out** sa App Store-a
- ✅ Moraš koristiti **Sandbox Test Account**

---

## ⚠️ Problem: Simulator ≠ Fizički Uređaj

**Simulator koristi lokalni fajl, fizički uređaj koristi App Store Connect!**

---

## 🔧 Rešenje za Fizički Uređaj

### KORAK 1: Proveri App Store Connect

1. **Idi na:** https://appstoreconnect.apple.com
2. **Tvoja aplikacija → In-App Purchases**
3. **Proveri da li su svi proizvodi:**
   - ✅ Kreirani
   - ✅ "Ready to Submit" ili "Approved"
   - ✅ Product ID se tačno poklapa sa kodom

### KORAK 2: Proveri RevenueCat Dashboard

1. **Idi na:** https://app.revenuecat.com
2. **Products → Sync Products** (sačekaj 1-2 minuta)
3. **Entitlements → `premium` → Attach products**
4. **Offerings → Set Current Offering**

### KORAK 3: Sign Out sa App Store-a

**OBVEZNO!** Ako si prijavljena, Sandbox neće raditi.

1. **Settings → App Store**
2. **Klikni na Apple ID** (gore)
3. **Klikni "Sign Out"**
4. **Proveri da li je zaista sign out:**
   - Treba da piše "Sign In" umesto tvog Apple ID-a

### KORAK 4: Kreiraj Sandbox Test Account

1. **App Store Connect → Users and Access → Sandbox Testers**
2. **Klikni "+"**
3. **Unesi:**
   - Email: bilo koji (npr. `test123@gmail.com`)
   - Password: min 8 karaktera (npr. `test1234`)
   - First/Last Name: bilo šta
4. **Klikni "Save"**

### KORAK 5: Testiraj na Fizičkom Uređaju

1. **Sign out sa App Store-a** (Settings → App Store → Sign Out)
2. **Otvori aplikaciju** (iz TestFlight-a)
3. **Klikni na plan** (One Time, Monthly, Yearly)
4. **Sandbox prozor se pojavljuje?**
   - ✅ DA → Prijavi se sa Sandbox Test Account-om
   - ❌ NE → Proveri sign out ponovo

---

## 🐛 Česte Greške na Fizičkom Uređaju

### Greška 1: "Purchase cancelled or failed"
**Razlog:** Nisi sign out sa App Store-a
**Rešenje:** Settings → App Store → Sign Out

### Greška 2: Sandbox prozor se ne pojavljuje
**Razlog:** Prijavljena si sa pravim Apple ID-om
**Rešenje:** Sign out sa App Store-a

### Greška 3: "Product not available"
**Razlog:** Proizvod nije "Ready to Submit" u App Store Connect
**Rešenje:** App Store Connect → In-App Purchases → Submit for Review

### Greška 4: "Network error"
**Razlog:** Proizvodi nisu sinhronizovani sa RevenueCat
**Rešenje:** RevenueCat Dashboard → Products → Sync

---

## ✅ Checklist za Fizički Uređaj

- [ ] App Store Connect → In-App Purchases → "Ready to Submit"
- [ ] RevenueCat Dashboard → Products → Sinhronizovani
- [ ] RevenueCat Dashboard → Entitlements → Attach-ovani
- [ ] RevenueCat Dashboard → Offerings → Current Offering postoji
- [ ] App Store Connect → Sandbox Testers → Kreiran test account
- [ ] iPhone → Settings → App Store → **Sign Out**
- [ ] iPhone → Settings → Screen Time → In-App Purchases: ON
- [ ] Test na fonu → Sandbox prozor se pojavljuje

---

## 💡 Zašto Radi na Simulatoru?

**Simulator koristi lokalni `Products.storekit` fajl:**
- Ne treba App Store Connect
- Ne treba Sandbox Test Account
- Ne treba sign out
- Radi odmah

**Fizički uređaj koristi App Store Connect Sandbox:**
- Mora biti povezan sa internetom
- Mora biti sign out sa App Store-a
- Mora koristiti Sandbox Test Account
- Mora biti sve konfigurisano u App Store Connect

---

## 🎯 Finalni Savet

**Ako radi na simulatoru ali ne na telefonu:**
1. Proveri da li si **sign out** sa App Store-a
2. Proveri da li su proizvodi **"Ready to Submit"** u App Store Connect
3. Proveri da li su proizvodi **sinhronizovani** sa RevenueCat
4. Proveri da li postoji **Sandbox Test Account**
5. **Sačekaj 10-15 minuta** nakon izmena (može potrajati da se sinhronizuje)

**Simulator ≠ Fizički Uređaj!** To je normalno i očekivano.

