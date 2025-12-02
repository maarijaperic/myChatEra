# 💰 RevenueCat iOS Setup - Detaljni Koraci

## 🎯 PREGLED:

Trebamo konfigurisati RevenueCat za iOS sa istim product ID-ovima kao na Androidu.

---

## 📋 KORAK 1: Dodaj iOS App u RevenueCat

### **1.1. Idi na RevenueCat Dashboard**

1. **Idi na:** https://app.revenuecat.com/
2. **Uloguj se** sa svojim nalogom

---

### **1.2. Dodaj iOS App**

1. **U RevenueCat dashboard:**
   - Idi na: **Projects** → **Tvoj projekat**
   - Klikni na: **Apps** → **+ Add app**

2. **Unesi informacije:**
   - **Platform:** iOS
   - **App Name:** `MyChatEra AI`
   - **Bundle ID:** `com.mychatera` (ISTO KAO NA ANDROIDU!)
   - **App Store Connect Shared Secret:** (opciono, za webhooks)

3. **Klikni:** **Add app**

---

## 📋 KORAK 2: Konfiguriši Product ID-ove

### **2.1. Dodaj Products**

**Trebaju ti 3 proizvoda (ISTI KAO NA ANDROIDU!):**

#### **A. One-Time Purchase**

1. **U RevenueCat dashboard:**
   - Idi na: **Products** → **+ Add product**
   - **Product ID:** `one_time_purchase` (ISTO KAO NA ANDROIDU!)
   - **Type:** **Non-Consumable**
   - **Store:** **App Store Connect**
   - **App Store Connect Product ID:** `one_time_purchase`

2. **Klikni:** **Save**

#### **B. Monthly Subscription**

1. **Klikni:** **+ Add product**
2. **Unesi:**
   - **Product ID:** `monthly_subscription` (ISTO KAO NA ANDROIDU!)
   - **Type:** **Subscription**
   - **Store:** **App Store Connect**
   - **App Store Connect Product ID:** `monthly_subscription`
   - **Duration:** **1 month**

3. **Klikni:** **Save**

#### **C. Yearly Subscription**

1. **Klikni:** **+ Add product**
2. **Unesi:**
   - **Product ID:** `yearly_subscription` (ISTO KAO NA ANDROIDU!)
   - **Type:** **Subscription**
   - **Store:** **App Store Connect**
   - **App Store Connect Product ID:** `yearly_subscription`
   - **Duration:** **1 year**

3. **Klikni:** **Save**

---

### **2.2. Proveri da li su Product ID-ovi Isti**

**MORAJU biti isti na oba platforma:**

| Platform | Product ID |
|----------|------------|
| Android | `one_time_purchase` |
| iOS | `one_time_purchase` |
| Android | `monthly_subscription` |
| iOS | `monthly_subscription` |
| Android | `yearly_subscription` |
| iOS | `yearly_subscription` |

✅ **Svi product ID-ovi su isti!**

---

## 📋 KORAK 3: Konfiguriši RevenueCat API Key

### **3.1. Pronađi RevenueCat API Key**

1. **U RevenueCat dashboard:**
   - Idi na: **Projects** → **Tvoj projekat** → **API Keys**
   - Pronađi **Public API Key** za iOS

2. **Kopiraj API key** (izgleda kao: `appl_xxxxxxxxxxxxx`)

---

### **3.2. Dodaj u Codemagic Environment Variables**

1. **U Codemagic dashboard:**
   - Idi na: **App settings** → **Environment variables**
   - Dodaj:
     - `REVENUECAT_API_KEY` = `appl_xxxxxxxxxxxxx` (tvoj iOS API key)

2. **Ili možeš dodati direktno u `main.dart`:**

**Proveri `main.dart`:**
```dart
const String revenueCatApiKey = String.fromEnvironment(
  'REVENUECAT_API_KEY',
  defaultValue: 'YOUR_REVENUECAT_PUBLIC_KEY_HERE',
);
```

**Za iOS, možeš koristiti isti kod - samo dodaj environment variable u Codemagic!**

---

## 📋 KORAK 4: Proveri RevenueCat Integraciju

### **4.1. Proveri main.dart**

✅ **Već imaš:**
```dart
if (revenueCatApiKey != 'YOUR_REVENUECAT_PUBLIC_KEY_HERE') {
  await RevenueCatService.initialize(revenueCatApiKey);
}
```

---

### **4.2. Proveri RevenueCatService**

**Proveri da li `RevenueCatService` koristi iste product ID-ove:**

```dart
// Trebalo bi da koristi:
// - one_time_purchase
// - monthly_subscription
// - yearly_subscription
```

✅ **Ovo već postoji u kodu!**

---

## 📋 KORAK 5: Test RevenueCat na iOS

### **5.1. Build Test Build**

1. **Koristi Codemagic da build-uješ test build**
2. **Instaliraj na iOS uređaj** (preko TestFlight)
3. **Testiraj purchase flow**

---

### **5.2. Proveri da li Purchase Radi**

**Proveri:**
- ✅ One-time purchase radi
- ✅ Monthly subscription radi
- ✅ Yearly subscription radi
- ✅ Premium features su unlock-ovane nakon purchase-a

---

## ⚠️ VAŽNE NAPOMENE:

### **Product ID-ovi:**
- ✅ **MORAJU biti isti** na Androidu i iOS-u
- ✅ **MORAJU biti isti** u RevenueCat i App Store Connect

### **RevenueCat API Key:**
- ✅ **iOS ima svoj API key** (različit od Android-a)
- ✅ **Dodaj u Codemagic environment variables**

### **App Store Connect:**
- ✅ **Product ID-ovi moraju biti kreirani** u App Store Connect
- ✅ **MORAJU biti isti** kao u RevenueCat

---

## 📋 CHECKLIST:

- [ ] ✅ Dodana iOS app u RevenueCat
- [ ] ✅ Konfigurisani product ID-ovi (3 proizvoda)
- [ ] ✅ Provereno da su product ID-ovi isti kao na Androidu
- [ ] ✅ Dodat RevenueCat API key u Codemagic
- [ ] ✅ Proveren RevenueCatService kod
- [ ] ✅ Test-ovano purchase flow na iOS

---

## 🔗 KORISNI LINKOVI:

- **RevenueCat Dashboard:** https://app.revenuecat.com/
- **RevenueCat iOS Setup:** https://docs.revenuecat.com/docs/ios

---

## 🎯 REZIME:

**RevenueCat iOS setup je jednostavan:**

1. ✅ Dodaj iOS app u RevenueCat
2. ✅ Konfiguriši iste product ID-ove kao na Androidu
3. ✅ Dodaj RevenueCat API key u Codemagic
4. ✅ Test-uj purchase flow

**Sve je spremno! 💰**

---

**RevenueCat iOS setup je završen! 🚀**
