@echo off
chcp 65001 >nul
echo ========================================
echo Push na GitHub - maarijaperic/myChatEra
echo ========================================
echo.

cd /d "%~dp0"

echo [1/6] Proveravam Git status...
git status
echo.
echo.

echo [2/6] Postavljam remote na https://github.com/maarijaperic/myChatEra.git
git remote remove origin 2>nul
git remote add origin https://github.com/maarijaperic/myChatEra.git
git remote -v
echo.
echo.

echo [3/6] Proveravam trenutnu granu...
git branch --show-current
echo.
echo.

echo [4/6] Dodajem sve promene...
git add .
echo.
echo.

echo [5/6] Commit-ujem promene...
git commit -m "Update: Latest changes" 2>&1
echo.
echo.

echo [6/6] Pull-ujem promene sa GitHub-a (da vidim da li ima novih)...
git pull origin main --no-edit 2>&1
if errorlevel 1 (
    echo.
    echo ⚠️  Ima konflikata ili problema sa pull-om!
    echo Reši konflikte ručno, pa pokreni ponovo.
    pause
    exit /b 1
)
echo.
echo.

echo [7/6] Push-ujem na GitHub...
git push origin main 2>&1
if errorlevel 1 (
    echo.
    echo ❌ Push neuspešan!
    echo.
    echo Mogući razlozi:
    echo 1. Autentifikacija - GitHub traži username/password
    echo 2. Koristi Personal Access Token umesto lozinke
    echo 3. Proveri da li imaš prava za push
    echo.
) else (
    echo.
    echo ✅ Push uspešan!
)
echo.
echo.

echo ========================================
echo Završeno!
echo ========================================
pause




