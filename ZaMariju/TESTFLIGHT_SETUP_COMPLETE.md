# 🚀 Kompletan Vodič: Kako da Radi u TestFlight-u

## ✅ Šta Znamo

- ✅ **Simulator radi** (koristi `Products.storekit` lokalni fajl)
- ❌ **TestFlight ne radi** (koristi App Store Connect Sandbox)
- ✅ **Problem:** Prvi in-app purchase mora biti submit-ovan sa verzijom aplikacije

---

## 📋 KORAK PO KORAK - Submit Verziju sa In-App Purchases

### KORAK 1: Proveri da li Su Proizvodi "Ready to Submit"

1. **Idi na App Store Connect:**
   - https://appstoreconnect.apple.com
   - **My Apps** → izaberi aplikaciju

2. **Proveri In-App Purchases:**
   - **Features** → **In-App Purchases**
   - Proveri da li su svi proizvodi **"Ready to Submit"**:
     - ✅ `one_time_purchase`
     - ✅ `monthly_subscription`
     - ✅ `yearly_subscription`

3. **Ako nisu "Ready to Submit":**
   - Klikni na proizvod
   - Popuni sve obavezne informacije
   - Klikni **"Save"** → **"Submit for Review"**

---

### KORAK 2: Kreiraj Novu Verziju Aplikacije

1. **App Store Connect → My Apps → Tvoja aplikacija**

2. **Kreiraj Novu Verziju:**
   - Klikni na **"+"** pored verzija (ili "Add Version")
   - Unesi verziju (npr. `1.0.0` ako je prva verzija)
   - Klikni **"Create"**

---

### KORAK 3: Dodaj In-App Purchases u Verziju

1. **Na stranici verzije:**
   - Scroll down do **"In-App Purchases and Subscriptions"** sekcije
   - Klikni **"+"** ili **"Add"**

2. **Izaberi In-App Purchases:**
   - Checkbox pored svakog proizvoda:
     - ✅ `one_time_purchase`
     - ✅ `monthly_subscription`
     - ✅ `yearly_subscription`
   - Klikni **"Add"** ili **"Done"**

---

### KORAK 4: Popuni Obavezne Informacije

**Ako je prvi put, moraš popuniti:**

1. **App Information:**
   - Name
   - Subtitle (opciono)
   - Category
   - Privacy Policy URL

2. **Version Information:**
   - What's New in This Version
   - Screenshots (obavezno za prvi put)
   - Description
   - Keywords
   - Support URL
   - Marketing URL (opciono)

3. **Pricing and Availability:**
   - Price
   - Availability

---

### KORAK 5: Upload IPA (Ako Nisi)

**Ako već imaš IPA upload-ovan, preskoči ovaj korak.**

1. **Build-uj IPA:**
   ```bash
   cd /Users/m1/Documents/myChatEra/ZaMariju
   flutter build ipa --release --export-options-plist=ios/ExportOptions.plist
   ```

2. **Upload IPA:**
   - Otvori **Transporter** aplikaciju
   - Drag & drop `build/ios/ipa/Runner.ipa`
   - Sačekaj da se upload-uje

---

### KORAK 6: Submit Verziju za Review

1. **Scroll do kraja stranice verzije**

2. **Proveri da li je sve popunjeno:**
   - ✅ App Information
   - ✅ Version Information
   - ✅ Screenshots (ako je prvi put)
   - ✅ In-App Purchases su dodati

3. **Klikni "Submit for Review"**

4. **Potvrdi submit**

---

## ⏰ Timeline

### Odmah Nakon Submit-a:
- ✅ Verzija je u statusu **"Waiting for Review"**
- ✅ In-app purchases su u statusu **"Waiting for Review"**
- ⚠️ **Možda će raditi u Sandbox-u** (neki proizvodi rade čim su submit-ovani)

### Nakon Review-a (1-3 dana):
- ✅ Verzija je **"Approved"**
- ✅ In-app purchases su **"Approved"**
- ✅ **Sigurno će raditi u Sandbox-u**

---

## 🧪 Testiranje u TestFlight-u

### Nakon Submit-a (Možda Odmah):

1. **Sačekaj 10-15 minuta** (da se sinhronizuje)

2. **Sign Out sa App Store-a:**
   - Settings → App Store → klikni na Apple ID → Sign Out

3. **Otvori aplikaciju iz TestFlight-a**

4. **Klikni na plan** (One Time, Monthly, Yearly)

5. **Sandbox prozor se pojavljuje?**
   - ✅ DA → Prijavi se sa Sandbox Test Account-om
   - ❌ NE → Sačekaj review (1-3 dana)

---

## ✅ Checklist

### Pre Submit-a:
- [ ] Svi in-app purchases su **"Ready to Submit"**
- [ ] Kreirana nova verzija aplikacije
- [ ] Svi in-app purchases su **dodati u verziju**
- [ ] Svi obavezni podaci su popunjeni
- [ ] IPA je upload-ovan (ako je prvi put)
- [ ] Screenshots su dodati (ako je prvi put)

### Nakon Submit-a:
- [ ] Verzija je u statusu **"Waiting for Review"**
- [ ] In-app purchases su u statusu **"Waiting for Review"**
- [ ] Sačekaj 10-15 minuta
- [ ] Testiraj u TestFlight-u

### Za TestFlight Testiranje:
- [ ] Sign out sa App Store-a
- [ ] Sandbox Test Account kreiran
- [ ] Otvori aplikaciju iz TestFlight-a
- [ ] Klikni na plan
- [ ] Sandbox prozor se pojavljuje

---

## 🐛 Ako Ne Radi Odmah

### Problem: Sandbox prozor se ne pojavljuje
**Rešenje:**
1. Proveri da li si sign out sa App Store-a
2. Sačekaj 10-15 minuta nakon submit-a
3. Ako i dalje ne radi, sačekaj review (1-3 dana)

### Problem: "Purchase cancelled or failed"
**Rešenje:**
1. Proveri da li su proizvodi submit-ovani
2. Proveri da li si sign out sa App Store-a
3. Proveri Sandbox Test Account

---

## 💡 Savet

**Submit-uj sve 3 proizvoda odjednom:**
- `one_time_purchase`
- `monthly_subscription`
- `yearly_subscription`

Tako će svi biti odobreni zajedno i ne moraš submit-ovati jedan po jedan.

---

## 🎯 Finalni Koraci

1. **Submit-uj verziju sa in-app purchases** (DANAS)
2. **Sačekaj 10-15 minuta** (možda će raditi odmah)
3. **Testiraj u TestFlight-u**
4. **Ako ne radi, sačekaj review** (1-3 dana)
5. **Nakon odobrenja, sigurno će raditi!**

---

## ✅ Rezultat

**Nakon submit-a i review-a:**
- ✅ TestFlight će raditi kao simulator
- ✅ Sandbox prozor će se pojavljivati
- ✅ Sve će raditi normalno

**Simulator = TestFlight** (nakon submit-a i review-a)

