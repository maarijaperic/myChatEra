# 📱 Simulator vs Fizički Uređaj - Objašnjenje

## 🤔 Zašto radi na Simulatoru a ne na Fizičkom Uređaju?

### ✅ SIMULATOR (Products.storekit)

**Kako radi:**
1. Xcode koristi `Products.storekit` fajl koji si podesio u Scheme
2. Ovaj fajl **simulira** kupovine **lokalno** na tvom Mac-u
3. **NE KORISTI** App Store Connect
4. **NE KORISTI** RevenueCat API za stvarne kupovine
5. **AUTOMATSKI ODOBRAVA** sve kupovine bez sandbox prozora

**Zašto radi:**
- ✅ `Products.storekit` je lokalni fajl na tvom Mac-u
- ✅ Xcode direktno čita ovaj fajl
- ✅ Ne treba internet konekcija za testiranje
- ✅ Ne treba App Store Connect
- ✅ Ne treba Sandbox Test Account

**Kada se koristi:**
- ✅ Samo u **iOS Simulatoru**
- ✅ Za brzo testiranje bez sandbox prozora
- ✅ Za development i debugging

---

### ❌ FIZIČKI UREĐAJ (App Store Connect Sandbox)

**Kako radi:**
1. iPhone/iPad **IGNORIŠE** `Products.storekit` fajl
2. Koristi **App Store Connect Sandbox** (stvarni Apple sistem)
3. **TRAŽI** internet konekciju
4. **TRAŽI** Sandbox Test Account
5. **PRIKAZUJE** sandbox prozor za autentifikaciju

**Zašto ne radi:**
- ❌ Fizički uređaj **NE ČITA** `Products.storekit` fajl
- ❌ Mora da se poveže sa App Store Connect
- ❌ Mora da se prijaviš sa Sandbox Test Account-om
- ❌ Mora da imaš internet konekciju

**Kada se koristi:**
- ✅ Na **fizičkom iPhone/iPad** uređaju
- ✅ Za testiranje kao stvarni korisnik
- ✅ Za produkciju

---

## 🔍 Detaljno Objašnjenje

### Simulator Flow:

```
Aplikacija → RevenueCat SDK → StoreKit (iOS) → Products.storekit (lokalni fajl)
                                                      ↓
                                              Automatski odobrava ✅
```

**Rezultat:** Kupovina prođe automatski bez prozora ✅

---

### Fizički Uređaj Flow:

```
Aplikacija → RevenueCat SDK → StoreKit (iOS) → App Store Connect Sandbox
                                                      ↓
                                              Traži Sandbox Account ❌
                                                      ↓
                                              Ako nisi sign out → greška
```

**Rezultat:** 
- Ako si sign out → sandbox prozor ✅
- Ako si sign in sa glavnim Apple ID → greška ❌

---

## 🎯 Zašto se Dešava "Purchase cancelled or failed"?

### Scenario 1: Sign In sa Glavnim Apple ID

1. Prijavljen si sa glavnim Apple ID-om na fonu
2. Pokušaš da kupiš → StoreKit traži sandbox
3. Ali si prijavljen sa **glavnim** Apple ID-om (ne sandbox)
4. App Store Connect kaže: "Ovo nije sandbox account"
5. **Rezultat:** "Purchase cancelled or failed" ❌

### Scenario 2: Sign Out sa App Store-a

1. **Sign Out** sa App Store-a na fonu
2. Pokušaš da kupiš → StoreKit traži sandbox
3. Pojavljuje se **sandbox prozor**
4. Prijaviš se sa **Sandbox Test Account**-om
5. **Rezultat:** Kupovina prođe ✅

---

## 📊 Tabela Poređenja

| Feature | Simulator | Fizički Uređaj |
|---------|-----------|----------------|
| **Products.storekit** | ✅ Koristi | ❌ Ignoriše |
| **App Store Connect** | ❌ Ne koristi | ✅ Koristi |
| **Sandbox Prozor** | ❌ Ne prikazuje | ✅ Prikazuje |
| **Internet** | ❌ Ne treba | ✅ Treba |
| **Sandbox Account** | ❌ Ne treba | ✅ Treba |
| **Sign Out** | ❌ Ne treba | ✅ Obavezno |

---

## 🔧 Kako da Radi na Fizičkom Uređaju?

### KORAK 1: Sign Out

1. **Settings** → **App Store**
2. Klikni na tvoj Apple ID
3. Klikni **"Sign Out"**

### KORAK 2: Test Kupovinu

1. Otvori aplikaciju
2. Klikni na bilo koji plan
3. **Sandbox prozor će se pojaviti**
4. Prijavi se sa **Sandbox Test Account**-om

### KORAK 3: Sandbox Test Account

Ako nemaš Sandbox Test Account:
1. App Store Connect → **Users and Access** → **Sandbox Testers**
2. Klikni **+** da kreiraš novi
3. Unesi bilo koji email (npr. `test@example.com`)
4. Lozinka (min 8 karaktera)

---

## ✅ Zaključak

**Simulator:**
- Koristi `Products.storekit` (lokalni fajl)
- Automatski odobrava kupovine
- Ne treba sandbox account
- ✅ Radi bez problema

**Fizički Uređaj:**
- Ignoriše `Products.storekit`
- Koristi App Store Connect Sandbox
- Traži sandbox account
- ❌ Ne radi ako si sign in sa glavnim Apple ID-om
- ✅ Radi ako si sign out i prijaviš se sa sandbox account-om

**Rešenje:** Sign Out sa App Store-a na fonu, pa pokušaj ponovo!

