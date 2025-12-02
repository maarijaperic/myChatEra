# 🔐 Kako da Build-uješ Signed AAB za Google Play

## ✅ ŠTA SAM URADIO:

1. ✅ **Kreirao keystore:** `ZaMariju/android/upload-keystore.jks`
   - Password: `android123`
   - Alias: `upload`

2. ✅ **Kreirao key.properties:** `ZaMariju/android/key.properties`
   - Sadrži sve potrebne informacije za signing

3. ✅ **Ažurirao build.gradle.kts:**
   - Dodao kod za učitavanje keystore properties
   - Konfigurisao release signing config

---

## 🚀 KAKO DA BUILD-UJEŠ SIGNED AAB:

### **KORAK 1: Build Signed AAB**

```bash
cd ZaMariju
flutter clean
flutter build appbundle --release
```

**Fajl će biti u:**
```
ZaMariju/build/app/outputs/bundle/release/app-release.aab
```

**Ovaj AAB je automatski sign-ovan sa upload keystore-om!** ✅

---

## 📤 KORAK 2: Upload u Google Play Console

1. **Idi na: Тестирање → Затворено тестирање**
2. **Klikni "Kreiraj novo izdanje"**
3. **Upload `app-release.aab`**
4. **Google Play će automatski koristiti Play App Signing!**

---

## ⚠️ VAŽNO:

- **Keystore password:** `android123`
- **Keystore fajl:** `ZaMariju/android/upload-keystore.jks`
- **Čuvaj keystore sigurno!** Ako ga izgubiš, nećeš moći da ažuriraš aplikaciju!

---

## 🔒 BEZBEDNOST:

**Za produkciju, promeni password:**
1. Generiši novi keystore sa jakim password-om
2. Ažuriraj `key.properties` sa novim password-om
3. **Čuvaj keystore i password na sigurnom mestu!**

---

**Sada možeš da build-uješ signed AAB i upload-uješ ga u Google Play Console! 🎉**
