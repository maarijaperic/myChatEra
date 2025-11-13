# Implementacija Plaćanja - Timeline i Vodič

## ⏱️ PROCENA VREMENA

### **Najbrže (sa RevenueCat): 4-6 sati**
- ✅ Najlakše rešenje
- ✅ Automatski handling subscriptiona
- ✅ Cross-platform (Android + iOS)
- ✅ Testiranje i debug: 1-2 sata

### **Srednje (Google Play Billing direktno): 8-12 sati**
- ⚠️ Komplikovanije
- ⚠️ Više koda
- ⚠️ Testiranje i debug: 2-4 sata

### **Sporije (custom backend + Stripe): 1-2 dana**
- ❌ Najkomplikovanije
- ❌ Treba backend server
- ❌ Više testiranja

---

## 🎯 PREPORUČENO: RevenueCat (4-6 sati)

### Zašto RevenueCat?
- ✅ **Najlakše** - gotovo sve je automatski
- ✅ **Besplatno** za početak (do $10k/mesečno)
- ✅ **Automatski sync** sa Google Play / App Store
- ✅ **Analytics** ugrađeni
- ✅ **Cross-platform** - radi na Android i iOS
- ✅ **Dokumentacija** je odlična

---

## 📋 KORACI ZA IMPLEMENTACIJU

### KORAK 1: RevenueCat Setup (30-60 min)

