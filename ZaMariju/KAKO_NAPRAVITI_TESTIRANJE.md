# 🧪 Kako da Napraviš Otvoreno i Zatvoreno Testiranje - Google Play Console

## 🎯 ŠTA TREBA DA URADIŠ:

Google Play Console zahteva da prvo upload-uješ aplikaciju u test track pre produkcije. Evo koraka:

---

## 📋 KORAK 1: Kreiraj Zatvoreno Testiranje (Closed Testing)

### **1.1. Idi na Testiranje**

1. **U Google Play Console, u meniju sa leve strane:**
   - Klikni na **"Тестирање"** (Testing)
   - Ima strelicu ⬇️ koja pokazuje da se može proširiti

2. **Kada klikneš, videćeš opcije:**
   - **"Затворено тестирање"** (Closed testing)
   - **"Отворено тестирање"** (Open testing)
   - Možda i druge opcije

### **1.2. Kreiraj Zatvoreno Testiranje**

1. **Klikni na "Затворено тестирање"** (Closed testing)
2. **Videćeš stranicu za zatvoreno testiranje**
3. **Klikni na:**
   - **"+ Kreiraj listu"** (+ Create list)
   - **"+ Kreiraj zatvoreno testiranje"** (+ Create closed testing)
   - **"Nova lista"** (New list)

4. **Unesi:**
   - **Naziv liste:** `Internal Test` ili `Zatvoreno testiranje`
   - **Opis:** (opciono) `Internal testing for billing setup`

5. **Klikni "Kreiraj"** ili **"Sačuvaj"**

### **1.3. Upload AAB u Zatvoreno Testiranje**

1. **Kada kreiraš listu, videćeš opciju:**
   - **"Kreiraj novo izdanje"** (Create new release)
   - **"+ Kreiraj izdanje"** (+ Create release)

2. **Klikni na to dugme**

3. **Upload AAB:**
   - Klikni **"Upload"** ili **"Otpremi"**
   - Odaberi `app-release.aab` fajl
   - Sačekaj da se upload završi

4. **Release notes:**
   ```
   Initial release for testing
   - Added billing support
   ```

5. **Klikni "Sačuvaj"**

6. **Dodaj testere (opciono):**
   - Možeš dodati email adrese testera
   - Ili možeš ostaviti prazno za sada

7. **Klikni "Sačuvaj"** ili **"Završi"**

---

## 📋 KORAK 2: Kreiraj Otvoreno Testiranje (Open Testing)

### **2.1. Idi na Otvoreno Testiranje**

1. **U Google Play Console, u meniju:**
   - **"Тестирање"** (Testing) → **"Отворено тестирање"** (Open testing)

2. **Klikni na "Отворено тестирање"**

### **2.2. Kreiraj Otvoreno Testiranje**

1. **Videćeš opciju:**
   - **"+ Kreiraj otvoreno testiranje"** (+ Create open testing)
   - **"Kreiraj novo izdanje"** (Create new release)

2. **Klikni na to dugme**

3. **Upload AAB:**
   - Klikni **"Upload"** ili **"Otpremi"**
   - Odaberi **ISTI** `app-release.aab` fajl
   - Sačekaj da se upload završi

4. **Release notes:**
   ```
   Initial release for open testing
   - Added billing support
   ```

5. **Klikni "Sačuvaj"**

---

## ✅ KORAK 3: Sada Možeš Kreirati Proizvode!

**Nakon što upload-uješ AAB u test track:**

1. **Sačekaj 5-10 minuta** (Google Play Console treba vreme da procesira AAB)

2. **Vrati se na:**
   - **Monetizacija → Производи → Једнократни производи**

3. **Sada bi trebalo da možeš da kreiraš proizvode!**

4. **Kreiraj:**
   - `one_time_purchase` ($9.99)
   - `monthly_subscription` ($4.99) - u "Пријаве"
   - `yearly_subscription` ($19.99) - u "Пријаве"

---

## 📋 CHECKLIST:

- [ ] ⏳ Kreiraj "Затворено тестирање" (Closed testing)
- [ ] ⏳ Upload AAB u zatvoreno testiranje
- [ ] ⏳ Kreiraj "Отворено тестирање" (Open testing)
- [ ] ⏳ Upload AAB u otvoreno testiranje
- [ ] ⏳ Sačekaj 5-10 minuta
- [ ] ⏳ Kreiraj proizvode u Google Play Console

---

## ⚠️ VAŽNO:

- **Ne moraš da submit-uješ za review** - samo upload-uj AAB u test track
- **Test track je samo za testiranje** - neće biti javno dostupan
- **Nakon što kreiraš proizvode, možeš upload-ovati u produkciju**

---

## 🎯 REZIME:

1. **Kreiraj zatvoreno testiranje** → Upload AAB
2. **Kreiraj otvoreno testiranje** → Upload AAB
3. **Sačekaj 5-10 minuta**
4. **Kreiraj proizvode** u Google Play Console
5. **Zatim možeš upload-ovati u produkciju**

---

**Sledeći korak: Kreiraj zatvoreno testiranje i upload-uj AAB! 🚀**
