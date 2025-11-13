# 📝 Kako kreirati .env fajl i dodati API Key

## ✅ KORAK 1: Kreiraj `.env` fajl

### Metoda 1: Preko Notepad-a (NAJLAKŠE)

1. Otvori **Notepad** (Notepad.exe)
2. Klikni **File** → **Save As**
3. U "Save as type" izaberi **"All Files (*.*)"** (važno!)
4. U "File name" ukucaj: `.env` (uključujući tačku na početku!)
5. Idi u folder: `C:\Users\Korisnik\Documents\GPTWrapped-1\proxy-server`
6. Klikni **Save**

**VAŽNO:** 
- Fajl se mora zvati `.env` (sa tačkom na početku, bez ekstenzije!)
- Ne zovi ga `.env.txt` ili `env.txt`

### Metoda 2: Preko File Explorera

1. Otvori File Explorer
2. Idi u: `C:\Users\Korisnik\Documents\GPTWrapped-1\proxy-server`
3. Desni klik → **New** → **Text Document**
4. Nazovi ga: `.env` (uključujući tačku!)
5. Windows će upozoriti - klikni **"Yes"**

### Metoda 3: Preko Command Prompt-a

1. Otvori CMD
2. Ukucaj:
   ```cmd
   cd "C:\Users\Korisnik\Documents\GPTWrapped-1\proxy-server"
   echo. > .env
   ```

---

## ✅ KORAK 2: Dodaj API Key u `.env` fajl

1. Otvori `.env` fajl (desni klik → "Open with" → "Notepad")
2. Dodaj sledeće (zameni `sk-tvoj-api-kljuc-ovde` sa svojim API key-jem):

```
OPENAI_API_KEY=sk-tvoj-api-kljuc-ovde
PORT=3000
```

**Primer kako treba da izgleda:**
```
OPENAI_API_KEY=sk-proj-abc123xyz789def456ghi012jkl345mno678pqr901stu234vwx567
PORT=3000
```

**⚠️ VAŽNO:**
- Nema razmaka oko `=`
- Nema navodnika oko vrednosti
- API key mora počinjati sa `sk-`
- Ne dodavaj komentare u `.env` fajl
- Svaka linija je jedna varijabla

3. Sačuvaj fajl (`Ctrl + S`)

---

## ✅ KORAK 3: Proveri da li je sve tačno

Tvoj `.env` fajl treba da izgleda ovako:

```
OPENAI_API_KEY=sk-proj-abc123xyz789...
PORT=3000
```

**Proveri:**
- [ ] Fajl se zove `.env` (ne `.env.txt`)
- [ ] Nema razmaka oko `=`
- [ ] API key počinje sa `sk-`
- [ ] PORT je 3000

---

## ✅ KORAK 4: Restartuj proxy server

Nakon što kreiraš `.env` fajl:

1. Ako je server pokrenut, zaustavi ga (`Ctrl + C`)
2. Pokreni ponovo:
   ```cmd
   npm start
   ```

3. Trebalo bi da vidiš:
   ```
   🚀 OpenAI Proxy Server running on port 3000
   📝 Health check: http://localhost:3000/health
   🔒 Make sure OPENAI_API_KEY is set in .env file
   ```

**Ako vidiš grešku "OPENAI_API_KEY is not set":**
- Proveri da li je fajl tačno nazvan `.env` (ne `.env.txt`)
- Proveri da li nema razmaka oko `=`
- Proveri da li je API key tačan

---

## 🔑 Gde naći OpenAI API Key?

1. Idi na: https://platform.openai.com/api-keys
2. Uloguj se
3. Klikni **"Create new secret key"**
4. Daj mu ime (npr. "GPT Wrapped")
5. Klikni **"Create secret key"**
6. **KOPIRAJ KLJUČ ODMAH!** (počinje sa `sk-`)
7. Nalepi ga u `.env` fajl

**⚠️ VAŽNO:** Nećeš moći da vidiš ključ ponovo! Sačuvaj ga negde sigurno.

---

## ❌ Česti problemi

### Problem: "OPENAI_API_KEY is not set"

**Uzrok:** Fajl nije tačno nazvan ili nema tačan format.

**Rešenje:**
1. Proveri da li se fajl zove `.env` (ne `.env.txt`)
2. Proveri da li nema razmaka oko `=`
3. Proveri da li API key počinje sa `sk-`

### Problem: Fajl se zove `.env.txt` umesto `.env`

**Rešenje:**
1. U File Explorer-u, omogući prikaz ekstenzija:
   - View → Options → View → Otkači "Hide extensions for known file types"
2. Preimenuj fajl: `.env.txt` → `.env`
3. Windows će upozoriti - klikni "Yes"

### Problem: Ne mogu da kreiram fajl sa tačkom na početku

**Rešenje:**
- Koristi Metodu 3 (Command Prompt) ili Notepad sa "All Files" opcijom

---

## ✅ Gotovo!

Sada tvoj `.env` fajl treba da izgleda ovako:

```
OPENAI_API_KEY=sk-tvoj-stvarni-api-kljuc-ovde
PORT=3000
```

Restartuj server i sve bi trebalo da radi! 🚀

