# 📱 Sledeći Koraci - Google Play Console

## ✅ Šta si već uradio:
- [x] Kreirao Developer account
- [x] Kreirao aplikaciju
- [x] Postavio cenu na "Besplatno"

---

## 🎯 Sledeći Koraci (Redosled):

### **KORAK 1: Kreiraj Subscription Proizvode** ⭐ (PRVO!)

**Zašto prvo?**
- Subscription proizvodi moraju biti kreirani pre nego što upload-uješ aplikaciju
- RevenueCat će moći da ih detektuje tek kada postoje u Google Play Console

**Kako:**

1. **U Google Play Console:**
   - Idi na: **Monetize → Products → Subscriptions**
   - Klikni **"+ Create subscription"** (ili **"+ Kreiraj pretplatu"**)

2. **Kreiraj 3 proizvoda:**

   **Proizvod 1: One-Time Purchase**
   - **Product ID:** `one_time_purchase`
   - **Name:** `Premium Lifetime Access`
   - **Description:** `Get lifetime access to premium analysis features`
   - **Price:** `$9.99` (ili izaberi valutu)
   - **Billing period:** `One-time payment`
   - Klikni **"Save"**

   **Proizvod 2: Monthly Subscription**
   - **Product ID:** `monthly_subscription`
   - **Name:** `Premium Monthly`
   - **Description:** `Get premium analysis features for one month`
   - **Price:** `$4.99`
   - **Billing period:** `Monthly`
   - **Free trial:** `None` (ili 7 dana ako želiš)
   - **Grace period:** `3 days` (dodatno vreme nakon neuspešnog plaćanja)
   - Klikni **"Save"**

   **Proizvod 3: Yearly Subscription**
   - **Product ID:** `yearly_subscription`
   - **Name:** `Premium Yearly`
   - **Description:** `Get premium analysis features for one year (67% savings!)`
   - **Price:** `$19.99`
   - **Billing period:** `Yearly`
   - **Free trial:** `None` (ili 14 dana ako želiš)
   - **Grace period:** `3 days`
   - Klikni **"Save"**

3. **Proveri da li su svi proizvodi kreirani:**
   - Trebalo bi da vidiš 3 proizvoda u listi
   - Status: **"Active"** (ili **"Aktivan"**)

---

### **KORAK 2: Pripremi Store Listing**

**Šta treba:**

1. **App Details:**
   - Idi na: **Store presence → Main store listing**
   - **Short description:** (max 80 karaktera)
     - Primer: `Discover your ChatGPT personality with AI-powered analysis`
   - **Full description:** (max 4000 karaktera)
     - Opis aplikacije, features, kako funkcioniše
   - **App icon:** (512x512 PNG)
   - **Feature graphic:** (1024x500 PNG)

2. **Screenshots:**
   - Idi na: **Store presence → Main store listing → Screenshots**
   - **Phone:** (min 2, max 8)
     - Format: 16:9 ili 9:16
     - Primer: 1080x1920 (portrait) ili 1920x1080 (landscape)
   - **Tablet:** (opciono)

3. **Privacy Policy:**
   - Idi na: **Store presence → Main store listing → Privacy Policy**
   - **URL:** (mora biti javno dostupan)
   - Možeš koristiti:
     - GitHub Pages
     - Netlify
     - Tvoj sajt
   - Primer: `https://yourusername.github.io/privacy-policy`

4. **Content Rating:**
   - Idi na: **Store presence → Content rating**
   - Popuni upitnik
   - Dobij rating (obično "Everyone")

---

### **KORAK 3: Build Android App Bundle (AAB)**

**Kako:**

1. **Otvori terminal/command prompt:**
   ```bash
   cd ZaMariju
   ```

2. **Build AAB:**
   ```bash
   flutter build appbundle --release
   ```

3. **Fajl će biti u:**
   ```
   ZaMariju/build/app/outputs/bundle/release/app-release.aab
   ```

4. **Proveri da li fajl postoji:**
   - Trebalo bi da vidiš `app-release.aab` fajl
   - Veličina: ~20-50 MB (zavisi od aplikacije)

---

### **KORAK 4: Upload AAB u Google Play Console**

**Kako:**

1. **U Google Play Console:**
   - Idi na: **Production → Create new release** (ili **"Kreiraj novo izdanje"**)

2. **Upload AAB:**
   - Klikni **"Upload"** (ili **"Otpremi"**)
   - Odaberi `app-release.aab` fajl
   - Sačekaj da se upload završi (1-5 minuta)

3. **Release notes:**
   - **What's new in this release:**
     ```
     Initial release of GPT Wrapped
     - Analyze your ChatGPT conversations
     - Discover your personality insights
     - Premium features available
     ```

4. **Klikni "Save"** (ili **"Sačuvaj"**)

---

### **KORAK 5: Proveri Sve Pre Submit-a**

**Checklist:**

- [ ] ✅ Subscription proizvodi kreirani (3 proizvoda)
- [ ] ✅ Store listing kompletan (opis, screenshots, itd.)
- [ ] ✅ Privacy Policy postavljen
- [ ] ✅ Content rating završen
- [ ] ✅ AAB upload-ovan
- [ ] ✅ Release notes dodati

---

### **KORAK 6: Submit za Review**

**Kako:**

1. **U Google Play Console:**
   - Idi na: **Production → Review**
   - Proveri da li sve je u redu (zelene checkmark-ove)

2. **Klikni "Start rollout to Production"** (ili **"Pokreni objavu u produkciji"**)

3. **Potvrdi:**
   - Pročitaćeš neke informacije
   - Klikni **"Confirm"** (ili **"Potvrdi"**)

4. **Status će biti:**
   - **"Pending review"** (ili **"Na čekanju"**)
   - Review obično traje **1-3 dana**

---

## ⏱️ Timeline

- **Kreiranje proizvoda:** 10-15 minuta
- **Store listing:** 1-2 sata (ako već imaš screenshots)
- **Build AAB:** 5-10 minuta
- **Upload:** 5-10 minuta
- **Review:** 1-3 dana

---

## 🎯 Šta Dalje?

**Dok čekaš review:**

1. **Pripremi iOS verziju** (ako planiraš)
2. **Setup RevenueCat** (poveži sa Google Play Console)
3. **Setup Firebase** (ako već nisi)
4. **Testiraj aplikaciju** lokalno

**Nakon odobrenja:**

1. Postavi `USE_FAKE_VERSION=false` u backend
2. Redeploy backend
3. App automatski prelazi na web view login! 🎉

---

## ❓ Pitanja?

Ako imaš problema:
- Proveri da li su svi proizvodi kreirani
- Proveri da li je AAB upload-ovan
- Proveri da li je Store listing kompletan

**Sledeći korak: KORAK 1 - Kreiraj Subscription Proizvode! 🚀**
