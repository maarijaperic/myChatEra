# ✅ Detaljni Koraci za Generisanje Sertifikata

## 📋 KORAK 1: Popuni Formu za Generisanje Sertifikata

### **1. Reference name:**
**Unesi:**
```
MyChatEra iOS Distribution Certificate
```
**Ili bilo koje ime koje želiš** (npr. `iOS Distribution`, `MyChatEra Certificate`, itd.)

**VAŽNO:**
- ✅ Može biti bilo koje ime - samo za identifikaciju u Codemagic-u
- ✅ Ne mora biti jedinstveno - samo za tvoju referencu

---

### **2. Certificate type:**
**Izaberi iz dropdown-a:**
```
iOS Distribution
```
**Ili:**
```
Apple Distribution
```

**VAŽNO:**
- ✅ **MORA biti "iOS Distribution" ili "Apple Distribution"** (ne Development!)
- ✅ Ovo je za App Store distribuciju
- ✅ Ne biraj "iOS Development" - to je samo za testiranje

---

### **3. Klikni "Generate" ili "Create":**
**Nakon što popuniš formu, klikni dugme za kreiranje.**

---

## 📋 KORAK 2: Čekaj da se Sertifikat Generiše

**Proces može trajati 1-2 minute:**
- ✅ Ne zatvaraj stranicu
- ✅ Čekaj da vidiš poruku "Certificate generated successfully" ili slično

---

## 📋 KORAK 3: Proveri da li je Sertifikat Kreiran

**Nakon što se proces završi:**

1. **Vrati se na:** Team settings → Code signing identities → iOS certificates
2. **Proveri sekciju:** "Code signing certificates"
3. **Trebalo bi da vidiš:**
   - ✅ Novi sertifikat u listi
   - ✅ Reference name koji si unela
   - ✅ Tip: iOS Distribution
   - ✅ Datum kreiranja

---

## 📋 KORAK 4: Generiši Provisioning Profile

**Sada kada imaš sertifikat:**

1. **Idi na tab:** **"iOS provisioning profiles"** (pored "iOS certificates" tab-a)
2. **Klikni:** **"Generate profile"** ili **"Create profile"**
3. **Popuni formu:**
   - **Reference name:** `MyChatEra App Store Profile` (ili bilo koje ime)
   - **Bundle identifier:** `com.mychatera`
   - **Profile type:** **App Store** (ili **iOS App Store**)
   - **Certificate:** Izaberi sertifikat koji si upravo kreirao (iz dropdown-a)
4. **Klikni:** **"Generate"** ili **"Create"**

---

## 📋 KORAK 5: Idi na App Settings → Distribution

**Sada kada imaš sertifikat i provisioning profile:**

1. **Idi na App Settings:**
   - Klikni na tvoju aplikaciju (GPTWrapped-1) u Codemagic dashboard-u
   - Idi na: **Settings** (ikona zupčanika ⚙️)
   - Idi na: **Distribution** (ili **iOS code signing**)

2. **Konfiguriši Code Signing:**
   - **Code signing method:** Izaberi **Manual** (ili **Automatic** ako postoji)
   - **Certificate:** Izaberi sertifikat koji si kreirala (iz dropdown-a)
   - **Provisioning profile:** Izaberi provisioning profile koji si kreirala (iz dropdown-a)
   - **Bundle identifier:** `com.mychatera`
   - **Save:** Klikni **Save** ili **Update**

---

## 📋 KORAK 6: Commit-uj i Push-uj Promene

**U GitHub Desktop:**
- Commit-uj promene u `codemagic.yaml` (ako ima promena)
- Push-uj na GitHub

---

## 📋 KORAK 7: Pokreni Build

**Nakon što konfigurišeš Distribution:**

1. **U Codemagic dashboard:**
   - Klikni: **Start new build**
   - **Select branch:** `main`
   - **Select file workflow:** `ios-workflow`
   - Klikni: **Start build**

2. **Build će sada:**
   - ✅ Koristiti sertifikat koji si kreirala
   - ✅ Koristiti provisioning profile koji si kreirala
   - ✅ Potpisati aplikaciju
   - ✅ Build-ovati IPA

---

## ⚠️ VAŽNO:

### **Ako Ne Vidiš "Distribution" Opciju u App Settings:**

**Mogući razlozi:**

1. **Sertifikat ili provisioning profile nisu kreirani:**
   - Proveri da li su kreirani u Team settings → Code signing identities

2. **App settings nisu pravilno konfigurisani:**
   - Proveri da li si u pravom mestu: App settings → Settings → Distribution

3. **Ako i dalje ne vidiš:**
   - Možda treba da koristiš YAML code signing umesto Dashboard-a
   - Kontaktiraj Codemagic support

---

## 🎯 REZIME:

**Šta treba da uradiš:**

1. ✅ **Reference name:** `MyChatEra iOS Distribution Certificate`
2. ✅ **Certificate type:** `iOS Distribution` (ili `Apple Distribution`)
3. ✅ **Klikni Generate** i čekaj da se sertifikat generiše
4. ✅ **Generiši provisioning profile** (tab "iOS provisioning profiles")
5. ✅ **Idi na App settings → Distribution** i konfiguriši Code Signing
6. ✅ **Pokreni build**

---

**Popuni formu sa "iOS Distribution" i klikni Generate! 🚀**