1. **Registracija:**
   - Idi na [app.revenuecat.com](https://app.revenuecat.com)
   - Registruj se (besplatno)

2. **Kreiraj projekat:**
   - Klikni "New Project"
   - Unesi ime aplikacije

3. **Poveži Google Play Console:**
   - Idi na "Integrations" → "Google Play"
   - Poveži sa Google Play Console nalogom
   - RevenueCat će automatski sync-ovati subscription proizvode

4. **Kreiraj Subscription Proizvode:**
   - U Google Play Console:
     - Idi na "Monetize" → "Products" → "Subscriptions"
     - Kreiraj 3 subscription proizvoda:
       - Monthly ($4.99/mo)
       - Yearly ($19.99/yr)
       - One-time ($9.99)
   - RevenueCat će automatski detektovati proizvode

5. **Dobij API Key:**
   - U RevenueCat dashboard-u
   - Idi na "API Keys"
   - Kopiraj "Public SDK Key"

---

### KORAK 2: Flutter Setup (1-2 sata)

1. **Dodaj paket u `pubspec.yaml`:**
   ```yaml
   dependencies:
     purchases_flutter: ^7.0.0
   ```

2. **Instaliraj:**
   ```bash
   flutter pub get
   ```

3. **Inicijalizuj RevenueCat u `main.dart`:**
   ```dart
   import 'package:purchases_flutter/purchases_flutter.dart';
   
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     
     // RevenueCat setup
     await Purchases.setDebugLogsEnabled(true); // Samo za development
     await Purchases.configure(
       PurchasesConfiguration('YOUR_REVENUECAT_API_KEY')
         ..appUserID = null // RevenueCat će automatski generisati
     );
     
     runApp(const MyApp());
   }
   ```

4. **Kreiraj Payment Service:**
   ```dart
   // lib/services/payment_service.dart
   import 'package:purchases_flutter/purchases_flutter.dart';
   
   class PaymentService {
     static Future<bool> purchaseSubscription(String productId) async {
       try {
         final customerInfo = await Purchases.purchaseProduct(productId);
         return customerInfo.entitlements.active.isNotEmpty;
       } catch (e) {
         print('Purchase error: $e');
         return false;
       }
     }
     
     static Future<List<Package>> getAvailablePackages() async {
       try {
         final offerings = await Purchases.getOfferings();
         if (offerings.current != null) {
           return offerings.current!.availablePackages;
         }
         return [];
       } catch (e) {
         print('Error getting packages: $e');
         return [];
       }
     }
     
     static Future<bool> isPremium() async {
       try {
         final customerInfo = await Purchases.getCustomerInfo();
         return customerInfo.entitlements.active.isNotEmpty;
       } catch (e) {
         return false;
       }
     }
   }
   ```

---

### KORAK 3: Ažuriraj SubscriptionScreen (1-2 sata)

1. **Dodaj logiku za plaćanje:**
   ```dart
   // U screen_subscription.dart
   import 'package:gpt_wrapped2/services/payment_service.dart';
   
   Future<void> _handlePurchase(int index) async {
     // index 0 = Monthly, 1 = Yearly, 2 = One-time
     final productIds = [
       'monthly_subscription',
       'yearly_subscription',
       'one_time_purchase'
     ];
     
     setState(() => _isLoading = true);
     
     final success = await PaymentService.purchaseSubscription(productIds[index]);
     
     setState(() => _isLoading = false);
     
     if (success) {
       // Uspešno plaćeno - navigiraj na premium
       Navigator.pop(context);
       widget.onSubscribe();
     } else {
       // Greška - prikaži poruku
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Purchase failed. Please try again.')),
       );
     }
   }
   ```

2. **Ažuriraj "Continue" dugme:**
   ```dart
   GestureDetector(
     onTap: _isLoading ? null : () => _handlePurchase(selectedIndex),
     child: Container(
       // ... styling
       child: _isLoading 
         ? CircularProgressIndicator()
         : Text('Continue'),
     ),
   )
   ```

---

### KORAK 4: Provera Premium Statusa (30-60 min)

1. **Proveri da li je korisnik premium:**
   ```dart
   // U main.dart ili gde god treba
   Future<bool> checkPremiumStatus() async {
     return await PaymentService.isPremium();
   }
   ```

2. **Ažuriraj navigaciju:**
   - Ako je premium → direktno na premium ekrane
   - Ako nije premium → prikaži SubscriptionScreen

---

### KORAK 5: Testiranje (1-2 sata)

1. **Google Play Console - Test Accounts:**
   - Dodaj sebe kao test korisnika
   - Testiraj sa test subscription proizvodima

2. **RevenueCat - Test Mode:**
   - RevenueCat ima test mode
   - Testiraj sve subscription opcije

3. **Test na različitim scenarijima:**
   - Uspešno plaćanje
   - Otkazano plaćanje
   - Greška u plaćanju
   - Restore purchases

---

## 📋 DETALJNA CHECKLIST

### Setup (1-2 sata)
- [ ] Registrovao si se na RevenueCat
- [ ] Kreirao projekat
- [ ] Povezao Google Play Console
- [ ] Kreirao subscription proizvode u Google Play Console
- [ ] Dobio RevenueCat API key

### Flutter Implementation (2-3 sata)
- [ ] Dodao `purchases_flutter` paket
- [ ] Inicijalizovao RevenueCat u `main.dart`
- [ ] Kreirao `PaymentService` klasu
- [ ] Ažurirao `SubscriptionScreen` sa payment logikom
- [ ] Dodao loading state
- [ ] Dodao error handling

### Testing (1-2 sata)
- [ ] Testirao na test account-u
- [ ] Proverio sve subscription opcije
- [ ] Testirao error scenarije
- [ ] Proverio premium status check

### Polish (30-60 min)
- [ ] Dodao loading indikatore
- [ ] Dodao error poruke
- [ ] Dodao success poruke
- [ ] Proverio UI/UX

---

## ⚠️ VAŽNE NAPOMENE

### 1. Google Play Console Setup
- Subscription proizvodi moraju biti kreirani u Google Play Console
- Moraš imati Google Play Developer nalog ($25)
- Proizvodi moraju biti odobreni od strane Google-a (može potrajati 1-2 dana)

### 2. Testiranje
- Koristi test account-e za testiranje
- Ne možeš testirati sa pravim novcem dok ne izbaciš aplikaciju
- RevenueCat ima test mode za development

### 3. Production
- Pre izbacivanja, proveri da li su svi proizvodi odobreni
- Proveri da li RevenueCat API key radi u production modu
- Testiraj na realnom uređaju pre izbacivanja

---

## 🚀 BRZI PUTOKAZ (4-6 sati)

```bash
# 1. RevenueCat Setup (30-60 min)
# - Registracija
# - Povezivanje Google Play Console
# - Kreiranje proizvoda

# 2. Flutter Setup (1-2 sata)
flutter pub add purchases_flutter
# Dodaj RevenueCat inicijalizaciju u main.dart
# Kreiraj PaymentService

# 3. Ažuriraj SubscriptionScreen (1-2 sata)
# Dodaj payment logiku
# Dodaj loading state
# Dodaj error handling

# 4. Testiranje (1-2 sata)
# Testiraj sve subscription opcije
# Proveri error scenarije
```

---

## 💰 TROŠKOVI

### RevenueCat:
- ✅ **Besplatno** do $10,000 mesečnog prihoda
- ✅ Nakon toga: 1% od prihoda

### Google Play:
- ✅ **$25** jednokratno (već imaš za Developer nalog)
- ✅ **30%** provizija od svake transakcije (standardno)

---

## 🎯 ZAKLJUČAK

**Vreme potrebno: 4-6 sati** (sa RevenueCat)

**Ako žuriš:**
- Možeš implementirati za 4 sata ako sve ide glatko
- Ali planiraj 6 sati da budeš siguran

**Ako nemaš vremena:**
- Možeš izbaciti aplikaciju bez plaćanja
- Dodati plaćanje u update-u nakon izbacivanja
- Korisnici će moći da testiraju besplatno

---

**Srećno sa implementacijom! 💳**

