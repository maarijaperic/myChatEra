# Skripta za rešavanje Git problema sa push-om na GitHub

Write-Host "=== Git Problem Resolver ===" -ForegroundColor Cyan
Write-Host ""

# 1. Proveri da li je ovo Git repozitorijum
Write-Host "1. Proveravam da li je ovo Git repozitorijum..." -ForegroundColor Yellow
if (-not (Test-Path .git)) {
    Write-Host "   ❌ Ovo nije Git repozitorijum!" -ForegroundColor Red
    Write-Host "   Kreiranje novog Git repozitorijuma..." -ForegroundColor Yellow
    git init
    Write-Host "   ✅ Git repozitorijum kreiran" -ForegroundColor Green
} else {
    Write-Host "   ✅ Git repozitorijum postoji" -ForegroundColor Green
}

Write-Host ""

# 2. Proveri status
Write-Host "2. Proveravam Git status..." -ForegroundColor Yellow
$status = git status
Write-Host $status
Write-Host ""

# 3. Proveri remote
Write-Host "3. Proveravam remote repozitorijum..." -ForegroundColor Yellow
$remote = git remote -v
if ($remote) {
    Write-Host $remote
} else {
    Write-Host "   ⚠️  Nema remote repozitorijuma!" -ForegroundColor Yellow
    Write-Host "   Postavljam remote na: https://github.com/maarijaperic/myChatEra.git" -ForegroundColor Cyan
    git remote add origin https://github.com/maarijaperic/myChatEra.git
    Write-Host "   ✅ Remote dodat" -ForegroundColor Green
}
Write-Host ""

# 4. Proveri trenutnu granu
Write-Host "4. Proveravam trenutnu granu..." -ForegroundColor Yellow
$branch = git branch --show-current
Write-Host "   Trenutna grana: $branch" -ForegroundColor Cyan
Write-Host ""

# 5. Proveri da li ima uncommitted promena
Write-Host "5. Proveravam uncommitted promene..." -ForegroundColor Yellow
$uncommitted = git status --porcelain
if ($uncommitted) {
    Write-Host "   ⚠️  Ima uncommitted promena!" -ForegroundColor Yellow
    Write-Host "   Želiš li da ih commit-uješ? (y/n)"
    $commitChoice = Read-Host
    if ($commitChoice -eq "y" -or $commitChoice -eq "Y") {
        Write-Host "   Dodajem sve promene..." -ForegroundColor Yellow
        git add .
        Write-Host "   Unesi commit poruku:"
        $commitMsg = Read-Host
        if (-not $commitMsg) {
            $commitMsg = "Update: Latest changes"
        }
        git commit -m $commitMsg
        Write-Host "   ✅ Promene commit-ovane" -ForegroundColor Green
    }
} else {
    Write-Host "   ✅ Nema uncommitted promena" -ForegroundColor Green
}
Write-Host ""

# 6. Pokušaj da pull-uješ (ako postoji remote)
Write-Host "6. Pokušavam da pull-ujem promene sa remote-a..." -ForegroundColor Yellow
$remoteExists = git remote get-url origin 2>$null
if ($remoteExists) {
    try {
        Write-Host "   Pull-ujem promene..." -ForegroundColor Yellow
        git fetch origin
        $localCommit = git rev-parse HEAD
        $remoteCommit = git rev-parse origin/$branch 2>$null
        
        if ($remoteCommit -and $localCommit -ne $remoteCommit) {
            Write-Host "   ⚠️  Remote ima nove promene!" -ForegroundColor Yellow
            Write-Host "   Pokušavam merge..." -ForegroundColor Yellow
            
            # Pokušaj merge
            $mergeResult = git merge origin/$branch 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-Host "   ❌ Merge conflict!" -ForegroundColor Red
                Write-Host "   Reši konflikte ručno, pa pokreni ponovo ovu skriptu" -ForegroundColor Yellow
                Write-Host $mergeResult
                exit 1
            } else {
                Write-Host "   ✅ Merge uspešan" -ForegroundColor Green
            }
        } else {
            Write-Host "   ✅ Lokalni i remote su sinhronizovani" -ForegroundColor Green
        }
    } catch {
        Write-Host "   ⚠️  Greška pri pull-u: $_" -ForegroundColor Yellow
    }
} else {
    Write-Host "   ⚠️  Nema remote repozitorijuma za pull" -ForegroundColor Yellow
}
Write-Host ""

# 7. Pokušaj push
Write-Host "7. Pokušavam push..." -ForegroundColor Yellow
$remoteExists = git remote get-url origin 2>$null
if ($remoteExists) {
    try {
        Write-Host "   Push-ujem na origin/$branch..." -ForegroundColor Yellow
        git push origin $branch 2>&1 | ForEach-Object {
            Write-Host "   $_"
        }
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   ✅ Push uspešan!" -ForegroundColor Green
        } else {
            Write-Host "   ❌ Push neuspešan!" -ForegroundColor Red
            Write-Host ""
            Write-Host "   Mogući razlozi:" -ForegroundColor Yellow
            Write-Host "   1. Autentifikacija - proveri GitHub credentials" -ForegroundColor Yellow
            Write-Host "   2. Permissions - proveri da li imaš prava za push" -ForegroundColor Yellow
            Write-Host "   3. Branch protection - proveri GitHub settings" -ForegroundColor Yellow
            Write-Host ""
            Write-Host "   Rešenja:" -ForegroundColor Cyan
            Write-Host "   - Ako koristiš HTTPS, možda treba da ažuriraš credentials:" -ForegroundColor White
            Write-Host "     git config --global credential.helper wincred" -ForegroundColor Gray
            Write-Host "   - Ili koristi Personal Access Token umesto lozinke" -ForegroundColor White
            Write-Host "   - Ako koristiš SSH, proveri SSH key:" -ForegroundColor White
            Write-Host "     ssh -T git@github.com" -ForegroundColor Gray
        }
    } catch {
        Write-Host "   ❌ Greška: $_" -ForegroundColor Red
    }
} else {
    Write-Host "   ⚠️  Nema remote repozitorijuma za push" -ForegroundColor Yellow
    Write-Host "   Dodaj remote repozitorijum prvo!" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Završeno ===" -ForegroundColor Cyan







