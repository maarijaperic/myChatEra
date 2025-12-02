# Subscription Logic - Kako Funkcioniše Plaćanje i Pristup

## 📋 Pregled Modela Plaćanja

### 1. **One-Time Payment ($9.99)**
**Kako funkcioniše:**
- ✅ Korisnik plati jednom → **LIFETIME ACCESS** do premium analize
- ✅ Premium insights se generišu **jednom** (kada plati)
- ✅ Rezultati se **čuvaju lokalno** na telefonu
- ✅ Korisnik **uvek** ima pristup toj analizi (čak i ako obriše app i reinstalira)

**Tehnički:**
```dart
// RevenueCat će vratiti:
- productId: 'one_time_purchase'
- entitlement: 'premium_lifetime'
- expiresDate: null (nikad ne ističe)
```

**Čuvanje podataka:**
- Premium insights se čuvaju u `SharedPreferences` sa ključem `premium_insights_${userId}`
- Ako korisnik reinstalira app → RevenueCat će vratiti da ima lifetime access
- Aplikacija će proveriti da li postoje lokalno sačuvani insights, ako ne → generiše ponovo

---

### 2. **Monthly Subscription ($4.99/mo)**
**Kako funkcioniše:**
- ✅ Korisnik plati → pristup premium analizi **tokom meseca**
- ✅ Premium insights se generišu **jednom** (kada prvi put plati)
- ✅ Rezultati se **čuvaju lokalno** na telefonu
- ✅ Na kraju meseca → subscription se **automatski obnovi** (ako je uključeno auto-renew)
- ✅ Ako korisnik **otkaže** → gubi pristup nakon isteka trenutnog perioda

**Tehnički:**
```dart
// RevenueCat će vratiti:
- productId: 'monthly_subscription'
- entitlement: 'premium_monthly'
- expiresDate: DateTime (npr. 2025-02-15) // 30 dana od plaćanja
```

**Čuvanje podataka:**
- Premium insights se čuvaju lokalno
- Svaki put kada korisnik otvori app → proverava se `expiresDate`
- Ako je subscription aktivan → korisnik vidi premium ekrane
- Ako je istekao → prikazuje se SubscriptionScreen ponovo

---

### 3. **Yearly Subscription ($19.99/yr)**
**Kako funkcioniše:**
- ✅ Korisnik plati → pristup premium analizi **tokom godine**
- ✅ Premium insights se generišu **jednom** (kada prvi put plati)
- ✅ Rezultati se **čuvaju lokalno** na telefonu
- ✅ Na kraju godine → subscription se **automatski obnovi** (ako je uključeno auto-renew)
- ✅ Ako korisnik **otkaže** → gubi pristup nakon isteka trenutnog perioda

**Tehnički:**
```dart
// RevenueCat će vratiti:
- productId: 'yearly_subscription'
- entitlement: 'premium_yearly'
- expiresDate: DateTime (npr. 2026-01-15) // 365 dana od plaćanja
```

**Čuvanje podataka:**
- Isto kao monthly, samo duži period

---

## 🔧 Implementacija

### Korak 1: Kreiraj Payment Service

