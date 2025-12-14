# 📦 Submit Prvi In-App Purchase sa Verzijom Aplikacije

## ⚠️ Problem

App Store Connect kaže:
> "Your first in-app purchase must be submitted with a new app version."

To znači da prvi in-app purchase **MORA** biti submit-ovan **SA VERZIJOM APLIKACIJE**, ne samostalno.

---

## 🔧 Kako da Submit-uješ Prvi In-App Purchase

### KORAK 1: Kreiraj Novu Verziju Aplikacije

1. **Idi na App Store Connect:**
   - https://appstoreconnect.apple.com
   - **My Apps** → izaberi aplikaciju

2. **Kreiraj Novu Verziju:**
   - Klikni na **"+"** pored verzija (ili "Add Version")
   - Unesi novu verziju (npr. `1.0.0` ako je prva verzija)
   - Klikni **"Create"**

---

### KORAK 2: Dodaj In-App Purchases u Verziju

1. **Na stranici verzije:**
   - Scroll down do **"In-App Purchases and Subscriptions"** sekcije
   - Klikni **"+"** ili **"Add"**

2. **Izaberi In-App Purchases:**
   - Checkbox pored svakog proizvoda koji želiš da submit-uješ:
     - ✅ `one_time_purchase`
     - ✅ `monthly_subscription`
     - ✅ `yearly_subscription`
   - Klikni **"Add"** ili **"Done"**

---

### KORAK 3: Submit Verziju za Review

1. **Popuni sve obavezne informacije:**
   - App Information
   - Pricing and Availability
   - Version Information
   - Screenshots (ako je prvi put)
   - Description
   - Keywords
   - Support URL
   - Marketing URL (opciono)

2. **Submit za Review:**
   - Scroll do kraja stranice
   - Klikni **"Submit for Review"**
   - Potvrdi da si proverio sve

---

## ⚠️ VAŽNO!

### Pre Submit-a:

- [ ] Svi in-app purchases su **"Ready to Submit"**
- [ ] Svi in-app purchases su **dodati u verziju**
- [ ] Svi obavezni podaci su popunjeni
- [ ] Screenshots su dodati (ako je prvi put)

### Nakon Submit-a:

- [ ] Verzija je u statusu **"Waiting for Review"**
- [ ] In-app purchases su u statusu **"Waiting for Review"**
- [ ] Sačekaj review (obično 1-3 dana)

---

## 🔍 Kako da Proveriš

### U App Store Connect:

1. **My Apps** → Tvoja aplikacija → **App Store** tab
2. **Verzija** → Proveri status
3. **In-App Purchases and Subscriptions** sekcija → Proveri da li su dodati

### Status Verzije:

- ✅ **"Ready to Submit"** → Možeš submit-ovati
- ⏳ **"Waiting for Review"** → Čeka review
- ✅ **"Approved"** → Odobreno!

---

## 📝 Napomene

### Prvi In-App Purchase:
- **MORA** biti submit-ovan sa verzijom aplikacije
- **NE MOŽE** biti submit-ovan samostalno

### Sledeći In-App Purchases:
- **MOGU** biti submit-ovani samostalno (nakon što je prvi odobren)
- **NE MORA** biti sa verzijom aplikacije

---

## 🎯 Checklist

- [ ] Kreirana nova verzija aplikacije
- [ ] Svi in-app purchases su dodati u verziju
- [ ] Svi obavezni podaci su popunjeni
- [ ] Submit-ovana verzija za review
- [ ] Status: "Waiting for Review"

---

## ⏰ Timeline

1. **Submit verzije:** Odmah
2. **Review proces:** 1-3 dana (obično)
3. **Nakon odobrenja:** In-app purchases će raditi u Sandbox-u

---

## 💡 Savet

**Ako je ovo prvi put:**
- Submit-uj sve 3 proizvoda odjednom (one_time, monthly, yearly)
- Tako će svi biti odobreni zajedno
- Ne moraš submit-ovati jedan po jedan

**Nakon odobrenja:**
- In-app purchases će raditi u Sandbox-u
- Možeš testirati na fizičkom uređaju
- Ne moraš čekati da aplikacija bude odobrena (samo in-app purchases)

---

## 🐛 Ako Ne Možeš da Submit-uješ

### Problem: "Missing required information"
**Rešenje:** Proveri da li su svi obavezni podaci popunjeni:
- App Information
- Version Information
- Screenshots (ako je prvi put)
- Description

### Problem: "In-app purchase not ready"
**Rešenje:** Proveri da li su svi in-app purchases "Ready to Submit"

### Problem: "Cannot submit without binary"
**Rešenje:** Upload-uj IPA fajl preko Transporter-a ili Xcode-a

---

## ✅ Finalni Koraci

1. **Submit-uj verziju sa in-app purchases**
2. **Sačekaj review** (1-3 dana)
3. **Nakon odobrenja, testiraj na fizičkom uređaju**
4. **Sandbox će raditi!**

