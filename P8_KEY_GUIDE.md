# 🔑 Kako da Nađeš P8 Key za RevenueCat

## 🎯 Problem: Ne možeš da pristupiš `/access/api` stranici

**Razlog:** Možda nemaš Admin pristup ili je link promenjen.

---

## ✅ REŠENJE: Alternativni načini pristupa

### **Metoda 1: Preko Users and Access (Najlakše)**

1. **Otvori App Store Connect:**
   - Idi na: https://appstoreconnect.apple.com/
   - Uloguj se

2. **Idi na Users and Access:**
   - Klikni na tvoj profil (gore desno, ikonica korisnika)
   - Izaberi **"Users and Access"**
   - Ili direktno: https://appstoreconnect.apple.com/access/users

3. **Idi na Keys tab:**
   - U levo meniju klikni **"Keys"** tab
   - Ili direktno: https://appstoreconnect.apple.com/access/api?type=appstoreconnect

4. **Proveri da li već imaš key:**
   - Ako vidiš listu keys → već imaš kreiran key!
   - Ako ne vidiš ništa → treba da kreiraš novi

---

### **Metoda 2: Preko Settings**

1. **U App Store Connect:**
   - Idi na "My Apps" → izaberi aplikaciju
   - Idi na "App Information" ili "App Store" tab
   - Scroll dole → traži "App Store Connect API" sekciju
   - Klikni "Manage API Keys" ili "Keys"

---

### **Metoda 3: Direktan link (probaj)**

1. **Probaj ovaj link:**
   ```
   https://appstoreconnect.apple.com/access/api?type=appstoreconnect
   ```

2. **Ili ovaj:**
   ```
   https://appstoreconnect.apple.com/access/api
   ```

---

## 🔍 Provera: Da li već imaš P8 key?

### **Proveri na računaru:**

1. **Traži `.p8` fajlove:**
   ```bash
   # Na Mac-u:
   find ~ -name "*.p8" -type f 2>/dev/null
   
   # Ili traži u Downloads:
   ls -la ~/Downloads/*.p8
   ```

2. **Proveri u dokumentaciji:**
   - Proveri da li si negde sačuvao P8 key
   - Proveri email (možda si ga poslao sebi)

---

## 📋 Kako da Kreiraš P8 Key (ako nemaš)

### **Korak 1: Pristup Keys stranici**

**Ako ne možeš da pristupiš `/access/api`:**

1. **Proveri pristup:**
   - Idi na: https://appstoreconnect.apple.com/access/users
   - Proveri da li si **Admin** ili **App Manager**
   - Ako nisi, zatraži od vlasnika naloga da ti da pristup

2. **Alternativno:**
   - Idi na: https://appstoreconnect.apple.com/
   - Klikni na tvoj profil (gore desno)
   - Izaberi "Users and Access"
   - Klikni "Keys" tab

### **Korak 2: Kreiraj novi API Key**

1. **Klikni "+" ili "Generate API Key"**

2. **Unesi:**
   - **Key Name:** `RevenueCat API Key` (ili bilo šta)
   - **Access:** "App Manager" (ili "Admin" ako imaš)

3. **Klikni "Generate"**

### **Korak 3: Download P8 Key**

1. **Nakon kreiranja:**
   - Klikni na key u listi
   - Klikni **"Download API Key"** ili **"Download"**
   - **VAŽNO:** Sačuvaj fajl! Može se download-ovati samo jednom!

2. **Fajl će biti:**
   - Format: `AuthKey_XXXXXXXXXX.p8`
   - Primer: `AuthKey_ABC123DEF4.p8`

### **Korak 4: Kopiraj Key ID i Issuer ID**

1. **Key ID:**
   - Vidi se u listi keys (pored key name-a)
   - Primer: `ABC123DEF4`

2. **Issuer ID:**
   - Vidi se na vrhu Keys stranice
   - Format: `12345678-1234-1234-1234-123456789012`
   - Ili idi na: https://appstoreconnect.apple.com/access/api
   - Issuer ID je na vrhu stranice

---

## 💡 Ako i dalje ne možeš da pristupiš

### **Problem: "You don't have access"**

**Rešenje:**
1. Kontaktiraj vlasnika Apple Developer naloga
2. Zatraži da ti da **Admin** ili **App Manager** pristup
3. Ili zatraži da on kreira API key i pošalje ti P8 fajl

### **Problem: "Page not found"**

**Rešenje:**
1. Proveri da li si ulogovan sa pravim Apple ID-om
2. Proveri da li imaš Apple Developer Program membership
3. Probaj u drugom browseru (Chrome, Safari, Firefox)
4. Probaj incognito mode

---

## 📤 Dodavanje u RevenueCat

### **Kada imaš P8 key:**

1. **Otvori RevenueCat Dashboard:**
   - Idi na: https://app.revenuecat.com/
   - Idi na tvoj projekat → iOS aplikaciju

2. **Idi na App Store Connect tab:**
   - Scroll do "In-app purchase key configuration"

3. **Upload P8 key:**
   - Klikni "Drop a file here" ili "Select"
   - Pronađi `AuthKey_XXXXXXXXXX.p8` fajl
   - Upload-uj

4. **Unesi Key ID i Issuer ID:**
   - **Key ID:** Unesi Key ID (npr. `ABC123DEF4`)
   - **Issuer ID:** Unesi Issuer ID (npr. `12345678-1234-1234-1234-123456789012`)
   - Klikni "Save"

---

## ✅ Checklist

- [ ] Pristupio Keys stranici u App Store Connect
- [ ] Kreirao API Key (ili našao postojeći)
- [ ] Download-ovao P8 fajl
- [ ] Kopirao Key ID
- [ ] Kopirao Issuer ID
- [ ] Upload-ovao P8 u RevenueCat
- [ ] Unesao Key ID i Issuer ID u RevenueCat
- [ ] Sačuvao promene

---

## 🆘 Ako i dalje ne možeš

**Kontaktiraj:**
1. Apple Developer Support: https://developer.apple.com/contact/
2. RevenueCat Support: https://www.revenuecat.com/support

---

**Srećno! 🚀**

