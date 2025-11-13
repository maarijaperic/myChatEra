# 🚀 Kako koristiti Proxy Server - Kompletan Vodič

## 📖 Šta je Proxy Server?

Proxy server je posredni server koji se nalazi između tvoje Flutter aplikacije i OpenAI API-ja. Njegova glavna uloga je:

1. **Sigurnost** - API ključ se nikad ne šalje iz Flutter aplikacije (ostaje na serveru)
2. **Zaštita** - Rate limiting sprečava zloupotrebu
3. **Jednostavnost** - Flutter aplikacija samo šalje zahteve, ne mora da zna API ključ

---

## 🔧 Kako postaviti Proxy Server

### Korak 1: Instaliraj Node.js dependencies

Otvori terminal u `proxy-server` folderu i pokreni:

```bash
cd proxy-server
npm install
```

### Korak 2: Kreiraj `.env` fajl

**Na Windows-u:**
1. Otvori `proxy-server` folder
2. Desni klik → New → Text Document
3. Nazovi ga `.env` (uključujući tačku na početku!)
4. Windows će upozoriti - klikni "Yes"

**Ili u terminalu:**
```bash
cd proxy-server
echo. > .env
```

### Korak 3: Dodaj OpenAI API Key u `.env` fajl

Otvori `.env` fajl i dodaj:

```
OPENAI_API_KEY=sk-tvoj-api-kljuc-ovde
PORT=3000
```

**Primer:**
```
OPENAI_API_KEY=sk-proj-abc123xyz789def456ghi012jkl345mno678pqr901stu234vwx567
PORT=3000
```

**⚠️ VAŽNO:**
- Nema razmaka oko `=`
- API ključ počinje sa `sk-`
- Ne commit-uj `.env` fajl u Git (već je u `.gitignore`)

### Korak 4: Gde naći OpenAI API Key?

1. Idi na: https://platform.openai.com/api-keys
2. Uloguj se (ili kreiraj nalog ako nemaš)
3. Klikni **"Create new secret key"**
4. Kopiraj ključ (počinje sa `sk-`)
5. **VAŽNO:** Sačuvaj ga negde sigurno - nećeš moći da ga vidiš ponovo!

---

## ▶️ Kako pokrenuti Proxy Server

### Za Development (sa auto-reload):

```bash
cd proxy-server
npm run dev
```

Server će se automatski restartovati kada promeniš kod.

### Za Production:

```bash
cd proxy-server
npm start
```

Server će raditi na `http://localhost:3000`

**Provera da li radi:**
Otvori browser i idi na: `http://localhost:3000/health`

Trebalo bi da vidiš:
```json
{"status":"ok","message":"OpenAI Proxy Server is running"}
```

---

## 📱 Kako koristiti u Flutter aplikaciji

### Lokalno testiranje (proxy server na tvom računaru)

Flutter aplikacija već je podešena da koristi proxy server! 

**Ako pokrećeš Flutter app na emulatoru ili fizičkom telefonu:**

1. **Emulator (Android/iOS Simulator):**
   - Koristi `http://10.0.2.2:3000` za Android emulator
   - Koristi `http://localhost:3000` za iOS Simulator

2. **Fizički telefon:**
   - Pronađi IP adresu tvog računara (npr. `192.168.1.100`)
   - Koristi `http://192.168.1.100:3000`

**Kako promeniti URL u Flutter aplikaciji:**

U `ai_analyzer.dart` fajlu, možeš postaviti proxy URL na početku aplikacije:

```dart
// Na početku main() funkcije ili u initState
AIAnalyzer.setProxyUrl('http://10.0.2.2:3000'); // Za Android emulator
// ili
AIAnalyzer.setProxyUrl('http://192.168.1.100:3000'); // Za fizički telefon
```

**Ili koristi environment variable:**

Kada pokrećeš Flutter app:
```bash
flutter run --dart-define=OPENAI_PROXY_URL=http://10.0.2.2:3000
```

### Production (proxy server na internetu)

Kada deploy-uješ proxy server na hosting (Railway, Render, itd.):

1. Deploy server (vidi SETUP_INSTRUCTIONS.md)
2. Dobij URL (npr. `https://your-proxy.railway.app`)
3. Postavi u Flutter aplikaciji:

