# 🔧 Troubleshooting: Purchase Failed

## ❌ Problem: "Purchase cancelled or failed" iako si sign out-ovana

Ako si sign out-ovana ali i dalje ne radi, proveri sledeće:

---

## ✅ CHECKLIST - Proveri Sve Ovo

### 1. App Store Connect - In-App Purchases

- [ ] **Idi na:** https://appstoreconnect.apple.com → Tvoja aplikacija → In-App Purchases
- [ ] **Proveri da li su svi proizvodi kreirani:**
  - `one_time_purchase`
  - `monthly_subscription`
  - `yearly_subscription`
- [ ] **Proveri STATUS svakog proizvoda:**
  - ✅ Mora biti **"Ready to Submit"** ili **"Approved"**
  - ❌ Ako je "Waiting for Review" ili "Missing Metadata" → **Submit for Review**
- [ ] **Proveri Product ID:**
  - Mora se tačno poklapati sa kodom:
    - `one_time_purchase` (tačno ovako, bez razmaka)
    - `monthly_subscription`
    - `yearly_subscription`

---

### 2. RevenueCat Dashboard - Products

- [ ] **Idi na:** https://app.revenuecat.com → Tvoj projekat → Products
- [ ] **Proveri da li su svi proizvodi sinhronizovani:**
  - `one_time_purchase`
  - `monthly_subscription`
  - `yearly_subscription`
- [ ] **Ako nisu sinhronizovani:**
  - Klikni "Sync Products" ili "Refresh"
  - Sačekaj 1-2 minuta

---

### 3. RevenueCat Dashboard - Entitlements

- [ ] **Idi na:** Entitlements → `premium`
- [ ] **Proveri da li su svi 3 proizvoda attach-ovani:**
  - `one_time_purchase` → attach-ovan na `premium`
  - `monthly_subscription` → attach-ovan na `premium`
  - `yearly_subscription` → attach-ovan na `premium`
- [ ] **Ako nisu attach-ovani:**
  - Klikni na proizvod → Attach to Entitlement → `premium`

---

### 4. RevenueCat Dashboard - Offerings

- [ ] **Idi na:** Offerings
- [ ] **Proveri da li postoji Current Offering:**
  - Mora postojati Current Offering (označen sa ★)
- [ ] **Proveri da li su svi paketi dodati:**
  - `$rc_annual` (yearly_subscription)
  - `$rc_monthly` (monthly_subscription)
  - `one_time` (one_time_purchase)
- [ ] **Ako nisu dodati:**
  - Klikni na Current Offering → Add Package
  - Dodaj sve 3 paketa

---

### 5. iPhone Settings - Sign Out

- [ ] **Settings → App Store**
- [ ] **Klikni na Apple ID** (gore)
- [ ] **Klikni "Sign Out"**
- [ ] **Proveri da li je zaista sign out:**
  - Treba da piše "Sign In" umesto tvog Apple ID-a

---

### 6. iPhone Settings - Screen Time

- [ ] **Settings → Screen Time**
- [ ] **Content & Privacy Restrictions**
- [ ] **Proveri:**
  - In-App Purchases: **Dozvoljeno** (ON)
  - Ako je disabled, uključi ga

---

### 7. Sandbox Test Account

- [ ] **App Store Connect → Users and Access → Sandbox Testers**
- [ ] **Proveri da li postoji Sandbox Test Account:**
  - Email: bilo koji (npr. `test@example.com`)
  - Password: min 8 karaktera
- [ ] **Ako ne postoji, kreiraj ga:**
  - Klikni "+" → Unesi email, password, ime → Save

---

### 8. Test na Fizičkom Uređaju

- [ ] **Sign out sa App Store-a** (Settings → App Store → Sign Out)
- [ ] **Otvori aplikaciju** (iz TestFlight-a)
- [ ] **Klikni na plan** (One Time, Monthly, ili Yearly)
- [ ] **Sandbox prozor se pojavljuje?**
  - ✅ DA → Prijavi se sa Sandbox Test Account-om
  - ❌ NE → Proveri ponovo sign out

---

## 🔍 Debug - Šta Da Proveriš u Logovima

Kada pokušaš kupovinu, proveri logove za:

### Ako vidiš: "NO CURRENT OFFERING FOUND"
**Problem:** Offerings nisu konfigurisani u RevenueCat
**Rešenje:** RevenueCat Dashboard → Offerings → Set Current Offering

### Ako vidiš: "PRODUCT NOT FOUND IN OFFERINGS"
**Problem:** Proizvod nije u Current Offering paketima
**Rešenje:** RevenueCat Dashboard → Offerings → Current Offering → Add Package

### Ako vidiš: "PRODUCT NOT AVAILABLE"
**Problem:** Proizvod nije "Ready to Submit" u App Store Connect
**Rešenje:** App Store Connect → In-App Purchases → Submit for Review

### Ako vidiš: "PURCHASE NOT ALLOWED"
**Problem:** Parental controls ili In-App Purchases disabled
**Rešenje:** Settings → Screen Time → Content & Privacy Restrictions → In-App Purchases: ON

### Ako vidiš: "NETWORK ERROR"
**Problem:** Proizvodi nisu sinhronizovani ili network problem
**Rešenje:** 
1. RevenueCat Dashboard → Products → Sync
2. Proveri internet konekciju
3. Restart aplikacije

---

## 🎯 Najčešći Problemi

### Problem 1: Proizvodi nisu "Ready to Submit"
**Simptom:** "Product not available"
**Rešenje:** App Store Connect → In-App Purchases → Submit for Review

### Problem 2: Proizvodi nisu sinhronizovani sa RevenueCat
**Simptom:** "Product not found in offerings"
**Rešenje:** RevenueCat Dashboard → Products → Sync/Refresh

### Problem 3: Entitlement nije attach-ovan
**Simptom:** Kupovina prolazi ali nema premium
**Rešenje:** RevenueCat Dashboard → Entitlements → `premium` → Attach products

### Problem 4: Offerings nisu konfigurisani
**Simptom:** "No current offering found"
**Rešenje:** RevenueCat Dashboard → Offerings → Set Current Offering

### Problem 5: Nisi sign out sa App Store-a
**Simptom:** Sandbox prozor se ne pojavljuje
**Rešenje:** Settings → App Store → Sign Out

---

## 📝 Kada Sve Proveriš

1. **Build-uj novi IPA** sa novim logovanjem
2. **Upload na TestFlight**
3. **Testiraj ponovo**
4. **Proveri logove** - videćeš tačnu grešku

---

## 💡 Savet

Ako i dalje ne radi nakon svih provera:
1. **Sačekaj 10-15 minuta** (može potrajati da se sinhronizuje)
2. **Restart aplikacije**
3. **Restart iPhone-a**
4. **Proveri logove** - videćeš tačnu grešku sa novim logovanjem

