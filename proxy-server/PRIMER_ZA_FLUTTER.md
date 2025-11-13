# 💻 Primer koda za Flutter aplikaciju

## Kako postaviti Proxy URL u Flutter aplikaciji

### Opcija 1: Direktno u `main.dart` (najlakše)

Otvori `ZaMariju/lib/main.dart` i dodaj na početak `main()` funkcije:

```dart
import 'package:gpt_wrapped2/services/ai_analyzer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ============================================
  // POSTAVI PROXY URL OVDE
  // ============================================
  
  // Za Desktop/Chrome (default):
  // AIAnalyzer.setProxyUrl('http://localhost:3000');
  
  // Za Android Emulator:
  AIAnalyzer.setProxyUrl('http://10.0.2.2:3000');
  
  // Za iOS Simulator (koristi localhost):
  // AIAnalyzer.setProxyUrl('http://localhost:3000');
  
  // Za fizički telefon (zameni sa IP adresom tvog računara):
  // AIAnalyzer.setProxyUrl('http://192.168.1.100:3000');
  
  // Za production (kada deploy-uješ proxy server):
  // AIAnalyzer.setProxyUrl('https://your-proxy.railway.app');
  
  runApp(const MyApp());
}
```

### Opcija 2: Preko Environment Variable (fleksibilnije)

**Kada pokrećeš Flutter app:**

```bash
cd ZaMariju

# Za Android Emulator:
flutter run --dart-define=OPENAI_PROXY_URL=http://10.0.2.2:3000

# Za iOS Simulator:
flutter run --dart-define=OPENAI_PROXY_URL=http://localhost:3000

# Za fizički telefon:
flutter run --dart-define=OPENAI_PROXY_URL=http://192.168.1.100:3000
```

**U `main.dart` ne treba ništa menjati** - već koristi environment variable!

### Opcija 3: Dinamičko postavljanje (najfleksibilnije)

Kreiraj helper funkciju koja automatski detektuje okruženje:

```dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:gpt_wrapped2/services/ai_analyzer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Automatski postavi proxy URL na osnovu platforme
  _setupProxyUrl();
  
  runApp(const MyApp());
}

void _setupProxyUrl() {
  // Proveri da li je postavljen preko environment variable
  const envUrl = String.fromEnvironment('OPENAI_PROXY_URL');
  if (envUrl.isNotEmpty) {
    AIAnalyzer.setProxyUrl(envUrl);
    if (kDebugMode) {
      print('Proxy URL set from environment: $envUrl');
    }
    return;
  }
  
  // Ako nije postavljen, koristi default na osnovu platforme
  if (kIsWeb) {
    // Web/Chrome
    AIAnalyzer.setProxyUrl('http://localhost:3000');
  } else if (Platform.isAndroid) {
    // Android Emulator ili telefon
    // Možeš dodati logiku da detektuje emulator vs telefon
    AIAnalyzer.setProxyUrl('http://10.0.2.2:3000'); // Emulator
    // AIAnalyzer.setProxyUrl('http://192.168.1.100:3000'); // Telefon
  } else if (Platform.isIOS) {
    // iOS Simulator
    AIAnalyzer.setProxyUrl('http://localhost:3000');
  } else {
    // Desktop (Windows/Mac/Linux)
    AIAnalyzer.setProxyUrl('http://localhost:3000');
  }
  
  if (kDebugMode) {
    print('Proxy URL set to: ${AIAnalyzer._getProxyUrl()}');
  }
}
```

**Napomena:** Ova funkcija koristi `_getProxyUrl()` koji je private. Možeš dodati public getter u `AIAnalyzer` klasu:

```dart
// U ai_analyzer.dart, dodaj:
static String getProxyUrl() {
  return _getProxyUrl();
}
```

---

## 📋 Checklist pre pokretanja

- [ ] Proxy server je pokrenut (`npm start` u `proxy-server` folderu)
- [ ] Health check prolazi (`http://localhost:3000/health`)
- [ ] Proxy URL je postavljen u `main.dart` ili preko environment variable
- [ ] Za fizički telefon: računar i telefon su na istoj Wi-Fi mreži
- [ ] Za fizički telefon: IP adresa je tačna (`ipconfig` na Windows-u)

---

## 🧪 Testiranje

Nakon što postaviš proxy URL, testiraj:

1. **Pokreni Flutter app:**
   ```bash
   cd ZaMariju
   flutter run
   ```

2. **U app-u, pokreni premium analizu**

3. **Proveri konzolu:**
   - Trebalo bi da vidiš: `[AIAnalyzer] POST http://.../api/chat via proxy`
   - Ako vidiš grešku, proveri da li je proxy server pokrenut

4. **Proveri konzolu proxy servera:**
   - Trebalo bi da vidiš: `[Proxy] Forwarding request to OpenAI`
   - Ako vidiš grešku sa API key-jem, proveri `.env` fajl

---

## 🔧 Debugging

### Ako vidiš "Connection refused":

1. Proveri da li je proxy server pokrenut
2. Proveri da li je URL tačan
3. Za Android emulator, koristi `10.0.2.2` umesto `localhost`

### Ako vidiš "Timeout":

1. Proveri internet konekciju
2. Proveri da li OpenAI API radi
3. Proveri da li je API key validan

### Ako vidiš "401 Unauthorized":

1. Proveri da li je API key tačan u `.env` fajlu
2. Proveri da li API key počinje sa `sk-`
3. Proveri da li nema razmaka u `.env` fajlu

---

**Srećno! 🚀**