```dart
AIAnalyzer.setProxyUrl('https://your-proxy.railway.app');
```

---

## 🧪 Kako koristiti pri testiranju

### Opcija 1: Koristi Proxy Server (preporučeno)

1. Pokreni proxy server:
   ```bash
   cd proxy-server
   npm start
   ```

2. U test fajlu, postavi proxy URL:
   ```dart
   setUp(() {
     AIAnalyzer.setProxyUrl('http://localhost:3000');
     AIAnalyzer.setUseProxy(true);
   });
   ```

3. Pokreni testove - proxy server će rukovati API pozivima.

### Opcija 2: Isključi Proxy (za mock testove)

Ako želiš da testiraš bez stvarnog API poziva:

```dart
setUp(() {
  AIAnalyzer.setUseProxy(false);
  // Možeš koristiti mock API key za testove
  AIAnalyzer.setApiKeyOverride('test-key');
});
```

**⚠️ Napomena:** Ako isključiš proxy, moraš imati API ključ postavljen (ali to nije preporučeno za production).

---

## 🔍 Kako proveriti da li sve radi

### 1. Proveri da li proxy server radi:

```bash
# U terminalu
curl http://localhost:3000/health
```

Trebalo bi da vidiš:
```json
{"status":"ok","message":"OpenAI Proxy Server is running"}
```

### 2. Testiraj API poziv:

```bash
curl -X POST http://localhost:3000/api/chat \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-4o-mini",
    "messages": [
      {"role": "user", "content": "Hello!"}
    ]
  }'
```

### 3. Proveri Flutter aplikaciju:

Kada pokreneš Flutter app i koristiš AI analize, proveri konzolu:

- Trebalo bi da vidiš: `[AIAnalyzer] POST http://localhost:3000/api/chat via proxy`
- Ako vidiš greške, proveri da li je proxy server pokrenut

---

## ❌ Česti problemi i rešenja

### Problem: "OPENAI_API_KEY is not set"

**Rešenje:**
- Proveri da li `.env` fajl postoji u `proxy-server` folderu
- Proveri da li ima tačan format: `OPENAI_API_KEY=sk-...` (bez razmaka)
- Restartuj server nakon dodavanja `.env` fajla

### Problem: "Cannot connect to proxy server"

**Rešenje:**
- Proveri da li je proxy server pokrenut (`npm start`)
- Proveri da li koristiš tačan URL u Flutter aplikaciji
- Za Android emulator koristi `http://10.0.2.2:3000`
- Za fizički telefon koristi IP adresu tvog računara

### Problem: "Port 3000 already in use"

**Rešenje:**
- Promeni `PORT=3001` u `.env` fajlu
- Ažuriraj URL u Flutter aplikaciji na `http://localhost:3001`

### Problem: CORS errors

**Rešenje:**
- Proxy server već ima CORS omogućen
- Ako i dalje imaš probleme, proveri da li server radi

---

## 📝 Rezime - Brzi start

1. **Kreiraj `.env` fajl** u `proxy-server` folderu
2. **Dodaj API key:** `OPENAI_API_KEY=sk-tvoj-kljuc`
3. **Pokreni server:** `npm start`
4. **Proveri:** `http://localhost:3000/health`
5. **Koristi u Flutter app** - već je podešeno!

---

## 🎯 Za Production Deployment

Kada budeš spreman da deploy-uješ na internet:

1. **Railway** (preporučeno - besplatno):
   - Push kod na GitHub
   - Konektuj repo na Railway
   - Dodaj `OPENAI_API_KEY` u environment variables
   - Deploy!

2. **Render:**
   - Kreiramo novi Web Service
   - Konektuj GitHub repo
   - Dodaj `OPENAI_API_KEY` u environment variables
   - Deploy!

Detaljne instrukcije su u `SETUP_INSTRUCTIONS.md`.

---

## ✅ Checklist

- [ ] Node.js instaliran
- [ ] `npm install` pokrenut u `proxy-server` folderu
- [ ] `.env` fajl kreiran
- [ ] OpenAI API key dodat u `.env`
- [ ] Proxy server pokrenut (`npm start`)
- [ ] Health check prolazi (`/health` endpoint)
- [ ] Flutter aplikacija koristi proxy URL
- [ ] Testovi prolaze

---

**Srećno! 🚀**

