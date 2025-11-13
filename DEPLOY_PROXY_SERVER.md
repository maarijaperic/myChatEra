# Kako da Deploy-uješ Proxy Server na Internet

## 🎯 Problem
Ako prijatelji nisu na istoj WiFi mreži, lokalni proxy server neće raditi. Treba deploy-ovati server na internet.

## ✅ Rešenje: Railway (NAJLAKŠE - Besplatno)

### KORAK 1: Registracija

1. Idi na [railway.app](https://railway.app)
2. Klikni **"Start a New Project"**
3. Registruj se sa GitHub nalogom (najlakše)

### KORAK 2: Deploy Proxy Servera

#### Opcija A: Deploy iz GitHub-a (PREPORUČENO)

1. **Upload proxy-server na GitHub:**
   ```bash
   # Ako već nemaš git repo:
   cd proxy-server
   git init
   git add .
   git commit -m "Initial commit"
   
   # Kreiraj novi repo na GitHub
   # Zatim:
   git remote add origin https://github.com/TVOJ_USERNAME/proxy-server.git
   git push -u origin main
   ```

2. **Na Railway:**
   - Klikni **"New Project"**
   - Izaberi **"Deploy from GitHub repo"**
   - Izaberi `proxy-server` repo
   - Railway će automatski detektovati Node.js

3. **Postavi Environment Variables:**
   - Klikni na projekat
   - Idi na **"Variables"** tab
   - Dodaj:
     ```
     OPENAI_API_KEY = tvoj_openai_api_key
     PORT = 3000 (opciono, Railway automatski postavlja)
     ```

4. **Deploy:**
   - Railway će automatski deploy-ovati
   - Sačekaj da se završi (1-2 minuta)
   - Railway će dati URL (npr. `https://your-app.railway.app`)

#### Opcija B: Deploy direktno (bez GitHub)

1. **Na Railway:**
   - Klikni **"New Project"**
   - Izaberi **"Empty Project"**

2. **Upload fajlova:**
   - Klikni **"Settings"** → **"Source"**
   - Upload `proxy-server` folder
   - Ili koristi Railway CLI

3. **Postavi Environment Variables** (kao gore)

---

## 🚀 KORAK 3: Ažuriraj Aplikaciju

### 1. Ažuriraj `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Production URL (Railway)
  AIAnalyzer.setProxyUrl('https://your-app.railway.app'); // Zameni sa tvojim Railway URL-om!
  
  runApp(const MyApp());
}
```

### 2. Rebuild APK:

```bash
cd ZaMariju
flutter clean
flutter pub get
flutter build apk --release
```

### 3. Testiraj:

- Otvori browser
- Idi na: `https://your-app.railway.app/health`
- Trebalo bi da vidiš: `{"status":"ok"}`

---

## 🔧 Alternativa: Render (Takođe Besplatno)

### KORAK 1: Registracija

1. Idi na [render.com](https://render.com)
2. Registruj se sa GitHub nalogom

### KORAK 2: Deploy

1. **Klikni "New +" → "Web Service"**
2. **Poveži GitHub repo:**
   - Izaberi `proxy-server` repo
   - Render će automatski detektovati Node.js

3. **Postavi konfiguraciju:**
   - **Name:** `gpt-wrapped-proxy` (ili bilo šta)
   - **Environment:** `Node`
   - **Build Command:** `npm install`
   - **Start Command:** `node server.js`
   - **Plan:** Free

4. **Postavi Environment Variables:**
   - Klikni **"Environment"** tab
   - Dodaj:
     ```
     OPENAI_API_KEY = tvoj_openai_api_key
     PORT = 3000
     ```

5. **Deploy:**
   - Klikni **"Create Web Service"**
   - Render će deploy-ovati (2-3 minuta)
   - Render će dati URL (npr. `https://your-app.onrender.com`)

### KORAK 3: Ažuriraj Aplikaciju

```dart
AIAnalyzer.setProxyUrl('https://your-app.onrender.com');
```

---

## ⚠️ VAŽNE NAPOMENE

### 1. Railway vs Render

**Railway:**
- ✅ Brži deploy
- ✅ Automatski HTTPS
- ✅ Besplatno (sa ograničenjima)
- ⚠️ Može biti sporiji na free planu

**Render:**
- ✅ Besplatno
- ✅ Automatski HTTPS
- ⚠️ Sporiji deploy
- ⚠️ Free tier se "uspava" nakon 15 min neaktivnosti (prvi request može biti spor)

### 2. Security

- ✅ **NE commit-uj** `OPENAI_API_KEY` u git!
- ✅ Koristi environment variables
- ✅ HTTPS je automatski omogućen

### 3. Rate Limiting

- Railway i Render imaju rate limiting na free tieru
- Ako imaš puno korisnika, možda treba upgrade

---

## 🧪 Testiranje Production Servera

### 1. Test Health Endpoint:

```bash
# U browseru ili sa curl:
curl https://your-app.railway.app/health
# Trebalo bi: {"status":"ok"}
```

### 2. Test OpenAI Proxy:

```bash
curl -X POST https://your-app.railway.app/api/chat \
  -H "Content-Type: application/json" \
  -d '{"model":"gpt-4o-mini","messages":[{"role":"user","content":"Hello"}]}'
```

### 3. Test iz Aplikacije:

- Instaliraj APK na telefon
- Otvori aplikaciju
- Login-uj se
- Testiraj analizu

---

## 📋 CHECKLIST

- [ ] Registrovao si se na Railway/Render
- [ ] Upload-ovao proxy-server na GitHub
- [ ] Deploy-ovao server
- [ ] Postavio `OPENAI_API_KEY` u environment variables
- [ ] Dobio production URL
- [ ] Testirao health endpoint
- [ ] Ažurirao `main.dart` sa production URL-om
- [ ] Rebuild-ovao APK
- [ ] Testirao aplikaciju sa production serverom

---

## 🚀 BRZI PUTOKAZ

```bash
# 1. Upload proxy-server na GitHub
cd proxy-server
git init
git add .
git commit -m "Initial commit"
# Kreiraj repo na GitHub i push-uj

# 2. Deploy na Railway
# - Registruj se na railway.app
# - New Project → Deploy from GitHub
# - Izaberi repo
# - Dodaj OPENAI_API_KEY u Variables
# - Sačekaj deploy

# 3. Ažuriraj aplikaciju
# - U main.dart: AIAnalyzer.setProxyUrl('https://your-app.railway.app')
# - flutter build apk --release

# 4. Testiraj i pošalji prijateljima!
```

---

## 💡 TIPS

1. **Koristi Railway za brži deploy**
2. **Testiraj server pre nego što pošalješ APK**
3. **Proveri da li server radi nakon deploy-a**
4. **Ako server ne radi, proveri logs na Railway/Render**

---

**Sada će aplikacija raditi za sve prijatelje, bez obzira na WiFi mrežu! 🎉**

