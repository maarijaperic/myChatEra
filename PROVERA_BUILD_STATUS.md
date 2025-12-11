# 🔍 Kako da Proveriš Build Status

## ✅ KORACI ZA PROVERU

### **Korak 1: Otvori App Store Connect**

1. **Idi na:**
   - https://appstoreconnect.apple.com/
   - Uloguj se sa Apple ID-om

2. **Idi na tvoju aplikaciju:**
   - My Apps → GPT Wrapped (ili kako se zove)
   - Klikni na aplikaciju

---

### **Korak 2: Proveri TestFlight Tab**

1. **Klikni na "TestFlight" tab** (gore u meniju)

2. **Proveri build status:**
   - Trebalo bi da vidiš build **1.0.0 (5)**
   - Status može biti:
     - ✅ **"Ready to Test"** → Spreman za testiranje!
     - ⏳ **"Processing"** → Još uvek se obrađuje
     - ❌ **"Invalid"** → Ima grešku (retko)

---

## ⏰ TIPIČNO VREME PROCESIRANJA

- **10-30 minuta** → Najčešće
- **30-60 minuta** → Normalno
- **1-2 sata** → Retko, ali može se desiti

**Ako je prošlo pola sata, trebalo bi da bude gotovo!**

---

## 🆘 Ako je Još Uvek "Processing"

### **Opcija 1: Sačekaj Još Malo**

- Apple ponekad treba više vremena
- Proveri ponovo za 10-15 minuta

### **Opcija 2: Proveri da li Ima Greške**

1. **U TestFlight tab-u:**
   - Klikni na build (1.0.0 (5))
   - Proveri da li ima greške ili upozorenja

2. **Ako vidiš greške:**
   - Pročitaj poruku
   - Javi mi šta piše

---

## ✅ Ako je "Ready to Test"

**Sledeći koraci:**

1. **Dodaj sebe kao testera:**
   - TestFlight tab → Internal Testing → "+"
   - Unesi svoj email
   - Klikni "Add"

2. **Dodaj build u testing:**
   - Klikni na build (1.0.0 (5))
   - Klikni "Add to Internal Testing"

3. **Instaliraj TestFlight app:**
   - Na iPhone-u → App Store → Traži "TestFlight"
   - Instaliraj TestFlight app

4. **Prihvati pozivnicu:**
   - Otvori TestFlight app
   - Prihvati pozivnicu (email će stići)

5. **Instaliraj aplikaciju:**
   - U TestFlight app-u → Klikni "Install"
   - Sačekaj da se instalira

6. **Testiraj:**
   - Pokreni aplikaciju
   - Proveri Firebase i RevenueCat

---

## 🔍 KAKO DA VIDIŠ DA LI RADI

### **Firebase:**
- Firebase Console → Firestore Database
- Proveri da li se kreiraju dokumenti

### **RevenueCat:**
- RevenueCat Dashboard → Customers
- Proveri da li se korisnik pojavio

---

## 📋 CHECKLIST

- [ ] App Store Connect → TestFlight tab
- [ ] Proveri build status (1.0.0 (5))
- [ ] Ako je "Ready to Test" → Dodaj testera
- [ ] Ako je "Processing" → Sačekaj još malo
- [ ] Ako je "Invalid" → Proveri greške

---

**Javi mi šta vidiš u App Store Connect-u! 🚀**

