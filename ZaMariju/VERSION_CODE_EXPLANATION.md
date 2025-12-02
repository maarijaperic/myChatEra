# 📦 Version Code - Objašnjenje

## ⚠️ PROBLEM:

Google Play Console kaže:
> "Кôд верзије 1 је већ искоришћен. Пробајте са другим кодом верзије."

**Šta to znači:**
- Svaki AAB koji upload-uješ mora imati **jedinstven version code**
- Version code 1 je već korišćen (verovatno si već upload-ovao AAB)
- Treba da povećaš version code na 2

---

## ✅ ŠTA SAM URADIO:

**Promenio sam version code u `pubspec.yaml`:**
- **Staro:** `version: 1.0.0+1` (version code = 1)
- **Novo:** `version: 1.0.0+2` (version code = 2)

---

## 🔨 ŠTA DA URADIŠ SADA:

### **KORAK 1: Build Novi AAB sa Novim Version Code-om**

```bash
cd ZaMariju
flutter clean
flutter build appbundle --release
```

**Novi AAB će imati version code 2!** ✅

### **KORAK 2: Upload Novi AAB**

1. **Vrati se na: Тестирање → Затворено тестирање**
2. **Kreiraj novo izdanje** (ili ažuriraj postojeće)
3. **Upload NOVI `app-release.aab`** (sa version code 2)
4. **Sada bi trebalo da prođe!** ✅

---

## 📋 KAKO FUNKCIONIŠE VERSION CODE:

**Format:** `version: X.Y.Z+BUILD`

- **X.Y.Z** = Version name (1.0.0) - korisnici vide ovo
- **BUILD** = Version code (+2) - Google Play koristi ovo

**Primer:**
- `version: 1.0.0+1` → Version code = 1
- `version: 1.0.0+2` → Version code = 2
- `version: 1.0.1+3` → Version code = 3

**Pravilo:**
- Svaki novi AAB mora imati **veći** version code
- Ne možeš upload-ovati AAB sa manjim version code-om

---

## ✅ FINALNI REZULTAT:

- ✅ Version code promenjen na **2**
- ✅ Sada možeš build-ovati novi AAB
- ✅ Upload novi AAB sa version code 2

---

## ⚠️ VAŽNO:

- **Svaki put kada upload-uješ novi AAB, povećaj version code**
- **Version code mora biti veći od prethodnog**
- **Version name može ostati isti** (1.0.0), ali version code mora rasti

---

**Build-uj novi AAB sa version code 2 i upload-uj ga! 🚀**
