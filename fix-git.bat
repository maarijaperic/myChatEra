@echo off
chcp 65001 >nul
echo ========================================
echo Git Problem Resolver
echo ========================================
echo.

cd /d "%~dp0"

echo Proveravam Git status...
git status
echo.
echo.

echo Proveravam remote repozitorijum...
git remote -v
echo.
echo.

echo Trenutna grana:
git branch --show-current
echo.
echo.

echo Pokušavam da pull-ujem promene...
git pull origin main
echo.
echo.

echo Pokušavam push...
git push origin main
echo.
echo.

echo ========================================
echo Završeno!
echo ========================================
pause







