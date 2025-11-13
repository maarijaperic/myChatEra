# 📱 Kako testirati na telefonu - Korak po korak

## ✅ KORAK 1: Pronađi IP adresu tvog računara

### Na Windows-u:

1. Otvori **Command Prompt** (CMD):
   - Pritisni `Win + R`
   - Ukucaj: `cmd`
   - Pritisni Enter

2. Ukucaj komandu:
   ```cmd
   ipconfig
   ```

3. Pronađi **"IPv4 Address"** pod jednim od ovih:
   - **"Wireless LAN adapter Wi-Fi"** (ako koristiš Wi-Fi)
   - **"Ethernet adapter"** (ako koristiš kabl)

4. Primer šta tražiš:
   ```
   Wireless LAN adapter Wi-Fi:
      IPv4 Address. . . . . . . . . . . : 192.168.1.100
   ```

5. **Zapiši ovu IP adresu!** (npr. `192.168.1.100`)

---

## ✅ KORAK 2: Proveri da li su računar i telefon na istoj Wi-Fi mreži

**VAŽNO:** Računar i telefon **MORAJU** biti na istoj Wi-Fi mreži!

- ✅ Računar: povezan na "Moja Wi-Fi Mreža"
- ✅ Telefon: povezan na "Moja Wi-Fi Mreža"
- ❌ NE: Računar na Wi-Fi, telefon na mobilnim podacima

---

## ✅ KORAK 3: Postavi Proxy URL u Flutter aplikaciji

Otvori `ZaMariju/lib/main.dart` i dodaj kod:

```dart
import 'package:gpt_wrapped2/services/ai_analyzer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Postavi proxy URL sa IP adresom tvog računara
  // ZAMENI 192.168.1.100 sa svojom IP adresom!
  AIAnalyzer.setProxyUrl('http://192.168.1.100:3000');
  
  runApp(const MyApp());
}
```

**Zameni `192.168.1.100` sa IP adresom koju si našla u KORAKU 1!**

---

## ✅ KORAK 4: Omogući Firewall (ako treba)

Ako telefon ne može da se poveže, možda Windows Firewall blokira port 3000.

### Privremeno omogući (samo za testiranje):

1. Otvori PowerShell **kao Administrator**
2. Pokreni:
   ```powershell
   New-NetFirewallRule -DisplayName "Allow Proxy Server" -Direction Inbound -LocalPort 3000 -Protocol TCP -Action Allow
   ```

**Ili ručno:**
1. Otvori Windows Defender Firewall
2. Klikni "Advanced settings"
3. "Inbound Rules" → "New Rule"
4. Port → TCP → Specific local ports: `3000`
5. Allow the connection
6. Sve profile (Domain, Private, Public)
7. Daj mu ime: "Proxy Server"

---

## ✅ KORAK 5: Proveri da li proxy server radi

1. Na računaru, proveri da li server radi:
   - Otvori browser: `http://localhost:3000/health`
   - Trebalo bi da vidiš: `{"status":"ok",...}`

2. **SA TELEFONA**, otvori browser i idi na:
   - `http://192.168.1.100:3000/health` (zameni sa svojom IP adresom!)
   - Trebalo bi da vidiš isti JSON odgovor

**Ako ne vidiš odgovor sa telefona:**
- Proveri da li su na istoj Wi-Fi mreži
- Proveri firewall (KORAK 4)
- Proveri da li je IP adresa tačna

---

## ✅ KORAK 6: Pokreni Flutter app na telefonu

1. Poveži telefon na računar (USB)
2. Omogući USB debugging (Android) ili Developer Mode (iOS)
3. Pokreni:
   ```bash
   cd ZaMariju
   flutter run
   ```

4. Flutter će ti ponuditi da izabereš telefon
5. Izaberi telefon i sačekaj da se app instalira

---

## ✅ KORAK 7: Testiraj!

1. Otvori app na telefonu
2. Uloguj se
3. Pokreni premium analizu
4. Proveri konzolu na računaru (gde radi `npm start`) - trebalo bi da vidiš zahteve

---

## ❌ Rešavanje problema

### Problem: "Cannot connect to proxy server"

**Rešenje:**
1. Proveri da li su računar i telefon na istoj Wi-Fi mreži
2. Proveri da li je proxy server pokrenut (`npm start`)
3. Proveri da li možeš pristupiti `http://IP_ADRESA:3000/health` sa telefona u browser-u
4. Proveri firewall

### Problem: "Connection timeout"

**Rešenje:**
1. Proveri da li je IP adresa tačna (`ipconfig`)
2. Proveri da li je server pokrenut
3. Proveri internet konekciju

### Problem: "Network error"

**Rešenje:**
1. Proveri da li su na istoj mreži
2. Restartuj proxy server
3. Restartuj Flutter app

---

## 📋 Checklist

- [ ] Pronašla si IP adresu računara (`ipconfig`)
- [ ] Računar i telefon su na istoj Wi-Fi mreži
- [ ] Proxy server radi (`npm start`)
- [ ] Možeš pristupiti `http://IP_ADRESA:3000/health` sa telefona
- [ ] Dodala si `AIAnalyzer.setProxyUrl('http://IP_ADRESA:3000')` u `main.dart`
- [ ] Firewall je podešen (ako treba)
- [ ] Flutter app je pokrenut na telefonu

---

**Srećno! 🚀**

