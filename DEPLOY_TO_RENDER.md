# Deploy Proxy Server na Render

## Korak 1: Kreiraj nalog na Render

1. Idi na https://render.com
2. Klikni "Get Started for Free"
3. Registruj se sa GitHub nalogom (najlakše)

## Korak 2: Konektuj GitHub Repo

1. U Render dashboardu, klikni "New +" → "Web Service"
2. Konektuj svoj GitHub nalog (ako već nije)
3. Izaberi repo: `maarijaperic/myChatEra`
4. Klikni "Connect"

## Korak 3: Konfiguriši Web Service

**Osnovne postavke:**
- **Name:** `openai-proxy-server` (ili bilo koje ime)
- **Region:** Izaberi najbližu regiju (npr. Frankfurt, ili bilo koja)
- **Branch:** `main`
- **Root Directory:** `proxy-server` (VAŽNO!)
- **Runtime:** `Node`
- **Build Command:** `npm install`
- **Start Command:** `npm start`

## Korak 4: Dodaj Environment Varijable

1. U "Environment" sekciji, klikni "Add Environment Variable"
2. Dodaj:
   - **Key:** `OPENAI_API_KEY`
   - **Value:** Tvoj OpenAI API key (počinje sa `sk-...`)
3. Klikni "Save Changes"

## Korak 5: Deploy

1. Klikni "Create Web Service"
2. Render će automatski:
   - Klonirati repo
   - Instalirati dependencies (`npm install`)
   - Pokrenuti server (`npm start`)
3. Sačekaj da se deploy završi (2-3 minuta)

## Korak 6: Dobij URL

1. Nakon deploy-a, Render će dati URL:
   - Format: `https://openai-proxy-server-xxxx.onrender.com`
   - Ili custom domain ako si ga postavio
2. **Kopiraj ovaj URL** - trebaće ti za Flutter aplikaciju

## Korak 7: Testiraj Server

1. Otvori u browseru: `https://tvoj-url.onrender.com/health`
2. Trebalo bi da vidiš: `{"status":"ok","message":"OpenAI Proxy Server is running"}`

## Korak 8: Ažuriraj Flutter Aplikaciju

1. Otvori `ZaMariju/lib/main.dart`
2. Pronađi liniju sa `defaultValue: 'https://gentle-blessing-production.up.railway.app'`
3. Zameni sa Render URL-om:
   ```dart
   defaultValue: 'https://tvoj-url.onrender.com',
   ```
4. Build-uj aplikaciju i testiraj

## Troubleshooting

**Problem: Server ne vidi OPENAI_API_KEY**
- Proveri da li si dodao varijablu u "Environment" sekciji
- Proveri da li je ime tačno `OPENAI_API_KEY` (bez razmaka)
- Proveri da li je vrednost tačna (tvoj API key)

**Problem: Build fails**
- Proveri da li je "Root Directory" postavljen na `proxy-server`
- Proveri da li je "Build Command" `npm install`
- Proveri da li je "Start Command" `npm start`

**Problem: Server ne radi**
- Proveri Render logs (u dashboardu)
- Proveri da li je server pokrenut (status bi trebalo da bude "Live")

## Prednosti Render-a nad Railway-om

✅ Bolja podrška za environment varijable
✅ Lakše postavljanje varijabli
✅ Besplatni tier za početak
✅ Automatski HTTPS
✅ Automatski deploy na svaki push na GitHub

## Važno

- Render automatski daje HTTPS (ne trebaš ništa dodatno)
- Render automatski deploy-uje na svaki push na `main` branch
- Render ima besplatni tier (može biti sporiji, ali radi)


