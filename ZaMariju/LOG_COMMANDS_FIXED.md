# 📋 Ispravne Komande za Praćenje Logova

## 🎯 Komanda 1: iOS System Logovi (Najbolja!)

```bash
xcrun simctl spawn booted log stream --level=debug --style=compact | grep -i "RevenueCat\|PREMIUM_DEBUG\|Purchase"
```

---

## 🎯 Komanda 2: Samo RevenueCat (Sa Grep)

```bash
xcrun simctl spawn booted log stream --level=debug --style=compact | grep -i "RevenueCat"
```

---

## 🎯 Komanda 3: Flutter Logovi (Najlakše!)

```bash
cd /Users/m1/Documents/myChatEra/ZaMariju
flutter logs
```

---

## 🎯 Komanda 4: Flutter Run sa Verbose (Sve u Jednom)

```bash
cd /Users/m1/Documents/myChatEra/ZaMariju
flutter run --verbose
```

---

## 🎯 Komanda 5: Console App (Alternativa)

Ako imaš problema sa terminal komandama, možeš koristiti Console aplikaciju:

1. Otvori **Console** aplikaciju (Applications → Utilities → Console)
2. U filteru unesi: `RevenueCat` ili `PREMIUM_DEBUG`
3. Izaberi simulator device

---

## 🎯 Komanda 6: Log Show (Istorijski Logovi)

```bash
xcrun simctl spawn booted log show --last 5m --predicate 'eventMessage contains "RevenueCat" OR eventMessage contains "PREMIUM_DEBUG"'
```

---

## 🚀 Preporučena Komanda (Najbolja!)

**Otvori novi terminal i pokreni:**

```bash
xcrun simctl spawn booted log stream --level=debug --style=compact | grep -i "RevenueCat\|PREMIUM_DEBUG\|Purchase"
```

**Ili još jednostavnije - samo Flutter logovi:**

```bash
cd /Users/m1/Documents/myChatEra/ZaMariju && flutter logs
```

---

## 💡 Alternativa: Flutter Run sa Verbose

**Najlakše rešenje - sve u jednom:**

```bash
cd /Users/m1/Documents/myChatEra/ZaMariju
flutter run --verbose
```

Ova komanda će:
- ✅ Pokrenuti aplikaciju
- ✅ Prikazati sve Flutter logove
- ✅ Prikazati RevenueCat logove
- ✅ Prikazati sve greške

---

## 📝 Kako Koristiti

### Opcija 1: Flutter Logovi (Najlakše)

1. **Otvori Terminal**
2. **Pokreni:**
   ```bash
   cd /Users/m1/Documents/myChatEra/ZaMariju
   flutter logs
   ```
3. **U drugom terminalu pokreni aplikaciju:**
   ```bash
   cd /Users/m1/Documents/myChatEra/ZaMariju
   flutter run
   ```

### Opcija 2: Flutter Run sa Verbose (Sve u Jednom)

1. **Otvori Terminal**
2. **Pokreni:**
   ```bash
   cd /Users/m1/Documents/myChatEra/ZaMariju
   flutter run --verbose
   ```
3. **Sve logove vidiš direktno u terminalu!**

---

## 🎯 Quick Copy-Paste Komande

### Najlakše (kopiraj ovo):

```bash
cd /Users/m1/Documents/myChatEra/ZaMariju && flutter run --verbose
```

### Ili samo logovi (kopiraj ovo):

```bash
cd /Users/m1/Documents/myChatEra/ZaMariju && flutter logs
```

### iOS System logovi sa grep (kopiraj ovo):

```bash
xcrun simctl spawn booted log stream --level=debug --style=compact | grep -i "RevenueCat\|PREMIUM_DEBUG\|Purchase"
```

