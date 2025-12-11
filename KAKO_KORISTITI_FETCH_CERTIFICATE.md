# ✅ Kako Koristiti "Fetch certificate" u Codemagic

## 🎯 PROBLEM:

Vidiš samo opcije za ručno upravljanje sertifikatima u Team settings, ali ne vidiš "Automatic Code Signing" opciju.

---

## ✅ REŠENJE:

**Koristi "Fetch certificate" dugme koje automatski koristi App Store Connect API key!**

---

## 📋 KORAK PO KORAK:

### **KORAK 1: Klikni "Fetch certificate"**

**U screenshot-u koji si poslala:**

1. **Vidiš sekciju:** "Get certificates from Apple Developer Portal"
2. **Klikni dugme:** **"Fetch certificate"**

**Ovo će automatski:**
- ✅ Koristiti App Store Connect API key koji si povezala u Team integrations
- ✅ Dohvatiti sertifikate direktno iz Apple Developer Portal-a
- ✅ Kreirati provisioning profile automatski

---

### **KORAK 2: Čekaj da se Sertifikati Dohvate**

**Nakon što klikneš "Fetch certificate":**

1. **Codemagic će:**
   - Koristiti App Store Connect API key iz Team integrations
   - Dohvatiti postojeće sertifikate iz Apple Developer Portal-a
   - Kreirati nove sertifikate ako ne postoje

2. **Ako nema sertifikata:**
   - Codemagic će automatski kreirati nove sertifikate
   - Koristiće App Store Connect API key za autentifikaciju

---

### **KORAK 3: Proveri da li su Sertifikati Dohvaćeni**

**Nakon što se proces završi:**

1. **Vrati se na istu stranicu** (Team settings → Code signing identities → iOS certificates)
2. **Proveri sekciju:** "Code signing certificates"
3. **Trebalo bi da vidiš:**
   - ✅ Listu sertifikata (umesto "No certificates shared with the team")
   - ✅ Bundle identifier: `com.mychatera`
   - ✅ Tip sertifikata: iOS Distribution

---

### **KORAK 4: Idi na App Settings → Distribution**

**Sada kada su sertifikati dohvaćeni:**

1. **Idi na App Settings:**
   - Klikni na tvoju aplikaciju (GPTWrapped-1) u Codemagic dashboard-u
   - Idi na: **Settings** (ikona zupčanika ⚙️)
   - Idi na: **Distribution** (ili **iOS code signing**)

2. **Sada bi trebalo da vidiš:**
   - ✅ **Code signing method:** Izaberi **Automatic**
   - ✅ **App Store Connect API key:** Izaberi tvoj API key
   - ✅ **Provisioning profile type:** Izaberi **App Store**
   - ✅ **Bundle identifier:** `com.mychatera`

---

### **KORAK 5: Pokreni Build**

**Nakon što konfigurišeš Distribution:**

1. **U Codemagic dashboard:**
   - Klikni: **Start new build**
   - **Select branch:** `main`
   - **Select file workflow:** `ios-workflow`
   - Klikni: **Start build**

2. **Build će sada:**
   - ✅ Koristiti sertifikate koje si dohvatila
   - ✅ Automatski kreirati provisioning profile
   - ✅ Potpisati aplikaciju
   - ✅ Build-ovati IPA

---

## ⚠️ VAŽNO:

### **Ako "Fetch certificate" Ne Radi:**

**Mogući razlozi:**

1. **App Store Connect Integration nije pravilno povezan:**
   - Proveri: **Team settings** → **Team integrations** → **Apple Developer Portal**
   - Mora biti povezano sa Issuer ID, Key ID, i API key

2. **Bundle identifier ne postoji u Apple Developer Portal:**
   - Proveri u App Store Connect: https://appstoreconnect.apple.com/
   - Idi na: **Certificates, Identifiers & Profiles**
   - Proveri da li postoji Bundle ID: `com.mychatera`

3. **Ako i dalje ne radi:**
   - Koristi **"Generate certificate"** opciju umesto "Fetch certificate"
   - Ili kontaktiraj Codemagic support

---

## 🎯 REZIME:

**Šta treba da uradiš:**

1. ✅ **Klikni "Fetch certificate"** u Team settings → Code signing identities → iOS certificates
2. ✅ **Čekaj da se sertifikati dohvate** (koristi App Store Connect API key)
3. ✅ **Proveri da li su sertifikati dohvaćeni** (u "Code signing certificates" sekciji)
4. ✅ **Idi na App settings → Distribution** i konfiguriši Automatic Code Signing
5. ✅ **Pokreni build**

---

**Klikni "Fetch certificate" i čekaj da se sertifikati dohvate! 🚀**



