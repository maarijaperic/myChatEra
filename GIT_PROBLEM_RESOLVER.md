# 🔧 Rešavanje Git Problema - Push na GitHub

## 🚨 Najčešći Problemi i Rešenja

### Problem 1: "Failed to push some refs" / "Updates were rejected"

**Razlog:** Remote repozitorijum ima promene koje lokalni nema.

**Rešenje:**
```bash
# 1. Prvo pull-uj promene
git pull origin main

# Ako ima konflikata, reši ih, pa:
git add .
git commit -m "Resolved merge conflicts"

# 2. Zatim push
git push origin main
```

**Alternativa (ako želiš da prepišeš remote):**
```bash
# ⚠️ OPAZNO: Ovo će prepisati remote promene!
git push origin main --force
```

---

### Problem 2: "Authentication failed" / "Permission denied"

**Razlog:** GitHub ne prepoznaje tvoje credentials.

**Rešenje A - HTTPS sa Personal Access Token:**
1. Idi na GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generiši novi token sa `repo` permisijama
3. Koristi token umesto lozinke kada Git traži password

**Rešenje B - Ažuriraj credentials:**
```bash
# Windows
git config --global credential.helper wincred

# Zatim pokušaj push ponovo - unesi username i token
```

**Rešenje C - Koristi SSH umesto HTTPS:**
```bash
# 1. Proveri da li imaš SSH key
ssh -T git@github.com

# 2. Ako nemaš, generiši:
ssh-keygen -t ed25519 -C "tvoj-email@example.com"

# 3. Dodaj key na GitHub (Settings → SSH and GPG keys)

# 4. Promeni remote na SSH:
git remote set-url origin git@github.com:tvoj-username/tvoj-repo.git
```

---

### Problem 3: Merge Conflicts

**Razlog:** Ista linija koda je promenjena i lokalno i na remote-u.

**Rešenje:**
```bash
# 1. Pull-uj promene
git pull origin main

# 2. Git će ti reći gde su konflikti
# Otvori fajlove sa konfliktima, traži:
# <<<<<<< HEAD
# tvoj kod
# =======
# remote kod
# >>>>>>> branch-name

# 3. Reši konflikte ručno (izbriši markere, ostavi željeni kod)

# 4. Dodaj rešene fajlove
git add .

# 5. Commit
git commit -m "Resolved merge conflicts"

# 6. Push
git push origin main
```

---

### Problem 4: "Branch is protected" / "Cannot push to protected branch"

**Razlog:** GitHub branch protection pravila blokiraju direktan push.

**Rešenje:**
```bash
# 1. Kreiraj novu granu
git checkout -b feature/novi-feature

# 2. Commit-uj promene
git add .
git commit -m "Tvoja poruka"

# 3. Push novu granu
git push origin feature/novi-feature

# 4. Otvori Pull Request na GitHub-u
# 5. Merge-uj PR nakon review-a
```

---

### Problem 5: "Remote repository not found" / "Repository does not exist"

**Razlog:** Remote URL je pogrešan ili repozitorijum ne postoji.

**Rešenje:**
```bash
# 1. Proveri trenutni remote
git remote -v

# 2. Ako je pogrešan, promeni ga:
git remote set-url origin https://github.com/tvoj-username/tvoj-repo.git

# 3. Ili dodaj remote ako ne postoji:
git remote add origin https://github.com/tvoj-username/tvoj-repo.git
```

---

## 📋 Korak-po-Korak: Kompletan Workflow

### Scenario: Imaš lokalne promene, želiš da push-uješ

```bash
# 1. Proveri status
git status

# 2. Dodaj promene
git add .

# 3. Commit
git commit -m "Opis tvojih promena"

# 4. Pull prvo (da vidiš da li ima novih promena na remote-u)
git pull origin main

# 5. Ako ima konflikata, reši ih (vidi Problem 3)

# 6. Push
git push origin main
```

---

## 🛠️ Automatska Skripta

Pokreni `fix-git-push.ps1` skriptu koja će automatski:
- Proveriti Git status
- Detektovati probleme
- Pomoci ti da ih rešiš

```powershell
.\fix-git-push.ps1
```

---

## 🔍 Diagnostika Problema

### Proveri trenutno stanje:
```bash
# Status
git status

# Remote URL
git remote -v

# Branches
git branch -a

# Poslednji commit-ovi
git log --oneline -10

# Razlike između lokalnog i remote-a
git log HEAD..origin/main
```

---

## 💡 Najbolje Prakse

1. **Uvek pull-uj pre push-a:**
   ```bash
   git pull origin main
   git push origin main
   ```

2. **Koristi opisne commit poruke:**
   ```bash
   git commit -m "Add: New feature for user authentication"
   ```

3. **Commit-uj često, push-uj kada je feature gotov:**
   - Commit = snimak promena
   - Push = deljenje sa timom/GitHub-om

4. **Koristi grane za nove feature-e:**
   ```bash
   git checkout -b feature/naziv-feature-a
   # ... radi na feature-u ...
   git push origin feature/naziv-feature-a
   ```

---

## 🆘 Ako Ništa Ne Radi

### Reset na poslednji uspešan commit:
```bash
# ⚠️ OPAZNO: Ovo će obrisati uncommitted promene!
git reset --hard HEAD

# Ili reset na remote verziju:
git fetch origin
git reset --hard origin/main
```

### Potpuno re-kreiranje veze sa remote-om:
```bash
# 1. Ukloni postojeći remote
git remote remove origin

# 2. Dodaj ponovo
git remote add origin https://github.com/tvoj-username/tvoj-repo.git

# 3. Pull
git pull origin main --allow-unrelated-histories

# 4. Push
git push origin main
```

---

## 📞 Potrebna Pomoc?

Ako ništa od ovoga ne radi, proveri:
1. Da li je GitHub repozitorijum javan ili imaš pristup
2. Da li imaš prava za push (ako si collaborator)
3. Da li je internet konekcija stabilna
4. Da li GitHub radi (status.github.com)







