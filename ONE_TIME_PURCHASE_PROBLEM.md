# 🔧 One-Time Purchase Problem - Rešenje

## ❌ PROBLEM KOJI VIDIM:

**Status:** "Waiting for Review" ali **Localization je "Rejected"**

**Greške u lokalizaciji:**
1. **Display Name:** "One time Analysis" ❌
   - Treba: "One Time Analysis" (oba dela velikim slovima)
   
2. **Description:** "Unlock your premium analysis get access to all features" ❌
   - Nedostaje reč "and"
   - Treba: "Unlock your premium analysis **and** get access to all features"

---

## ✅ REŠENJE - Popravi Lokalizaciju (3 min)

### Korak 1: Popravi Display Name

1. **U IAP stranici, idi na "App Store Localization" sekciju**
2. **Klikni na "English (U.S.)" red** (ili edit dugme pored njega)
3. **Display Name:**
   - **OBRIŠI:** "One time Analysis"
   - **UNESI:** `One Time Analysis`
   - (Oba dela "One" i "Time" moraju biti velikim slovima!)

### Korak 2: Popravi Description

4. **U istom prozoru, Description polje:**
   - **OBRIŠI:** "Unlock your premium analysis get access to all features"
   - **UNESI:** `Unlock your premium analysis and get access to all premium features including MBTI personality insights.`
   
   **ILI kraće:**
   - `Get one-time access to premium analysis features. Unlock all premium insights with this single purchase.`

5. **Klikni "Save"**

### Korak 3: Proveri Status

6. **Nakon čuvanja, status bi trebalo da se promeni:**
   - "Rejected" → "Ready to Submit"

---

## 📤 SUBMISSION - DA LI MORA ODVOJENO?

### ❌ NE, NE MOŽEŠ ODVOJENO!

**Apple kaže:**
> "Your first in-app purchase must be submitted with a new app version"

**Šta ovo znači:**
- **Prvi IAP MORA** da se submit-uje **SA app binary-jem zajedno** u istom submission-u
- Ne možeš da submit-uješ IAP-ove bez binary-ja
- Ne možeš da submit-uješ IAP-ove odvojeno od aplikacije

**Kako da submit-uješ:**
1. **App Store Connect → My Apps → MyChatEra AI**
2. **App Store tab → Klikni na verziju (1.0.0)**
3. **Izaberi Build** (mora biti izabran!)
4. **Proveri "In-App Purchases" sekciju:**
   - Trebalo bi da vidiš sva tri IAP-a navedena:
     - ✅ `one_time_purchase`
     - ✅ `monthly_subscription`
     - ✅ `yearly_subscription`
5. **Proveri da su svi "Ready to Submit"**
6. **Klikni "Submit for Review"**
7. ✅ **Ovo submit-uje I app binary I sve IAP-ove ZAJEDNO!**

---

## 🧪 KAKO DA TESTIRAŠ IAP-OVE?

### Opcija 1: TestFlight (Preporučeno)

1. **Upload build u App Store Connect**
2. **Procesiraj u TestFlight**
3. **Instaliraj preko TestFlight na fizički uređaj**
4. **Testiraj purchase flow:**
   - Kada klikneš na purchase, Apple će tražiti Sandbox account
   - Uloguj se sa Sandbox tester account-om
   - Testiraj purchase (neće ti naplatiti stvarno)

### Opcija 2: Sandbox Tester Account

**Kreiraj Sandbox Tester:**
1. **App Store Connect → Users and Access → Sandbox Testers**
2. **Klikni "+"**
3. **Unesi:**
   - Email (mora biti unique, npr. `test1@example.com`)
   - Password
   - First Name / Last Name
4. **Save**

**Testiraj na fizičkom uređaju:**
1. **Odjavi se sa App Store-a** na iPhone-u/iPad-u
2. **Pokušaj da kupiš premium plan** u app-u
3. **Kada Apple traži login, unesi Sandbox tester email i password**
4. **Kupi proizvod** (neće naplatiti stvarno)

### Opcija 3: Simulator (Ograničeno)

- Možeš testirati purchase flow u simulatoru
- Ali RevenueCat i IAP-ovi ne rade uvek dobro u simulatoru
- **Preporučeno:** Koristi fizički uređaj sa TestFlight ili Sandbox

---

## ⚠️ VAŽNO O SUBMISSION-U:

### Prvi IAP = Mora sa binary-jem
- Apple zahteva da **prvi IAP** ide sa **prvom verzijom** aplikacije
- Ne možeš submit-ovati samo IAP bez binary-ja

### Dodatni IAP-ovi = Mogu odvojeno (posle)
- Nakon što je prvi IAP odobren sa aplikacijom
- Možeš submit-ovati dodatne IAP-ove odvojeno
- Ali i dalje treba da imaš validan build upload-ovan

### Review proces:
- Apple će testirati IAP-ove u **sandbox-u** tokom review-a
- Ne moraš da čekaš da IAP-ovi budu "Approved" pre nego što submit-uješ app
- Ali **svi IAP-ovi moraju biti "Ready to Submit"** kada submit-uješ app

---

## ✅ FINALNI CHECKLIST:

### Pre submission-a, proveri:

- [ ] **Display Name:** "One Time Analysis" (ne "One time")
- [ ] **Description:** Ima "and" i gramatički ispravan
- [ ] **Status:** "Ready to Submit" (ne "Rejected")
- [ ] **Sve tri IAP-a su "Ready to Submit":**
  - [ ] `one_time_purchase`
  - [ ] `monthly_subscription`
  - [ ] `yearly_subscription`
- [ ] **Build je izabran** u App Store submission-u
- [ ] **Sva tri IAP-a su navedena** u App Store submission-u
- [ ] **Submit za Review** je kliknuto (šalje i app i IAP-ove zajedno)

---

## 🎯 SAŽETAK:

1. **Popravi lokalizaciju:** Display Name i Description
2. **Status će se promeniti:** "Rejected" → "Ready to Submit"
3. **Submit IAP-ove SA binary-jem:** Ne možeš odvojeno, mora zajedno
4. **Testiraj u TestFlight/Sandbox:** Pre submission-a ako možeš

**Nakon što popraviš lokalizaciju i submit-uješ sve zajedno, biće OK! 🚀**

