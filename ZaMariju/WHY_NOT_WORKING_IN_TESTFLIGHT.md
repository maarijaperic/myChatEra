# ❓ Zašto Ne Radi u TestFlight-u?

## 🎯 Kratak Odgovor

**TestFlight takođe koristi App Store Connect Sandbox**, ne lokalni `Products.storekit` fajl!

---

## 🔍 Razlika Između Simulatora i TestFlight-a

### Simulator:
- ✅ Koristi **`Products.storekit`** (lokalni fajl)
- ✅ Ne koristi App Store Connect
- ✅ Radi odmah bez submit-a
- ✅ Ne treba review

### TestFlight:
- ❌ **NE koristi** `Products.storekit` fajl
- ✅ Koristi **App Store Connect Sandbox**
- ❌ **TREBA** submit sa verzijom
- ❌ **TREBA** review (ili barem da bude submit-ovano)

---

## ⚠️ Zašto Ne Radi u TestFlight-u?

### Problem 1: Proizvodi Nisu Submit-ovani

**TestFlight koristi App Store Connect Sandbox:**
- Ako proizvodi nisu submit-ovani sa verzijom → **ne mogu se koristiti**
- App Store Connect ne dozvoljava Sandbox testiranje dok proizvodi nisu submit-ovani
- To je zaštita Apple-a - ne možeš testirati proizvode koji nisu submit-ovani

### Problem 2: TestFlight ≠ Simulator

**Simulator:**
- Koristi lokalni fajl (`Products.storekit`)
- Ne koristi App Store Connect
- Radi bez submit-a

**TestFlight:**
- Koristi App Store Connect Sandbox
- Mora biti submit-ovano
- Ne radi bez submit-a

---

## 📊 Tabela Poređenja

| Feature | Simulator | TestFlight | Fizički Uređaj |
|---------|-----------|------------|----------------|
| **Products.storekit** | ✅ Koristi | ❌ Ne koristi | ❌ Ne koristi |
| **App Store Connect** | ❌ Ne koristi | ✅ Koristi | ✅ Koristi |
| **Sandbox** | ❌ Ne koristi | ✅ Koristi | ✅ Koristi |
| **Submit Required** | ❌ Ne | ✅ DA | ✅ DA |
| **Review Required** | ❌ Ne | ⚠️ Možda | ⚠️ Možda |

---

## 🔧 Kada će Raditi u TestFlight-u?

### Opcija 1: Nakon Submit-a (Pre Review-a)

**Možda će raditi čim submit-uješ:**
- Neki proizvodi mogu raditi u Sandbox-u čim su submit-ovani
- Ne mora proći review
- Ali mora biti submit-ovano sa verzijom

### Opcija 2: Nakon Review-a (Sigurno)

**Definitivno će raditi nakon review-a:**
- Apple odobri proizvode
- Sandbox će raditi u TestFlight-u
- Sve će raditi normalno

---

## 🎯 Zašto Simulator Radi a TestFlight Ne?

### Simulator:
```
Aplikacija → RevenueCat → StoreKit → Products.storekit (lokalni fajl)
                                                      ↓
                                              Automatski odobrava ✅
```

**Rezultat:** Radi odmah, bez submit-a ✅

### TestFlight:
```
Aplikacija → RevenueCat → StoreKit → App Store Connect Sandbox
                                                      ↓
                                              Proverava submit status
                                                      ↓
                                    Ako nije submit-ovano → ❌ Ne radi
```

**Rezultat:** Ne radi dok nije submit-ovano ❌

---

## ✅ Rešenje

### 1. Submit-uj Verziju sa In-App Purchases
- Kreiraj verziju
- Dodaj in-app purchases
- Submit za review

### 2. Sačekaj (Možda će Raditi Odmah)
- Neki proizvodi mogu raditi čim su submit-ovani
- Ne mora proći review
- Testiraj u TestFlight-u

### 3. Ako Ne Radi, Sačekaj Review
- Review proces: 1-3 dana
- Nakon odobrenja, sigurno će raditi

---

## 💡 Zašto Apple Tako Radi?

**Apple zahteva submit jer:**
1. **Bezbednost:** Ne možeš testirati proizvode koji nisu pregledani
2. **Kvalitet:** Proverava da li su proizvodi pravilno konfigurisani
3. **Zaštita:** Sprečava zloupotrebu Sandbox sistema

---

## 🔍 Kako da Proveriš

### Nakon Submit-a:

1. **Proveri Status:**
   - App Store Connect → Verzija → Status
   - In-App Purchases → Status

2. **Testiraj u TestFlight-u:**
   - Sign out sa App Store-a
   - Otvori aplikaciju iz TestFlight-a
   - Klikni na plan
   - **Sandbox prozor se pojavljuje?** → ✅ Radi!

---

## ✅ Finalni Odgovor

**Zašto ne radi u TestFlight-u:**
- TestFlight koristi App Store Connect Sandbox
- Sandbox ne radi dok proizvodi nisu submit-ovani
- To je zaštita Apple-a

**Kada će raditi:**
- Možda odmah nakon submit-a (pre review-a)
- Sigurno nakon review-a (1-3 dana)

**Zašto simulator radi:**
- Simulator koristi lokalni fajl (`Products.storekit`)
- Ne koristi App Store Connect
- Ne treba submit

**Rešenje:**
- Submit-uj verziju sa in-app purchases
- Testiraj u TestFlight-u
- Ako ne radi, sačekaj review

---

## 🎯 Zaključak

**TestFlight = Fizički Uređaj** (oba koriste App Store Connect Sandbox)

**Simulator ≠ TestFlight** (simulator koristi lokalni fajl)

Zato simulator radi, a TestFlight i fizički uređaj ne rade - sve dok ne submit-uješ proizvode sa verzijom!