```dart
// lib/services/payment_service.dart
import 'package:purchases_flutter/purchases_flutter.dart';

class PaymentService {
  static Future<bool> initialize() async {
    // Inicijalizuj RevenueCat sa API key-jem
    await Purchases.configure(
      PurchasesConfiguration('your_revenuecat_api_key')
    );
    return true;
  }

  /// Proveri da li je korisnik premium
  static Future<bool> isPremium() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      
      // Proveri da li ima aktivan entitlement
      final hasLifetime = customerInfo.entitlements.active['premium_lifetime'] != null;
      final hasMonthly = customerInfo.entitlements.active['premium_monthly'] != null;
      final hasYearly = customerInfo.entitlements.active['premium_yearly'] != null;
      
      return hasLifetime || hasMonthly || hasYearly;
    } catch (e) {
      print('Error checking premium status: $e');
      return false;
    }
  }

  /// Proveri tip subscription-a
  static Future<String?> getSubscriptionType() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      
      if (customerInfo.entitlements.active['premium_lifetime'] != null) {
        return 'lifetime';
      } else if (customerInfo.entitlements.active['premium_yearly'] != null) {
        return 'yearly';
      } else if (customerInfo.entitlements.active['premium_monthly'] != null) {
        return 'monthly';
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Kupi subscription
  static Future<bool> purchaseSubscription(String productId) async {
    try {
      final offerings = await Purchases.getOfferings();
      final package = offerings.current?.availablePackages.firstWhere(
        (p) => p.storeProduct.identifier == productId,
      );
      
      if (package == null) return false;
      
      final purchaserInfo = await Purchases.purchasePackage(package);
      
      // Proveri da li je uspešno
      return purchaserInfo.entitlements.active.isNotEmpty;
    } catch (e) {
      print('Purchase error: $e');
      return false;
    }
  }

  /// Proveri da li je subscription istekao
  static Future<bool> isSubscriptionExpired() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      
      // Lifetime nikad ne ističe
      if (customerInfo.entitlements.active['premium_lifetime'] != null) {
        return false;
      }
      
      // Proveri monthly/yearly
      final monthly = customerInfo.entitlements.active['premium_monthly'];
      final yearly = customerInfo.entitlements.active['premium_yearly'];
      
      final entitlement = monthly ?? yearly;
      if (entitlement == null) return true;
      
      // Proveri expiresDate
      final expiresDate = entitlement.expirationDate;
      if (expiresDate == null) return false; // Lifetime
      
      return DateTime.now().isAfter(expiresDate);
    } catch (e) {
      return true; // Ako greška → pretpostavi da je istekao
    }
  }
}
```

---

### Korak 2: Ažuriraj SubscriptionScreen

```dart
// U screen_subscription.dart
Future<void> _handlePurchase(int index) async {
  final productIds = [
    'monthly_subscription',
    'yearly_subscription',
    'one_time_purchase'
  ];
  
  setState(() => _isLoading = true);
  
  final success = await PaymentService.purchaseSubscription(productIds[index]);
  
  setState(() => _isLoading = false);
  
  if (success) {
    // Uspešno plaćeno
    Navigator.pop(context);
    widget.onSubscribe(); // Pokreni premium analizu
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Purchase failed. Please try again.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
```

---

### Korak 3: Čuvanje Premium Insights

```dart
// lib/services/premium_storage.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:gpt_wrapped2/services/premium_processor.dart';

class PremiumStorage {
  static const String _key = 'premium_insights';
  
  /// Sačuvaj premium insights lokalno
  static Future<void> saveInsights(PremiumInsights insights) async {
    final prefs = await SharedPreferences.getInstance();
    final json = {
      'personalityType': insights.personalityType,
      'typeAPercentage': insights.typeAPercentage,
      'typeBPercentage': insights.typeBPercentage,
      // ... svi ostali podaci
    };
    await prefs.setString(_key, jsonEncode(json));
  }
  
  /// Učitaj premium insights
  static Future<PremiumInsights?> loadInsights() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return null;
    
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    // Rekonstruiši PremiumInsights objekat
    return PremiumInsights(/* ... */);
  }
  
  /// Proveri da li postoje sačuvani insights
  static Future<bool> hasInsights() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_key);
  }
}
```

---

### Korak 4: Logika Pristupa u Main.dart

```dart
// U main.dart ili gde god proveravaš pristup
Future<void> _checkPremiumAccess() async {
  // 1. Proveri RevenueCat status
  final isPremium = await PaymentService.isPremium();
  
  if (!isPremium) {
    // Nije premium → prikaži free ekrane
    return;
  }
  
  // 2. Proveri da li postoje lokalno sačuvani insights
  final cachedInsights = await PremiumStorage.loadInsights();
  
  if (cachedInsights != null) {
    // Koristi sačuvane insights
    _premiumInsights = cachedInsights;
    return;
  }
  
  // 3. Ako nema sačuvanih insights → generiši nove
  // (ovo se dešava kada korisnik prvi put plati)
  if (parsedConversations != null && parsedConversations!.isNotEmpty) {
    // Pokreni premium analizu
    // ...
  }
}
```

