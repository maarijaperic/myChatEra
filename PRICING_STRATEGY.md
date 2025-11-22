# 💰 Pricing Strategy - GPT Wrapped

## 📊 Analiza Trenutnih Cena

**Trenutno:**
- Monthly: $2.99/mesec = $35.88/god
- Yearly: $12.99/god = $1.08/mesec
- One-time: $4.99 (lifetime)

**Problem:** Yearly je previše jeftin u odnosu na monthly!

---

## 🎯 PREPORUČENE CENE (3 opcije)

### **OPCIJA 1: Balanced (Preporučeno) ⭐**

```
Monthly:  $4.99/mesec  ($59.88/god)
Yearly:   $19.99/god   ($1.67/mesec) - SAVE 67%
One-time: $9.99       (lifetime)
```

**Zašto ovo radi:**
- ✅ Yearly ima jasnu uštedu (67%)
- ✅ One-time je pristupačan ali ne previše jeftin
- ✅ Monthly je OK za one koji ne žele commitment
- ✅ Psihološki: $19.99 zvuči bolje od $20

**Revenue analiza (1,000 korisnika):**
- 40% yearly = 400 × $19.99 = $7,996
- 30% monthly = 300 × $4.99 × 12 = $17,964 (godišnje)
- 30% one-time = 300 × $9.99 = $2,997
- **Ukupno: ~$28,957 godišnje**

---

### **OPCIJA 2: Premium (Više zarade)**

```
Monthly:  $5.99/mesec  ($71.88/god)
Yearly:   $24.99/god   ($2.08/mesec) - SAVE 65%
One-time: $14.99      (lifetime)
```

**Zašto ovo radi:**
- ✅ Viša cena = više zarade
- ✅ Još uvek pristupačno
- ✅ Yearly ušteda je jasna

**Revenue analiza (1,000 korisnika):**
- 40% yearly = 400 × $24.99 = $9,996
- 30% monthly = 300 × $5.99 × 12 = $21,564
- 30% one-time = 300 × $14.99 = $4,497
- **Ukupno: ~$36,057 godišnje**

---

### **OPCIJA 3: Aggressive (Više konverzija)**

```
Monthly:  $3.99/mesec  ($47.88/god)
Yearly:   $14.99/god   ($1.25/mesec) - SAVE 69%
One-time: $7.99       (lifetime)
```

**Zašto ovo radi:**
- ✅ Niža cena = više ljudi će kupiti
- ✅ One-time je vrlo pristupačan
- ✅ Može privući više korisnika

**Revenue analiza (1,000 korisnika):**
- 40% yearly = 400 × $14.99 = $5,996
- 30% monthly = 300 × $3.99 × 12 = $14,364
- 30% one-time = 300 × $7.99 = $2,397
- **Ukupno: ~$22,757 godišnje**

---

## 🧠 PSIHOLOGIJA CENA

### **Zašto $19.99 umesto $20?**
- "Charm pricing" - $19.99 zvuči jeftinije
- Psihološki: ljudi čitaju "19" a ne "20"

### **Zašto yearly treba da bude 60-70% uštede?**
- Jasna vrednost: "Save 67%" je privlačno
- Incentivizuje yearly purchase
- Više recurring revenue za tebe

### **Zašto one-time treba da bude između monthly i yearly?**
- Ne previše jeftin (ne devalvira vrednost)
- Ne previše skup (ne odbija korisnike)
- Sweet spot: $7.99-$14.99

---

## 📈 KOMPARACIJA SA KONKURENCIJOM

### **Slične aplikacije:**
- **Personality test apps:** $4.99-$9.99 one-time
- **AI analysis tools:** $4.99-$19.99/month
- **Wrapped-style apps:** Besplatno (ali bez AI)

### **Tvoja prednost:**
- ✅ AI-powered (dodaje vrednost)
- ✅ Unique concept (ChatGPT Wrapped)
- ✅ Viral potential (ljudi dele rezultate)

