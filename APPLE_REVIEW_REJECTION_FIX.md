# 🔧 Apple Review Rejection - ŠTA TREBA DA SREDIŠ

## ❌ PROBLEMI IZ REVIEW-A:

1. **Promotional Image** - isti kao app icon
2. **App Name Mismatch** - Marketplace: "MyChatEra AI", Device: "Gpt Wrapped2"
3. **Terms of Use (EULA) Missing** - nedostaje link u App Description
4. **IAP Purchase Bug** - greška pri purchase-u premium planova

---

## ✅ 1. PROMOTIONAL IMAGE (2 min)

**Problem:** Promotional image je isti kao app icon.

**Rešenje - OBRISI Promotional Image (najjednostavnije):**

1. **App Store Connect → My Apps → MyChatEra AI**
2. **Features → In-App Purchases**
3. **Klikni na IAP koji ima promotional image** (verovatno `monthly_subscription` ili `yearly_subscription`)
4. **Scroll do "Promotional Image" sekcije**
5. **Klikni "Remove" ili "Delete"**
6. **Save**

**Alternativa - Kreiraj novi promotional image (ako želiš da promovišeš):**
- Format: PNG ili JPEG
- Rezolucija: 1200 x 1200 pixels (ili veća)
- Moraju biti D RUŽIČNI od app icon-a
- Treba da prikazuje šta IAP omogućava (npr. premium features ekran)

---

## ✅ 2. APP NAME MISMATCH (VEĆ SREDJENO U KODU - TREBA NOVI BUILD!)

**Problem:** 
- Marketplace: "MyChatEra AI"
- Device: "Gpt Wrapped2"

**Status:** ✅ **Već je popravljeno u `ios/Runner/Info.plist`** - `CFBundleDisplayName` je "MyChatEra AI"

**MORAŠ DA URADIŠ:**
1. **Build novi IPA:**
   ```bash
   cd ~/Documents/myChatEra/ZaMariju
   flutter clean
   flutter pub get
   flutter build ipa --export-options-plist=ios/ExportOptions.plist
   ```

2. **Upload novi IPA u App Store Connect**
3. **Izaberi novi build u App Store submission-u**

---

## ✅ 3. TERMS OF USE (EULA) LINK ⚠️ OBAVEZNO!

**Problem:** Nedostaje link na Terms of Use u App Description ili EULA polje.

**Rešenje - DODAJ LINK U APP DESCRIPTION:**

### Opcija 1: Dodaj u App Description (najjednostavnije)

1. **App Store Connect → My Apps → MyChatEra AI**
2. **App Store tab → Klikni na verziju (1.0.0)**
3. **Scroll do "Description" sekcije**
4. **Na kraju description-a, DODAJ:**

```
Terms of Use: https://github.com/maarijaperic/myChatEra-legal/blob/main/TERMS_OF_SERVICE.md
Privacy Policy: https://github.com/maarijaperic/myChatEra-legal/blob/main/PRIVACY_POLICY.md
```

**ILI koristi Apple's Standard EULA:**
```
Terms of Use: https://www.apple.com/legal/internet-services/itunes/dev/stdeula/
```

### Opcija 2: Upload Custom EULA u App Store Connect

1. **App Store Connect → My Apps → MyChatEra AI**
2. **App Information** (u levom meniju)
3. **Scroll do "EULA" sekcije**
4. **Klikni "Edit" ili "Add EULA"**
5. **Upload EULA fajl ILI unesi tekst direktno**

**Preporuka:** Koristi Opciju 1 (dodaj u Description) jer je najbrže i Apple prihvata to.

---

## ✅ 4. IAP PURCHASE BUG ⚠️ TESTIRAJ!

**Problem:** Greška pri purchase-u premium planova.

**Ovo može biti zbog:**
1. RevenueCat nije pravilno konfigurisan
2. Sandbox account problem
3. IAP products nisu pravilno setup-ovani
4. Paid Apps Agreement nije prihvaćen

**Rešenje - Proveri sledeće:**

### 4.1 Proveri Paid Apps Agreement

1. **App Store Connect → Agreements, Tax, and Banking**
2. **Proveri "Paid Apps Agreement":**
   - [ ] Status: "Active" ili "In Effect"
   - [ ] Ako nije, prihvati ga

