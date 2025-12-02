# 📝 Kako da Kreiraš Proizvode - Google Play Console (Srpski)

## 🎯 VIDIM ŠTA IMAŠ:

Kada si kliknuo na "Производи", vidiš:
1. ✅ "Цене апликација" (App prices) - već si postavio na "Besplatno"
2. ✅ "Једнократни производи" (One-time products) - za one-time purchase
3. ✅ "Пријаве" - **OVO JE VEROVATNO ZA PRETPLATE!** (loš prevod)

---

## 📋 KORAK PO KORAK:

### **KORAK 1: Kreiraj One-Time Purchase**

1. **Klikni na "Једнократни производи"** (One-time products)
2. **Videćeš dugme:**
   - "+ Kreiraj proizvod" (Create product)
   - "+ Dodaj proizvod" (Add product)
3. **Klikni na to dugme**
4. **Popuni formu:**
   - **Product ID:** `one_time_purchase`
   - **Name:** `Premium Lifetime Access`
   - **Description:** `Get lifetime access to premium analysis features`
   - **Price:** `$9.99`
   - **Tip proizvoda:** Odaberi **"Ne potrošni"** (Non-consumable)
5. **Klikni "Save"** (Sačuvaj)

---

### **KORAK 2: Kreiraj Monthly i Yearly Subscriptions**

1. **Klikni na "Пријаве"** (ovo je verovatno za pretplate!)
2. **Videćeš:**
   - Listu pretplata (prazna ako nisi kreirao)
   - Dugme "+ Kreiraj pretplatu" ili "+ Dodaj pretplatu"
3. **Klikni na dugme za kreiranje**
4. **Kreiraj prvi proizvod:**
   - **Product ID:** `monthly_subscription`
   - **Name:** `Premium Monthly`
   - **Description:** `Get premium analysis features for one month`
   - **Price:** `$4.99`
   - **Billing period:** `Monthly` (Mesečno)
   - **Free trial:** `None` (ili 7 dana ako želiš)
5. **Klikni "Save"**
6. **Ponovi za yearly:**
   - **Product ID:** `yearly_subscription`
   - **Name:** `Premium Yearly`
   - **Description:** `Get premium analysis features for one year (67% savings!)`
   - **Price:** `$19.99`
   - **Billing period:** `Yearly` (Godišnje)

---

## ⚠️ ALTERNATIVA: Ako "Пријаве" nije za pretplate

**Ako kada klikneš na "Пријаве" ne vidiš opcije za pretplate:**

1. **Vrati se nazad**
2. **Probaj da kreiraš subscription kao "Једнократни производи" ali sa tipom "Pretplata"**
3. **Ili traži u meniju:**
   - Možda postoji opcija "Pretplate" negde drugde
   - Možda je u glavnom meniju (ne pod "Производи")

---

## ✅ FINALNI REZULTAT:

Trebalo bi da imaš:
- ✅ `one_time_purchase` ($9.99) - u "Једнократни производи"
- ✅ `monthly_subscription` ($4.99) - u "Пријаве" (ili gde god su pretplate)
- ✅ `yearly_subscription` ($19.99) - u "Пријаве" (ili gde god su pretplate)

---

**Prvo klikni na "Једнократни производи" i kreiraj one-time purchase, pa onda klikni na "Пријаве" i vidi šta se tamo nalazi! 🚀**
