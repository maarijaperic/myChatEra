# 📚 DETALJNI KORACI - Kako koristiti Proxy Server

Ovaj vodič će te provesti kroz **SVE** korake, od početka do kraja, sa konkretnim primerima.

---

## 🎯 KORAK 1: Instalacija Node.js (ako nemaš)

### Provera da li imaš Node.js:

1. Otvori **PowerShell** ili **Command Prompt**
2. Ukucaj:
   ```bash
   node --version
   ```
3. Ako vidiš verziju (npr. `v18.17.0`), imaš Node.js! ✅
4. Ako vidiš grešku, instaliraj Node.js:

### Instalacija Node.js:

1. Idi na: https://nodejs.org/
2. Preuzmi **LTS verziju** (preporučeno)
3. Pokreni installer
4. Klikni "Next" kroz sve korake
5. Restartuj terminal nakon instalacije
6. Proveri ponovo: `node --version`

---

## 🔧 KORAK 2: Instalacija Dependencies za Proxy Server

### 2.1. Otvori Terminal u `proxy-server` folderu

**Na Windows-u:**
1. Otvori File Explorer
2. Idi u folder: `C:\Users\Korisnik\Documents\GPTWrapped-1\proxy-server`
3. Klikni na adresnu traku (gde piše putanja)
4. Ukucaj: `powershell` i pritisni Enter
   - Ili desni klik u folderu → "Open in Terminal" / "Open PowerShell window here"

**Ili direktno u PowerShell:**
```powershell
cd "C:\Users\Korisnik\Documents\GPTWrapped-1\proxy-server"
```

### 2.2. Instaliraj dependencies

U terminalu ukucaj:
```bash
npm install
```

**Šta se dešava:**
- Node.js će preuzeti sve potrebne pakete (express, cors, axios, dotenv)
- Ovo može potrajati 1-2 minuta
- Trebalo bi da vidiš: `added 50 packages` ili slično

**Ako vidiš grešku:**
- `'npm' is not recognized` → Node.js nije instaliran ili nije u PATH-u
- `EACCES` ili permission error → Pokreni PowerShell kao Administrator

---

## 🔑 KORAK 3: Dobijanje OpenAI API Key

### 3.1. Kreiraj nalog na OpenAI (ako nemaš)

1. Idi na: https://platform.openai.com/
2. Klikni **"Sign up"**
3. Popuni formu ili se uloguj sa Google/Microsoft nalogom

### 3.2. Dodaj kreditnu karticu (potrebno za API)

1. Uloguj se na: https://platform.openai.com/
2. Idi u **"Settings"** → **"Billing"**
3. Klikni **"Add payment method"**
4. Unesi podatke kartice
5. **Napomena:** OpenAI naplaćuje samo ono što koristiš (~$0.01-0.02 po korisniku)

### 3.3. Kreiraj API Key

1. Idi na: https://platform.openai.com/api-keys
2. Klikni **"Create new secret key"**
3. Daj mu ime (npr. "GPT Wrapped Proxy")
4. Klikni **"Create secret key"**
5. **VAŽNO:** Kopiraj ključ ODMAH! (počinje sa `sk-`)
   - Primer: `sk-proj-abc123xyz789def456ghi012jkl345mno678pqr901stu234vwx567`
6. Sačuvaj ga negde sigurno (npr. u Notepad)

**⚠️ VAŽNO:**
- Nećeš moći da vidiš ključ ponovo!
- Ako ga izgubiš, moraš kreirati novi
- Ne deli ga sa drugima!

---

## 📝 KORAK 4: Kreiranje `.env` fajla

### 4.1. Kreiraj `.env` fajl u `proxy-server` folderu

**Metoda 1: Preko File Explorera (Windows)**

1. Otvori folder: `C:\Users\Korisnik\Documents\GPTWrapped-1\proxy-server`
2. Desni klik → **"New"** → **"Text Document"**
3. Nazovi ga: `.env` (uključujući tačku na početku!)
4. Windows će upozoriti: "If you change a file name extension, the file might become unusable"
5. Klikni **"Yes"**
6. Fajl će se zvati `.env` (bez ekstenzije)

