# 🔄 Kako da Opozoveš Review u App Store Connect

## 🎯 Problem: Submit-ovao si aplikaciju bez Firebase i RevenueCat integracije

**Rešenje:** Opozovi review i submit-uj ponovo sa novim build-om!

---

## ✅ KORACI ZA OPOZIVANJE REVIEW-A

### **Korak 1: Otvori App Store Connect**

1. **Idi na App Store Connect:**
   - https://appstoreconnect.apple.com/
   - Uloguj se sa Apple ID-om

2. **Idi na tvoju aplikaciju:**
   - My Apps → GPT Wrapped (ili kako se zove)
   - Idi na "App Store" tab

---

### **Korak 2: Opozovi Review**

1. **Pronađi verziju koja je u review-u:**
   - U "App Store" tab-u, trebalo bi da vidiš verziju (npr. 1.0.0)
   - Status: "Waiting for Review" ili "In Review"

2. **Klikni na verziju:**
   - Klikni na verziju koja je u review-u

3. **Opozovi Review:**
   - Scroll dole na stranicu
   - Klikni "Remove from Review" ili "Withdraw from Review"
   - Potvrdi opoziv

4. **Status će se promeniti:**
   - Status će biti "Developer Removed from Review" ili "Removed from Sale"
   - Aplikacija više nije u review-u

---

## 📋 ALTERNATIVNO: Ako ne vidiš "Remove from Review"

### **Opcija 1: Sačekaj da Apple odbije**

1. **Ako je aplikacija u review-u:**
   - Možeš da sačekaš da Apple odbije aplikaciju
   - Zatim možeš da submit-uješ novi build

### **Opcija 2: Kontaktiraj Apple Support**

1. **Ako ne možeš da opozoveš:**
   - Kontaktiraj Apple Developer Support
   - https://developer.apple.com/contact/
   - Objasni da želiš da opozoveš review

---

## 🔄 NAKON OPOZIVANJA: Submit Novi Build

### **Korak 1: Build Novi IPA**

```bash
# Povećaj build number
# U pubspec.yaml: version: 1.0.0+3

cd ~/Documents/myChatEra/ZaMariju
flutter clean
flutter pub get
flutter build ipa --export-options-plist=ios/ExportOptions.plist
```

### **Korak 2: Upload Novi IPA**

1. **Upload u Transporter:**
   - Otvori Apple Transporter
   - Upload novi IPA (1.0.0+3)
   - Sačekaj da se upload završi

### **Korak 3: Submit Novi Build**

1. **U App Store Connect:**
   - My Apps → GPT Wrapped → App Store tab
   - Klikni na verziju (1.0.0)
   - Izaberi novi build (1.0.0 (3))
   - Klikni "Submit for Review"

---

## ✅ CHECKLIST

### **Opozivanje:**
- [ ] App Store Connect → My Apps → GPT Wrapped
- [ ] App Store tab → Klikni na verziju
- [ ] Scroll dole → "Remove from Review"
- [ ] Potvrdi opoziv

### **Novi Build:**
- [ ] Build number povećan (1.0.0+3)
- [ ] IPA build-ovan
- [ ] IPA upload-ovan u Transporter
- [ ] Novi build submit-ovan za review

---

## 🆘 TROUBLESHOOTING

### **"Ne vidim Remove from Review dugme"**
- Proveri da li je aplikacija stvarno u review-u
- Proveri da li imaš dozvole (Admin ili Account Holder)
- Kontaktiraj Apple Support

### **"Aplikacija je već odobrena"**
- Ako je aplikacija već odobrena, ne možeš da je opozoveš
- Možeš da submit-uješ novu verziju (1.0.1) sa Firebase i RevenueCat

### **"Aplikacija je u review-u"**
- Možeš da sačekaš da Apple odbije
- Ili kontaktiraj Apple Support da ubrzaš proces

---

## 🎯 REZIME

1. **Opozovi Review:** App Store Connect → App Store tab → Remove from Review
2. **Build Novi IPA:** Povećaj build number → Build IPA
3. **Upload Novi IPA:** Transporter → Upload
4. **Submit Novi Build:** App Store Connect → Submit for Review

---

**Srećno! 🚀**