---

## 🎯 Scenariji Korišćenja

### Scenario 1: One-Time Payment
1. Korisnik plati $9.99
2. Premium analiza se generiše
3. Insights se čuvaju lokalno
4. Korisnik **uvek** ima pristup (čak i nakon reinstalacije)
5. RevenueCat će vratiti `premium_lifetime` entitlement

### Scenario 2: Monthly Subscription (Aktivan)
1. Korisnik plati $4.99
2. Premium analiza se generiše
3. Insights se čuvaju lokalno
4. Korisnik ima pristup **30 dana**
5. Na kraju meseca → auto-renew (ako je uključeno)
6. Ako otkaže → pristup traje do kraja perioda

### Scenario 3: Monthly Subscription (Istekao)
1. Subscription je istekao
2. RevenueCat vraća `expiresDate` u prošlosti
3. Aplikacija prikazuje SubscriptionScreen ponovo
4. Korisnik može da plati ponovo ili otkaže
5. **Stari insights ostaju sačuvani** (ali nema pristup dok ne plati)

### Scenario 4: Yearly Subscription
1. Isto kao monthly, samo **365 dana** umesto 30
2. Bolja vrednost → korisnici će više birati yearly

---

## 📱 Šta Treba Dodati

### ✅ Već Imate:
- SubscriptionScreen sa 3 opcije
- Premium analiza funkcionalnost
- Premium ekrani

### ❌ Treba Dodati:

1. **RevenueCat integracija:**
   - `purchases_flutter` package
   - API key konfiguracija
   - Product ID-ovi u Google Play Console / App Store Connect

2. **Payment Service:**
   - `PaymentService` klasa (kao gore)
   - Provera premium statusa
   - Purchase flow

3. **Premium Storage:**
   - Čuvanje insights lokalno
   - Učitavanje insights pri pokretanju

4. **Access Control:**
   - Provera pristupa pri navigaciji
   - Prikaz SubscriptionScreen ako nije premium
   - Validacija subscription statusa

5. **Restore Purchases:**
   - Dugme "Restore Purchases" za korisnike koji reinstaliraju app
   - RevenueCat automatski vraća status

---

## 🔐 Security Notes

- ✅ RevenueCat čuva sve na backend-u → sigurno
- ✅ Premium insights se čuvaju lokalno → brzo učitavanje
- ✅ Validacija se radi preko RevenueCat API-ja → ne može se zaobići
- ✅ One-time purchase se čuva u RevenueCat → lifetime access garantovan

---

## 💡 Preporuke

1. **One-Time Purchase:**
   - Najbolje za korisnike koji ne žele subscription
   - Lifetime access → korisnici će biti zadovoljni
   - Možeš kasnije povećati cenu ako vidiš da je popularno

2. **Yearly Subscription:**
   - Najbolja vrednost → promoviši ovo
   - 67% ušteda → privlačno za korisnike
   - Manje transaction fee-jeva → više profita

3. **Monthly Subscription:**
   - Najfleksibilnije → lako otkazati
   - Dobro za korisnike koji žele da probaju
   - Možeš kasnije konvertovati u yearly

---

## 🚀 Sledeći Koraci

1. ✅ Dodaj RevenueCat SDK
2. ✅ Kreiraj PaymentService
3. ✅ Integriši sa SubscriptionScreen
4. ✅ Dodaj PremiumStorage za čuvanje
5. ✅ Dodaj access control logiku
6. ✅ Testiraj sve scenarije
7. ✅ Dodaj "Restore Purchases" dugme

**Sve je spremno! Samo treba da integrišeš RevenueCat i to je to! 🎉**