**Metoda 2: Preko PowerShell-a**

```powershell
cd "C:\Users\Korisnik\Documents\GPTWrapped-1\proxy-server"
New-Item -Path .env -ItemType File
```

**Metoda 3: Preko Notepad-a**

1. Otvori Notepad
2. Klikni **"Save As"**
3. U "Save as type" izaberi **"All Files (*.*)"**
4. Nazovi fajl: `.env`
5. Sačuvaj u `proxy-server` folderu

### 4.2. Dodaj sadržaj u `.env` fajl

1. Otvori `.env` fajl (desni klik → "Open with" → "Notepad")
2. Dodaj sledeće (zameni `sk-tvoj-api-kljuc-ovde` sa svojim ključem):

```
OPENAI_API_KEY=sk-tvoj-api-kljuc-ovde
PORT=3000
```

**Konkretan primer:**
```
OPENAI_API_KEY=sk-proj-abc123xyz789def456ghi012jkl345mno678pqr901stu234vwx567
PORT=3000
```

**⚠️ VAŽNO:**
- Nema razmaka oko `=`
- Nema navodnika oko vrednosti
- API ključ mora počinjati sa `sk-`
- Ne dodavaj komentare u `.env` fajl

### 4.3. Sačuvaj fajl

1. Pritisni `Ctrl + S` ili File → Save
2. Zatvori Notepad

---

## ▶️ KORAK 5: Pokretanje Proxy Servera

### 5.1. Otvori Terminal u `proxy-server` folderu

Vidi **KORAK 2.1** za instrukcije kako otvoriti terminal.

### 5.2. Pokreni server

**Za prvo pokretanje:**
```bash
npm start
```

**Za development (sa auto-reload):**
```bash
npm run dev
```

**Šta treba da vidiš:**
```
🚀 OpenAI Proxy Server running on port 3000
📝 Health check: http://localhost:3000/health
🔒 Make sure OPENAI_API_KEY is set in .env file
```

**Ako vidiš grešku:**
- `OPENAI_API_KEY is not set` → Proveri `.env` fajl (vidi KORAK 4)
- `Port 3000 already in use` → Promeni `PORT=3001` u `.env` fajlu
- `Cannot find module` → Pokreni `npm install` ponovo

### 5.3. Proveri da li server radi

**Metoda 1: Preko Browser-a**

1. Otvori browser (Chrome, Firefox, Edge)
2. Idi na: `http://localhost:3000/health`
3. Trebalo bi da vidiš:
   ```json
   {"status":"ok","message":"OpenAI Proxy Server is running"}
   ```

**Metoda 2: Preko PowerShell-a**

U novom terminalu:
```powershell
curl http://localhost:3000/health
```

**Ako vidiš JSON odgovor, server radi! ✅**

---

## 📱 KORAK 6: Podešavanje Flutter Aplikacije

### 6.1. Razumevanje kako Flutter app koristi proxy

Flutter aplikacija već je podešena da koristi proxy server! Pogledaj `ai_analyzer.dart`:

```dart
static const String _proxyBaseUrl = String.fromEnvironment(
  'OPENAI_PROXY_URL',
  defaultValue: 'http://localhost:3000',
);
```

**Default URL:** `http://localhost:3000` (radi samo ako pokrećeš app na računaru)

### 6.2. Podešavanje za različite scenarije

#### Scenario A: Pokrećeš Flutter app na računaru (Chrome/Desktop)

**Ništa ne treba menjati!** Proxy server već koristi `http://localhost:3000`.

#### Scenario B: Pokrećeš Flutter app na Android Emulatoru

**Problem:** Android emulator ne može pristupiti `localhost` tvog računara.

**Rešenje:** Koristi specijalnu IP adresu `10.0.2.2` koja predstavlja `localhost` tvog računara.

**Kako postaviti:**

1. Otvori `ZaMariju/lib/main.dart`
2. Dodaj na početak `main()` funkcije:

```dart
import 'package:gpt_wrapped2/services/ai_analyzer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Postavi proxy URL za Android emulator
  AIAnalyzer.setProxyUrl('http://10.0.2.2:3000');
  
  runApp(const MyApp());
}
```

