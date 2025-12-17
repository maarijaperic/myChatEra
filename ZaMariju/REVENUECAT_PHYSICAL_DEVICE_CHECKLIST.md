# ✅ RevenueCat Physical Device Checklist

## 🔍 Proveri Ovo Pre Testiranja

### 1. App Store Connect ✅

- [ ] **In-App Purchases** → svi proizvodi su kreirani:
  - `one_time_purchase`
  - `monthly_subscription`
  - `yearly_subscription`

- [ ] **Status proizvoda** → svi su **"Ready to Submit"** ili **"Approved"**

- [ ] **Product ID-ovi** → poklapaju se sa onima u kodu:
  - `one_time_purchase`
  - `monthly_subscription`
  - `yearly_subscription`

- [ ] **Sandbox Testers** → kreiran test account:
  - Email: bilo koji (npr. `test@example.com`)
  - Password: min 8 karaktera

### 2. RevenueCat Dashboard ✅

- [ ] **Products** → svi proizvodi su sinhronizovani:
  - `one_time_purchase`
  - `monthly_subscription`
  - `yearly_subscription`

- [ ] **Entitlements** → `premium` entitlement postoji:
  - Identifier: `premium`
  - Attached products: svi 3 proizvoda su attach-ovani

- [ ] **Offerings** → Current Offering postoji:
  - Identifier: bilo koji (npr. `default` ili `one_time`)
  - Packages: svi paketi su dodati:
    - `$rc_annual` (yearly_subscription)
    - `$rc_monthly` (monthly_subscription)
    - `one_time` (one_time_purchase)

### 3. iPhone Settings ✅

- [ ] **App Store** → Sign Out (obavezno!)
  - Settings → App Store → klikni na Apple ID → Sign Out
  - ILI Settings → [Tvoje Ime] → Media & Purchases → Sign Out

- [ ] **Screen Time** → Content & Privacy Restrictions:
  - In-App Purchases: dozvoljeno

- [ ] **App Store** → In-App Purchases: uključeno

### 4. Test na Fizičkom Uređaju ✅

- [ ] Sign out sa App Store-a
- [ ] Otvori aplikaciju
- [ ] Klikni na plan
- [ ] Sandbox prozor se pojavljuje
- [ ] Prijavi se sa Sandbox Test Account-om
- [ ] Kupovina prolazi

---

## 🐛 Ako I Dalje Ne Radi

### Proveri Logove

Kada pokušaš kupovinu, proveri logove za:

1. **"Product is not available"** → Proizvod nije "Ready to Submit"
2. **"Product not found in offerings"** → Proizvod nije sinhronizovan sa RevenueCat
3. **"No current offering found"** → Offerings nisu konfigurisani u RevenueCat
4. **"Purchase not allowed"** → Parental controls ili In-App Purchases disabled
5. **"User cancelled"** → Korisnik je otkazao (možda nije prijavljen sa Sandbox account-om)

### Najčešći Problemi

1. **Nisi sign out sa App Store-a**
   - → Sign out i probaj ponovo

2. **Proizvodi nisu "Ready to Submit"**
   - → App Store Connect → In-App Purchases → Submit for Review

3. **Proizvodi nisu sinhronizovani sa RevenueCat**
   - → RevenueCat Dashboard → Products → Sync/Refresh

4. **Entitlement nije attach-ovan**
   - → RevenueCat Dashboard → Entitlements → `premium` → Attach products

5. **Offerings nisu konfigurisani**
   - → RevenueCat Dashboard → Offerings → Create/Edit Current Offering

---

## 📝 Debug Komande

Kada testiraš, proveri logove za:

```
🔴 RevenueCat: Product [ID] - available: [true/false]
🔴 RevenueCat: Package products: [lista]
❌ RevenueCat: [greška]
```

Ako vidiš `available: false`, to znači da proizvod nije dostupan za kupovinu.

---

## ✅ Finalni Checklist

- [ ] App Store Connect → In-App Purchases → "Ready to Submit"
- [ ] RevenueCat Dashboard → Products → sinhronizovani
- [ ] RevenueCat Dashboard → Entitlements → `premium` attach-ovan
- [ ] RevenueCat Dashboard → Offerings → Current Offering postoji
- [ ] iPhone → Settings → App Store → Sign Out
- [ ] Test na fonu → Sandbox prozor se pojavljuje

