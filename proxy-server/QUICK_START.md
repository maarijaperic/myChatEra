# ⚡ QUICK START - Brzi početak

## 🚀 5 koraka do funkcionalnog proxy servera

### 1️⃣ Instaliraj dependencies
```bash
cd proxy-server
npm install
```

### 2️⃣ Kreiraj `.env` fajl
U `proxy-server` folderu, kreiraj fajl `.env` sa:
```
OPENAI_API_KEY=sk-tvoj-api-kljuc-ovde
PORT=3000
```

**Gde naći API key:** https://platform.openai.com/api-keys

### 3️⃣ Pokreni server
```bash
npm start
```

Trebalo bi da vidiš:
```
🚀 OpenAI Proxy Server running on port 3000
```

### 4️⃣ Proveri da li radi
Otvori browser: `http://localhost:3000/health`

Trebalo bi da vidiš: `{"status":"ok",...}`

### 5️⃣ Postavi u Flutter app

**Za Android Emulator:**
```dart
// U main.dart, dodaj:
import 'package:gpt_wrapped2/services/ai_analyzer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AIAnalyzer.setProxyUrl('http://10.0.2.2:3000');
  runApp(const MyApp());
}
```

**Za Desktop/iOS:**
```dart
AIAnalyzer.setProxyUrl('http://localhost:3000');
```

---

## ✅ Gotovo!

Sada možeš koristiti premium funkcije u Flutter app-u!

---

## 📚 Detaljnije instrukcije

- **DETALJNI_KORACI.md** - Kompletan vodič sa svim detaljima
- **PRIMER_ZA_FLUTTER.md** - Primeri koda za Flutter
- **SETUP_INSTRUCTIONS.md** - Instrukcije za deployment

---

## ❌ Problem?

**"OPENAI_API_KEY is not set"**
→ Proveri `.env` fajl

**"Cannot connect"**
→ Proveri da li je server pokrenut (`npm start`)

**"Port 3000 in use"**
→ Promeni `PORT=3001` u `.env` fajlu