**Ili koristi environment variable:**

Kada pokrećeš Flutter app:
```bash
cd ZaMariju
flutter run --dart-define=OPENAI_PROXY_URL=http://10.0.2.2:3000
```

#### Scenario C: Pokrećeš Flutter app na iOS Simulatoru

**iOS Simulator može koristiti `localhost` direktno!**

Ništa ne treba menjati, koristi default `http://localhost:3000`.

#### Scenario D: Pokrećeš Flutter app na fizičkom telefonu

**Problem:** Fizički telefon ne može pristupiti `localhost` tvog računara.

**Rešenje:** Koristi IP adresu tvog računara na lokalnoj mreži.

**Kako pronaći IP adresu:**

**Na Windows-u:**
1. Otvori PowerShell
2. Ukucaj:
   ```powershell
   ipconfig
   ```
3. Pronađi "IPv4 Address" pod "Wireless LAN adapter Wi-Fi" ili "Ethernet adapter"
4. Primer: `192.168.1.100`

**Kako postaviti u Flutter app:**

1. Otvori `ZaMariju/lib/main.dart`
2. Dodaj na početak `main()` funkcije:

```dart
import 'package:gpt_wrapped2/services/ai_analyzer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Postavi proxy URL sa IP adresom tvog računara
  AIAnalyzer.setProxyUrl('http://192.168.1.100:3000'); // Zameni sa svojom IP adresom!
  
  runApp(const MyApp());
}
```

**VAŽNO:**
- Proxy server mora biti pokrenut na računaru
- Računar i telefon moraju biti na istoj Wi-Fi mreži
- Možda ćeš morati da onemogućiš Windows Firewall za port 3000

---

## 🧪 KORAK 7: Korišćenje pri testiranju

### 7.1. Testiranje sa Proxy Serverom (preporučeno)

**Korak 1:** Pokreni proxy server (vidi KORAK 5)

**Korak 2:** U test fajlu, postavi proxy URL:

```dart
import 'package:gpt_wrapped2/services/ai_analyzer.dart';

void main() {
  setUp(() {
    // Postavi proxy URL
    AIAnalyzer.setProxyUrl('http://localhost:3000');
    // Omogući proxy
    AIAnalyzer.setUseProxy(true);
  });
  
  test('Test AI analyzer', () async {
    // Tvoji testovi ovde
  });
}
```

**Korak 3:** Pokreni testove:
```bash
cd ZaMariju
flutter test
```

### 7.2. Testiranje bez Proxy Servera (mock testovi)

Ako želiš da testiraš bez stvarnog API poziva:

```dart
setUp(() {
  // Isključi proxy
  AIAnalyzer.setUseProxy(false);
  // Postavi mock API key (neće se koristiti ako mock-uješ API pozive)
  AIAnalyzer.setApiKeyOverride('test-key');
});
```

**Napomena:** Ovo zahteva da mock-uješ HTTP pozive (koristi `http` paket sa mock-om).

### 7.3. Testiranje Proxy Servera direktno

**Test 1: Health Check**

```bash
curl http://localhost:3000/health
```

**Očekivani odgovor:**
```json
{"status":"ok","message":"OpenAI Proxy Server is running"}
```

**Test 2: API Poziv**

```bash
curl -X POST http://localhost:3000/api/chat ^
  -H "Content-Type: application/json" ^
  -d "{\"model\":\"gpt-4o-mini\",\"messages\":[{\"role\":\"user\",\"content\":\"Hello!\"}]}"
```

**Očekivani odgovor:**
```json
{
  "id": "chatcmpl-...",
  "object": "chat.completion",
  "choices": [
    {
      "message": {
        "role": "assistant",
        "content": "Hello! How can I help you today?"
      }
    }
  ]
}
```

---

## 🔍 KORAK 8: Provera da li sve radi

### 8.1. Checklist

