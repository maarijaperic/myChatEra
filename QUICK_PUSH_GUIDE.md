# 🚀 Brzi Vodič za Push na GitHub

## Tvoj Repozitorijum
- **Username:** maarijaperic
- **Repo:** myChatEra
- **URL:** https://github.com/maarijaperic/myChatEra

---

## ⚡ Najbrži Način (Duplim Klikom)

**Duplim klikom pokreni:** `push-to-github.bat`

Ova skripta će automatski:
1. ✅ Postaviti remote na tvoj GitHub repo
2. ✅ Dodati sve promene
3. ✅ Commit-ovati ih
4. ✅ Pull-ovati promene sa GitHub-a (ako ih ima)
5. ✅ Push-ovati tvoje promene

---

## 📝 Ručno (Ako Skripta Ne Radi)

### Korak 1: Otvori PowerShell ili Command Prompt
U folderu projekta (`GPTWrapped-1`)

### Korak 2: Postavi Remote (ako nije postavljen)
```bash
git remote remove origin
git remote add origin https://github.com/maarijaperic/myChatEra.git
git remote -v  # Proveri da li je postavljen
```

### Korak 3: Dodaj i Commit-uj Promene
```bash
git add .
git commit -m "Update: Latest changes"
```

### Korak 4: Pull Prvo (VAŽNO!)
```bash
git pull origin main
```
Ako ima konflikata, reši ih, pa:
```bash
git add .
git commit -m "Resolved conflicts"
```

### Korak 5: Push
```bash
git push origin main
```

---

## 🔐 Autentifikacija

Kada Git traži username/password:

1. **Username:** `maarijaperic`
2. **Password:** Koristi **Personal Access Token** (ne lozinku!)

### Kako da dobiješ Personal Access Token:

1. Idi na GitHub.com
2. Settings → Developer settings → Personal access tokens → Tokens (classic)
3. Generate new token (classic)
4. Izaberi `repo` permisije
5. Kopiraj token (nećeš ga više videti!)
6. Koristi token umesto lozinke kada Git traži password

---

## 🐛 Ako Ima Problema

### Problem: "Repository not found"
- Proveri da li je repo javan ili imaš pristup
- Proveri da li je URL tačan: `https://github.com/maarijaperic/myChatEra.git`

### Problem: "Authentication failed"
- Koristi Personal Access Token umesto lozinke
- Ili postavi SSH key (komplikovanije)

### Problem: "Merge conflicts"
- Git će ti reći gde su konflikti
- Otvori te fajlove, traži `<<<<<<< HEAD`
- Reši konflikte ručno
- Zatim: `git add .` → `git commit -m "Resolved conflicts"` → `git push`

### Problem: "Updates were rejected"
- Prvo uradi: `git pull origin main`
- Zatim: `git push origin main`

---

## 💡 Najčešći Workflow

```bash
# 1. Proveri status
git status

# 2. Dodaj promene
git add .

# 3. Commit
git commit -m "Opis promena"

# 4. Pull (da vidiš da li ima novih promena)
git pull origin main

# 5. Push
git push origin main
```

---

## ✅ Provera da li je Push Uspešan

Idi na: https://github.com/maarijaperic/myChatEra

Trebalo bi da vidiš svoje najnovije promene!







