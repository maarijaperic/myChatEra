# 🔧 Fix xcode-project use-profiles Syntax

## 🎯 PROBLEM:

Greška:
> "xcode-project: error: unrecognized arguments: --team-id 522DMZ83DM --bundle-id com.mychatera --profile-type app-store"

**Problem:** `xcode-project use-profiles` ne prihvata `--team-id`, `--bundle-id`, i `--profile-type` parametre!

---

## ✅ REŠENJE:

### **KORISTIM `--archive-method` PARAMETAR!**

**Šta sam uradio:**
1. ✅ Uklonio neispravne parametre (`--team-id`, `--bundle-id`, `--profile-type`)
2. ✅ Dodao `--archive-method app-store` parametar

---

## 📋 ŠTA SAM URADIO:

### **1. Ispravio Sintaksu:**

**Pre:**
```yaml
- name: Set up code signing settings on Xcode project
  script: |
    xcode-project use-profiles \
      --team-id 522DMZ83DM \
      --bundle-id com.mychatera \
      --profile-type app-store
```

**Sada:**
```yaml
- name: Set up code signing settings on Xcode project
  script: |
    xcode-project use-profiles --archive-method app-store
```

**Zašto?**
- ✅ `xcode-project use-profiles` prihvata samo određene parametre
- ✅ `--archive-method app-store` specifikuje tip provisioning profile-a
- ✅ Team ID i Bundle ID se automatski uzimaju iz `project.pbxproj`

---

## 📋 SLEDEĆI KORACI:

### **1. Proveri Environment Variables:**

**U Codemagic dashboard, proveri da li imaš:**

- ✅ `APP_STORE_CONNECT_PRIVATE_KEY` (sadržaj `.p8` fajla)
- ✅ `APP_STORE_CONNECT_KEY_IDENTIFIER` (Key ID)
- ✅ `APP_STORE_CONNECT_ISSUER_ID` (Issuer ID)

---

### **2. Commit-uj i Push-uj:**

1. **U GitHub Desktop:**
   - Commit-uj promene u `codemagic.yaml`
   - Push-uj na GitHub

---

### **3. Pokreni Build:**

1. **U Codemagic dashboard:**
   - Klikni: **Start new build**
   - **Select branch:** `main`
   - **Select file workflow:** `ios-workflow`
   - Klikni: **Start build**

2. **Build će sada:**
   - ✅ Koristiti `--archive-method app-store` za code signing
   - ✅ Automatski koristiti Team ID iz `project.pbxproj` (`522DMZ83DM`)
   - ✅ Automatski koristiti Bundle ID iz `project.pbxproj` (`com.mychatera`)
   - ✅ Potpisati aplikaciju
   - ✅ Build-ovati IPA
   - ✅ Upload-ovati u TestFlight

---

## ⚠️ VAŽNO:

### **Pravilna Sintaksa za `xcode-project use-profiles`:**

**`xcode-project use-profiles` prihvata:**
- ✅ `--project` - Putanja do `.xcodeproj` fajla
- ✅ `--profile` - Putanja do `.mobileprovision` fajla
- ✅ `--archive-method` - Tip provisioning profile-a (`app-store`, `ad-hoc`, `development`, `enterprise`)
- ✅ `--export-options-plist` - Putanja za export options plist
- ✅ `--custom-export-options` - Dodatne export opcije u JSON formatu

**NE prihvata:**
- ❌ `--team-id`
- ❌ `--bundle-id`
- ❌ `--profile-type`

---

### **Kako `xcode-project use-profiles` Radi:**

**`xcode-project use-profiles` automatski:**
- ✅ Koristi Team ID iz `project.pbxproj` (`DEVELOPMENT_TEAM`)
- ✅ Koristi Bundle ID iz `project.pbxproj` (`PRODUCT_BUNDLE_IDENTIFIER`)
- ✅ Koristi App Store Connect API key iz `app_store_connect` sekcije (ako je konfigurisano)
- ✅ Filtrira provisioning profile-e po `--archive-method`

---

## 📋 CHECKLIST:

- [ ] ✅ `codemagic.yaml` je ažuriran (ispravljena sintaksa)
- [ ] ✅ `--archive-method app-store` je dodat
- [ ] ✅ Team ID je ažuriran u `project.pbxproj` (`522DMZ83DM`)
- [ ] ✅ Environment variables su dodati (`APP_STORE_CONNECT_*`)
- [ ] ✅ `app_store_connect` sekcija je konfigurisana u `codemagic.yaml`
- [ ] ✅ Promene su commit-ovane i push-ovane
- [ ] ✅ Pokrenut novi build
- [ ] ✅ Build je uspešan (code signing radi)

---

## 🎯 REZIME:

**Problem:** `xcode-project use-profiles` ne prihvata `--team-id`, `--bundle-id`, i `--profile-type` parametre

**Rešenje:**
1. ✅ **Uklonio neispravne parametre**
2. ✅ **Dodao `--archive-method app-store`** - ispravan parametar
3. ✅ **Team ID i Bundle ID se automatski uzimaju iz `project.pbxproj`**

---

**Commit-uj promene i pokreni build - trebalo bi da radi! 🚀**



