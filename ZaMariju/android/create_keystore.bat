@echo off
cd /d "%~dp0"
echo Creating keystore...
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload -storepass android123 -keypass android123 -dname "CN=GPT Wrapped, OU=Development, O=GPT Wrapped, L=Belgrade, ST=Serbia, C=RS"
if exist upload-keystore.jks (
    echo SUCCESS: Keystore created successfully!
    dir upload-keystore.jks
) else (
    echo ERROR: Failed to create keystore
    pause
)