- [ ] Node.js instaliran (`node --version`)
- [ ] Dependencies instalirani (`npm install` u `proxy-server`)
- [ ] `.env` fajl kreiran sa API key-jem
- [ ] Proxy server pokrenut (`npm start`)
- [ ] Health check prolazi (`http://localhost:3000/health`)
- [ ] Flutter app koristi tačan proxy URL
- [ ] Proxy server i Flutter app su na istoj mreži (za telefon)

### 8.2. Testiranje end-to-end

1. **Pokreni proxy server:**
   ```bash
   cd proxy-server
   npm start
   ```

2. **Pokreni Flutter app:**
   ```bash
   cd ZaMariju
   flutter run
   ```

3. **U Flutter app-u:**
   - Uloguj se
   - Pokreni premium analizu
   - Proveri konzolu za poruke:
     ```
     [AIAnalyzer] POST http://localhost:3000/api/chat via proxy
     [AIAnalyzer] Proxy response 200 OK (1234 ms)
     ```

4. **Ako vidiš greške:**
   - Proveri da li je proxy server pokrenut
   - Proveri da li je URL tačan
   - Proveri konzolu proxy servera za detalje

---

## ❌ Rešavanje problema

### Problem 1: "OPENAI_API_KEY is not set"

**Uzrok:** `.env` fajl ne postoji ili nema tačan format.

**Rešenje:**
1. Proveri da li `.env` fajl postoji u `proxy-server` folderu
2. Proveri da li ima tačan format: `OPENAI_API_KEY=sk-...` (bez razmaka)
3. Restartuj server nakon izmene `.env` fajla

### Problem 2: "Cannot connect to proxy server"

**Uzrok:** Proxy server nije pokrenut ili URL nije tačan.

**Rešenje:**
1. Proveri da li je proxy server pokrenut (`npm start`)
2. Proveri da li koristiš tačan URL:
   - Desktop: `http://localhost:3000`
   - Android Emulator: `http://10.0.2.2:3000`
   - Fizički telefon: `http://192.168.1.100:3000` (tvoja IP)
3. Proveri da li server radi: `http://localhost:3000/health`

### Problem 3: "Port 3000 already in use"

**Uzrok:** Drugi proces koristi port 3000.

**Rešenje:**
1. Promeni port u `.env` fajlu: `PORT=3001`
2. Ažuriraj URL u Flutter app: `http://localhost:3001`

### Problem 4: CORS errors u browser-u

**Uzrok:** Browser blokira zahteve.

**Rešenje:**
- Proxy server već ima CORS omogućen
- Ako i dalje imaš probleme, proveri da li server radi

### Problem 5: "Network error" na fizičkom telefonu

**Uzrok:** Firewall blokira port ili telefon nije na istoj mreži.

**Rešenje:**
1. Proveri da li su računar i telefon na istoj Wi-Fi mreži
2. Onemogući Windows Firewall za port 3000 (privremeno):
   ```powershell
   New-NetFirewallRule -DisplayName "Allow Proxy Server" -Direction Inbound -LocalPort 3000 -Protocol TCP -Action Allow
   ```
3. Proveri da li koristiš tačnu IP adresu (`ipconfig`)

---

## 📊 Rezime - Brzi Start

1. ✅ Instaliraj Node.js
2. ✅ `cd proxy-server` → `npm install`
3. ✅ Kreiraj `.env` fajl sa `OPENAI_API_KEY=sk-...`
4. ✅ `npm start` (pokreni server)
5. ✅ Proveri: `http://localhost:3000/health`
6. ✅ Postavi URL u Flutter app (ako treba)
7. ✅ Pokreni Flutter app i testiraj!

---

## 🎯 Produkcija (Production)

Kada budeš spreman da deploy-uješ na internet:

1. **Deploy proxy server** na Railway/Render/Heroku
2. **Dobij URL** (npr. `https://your-proxy.railway.app`)
3. **Postavi u Flutter app:**
   ```dart
   AIAnalyzer.setProxyUrl('https://your-proxy.railway.app');
   ```
4. **Build Flutter app** za production

Detaljne instrukcije za deployment su u `SETUP_INSTRUCTIONS.md`.

---

**Srećno! Ako imaš pitanja, proveri konzolu za detaljne greške! 🚀**

