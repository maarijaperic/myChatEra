# 💳 Kako da Dodaš Billing Dozvolu - Google Play Console

## ⚠️ PROBLEM:

Google Play Console kaže:
> "Апликација још увек нема ниједан једнократни производ. Да бисте додали једнократне производе, треба да додате дозволу за ОБРАЧУН у APK и objavi novi apk"

**Šta to znači:**
- Google Play Console zahteva da aplikacija ima billing dependency u build.gradle pre nego što možeš kreirati proizvode
- Treba da rebuild-uješ aplikaciju sa billing dependency-jem
- Treba da upload-uješ novi AAB u Google Play Console

---

## ✅ REŠENJE:

### **KORAK 1: Dodaj Billing Dependency**

**Već sam dodao billing dependency u `build.gradle.kts`!** ✅

Fajl: `ZaMariju/android/app/build.gradle.kts`

Dodato:
```kotlin
dependencies {
    // Google Play Billing - required for in-app purchases
    implementation("com.android.billingclient:billing:6.1.0")
    implementation("com.android.billingclient:billing-ktx:6.1.0")
}
```

### **KORAK 2: Dodaj Billing Permission**

**Već sam dodao billing permission u `AndroidManifest.xml`!** ✅

Fajl: `ZaMariju/android/app/src/main/AndroidManifest.xml`

Dodato:
```xml
<uses-permission android:name="com.android.vending.BILLING"/>
```

---

## 🔨 KORAK 3: Build Novi AAB

**Sada treba da rebuild-uješ aplikaciju:**

1. **Otvori terminal/command prompt:**
   ```bash
   cd ZaMariju
   ```

2. **Clean build (opciono, ali preporučeno):**
   ```bash
   flutter clean
   ```

3. **Build AAB:**
   ```bash
   flutter build appbundle --release
   ```

4. **Fajl će biti u:**
   ```
   ZaMariju/build/app/outputs/bundle/release/app-release.aab
   ```

---

## 📤 KORAK 4: Upload Novi AAB u Google Play Console

1. **U Google Play Console:**
   - Idi na: **Production → Create new release** (ili **"Kreiraj novo izdanje"**)

2. **Upload novi AAB:**
   - Klikni **"Upload"** (ili **"Otpremi"**)
   - Odaberi **NOVI** `app-release.aab` fajl (onaj koji si upravo build-ovao)
   - Sačekaj da se upload završi (1-5 minuta)

3. **Release notes:**
   - **What's new in this release:**
     ```
     Added billing support for in-app purchases
     - Added Google Play Billing dependency
     - Ready for subscription products
     ```

4. **Klikni "Save"** (ili **"Sačuvaj"**)

5. **NE SUBMIT-UJ ZA REVIEW JOS!**
   - Samo upload-uj AAB
   - Ne klikaj "Start rollout to Production" još

---

## ✅ KORAK 5: Sada Možeš Kreirati Proizvode!

**Nakon što upload-uješ novi AAB:**

1. **Sačekaj 5-10 minuta** (Google Play Console treba vreme da procesira AAB)

2. **Vrati se na:**
   - **Monetizacija → Производи → Једнократни производи**

3. **Sada bi trebalo da možeš da kreiraš proizvode!**

4. **Kreiraj:**
   - `one_time_purchase` ($9.99)
   - `monthly_subscription` ($4.99) - u "Пријаве"
   - `yearly_subscription` ($19.99) - u "Пријаве"

---

## 📋 CHECKLIST:

- [x] ✅ Billing dependency dodat u `build.gradle.kts`
- [x] ✅ Billing permission dodat u `AndroidManifest.xml`
- [ ] ⏳ Build novi AAB (`flutter build appbundle --release`)
- [ ] ⏳ Upload novi AAB u Google Play Console
- [ ] ⏳ Sačekaj 5-10 minuta
- [ ] ⏳ Kreiraj proizvode u Google Play Console

---

## ⚠️ VAŽNO:

- **RevenueCat SDK već koristi billing**, ali Google Play Console zahteva eksplicitnu dependency u build.gradle
- **Ne submit-uj za review još** - samo upload-uj AAB
- **Sačekaj da Google Play Console procesira AAB** pre nego što pokušaš da kreiraš proizvode

---

**Sledeći korak: Build novi AAB i upload-uj ga u Google Play Console! 🚀**
