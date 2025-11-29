# 🖥️ GitHub Desktop - Vodič za Push Promena

## 📥 Instalacija (Ako Nemaš)

1. Preuzmi sa: https://desktop.github.com/
2. Instaliraj aplikaciju
3. Login-uj se sa svojim GitHub nalogom (`maarijaperic`)

---

## 🚀 Korak-po-Korak: Push Promena

### Korak 1: Otvori Repozitorijum u GitHub Desktop-u

**Opcija A - Ako već imaš repozitorijum otvoren:**
- GitHub Desktop će automatski detektovati promene

**Opcija B - Ako treba da otvoriš repozitorijum:**
1. Otvori GitHub Desktop
2. File → Add Local Repository
3. Izaberi folder: `C:\Users\Korisnik\Documents\GPTWrapped-1`
4. Klikni "Add repository"

**Opcija C - Ako treba da kloniraš sa GitHub-a:**
1. File → Clone Repository
2. Izaberi "GitHub.com" tab
3. Pronađi `maarijaperic/myChatEra`
4. Klikni "Clone"

---

### Korak 2: Proveri Remote URL

1. U GitHub Desktop-u, klikni na **Repository** → **Repository Settings**
2. Proveri da li je **Primary remote repository** postavljen na:
   ```
   https://github.com/maarijaperic/myChatEra.git
   ```
3. Ako nije, klikni **Edit** i promeni na tačan URL

---

### Korak 3: Vidi Promene

U GitHub Desktop-u ćeš videti:
- **Leva strana:** Lista promenjenih fajlova
- **Desna strana:** Diff (razlike) za svaki fajl

**Ako ne vidiš promene:**
- Klikni na **Fetch origin** (gore desno) da povučeš najnovije promene sa GitHub-a

---

### Korak 4: Commit Promena

1. **Dodaj promene:**
   - Na dnu levo, vidiš checkbox-ove pored svakog fajla
   - Možeš da izabereš pojedinačne fajlove ili klikneš "Select all" za sve

2. **Napiši commit poruku:**
   - Na dnu, u polju "Summary" unesi kratku poruku, npr:
     ```
     Update: Latest changes
     ```
   - Opciono, možeš dodati detaljniji opis u "Description"

3. **Commit:**
   - Klikni na dugme **"Commit to main"** (ili koja god je tvoja grana)

---

### Korak 5: Pull Prvo (VAŽNO!)

**Pre push-a, uvek pull-uj promene sa GitHub-a:**

1. Klikni na **Fetch origin** (gore desno)
2. Ako vidiš poruku "This branch is X commits behind origin/main":
   - Klikni na **Pull origin** ili **Merge into main**
   - GitHub Desktop će automatski pokušati merge

**Ako ima konflikata:**
- GitHub Desktop će ti reći koji fajlovi imaju konflikte
- Klikni na fajl da ga otvoriš
- Vidićeš markere konflikata: `<<<<<<<`, `=======`, `>>>>>>>`
- Reši konflikte ručno (izbriši markere, ostavi željeni kod)
- Klikni **"Mark as resolved"** za svaki fajl
- Zatim commit-uj ponovo

---

### Korak 6: Push na GitHub

1. Klikni na dugme **"Push origin"** (gore desno)
2. GitHub Desktop će push-ovati tvoje promene

**Ako vidiš grešku:**
- Proveri autentifikaciju (možda treba da se login-uješ ponovo)
- Proveri da li imaš prava za push

---

## 🔄 Kompletan Workflow u GitHub Desktop-u

```
1. Otvori GitHub Desktop
2. Fetch origin (da vidiš da li ima novih promena)
3. Ako ima, Pull origin (da povučeš promene)
4. Reši konflikte ako ih ima
5. Commit svoje promene (dodaj fajlove, napiši poruku, commit)
6. Push origin (da pošalješ promene na GitHub)
```

---

## 🐛 Rešavanje Problema

### Problem: "Repository not found"

**Rešenje:**
1. Repository → Repository Settings
2. Proveri Primary remote repository URL
3. Ako je pogrešan, klikni Edit i promeni na:
   ```
   https://github.com/maarijaperic/myChatEra.git
   ```

