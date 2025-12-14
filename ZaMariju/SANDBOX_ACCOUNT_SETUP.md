# 🔐 Sandbox Test Account - Detaljno Uputstvo

## ❓ Gde Se Prijavljuješ?

**VAŽNO:** Ne prijavljuješ se NIGDE pre kupovine! Apple će automatski pokazati Sandbox prozor kada pokušaš kupovinu.

---

## 📋 KORAK PO KORAK

### KORAK 1: Kreiraj Sandbox Test Account

1. **Idi na App Store Connect:**
   - Otvori: https://appstoreconnect.apple.com
   - Prijavi se sa svojim Apple Developer nalogom

2. **Idi na Sandbox Testers:**
   - Klikni na "Users and Access" (levo u meniju)
   - Klikni na "Sandbox Testers" (gore u tab-ovima)

3. **Kreiraj Novi Test Account:**
   - Klikni na "+" (plus) u gornjem desnom uglu
   - Popuni formu:
     - **Email:** bilo koji email (npr. `test123@gmail.com`)
       - ⚠️ NE može biti email koji već postoji u App Store-u
       - ⚠️ NE može biti tvoj pravi Apple ID email
     - **Password:** min 8 karaktera (npr. `test1234`)
     - **First Name:** bilo šta (npr. `Test`)
     - **Last Name:** bilo šta (npr. `User`)
   - Klikni "Save"

4. **Zapamti Email i Password:**
   - Ovo ćeš koristiti kada pokušaš kupovinu

---

### KORAK 2: Sign Out sa App Store-a na iPhone-u

**OBVEZNO!** Ako si prijavljena sa svojim Apple ID-om, moraš se sign out-ovati.

#### Način 1 (iOS 13+):
1. **Settings** → **App Store**
2. Klikni na svoj **Apple ID** (gore)
3. Klikni **"Sign Out"**

#### Način 2 (Ako ne vidiš Sign Out):
1. **Settings** → **[Tvoje Ime]** (gore)
2. **Media & Purchases**
3. Klikni na **Apple ID**
4. Klikni **"Sign Out"**

---

### KORAK 3: Testiraj Kupovinu

1. **Otvori aplikaciju** (iz TestFlight-a)
2. **Klikni na plan** (One Time, Monthly, ili Yearly)
3. **Apple će automatski pokazati Sandbox prozor!**
   - Ne prijavljuj se NIGDE pre toga
   - Prozor će se pojaviti automatski kada klikneš kupovinu

4. **U Sandbox prozoru:**
   - Unesi **email** koji si kreirao (npr. `test123@gmail.com`)
   - Unesi **password** koji si kreirao (npr. `test1234`)
   - Klikni "Sign In"

5. **Kupovina će proći!**

---

## ⚠️ ČESTE GREŠKE

### ❌ "Purchase cancelled or failed"
**Razlog:** Nisi sign out sa App Store-a
**Rešenje:** Settings → App Store → Sign Out

### ❌ Sandbox prozor se ne pojavljuje
**Razlog:** Prijavljena si sa pravim Apple ID-om
**Rešenje:** Sign out sa App Store-a

### ❌ "Invalid credentials"
**Razlog:** Pogrešan email ili password
**Rešenje:** Proveri email i password u App Store Connect → Sandbox Testers

### ❌ "This Apple ID is already in use"
**Razlog:** Koristiš email koji već postoji u App Store-u
**Rešenje:** Kreiraj novi Sandbox Test Account sa drugim email-om

---

## ✅ Checklist

- [ ] Kreirao si Sandbox Test Account u App Store Connect
- [ ] Zapamtio si email i password
- [ ] Sign out-ovala si se sa App Store-a na iPhone-u
- [ ] Otvorila si aplikaciju iz TestFlight-a
- [ ] Kliknula si na plan
- [ ] Sandbox prozor se pojavio
- [ ] Prijavila si se sa Sandbox Test Account-om
- [ ] Kupovina je prošla!

---

## 💡 Savet

**Kreiraj 2-3 Sandbox Test Account-a:**
- Jedan za sebe
- Jedan za drugog testera
- Jedan rezervni

Tako možeš testirati sa različitim nalozima bez problema.

---

## 🔍 Gde Se Prijavljuješ?

**ODGOVOR:** Ne prijavljuješ se NIGDE pre kupovine!

- ❌ NE u Settings
- ❌ NE u App Store aplikaciji
- ❌ NE u TestFlight-u
- ✅ DA - samo kada klikneš kupovinu i pojavi se Sandbox prozor!

Apple automatski detektuje da si sign out sa App Store-a i pokazuje Sandbox prozor kada pokušaš kupovinu.

