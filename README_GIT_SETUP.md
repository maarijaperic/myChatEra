# Git Setup - Bezbedno Commit-ovanje

## ✅ Šta je Već Bezbedno

1. **`.gitignore` već postoji** i uključuje:
   - `.env` fajlove (neće se commit-ovati)
   - `node_modules/` (proxy-server)
   - Build fajlove
   - API keys i secrets

2. **Proxy server `.gitignore`** takođe uključuje `.env`

## 🔒 Šta Treba Proveriti Pre Commit-a

### 1. Proveri da li postoji `.env` fajl u git-u:
```bash
git ls-files | grep .env
```
Ako vidiš bilo koji `.env` fajl, ukloni ga:
```bash
git rm --cached proxy-server/.env
```

### 2. Proveri da li ima hardkodovanih API keys:
```bash
# Proveri u kodu
grep -r "sk-" . --exclude-dir=node_modules --exclude-dir=build
grep -r "OPENAI_API_KEY" . --exclude-dir=node_modules --exclude-dir=build
```

### 3. Proveri `main.dart`:
- IP adresa je sada placeholder (`localhost:3000`)
- Može se postaviti preko environment variable

## 📝 Kako da Commit-uješ Bezbedno

### 1. Proveri status:
```bash
git status
```

### 2. Proveri da li `.env` fajl nije u staging:
```bash
git status | grep .env
```
Ako vidiš `.env`, ne commit-uj ga!

### 3. Dodaj fajlove:
```bash
# Dodaj sve osim .env fajlova
git add .
git reset HEAD proxy-server/.env  # Ako je slučajno dodat
```

### 4. Commit:
```bash
git commit -m "Update: Latest changes without secrets"
```

### 5. Push:
```bash
git push origin main
```

## 🚨 Ako Si Slučajno Commit-ovao API Key

### 1. Ukloni iz git history:
```bash
# OVO JE VAŽNO - ukloni API key iz git history
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch proxy-server/.env" \
  --prune-empty --tag-name-filter cat -- --all
```

### 2. Ili jednostavnije - promeni API key:
- Idi na OpenAI dashboard
- Revoke stari API key
- Kreiraj novi API key
- Ažuriraj `.env` fajl sa novim key-om

## 📋 Checklist Pre Svakog Commit-a

- [ ] Proverio sam da `.env` nije u staging (`git status`)
- [ ] Proverio sam da nema hardkodovanih API keys u kodu
- [ ] Proverio sam da `main.dart` koristi placeholder za proxy URL
- [ ] Testirao sam da aplikacija radi sa lokalnim `.env` fajlom

## 🔐 Bezbednost

### Šta JE bezbedno commit-ovati:
- ✅ Source kod (bez API keys)
- ✅ `.env.example` fajl (bez stvarnih keys)
- ✅ `package.json` i dependencies
- ✅ README fajlove
- ✅ Configuration fajlove (bez secrets)

### Šta NIJE bezbedno commit-ovati:
- ❌ `.env` fajl sa API keys
- ❌ Hardkodovane API keys u kodu
- ❌ Production credentials
- ❌ Private keys i certificates

## 📝 .env.example Fajl

Kreirao sam `proxy-server/.env.example` fajl koji:
- ✅ Može se commit-ovati (bez stvarnih keys)
- ✅ Služi kao template za druge developere
- ✅ Pokazuje koje environment variables su potrebne

## 🎯 Finalni Koraci

1. **Kreiraj `.env` fajl lokalno** (ne commit-uj ga):
   ```bash
   cd proxy-server
   cp .env.example .env
   # Zatim dodaj svoj stvarni API key u .env
   ```

2. **Testiraj da aplikacija radi** sa lokalnim `.env`

3. **Commit-uj sve osim `.env`**:
   ```bash
   git add .
   git commit -m "Update: Application code without secrets"
   git push origin main
   ```

---

**Sada možeš bezbedno commit-ovati kod! 🔒**

