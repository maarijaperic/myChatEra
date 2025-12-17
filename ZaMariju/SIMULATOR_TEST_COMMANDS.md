# 📱 Komande za Testiranje na Simulatoru

## 🚀 Pokretanje Simulatora iPhone 16 Pro

### Komanda 1: Otvori Simulator iPhone 16 Pro

```bash
xcrun simctl boot "iPhone 16 Pro" 2>/dev/null || open -a Simulator && xcrun simctl boot "iPhone 16 Pro"
```

**Ili jednostavnije:**

```bash
open -a Simulator
```

Zatim u Simulator-u:
- **File → Open Simulator → iPhone 16 Pro**

---

## 🔍 Komande za Logove

### Komanda 2: Praćenje Flutter Logova (Sve)

```bash
flutter run --verbose
```

**Ili samo Flutter logovi:**

```bash
flutter logs
```

---

### Komanda 3: Praćenje iOS System Logova (Simulator)

```bash
xcrun simctl spawn booted log stream --level=debug --predicate 'processImagePath contains "Runner"'
```

**Ili jednostavnije (samo RevenueCat logovi):**

```bash
xcrun simctl spawn booted log stream --level=debug --predicate 'messageText contains "RevenueCat"'
```

---

### Komanda 4: Praćenje StoreKit Logova

```bash
xcrun simctl spawn booted log stream --level=debug --predicate 'subsystem == "com.apple.storekit"'
```

---

### Komanda 5: Svi Logovi (Flutter + iOS + StoreKit)

```bash
flutter run --verbose 2>&1 | tee simulator_logs.txt &
xcrun simctl spawn booted log stream --level=debug --predicate 'processImagePath contains "Runner" OR subsystem == "com.apple.storekit" OR messageText contains "RevenueCat"' 2>&1 | tee ios_logs.txt
```

---

## 📋 Kompletan Workflow

### Korak 1: Otvori Simulator

```bash
open -a Simulator
```

Zatim izaberi **iPhone 16 Pro** iz menija.

---

### Korak 2: Pokreni Aplikaciju sa Detaljnim Logovima

```bash
cd /Users/m1/Documents/myChatEra/ZaMariju
flutter run --verbose
```

**Ili u drugom terminalu:**

```bash
cd /Users/m1/Documents/myChatEra/ZaMariju
flutter run
```

---

### Korak 3: Praćenje iOS Logova (U Drugom Terminalu)

```bash
xcrun simctl spawn booted log stream --level=debug --predicate 'messageText contains "RevenueCat" OR messageText contains "StoreKit" OR messageText contains "Purchase"'
```

---

## 🎯 Najbolji Način - Dva Terminala

### Terminal 1: Flutter Aplikacija

```bash
cd /Users/m1/Documents/myChatEra/ZaMariju
flutter run --verbose
```

### Terminal 2: iOS System Logovi

```bash
xcrun simctl spawn booted log stream --level=debug --predicate 'messageText contains "RevenueCat" OR messageText contains "StoreKit" OR messageText contains "Purchase" OR messageText contains "PREMIUM_DEBUG"'
```

---

## 📝 Šta ćeš Videti u Logovima

### Flutter Logovi (Terminal 1):
- ✅ `🔴 RevenueCat:` - RevenueCat logovi
- ✅ `🔴 PREMIUM_DEBUG:` - Premium debug logovi
- ✅ `✅ RevenueCat:` - Uspešne operacije
- ✅ `❌ RevenueCat:` - Greške

### iOS System Logovi (Terminal 2):
- ✅ StoreKit logovi
- ✅ Purchase flow logovi
- ✅ Sandbox logovi (ako koristi)

---

## 🔍 Filteri za Logove

### Samo RevenueCat:

```bash
xcrun simctl spawn booted log stream --level=debug --predicate 'messageText contains "RevenueCat"'
```

### Samo Purchase:

```bash
xcrun simctl spawn booted log stream --level=debug --predicate 'messageText contains "Purchase"'
```

### Samo Greške:

```bash
xcrun simctl spawn booted log stream --level=error --predicate 'messageText contains "RevenueCat" OR messageText contains "Purchase"'
```

---

## 💾 Čuvanje Logova u Fajl

### Flutter Logovi:

```bash
flutter run --verbose 2>&1 | tee flutter_logs_$(date +%Y%m%d_%H%M%S).txt
```

### iOS System Logovi:

```bash
xcrun simctl spawn booted log stream --level=debug --predicate 'messageText contains "RevenueCat"' 2>&1 | tee ios_logs_$(date +%Y%m%d_%H%M%S).txt
```

---

## 🎯 Quick Start (Sve u Jednom)

### Otvori Simulator i Pokreni Aplikaciju:

```bash
cd /Users/m1/Documents/myChatEra/ZaMariju
open -a Simulator && sleep 2 && flutter run --verbose
```

### U Drugom Terminalu - Praćenje Logova:

```bash
xcrun simctl spawn booted log stream --level=debug --predicate 'messageText contains "RevenueCat" OR messageText contains "PREMIUM_DEBUG" OR messageText contains "Purchase"'
```

---

## ✅ Checklist

- [ ] Simulator je otvoren (iPhone 16 Pro)
- [ ] Aplikacija je pokrenuta (`flutter run`)
- [ ] Logovi su aktivni (drugi terminal)
- [ ] Testiraš kupovinu u aplikaciji
- [ ] Proveravaš logove za greške

---

## 🐛 Ako Ne Vidiš Logove

### Problem: Logovi se ne prikazuju
**Rešenje:**
1. Proveri da li je aplikacija pokrenuta
2. Proveri da li je simulator aktivan
3. Proveri da li su filteri tačni

### Problem: Previše logova
**Rešenje:**
- Koristi specifičnije filtere (samo "RevenueCat")

### Problem: Logovi su spori
**Rešenje:**
- Koristi `--level=error` umesto `--level=debug` za brže logove

