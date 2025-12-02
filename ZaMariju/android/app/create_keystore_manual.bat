@echo off
echo ========================================
echo Creating Android Keystore for Release
echo ========================================
echo.

cd /d "%~dp0"

echo Current directory: %CD%
echo.

echo Running keytool command...
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload -storepass android123 -keypass android123 -dname "CN=GPT Wrapped, OU=Development, O=GPT Wrapped, L=Belgrade, ST=Serbia, C=RS"

echo.
echo Checking if keystore was created...

if exist upload-keystore.jks (
    echo.
    echo ========================================
    echo SUCCESS: Keystore created successfully!
    echo ========================================
    echo.
    echo File location: %CD%\upload-keystore.jks
    dir upload-keystore.jks
    echo.
    echo You can now build your signed AAB with:
    echo   flutter build appbundle --release
) else (
    echo.
    echo ========================================
    echo ERROR: Keystore was NOT created!
    echo ========================================
    echo.
    echo Please check:
    echo 1. Java is installed and in PATH
    echo 2. Run this as Administrator
    echo 3. Check the error message above
    echo.
)

pause
