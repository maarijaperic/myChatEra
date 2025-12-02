# ⚙️ Codemagic Dashboard Settings - Project Path

## 🎯 PROBLEM:

Codemagic i dalje pokušava da instalira dependencies u root-u, čak i sa `working_directory` u `codemagic.yaml`.

**Zašto?**
- Codemagic automatski instalira dependencies PRE script-ova
- `working_directory` utiče samo na script-ove, ne na automatsku instalaciju

---

## ✅ REŠENJE:

### **POSTAVI PROJECT PATH U CODEMAGIC DASHBOARD-U!**

**Ovo je NAJVAŽNIJI korak - mora se postaviti u dashboard-u!**

---

## 📋 KORAK PO KORAK:

### **1. Idi na Codemagic Dashboard:**

1. **Otvori:** https://codemagic.io/
2. **Uloguj se** sa svojim nalogom
3. **Klikni na tvoju aplikaciju**

---

### **2. Idi na Settings:**

1. **U Codemagic dashboard:**
   - Klikni na tvoju aplikaciju
   - Idi na: **Settings** (ili **⚙️** ikona)
   - Traži: **Build settings** ili **Project settings**

---

### **3. Postavi Project Path:**

1. **Traži polje:**
   - **"Project path"** ili
   - **"Working directory"** ili
   - **"Project root"** ili
   - **"Flutter project path"**

2. **Unesi:**
   ```
   ZaMariju
   ```

3. **Sačuvaj:**
   - Klikni: **Save** ili **Update**

---

### **4. Ako Ne Vidiš Polje:**

**Ako ne vidiš "Project path" polje:**

1. **Idi na: Settings → Build configuration**
2. **Traži: "Project type" ili "Flutter project"**
3. **Možda ima opciju: "Select Flutter project"**
4. **Izaberi: `ZaMariju`**

---

### **5. Alternativa: Re-kreiraj Aplikaciju:**

**Ako ne možeš da pronađeš polje:**

1. **Idi na: Applications → Add application**
2. **Izaberi tvoj repo**
3. **Kada vidiš:**
   > "The repository doesn't seem to contain a mobile application..."

4. **U polju "Project path":**
   - Unesi: `ZaMariju`
   - Klikni: **Continue**

5. **Codemagic će sada detektovati Flutter projekat!**

---

## 📋 PROVERA:

### **1. Proveri da li je Postavljeno:**

**Nakon što postaviš project path:**

1. **Idi na: Settings → Build settings**
2. **Proveri da li piše:**
   - **Project path:** `ZaMariju`
   - Ili: **Working directory:** `ZaMariju`

---

### **2. Pokreni Test Build:**

1. **Klikni: Start new build**
2. **Izaberi: iOS workflow**
3. **Klikni: Start build**

4. **Proveri build log-ove:**
   - Trebalo bi da vidiš: `Installing dependencies in ZaMariju`
   - Ili: `Found pubspec.yaml in ZaMariju`

---

## ⚠️ VAŽNO:

**Project path MORA biti postavljen u Codemagic dashboard-u!**

**`codemagic.yaml` sa `working_directory` NIJE DOVOLJNO!**

**Codemagic automatski instalira dependencies PRE script-ova, pa mora znati gde je projekat!**

---

## 📋 CHECKLIST:

- [ ] ✅ Otvoren Codemagic dashboard
- [ ] ✅ Idi na Settings → Build settings
- [ ] ✅ Pronađen "Project path" polje
- [ ] ✅ Postavljeno na `ZaMariju`
- [ ] ✅ Sačuvano
- [ ] ✅ Pokrenut novi build
- [ ] ✅ Build log-ovi pokazuju da se nalazi u `ZaMariju` folderu
- [ ] ✅ Dependencies su instalirane uspešno

---

## 🎯 REZIME:

**Problem:** Codemagic automatski instalira dependencies u root-u

**Rešenje:**
1. ✅ **POSTAVI Project path na `ZaMariju` u Codemagic dashboard-u**
2. ✅ Ovo je NAJVAŽNIJI korak!
3. ✅ `codemagic.yaml` sa `working_directory` je backup
4. ✅ Pokreni novi build

---

**POSTAVI Project path u Codemagic dashboard-u - to je ključ! 🔑**
