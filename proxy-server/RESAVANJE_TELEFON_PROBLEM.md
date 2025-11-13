# 🔧 Rešavanje problema sa telefonom - Teško se učitava

## Problem

- ✅ `http://192.168.56.1:3000/health` radi na računaru
- ❌ Ne radi na telefonu (teško se učitava)

## Uzrok

`192.168.56.1` je verovatno **VirtualBox/VMware IP adresa**, ne stvarna IP adresa tvog računara na Wi-Fi mreži.

---

## ✅ Rešenje 1: Pronađi tačnu Wi-Fi IP adresu

### Korak 1: Pronađi stvarnu IP adresu

1. Otvori **CMD** (Command Prompt)
2. Ukucaj:
   ```cmd
   ipconfig
   ```

3. Pronađi **"Wireless LAN adapter Wi-Fi"** sekciju
4. Pronađi **"IPv4 Address"** - to je tvoja stvarna IP adresa
   - Primer: `192.168.1.100` ili `192.168.0.50` ili `10.0.0.5`

### Korak 2: Proveri sa telefona

1. Na telefonu, otvori browser
2. Idi na: `http://STVARNA_IP_ADRESA:3000/health`
   - Primer: `http://192.168.1.100:3000/health`
3. Trebalo bi da vidiš: `{"status":"ok",...}`

### Korak 3: Ažuriraj kod u Flutter app

1. Otvori `ZaMariju/lib/main.dart`
2. Pronađi liniju sa `AIAnalyzer.setProxyUrl`
3. Zameni IP adresu:
   ```dart
   AIAnalyzer.setProxyUrl('http://192.168.1.100:3000'); // Zameni sa svojom IP adresom!
   ```

---

## ✅ Rešenje 2: Proveri da li su na istoj mreži

**VAŽNO:** Računar i telefon **MORAJU** biti na istoj Wi-Fi mreži!

### Provera:

1. **Na računaru:**
   - Settings → Network & Internet → Wi-Fi
   - Vidi ime mreže (npr. "Moja Wi-Fi")

2. **Na telefonu:**
   - Settings → Wi-Fi
   - Proveri da li je povezan na **ISTU** mrežu

**Ako nisu na istoj mreži:**
- Poveži telefon na istu Wi-Fi mrežu kao računar
- Ne koristi mobilne podatke!

---

## ✅ Rešenje 3: Omogući Firewall

Ako i dalje ne radi, možda Windows Firewall blokira pristup.

### Privremeno omogući (samo za testiranje):

1. Otvori **PowerShell kao Administrator**
2. Pokreni:
   ```powershell
   New-NetFirewallRule -DisplayName "Allow Proxy Server" -Direction Inbound -LocalPort 3000 -Protocol TCP -Action Allow
   ```

3. Pokušaj ponovo sa telefona

---

## ✅ Rešenje 4: Koristi USB port forwarding (alternativa)

Ako ne možeš da koristiš Wi-Fi, možeš koristiti USB:

### Za Android:

1. Poveži telefon preko USB-a
2. U CMD-u, pokreni:
   ```cmd
   adb reverse tcp:3000 tcp:3000
   ```

3. U Flutter app, koristi:
   ```dart
   AIAnalyzer.setProxyUrl('http://localhost:3000');
   ```

**Napomena:** Ovo zahteva da imaš Android Debug Bridge (ADB) instaliran.

---

## ✅ Rešenje 5: Proveri proxy server konfiguraciju

Možda server sluša samo na `localhost`, ne na svim interfejsima.

### Proveri `server.js`:

Trebalo bi da ima:
```javascript
app.listen(PORT, '0.0.0.0', () => {
  // ...
});
```

Ako ima samo `app.listen(PORT, ...)`, dodaj `'0.0.0.0'` da sluša na svim interfejsima.

---

## 🔍 Debugging koraci

1. **Proveri IP adresu:**
   ```cmd
   ipconfig
   ```
   - Pronađi Wi-Fi IPv4 adresu

2. **Proveri sa telefona u browser-u:**
   - `http://IP_ADRESA:3000/health`
   - Trebalo bi da vidiš JSON odgovor

3. **Proveri firewall:**
   - Windows Defender Firewall → Advanced settings
   - Proveri da li port 3000 dozvoljen

4. **Proveri da li su na istoj mreži:**
   - Računar i telefon moraju biti na istoj Wi-Fi mreži

---

## 📋 Checklist

- [ ] Pronašla si stvarnu Wi-Fi IP adresu (`ipconfig`)
- [ ] Proverila si da li možeš pristupiti `http://IP_ADRESA:3000/health` sa telefona
- [ ] Računar i telefon su na istoj Wi-Fi mreži
- [ ] Firewall je omogućen za port 3000
- [ ] Ažurirala si IP adresu u `main.dart`
- [ ] Restartovala si Flutter app

---

## 🎯 Najverovatnije rešenje

**Pronađi stvarnu Wi-Fi IP adresu i zameni `192.168.56.1` u kodu!**

1. `ipconfig` u CMD-u
2. Pronađi "Wireless LAN adapter Wi-Fi" → "IPv4 Address"
3. Zameni u `main.dart`
4. Proveri sa telefona u browser-u
5. Restartuj Flutter app

---

**Javi mi koju IP adresu si našla i da li radi! 🚀**