### 4.2 Proveri IAP Products u App Store Connect

1. **App Store Connect → My Apps → MyChatEra AI**
2. **Features → In-App Purchases**
3. **Proveri svaki IAP:**
   - [ ] `one_time_purchase` - Status: "Ready to Submit" ili "Approved"
   - [ ] `monthly_subscription` - Status: "Ready to Submit" ili "Approved"
   - [ ] `yearly_subscription` - Status: "Ready to Submit" ili "Approved"

### 4.3 Proveri RevenueCat Setup

1. **RevenueCat Dashboard → Products**
2. **Proveri da su products povezani sa App Store Connect:**
   - [ ] Products imaju "Synced" status
   - [ ] Entitlement `premium` je povezan sa products

### 4.4 Testiraj u Sandbox (ako imaš fizički uređaj)

1. **Kreiraj Sandbox Tester:**
   - App Store Connect → Users and Access → Sandbox Testers
   - Klikni "+" da kreiraš novog testera
   
2. **Testiraj na fizičkom uređaju:**
   - Odjavi se sa App Store-a na uređaju
   - Pokušaj da kupiš premium plan
   - Uloguj se sa Sandbox account-om kada Apple traži

**NAPOMENA:** Apple kaže "In-App Purchase products do not need prior approval to function in review" - znači da IAP-ovi treba da rade u sandbox-u tokom review-a. Greška verovatno dolazi iz app-a ili RevenueCat setup-a.

### 4.5 Proveri kod - RevenueCat Initialization

Proveri da li je RevenueCat pravilno inicijalizovan u kodu:

```dart
// Proveri da RevenueCat API key postoji
// Proveri da products su pravilno konfigurisani
// Proveri da purchase flow nema greške
```

**Ako i dalje imaš problem:**
- Proveri RevenueCat log-ove
- Proveri da li su IAP product ID-evi tačni u kodu
- Proveri da li RevenueCat entitlement koristiš pravilno

---

## 📋 FINALNI CHECKLIST PRE RESUBMISSION-A:

### Promotional Image:
- [ ] Promotional image je obrisan ILI zamenjen jedinstvenim image-om

### App Name:
- [ ] Novi IPA je build-ovan (sa "MyChatEra AI" u Info.plist)
- [ ] Novi IPA je upload-ovan
- [ ] Novi build je izabran u submission-u

### Terms of Use:
- [ ] Link na Terms of Use je dodat u App Description ILI
- [ ] Custom EULA je upload-ovan u App Information

### IAP Purchase Bug:
- [ ] Paid Apps Agreement je prihvaćen i "Active"
- [ ] Svi IAP products su "Ready to Submit" ili "Approved"
- [ ] RevenueCat products su sync-ovani sa App Store Connect
- [ ] Testirano u sandbox-u (ako je moguće)

### General:
- [ ] Sve sekcije su popunjene
- [ ] Build je izabran
- [ ] Svi IAP-ovi su navedeni u submission-u
- [ ] "Submit for Review" je kliknuto

---

## 🎯 PRIORITETI (Šta prvo):

1. **Terms of Use link** - Dodaj u Description (2 min)
2. **Promotional Image** - Obriši (2 min)
3. **Build novi IPA** - Za app name fix (15-30 min)
4. **Proveri Paid Apps Agreement** - (2 min)
5. **Test IAP flow** - Ako možeš (10-20 min)

---

## ⚠️ VAŽNE NAPOMENE:

1. **App Name:** Možda ćeš morati da rebuild-uješ app jer Apple review-uje binary koji je upload-ovan. Ako si već promenio Info.plist, samo rebuild-uj i upload-uj novi IPA.

2. **Terms of Use:** Najlakše je dodati link u App Description. Apple prihvata i to.

3. **IAP Bug:** Ako je greška u sandbox-u, verovatno je problem u kodu ili RevenueCat setup-u. Proveri log-ove.

4. **Promotional Image:** Najjednostavnije je obrisati ako ne planiraš da promovišeš IAP-ove. Možeš uvek dodati kasnije.

---

## 📞 NAKON POPRAVKE:

1. **Submit za Review ponovo**
2. **Sačekaj 1-3 dana** za Apple review
3. **Proveri status** u App Store Connect

**Srećno! 🚀**