---

## 🎯 FINALNA PREPORUKA

### **KORISTI OPCIJU 1: Balanced** ⭐

```
Monthly:  $4.99/mesec
Yearly:   $19.99/god   (SAVE 67%)
One-time: $9.99
```

**Zašto:**
1. ✅ **Optimalna zarada** - balans između cene i konverzije
2. ✅ **Jasna vrednost** - yearly ušteda je očigledna
3. ✅ **Pristupačno** - ne odbija korisnike
4. ✅ **Psihološki** - $19.99 zvuči bolje od $20
5. ✅ **Testirano** - slične cene rade dobro u app store-ovima

---

## 💡 STRATEGIJA ZA POČETAK

### **Launch Pricing (Prvi mesec):**
```
Monthly:  $3.99/mesec  (LAUNCH PRICE)
Yearly:   $14.99/god   (SAVE 69%)
One-time: $7.99       (LAUNCH PRICE)
```

**Zašto:**
- ✅ Niža cena privlači više early adopters
- ✅ Build user base brže
- ✅ Dobri reviews = više downloads

**Nakon 1 meseca:**
- Povećaj na normalne cene
- Early adopters zadrže launch price (loyalty)

---

## 📊 REVENUE PROJEKCIJE

### **Sa 1,000 premium korisnika (Opcija 1):**

**Mesec 1:**
- 400 yearly × $19.99 = $7,996
- 300 monthly × $4.99 = $1,497
- 300 one-time × $9.99 = $2,997
- **Ukupno: $12,490**

**Godišnje (sa monthly retention):**
- Yearly: $7,996 (jedan put)
- Monthly: $1,497 × 12 = $17,964
- One-time: $2,997 (jedan put)
- **Ukupno: ~$28,957**

### **Sa 10,000 premium korisnika (Opcija 1):**

**Godišnje:**
- **~$289,570** (sa 70% monthly retention)

### **Sa 100,000 premium korisnika (Opcija 1):**

**Godišnje:**
- **~$2,895,700** (sa 70% monthly retention)

---

## 🎯 IMPLEMENTACIJA

### **Korak 1: Ažuriraj cene u kodu**

Fajl: `ZaMariju/lib/screen_subscription.dart`

```dart
// Monthly option
price: '\$4.99',
period: '/mo',

// Yearly option (highlighted)
price: '\$19.99',
period: '/yr',
badge: 'SAVE 67%',

// One-time option
price: '\$9.99',
period: 'once',
```

### **Korak 2: Ažuriraj bullet points**

```dart
case 1: // Yearly
  return [
    'All premium insights',
    'Best value - save 67%',
    'Billed once per year',
  ];
```

### **Korak 3: A/B test (opciono)**

- Testiraj obe cene (Opcija 1 vs Opcija 2)
- Vidi koja daje više konverzija
- Optimizuj na osnovu rezultata

---

## ✅ CHECKLIST

- [ ] Odluči se za pricing opciju
- [ ] Ažuriraj cene u `screen_subscription.dart`
- [ ] Ažuriraj bullet points
- [ ] Ažuriraj marketing materijale (ako spominješ cenu)
- [ ] Setup-uj billing (RevenueCat ili slično)
- [ ] Testiraj payment flow
- [ ] Pripremi launch pricing (opciono)

---

## 🚀 FINALNI SAVET

**Počni sa Opcijom 1 ($4.99/$19.99/$9.99):**
- Ako konverzija nije dobra → smanji (Opcija 3)
- Ako konverzija je dobra → možda povećaj (Opcija 2)
- Testiraj i optimizuj!

**Najvažnije:** 
- Yearly treba da bude "BEST VALUE" - highlight-uj ga!
- One-time je dobar za one koji ne vole subscription
- Monthly je za one koji žele fleksibilnost

**Srećno!** 🎯




