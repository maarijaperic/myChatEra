# 📱 Fix Sandbox na Fizičkom Uređaju

## ⚠️ Problem: "Purchase cancelled or failed" na fizičkom telefonu

Na fizičkom telefonu, `Products.storekit` se **NE KORISTI**. Treba da koristiš **App Store Connect Sandbox**.

---

## 🔧 KORAK 1: Proveri App Store Connect

### 1.1. Proveri da li su Proizvodi Kreirani

1. Idi na https://appstoreconnect.apple.com
2. **My Apps** → izaberi aplikaciju
3. **Features** → **In-App Purchases**
4. Proveri da li postoje:
   - ✅ `one_time_purchase`
   - ✅ `monthly_subscription`
   - ✅ `yearly_subscription`

### 1.2. Proveri Status Proizvoda

Svaki proizvod mora biti:
- ✅ **Status:** "Ready to Submit" ili "Approved"
- ✅ **Product ID:** Mora se poklapati sa onim u kodu
- ✅ **Price:** Postavljen

**Ako nisu "Ready to Submit":**
- Klikni na proizvod
- Popuni sve obavezne informacije
- Klikni **"Save"** → **"Submit for Review"**

---

## 🔧 KORAK 2: Kreiraj Sandbox Test Account

### 2.1. U App Store Connect

1. **Users and Access** → **Sandbox Testers** tab
2. Klikni **+** da kreiraš novi test account
3. Unesi:
   - **Email:** bilo koji email (npr. `test@example.com`)
   - **Password:** min 8 karaktera
   - **First Name:** bilo šta
   - **Last Name:** bilo šta
   - **Country/Region:** izaberi zemlju

### 2.2. Prijavi se na Fonu sa Sandbox Account-om

**VAŽNO:** Ne možeš koristiti isti Apple ID koji koristiš za App Store Connect!

1. Na iPhone-u, **Settings** → **App Store**
2. **Sign Out** (ako si prijavljen)
3. **NE PRIJAVLJUJ SE** sa tvojim glavnim Apple ID-om
4. Kada pokušaš da kupiš u aplikaciji, pojaviće se sandbox prozor
5. Prijavi se sa **Sandbox Test Account**-om koji si kreirao

---

## 🔧 KORAK 3: Proveri RevenueCat Dashboard

### 3.1. Proveri Products Sync

1. Idi na https://app.revenuecat.com
2. Tvoj projekat → **Products**
3. Proveri da li su svi proizvodi sinhronizovani:
   - ✅ `one_time_purchase`
   - ✅ `monthly_subscription`
   - ✅ `yearly_subscription`

**Ako nisu sinhronizovani:**
- Klikni **"Sync Products"** ili **"Refresh"**
- Sačekaj nekoliko minuta

### 3.2. Proveri Offerings

1. **Offerings** → **Current Offering**
2. Proveri da li su svi paketi dodati:
   - ✅ `$rc_annual` (yearly_subscription)
   - ✅ `$rc_monthly` (monthly_subscription)
   - ✅ `one_time` (one_time_purchase)

---

## 🔧 KORAK 4: Proveri Device Settings

### 4.1. Proveri In-App Purchases

1. **Settings** → **Screen Time** → **Content & Privacy Restrictions**
2. Proveri da li su **In-App Purchases** dozvoljeni

### 4.2. Proveri App Store Settings

1. **Settings** → **App Store**
2. Proveri da li je **In-App Purchases** uključeno

---

## 🔧 KORAK 5: Test na Fizičkom Uređaju

### 5.1. Priprema

1. **Sign Out** sa App Store-a na fonu
2. **NE PRIJAVLJUJ SE** sa glavnim Apple ID-om
3. Otvori aplikaciju

### 5.2. Pokušaj Kupovinu

1. Klikni na bilo koji plan
2. **Sandbox prozor će se pojaviti**
3. Prijavi se sa **Sandbox Test Account**-om
4. Kupovina bi trebalo da prođe

---

## 🐛 Troubleshooting

### Problem: "Purchase cancelled or failed"

**Uzrok:** Proizvodi nisu dostupni ili nisi prijavljen sa Sandbox account-om

**Rešenje:**
1. ✅ Proveri App Store Connect → In-App Purchases → Status "Ready to Submit"
2. ✅ Sign Out sa App Store-a na fonu
3. ✅ Pokušaj kupovinu → prijavi se sa Sandbox account-om
4. ✅ Proveri RevenueCat Dashboard → Products sync

### Problem: Sandbox prozor se ne pojavljuje

**Uzrok:** Prijavljen si sa glavnim Apple ID-om

**Rešenje:**
1. ✅ **Sign Out** sa App Store-a na fonu
2. ✅ Pokušaj kupovinu → sandbox prozor će se pojaviti
3. ✅ Prijavi se sa Sandbox Test Account-om

### Problem: "Product not available"

**Uzrok:** Proizvod nije kreiran ili nije "Ready to Submit"

**Rešenje:**
1. ✅ App Store Connect → In-App Purchases → kreiraj proizvod
2. ✅ Popuni sve obavezne informacije
3. ✅ Submit for Review
4. ✅ Sačekaj da bude "Ready to Submit"

---

## ✅ Checklist

- [ ] App Store Connect → In-App Purchases → svi proizvodi su "Ready to Submit"
- [ ] App Store Connect → Sandbox Testers → kreiran test account
- [ ] RevenueCat Dashboard → Products → svi proizvodi su sinhronizovani
- [ ] RevenueCat Dashboard → Offerings → svi paketi su dodati
- [ ] iPhone Settings → App Store → Sign Out
- [ ] Test na fonu → prijavi se sa Sandbox account-om kada se pojavi prozor

---

## 📝 Napomene

- **Fizički uređaj:** Koristi App Store Connect Sandbox (NE Products.storekit)
- **Sandbox Test Account:** Mora biti drugačiji od glavnog Apple ID-a
- **Sign Out:** Obavezno sign out sa App Store-a pre testiranja
- **Products.storekit:** Radi samo u Simulatoru, ne na fizičkom uređaju