---

### Problem: "Authentication failed"

**Rešenje:**
1. File → Options → Accounts
2. Proveri da li si login-ovan sa `maarijaperic` nalogom
3. Ako nisi, klikni "Sign in" i login-uj se
4. Ako i dalje ne radi, možda treba da generišeš Personal Access Token:
   - GitHub.com → Settings → Developer settings → Personal access tokens
   - Generiši novi token sa `repo` permisijama
   - U GitHub Desktop, možda će tražiti token umesto lozinke

---

### Problem: "Merge conflicts"

**Rešenje:**
1. GitHub Desktop će ti pokazati koje fajlove imaju konflikte
2. Klikni na fajl da ga otvoriš
3. Vidićeš markere:
   ```
   <<<<<<< HEAD
   tvoj kod
   =======
   remote kod
   >>>>>>> branch-name
   ```
4. Reši konflikte:
   - Izbriši markere (`<<<<<<<`, `=======`, `>>>>>>>`)
   - Ostavi kod koji želiš
5. Klikni **"Mark as resolved"** za svaki fajl
6. Commit ponovo
7. Push

---

### Problem: "Updates were rejected"

**Rešenje:**
1. Klikni **Fetch origin**
2. Ako vidiš da je branch "behind", klikni **Pull origin**
3. Reši konflikte ako ih ima
4. Zatim **Push origin**

---

### Problem: Ne vidi promene

**Rešenje:**
1. Proveri da li si u pravom folderu
2. Repository → Show in Explorer (da otvoriš folder)
3. Proveri da li su fajlovi zaista promenjeni
4. Pokušaj da refresh-uješ: View → Refresh (ili F5)

---

## 💡 Korisni Saveti

### 1. Uvek Pull Pre Push-a
- GitHub Desktop će te upozoriti ako pokušaš da push-uješ bez pull-a
- Ali bolje je uvek prvo Fetch/Pull

### 2. Commit Često
- Ne čekaj da napraviš puno promena
- Commit-uj kada završiš jedan feature ili popravku

### 3. Koristi Opisne Commit Poruke
- Umesto "Update", napiši "Add: User authentication feature"
- Lakše ćeš se snalaziti u istoriji

### 4. Pregledaj Promene Pre Commit-a
- Uvek pogledaj diff (razlike) pre commit-a
- Proveri da nisi slučajno dodao `.env` fajl ili API keys

### 5. Branch Management
- Za nove feature-e, kreiraj novu granu:
  - Branch → New branch
  - Napiši ime, npr: `feature/user-auth`
  - Radi na feature-u
  - Commit i push
  - Otvori Pull Request na GitHub-u

---

## ✅ Provera da li je Push Uspešan

1. U GitHub Desktop-u, vidićeš "X commits ahead of origin/main" → "This branch is up to date"
2. Idi na: https://github.com/maarijaperic/myChatEra
3. Trebalo bi da vidiš svoje najnovije promene!

---

## 🎯 Brzi Checklist

- [ ] GitHub Desktop otvoren
- [ ] Repozitorijum otvoren (GPTWrapped-1)
- [ ] Remote URL tačan (maarijaperic/myChatEra)
- [ ] Fetch origin (povukao najnovije promene)
- [ ] Pull origin (ako ima novih promena)
- [ ] Rešio konflikte (ako ih ima)
- [ ] Commit-ovao promene (dodao fajlove, napisao poruku)
- [ ] Push origin (poslao na GitHub)
- [ ] Proverio na GitHub.com da li su promene tamo

---

## 🆘 Ako Ništa Ne Radi

1. **Restart GitHub Desktop:**
   - Zatvori i ponovo otvori aplikaciju

2. **Re-authenticate:**
   - File → Options → Accounts
   - Sign out i sign in ponovo

3. **Re-clone Repository:**
   - File → Clone Repository
   - Kloniraj ponovo sa GitHub-a
   - Kopiraj svoje promene u novi folder

4. **Proveri Internet:**
   - Da li imaš stabilnu internet konekciju
   - Da li GitHub radi (status.github.com)

---

**GitHub Desktop je najlakši način za rad sa Git-om! 🎉**
