# 🔍 Kako da Nađeš Subscription Proizvode - Google Play Console (Srpski)

## 📍 RAZLIČITE PUTANJE DO SUBSCRIPTION PROIZVODA

Google Play Console može imati različite strukture menija. Evo svih mogućih putanja:

---

## 🎯 METODA 1: Preko Menija sa Leve Strane

1. **U Google Play Console, pogledaj meni sa LEVE STRANE**
2. **Traži jednu od ovih opcija:**
   - **"Monetizacija"** (Monetization)
   - **"Proizvodi"** (Products)
   - **"Pretplate"** (Subscriptions)
   - **"In-app proizvodi"** (In-app products)

3. **Klikni na to**
4. **Ako vidiš opciju "Pretplate" ili "Subscriptions" → klikni na to**
5. **Trebalo bi da vidiš dugme:**
   - **"+ Kreiraj pretplatu"** (Create subscription)
   - **"+ Dodaj pretplatu"** (Add subscription)
   - **"Nova pretplata"** (New subscription)

---

## 🎯 METODA 2: Preko Tvoje Aplikacije

1. **Klikni na tvoju aplikaciju** (u listi aplikacija)
2. **U meniju sa leve strane, traži:**
   - **"Monetizacija"** → **"Proizvodi"** → **"Pretplate"**
   - **"Proizvodi"** → **"Pretplate"**
   - **"Pretplate"** (direktno)

3. **Ako vidiš "Pretplate" → klikni**
4. **Trebalo bi da vidiš dugme za kreiranje**

---

## 🎯 METODA 3: Preko Pretraživanja

1. **U Google Play Console, na vrhu imaš polje za pretraživanje** (ikonica lupa 🔍)
2. **Ukucaj:**
   - `pretplata`
   - `subscription`
   - `proizvod`
   - `monetizacija`

3. **Klikni na rezultat koji se odnosi na pretplate**

---

## 🎯 METODA 4: Preko URL-a Direktno

1. **U browser-u, ukucaj:**
   ```
   https://play.google.com/console/u/0/developers/[Tvoj-ID]/app/[App-ID]/monetization/products/subscriptions
   ```

2. **Zameni:**
   - `[Tvoj-ID]` sa tvojim Developer ID-jem
   - `[App-ID]` sa ID-jem tvoje aplikacije

3. **Ili jednostavno:**
   - Idi na Google Play Console
   - Klikni na tvoju aplikaciju
   - U URL-u, na kraju dodaј `/monetization/products/subscriptions`

---

## 📸 ŠTA TREBA DA VIDIŠ

**Kada nađeš pravu stranicu, trebalo bi da vidiš:**

- **Naslov:** "Pretplate" ili "Subscriptions"
- **Dugme:** "+ Kreiraj pretplatu" ili "+ Dodaj pretplatu"
- **Lista proizvoda:** (prazna ako nisi kreirao ništa)

---

## ⚠️ VAŽNO: Možda Nisi Još Omogućio Monetizaciju

**Ako ne vidiš opciju za pretplate, možda treba prvo da omogućiš monetizaciju:**

1. **Idi na: Tvoja aplikacija → Monetizacija** (ili **"Monetization"**)
2. **Proveri da li postoji opcija:**
   - **"Omogući monetizaciju"** (Enable monetization)
   - **"Podesi monetizaciju"** (Setup monetization)

3. **Ako postoji → klikni i omogući**

---

## 🔄 ALTERNATIVA: In-App Products Umesto Subscriptions

**Ako ne možeš da nađeš "Pretplate", možda Google Play Console koristi "In-app proizvodi":**

1. **Traži:**
   - **"In-app proizvodi"** (In-app products)
   - **"Proizvodi u aplikaciji"** (Products in app)

2. **Klikni na to**
3. **Možda ćeš videti opciju za kreiranje subscription proizvoda tamo**

---

## 📝 KAKO DA KREIRAŠ ONE-TIME PURCHASE

**One-Time Purchase se kreira kao "In-app proizvod", ne kao subscription:**

1. **Traži:**
   - **"In-app proizvodi"** (In-app products)
   - **"Proizvodi u aplikaciji"**

2. **Klikni "+ Kreiraj proizvod"** (Create product)
3. **Tip proizvoda:** Odaberi **"Ne potrošni"** (Non-consumable) ili **"Jednokratna kupovina"** (One-time purchase)

---

## 🆘 ŠTA AKO I DALJE NE MOŽEŠ DA NAĐEŠ?

**Probaj ovo:**

1. **Screenshot:** Pošalji mi screenshot Google Play Console interfejsa (meni sa leve strane)
2. **Ili opiši:** Šta tačno vidiš u meniju sa leve strane?
3. **Ili probaj:**
   - Promeni jezik na Engleski (ako je moguće)
   - Refresh stranicu (F5)
   - Proveri da li si u pravom projektu/aplikaciji

---

## ✅ KADA NAĐEŠ OPCIJU

**Kada konačno nađeš opciju za kreiranje pretplate:**

1. **Klikni "+ Kreiraj pretplatu"** (ili slično)
2. **Popuni formu:**
   - **Product ID:** `one_time_purchase` (za one-time)
   - **Product ID:** `monthly_subscription` (za monthly)
   - **Product ID:** `yearly_subscription` (za yearly)
   - **Cena:** $9.99, $4.99, $19.99
   - **Period:** Jednokratno, Mesečno, Godišnje

3. **Sačuvaj**

---

**Pošalji mi screenshot ili opiši šta vidiš, pa ću ti tačno reći gde da klikneš! 📸**
