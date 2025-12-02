# 🔥 Firebase + RevenueCat - Kako Funkcioniše Integracija

## 📊 PREGLED

Aplikacija koristi **Firebase Firestore** za praćenje analiza i **RevenueCat** za upravljanje subscription-ima. Evo kako se spajaju:

---

## 🔄 FLOW DIAGRAM

```
┌─────────────────────────────────────────────────────────┐
│                    KORISNIK KLIKNE                      │
│              "Generate Premium Analysis"                 │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│              REVENUECAT PROVERA                         │
│  "Da li je korisnik premium?"                           │
│  - Proverava subscription status                        │
│  - Vraća: isPremium (true/false)                       │
│  - Vraća: subscriptionType (one_time/monthly/yearly)    │
└────────────────────┬────────────────────────────────────┘
                     │
         ┌───────────┴───────────┐
         │                       │
         ▼                       ▼
    ✅ PREMIUM              ❌ NIJE PREMIUM
         │                       │
         │                       └───► Prikaži SubscriptionScreen
         │
         ▼
┌─────────────────────────────────────────────────────────┐
│              FIREBASE PROVERA                           │
│  "Da li korisnik ima preostalih analiza?"               │
│  - Proverava limit na osnovu subscriptionType          │
│  - One-time: oneTimeUsed == false?                      │
│  - Monthly/Yearly: monthlyCounts[month] < 5?           │
└────────────────────┬────────────────────────────────────┘
                     │
         ┌───────────┴───────────┐
         │                       │
         ▼                       ▼
    ✅ IMA LIMIT            ❌ LIMIT DOSTIGNUT
         │                       │
         │                       └───► Prikaži "Limit reached"
         │
         ▼
┌─────────────────────────────────────────────────────────┐
│              GENERIŠI PREMIUM ANALIZU                   │
│  - Pozovi PremiumProcessor.analyzePremiumInsights()     │
│  - Sačuvaj rezultate lokalno                            │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│              FIREBASE UPDATE                            │
│  - Povećaj broj analiza                                 │
│  - One-time: oneTimeUsed = true                         │
│  - Monthly/Yearly: monthlyCounts[month]++              │
│  - lastAnalysis = now                                   │
└─────────────────────────────────────────────────────────┘
```

---

## 💾 FIREBASE STRUKTURA

### Collection: `user_analyses`

**Document ID:** RevenueCat User ID (automatski generisan)

**Polja:**
```json
{
  "userId": "revenuecat_user_123",
  "oneTimeUsed": false,
  "monthlyCounts": {
    "2025-01": 2,
    "2025-02": 1
  },
  "lastAnalysis": "2025-02-15T10:30:00Z",
  "lastUpdated": "2025-02-15T10:30:00Z"
}
```

### Kako se koristi:

**One-Time Purchase:**
- `oneTimeUsed == false` → može da generiše analizu
- `oneTimeUsed == true` → ne može (već iskorišćeno)

**Monthly/Yearly Subscription:**
- `monthlyCounts["2025-02"] < 5` → može da generiše analizu
- `monthlyCounts["2025-02"] >= 5` → ne može (limit dostignut)

---

## 🔐 REVENUECAT STRUKTURA

### Entitlement: `premium`

**Proizvodi povezani sa `premium`:**
- `one_time_purchase` → lifetime access
- `monthly_subscription` → 30 dana access
- `yearly_subscription` → 365 dana access

### Kako se koristi:

**Provera premium statusa:**
```dart
final isPremium = await RevenueCatService.isPremium();
// Vraća true ako ima aktivan subscription
```

**Provera subscription tipa:**
```dart
final subscriptionType = await RevenueCatService.getSubscriptionType();
// Vraća: 'one_time', 'monthly', 'yearly', ili null
```

**Provera User ID:**
```dart
final userId = await RevenueCatService.getUserId();
// Vraća RevenueCat User ID (koristi se kao Document ID u Firebase)
```

---

## 📝 IMPLEMENTACIJA U KODU

### 1. Provera da li može da generiše analizu

**Fajl:** `lib/services/analysis_tracker.dart`

```dart
static Future<bool> canGenerateAnalysis() async {
  // 1. Proveri RevenueCat (da li je premium)
  final isPremium = await RevenueCatService.isPremium();
  if (!isPremium) return false;
  
  // 2. Proveri Firebase (da li ima limit)
  final subscriptionType = await RevenueCatService.getSubscriptionType();
  final userId = await RevenueCatService.getUserId();
  
  if (subscriptionType == 'one_time') {
    return await _canGenerateOneTime(userId);
  } else {
    return await _canGenerateMonthly(userId);
  }
}
```

### 2. Provera one-time limita

```dart
static Future<bool> _canGenerateOneTime(String userId) async {
  final doc = await _firestore
    .collection('user_analyses')
    .doc(userId)
    .get();
  
  if (!doc.exists) return true; // Prvi put
  
  final data = doc.data();
  final oneTimeUsed = data?['oneTimeUsed'] ?? false;
  
  return !oneTimeUsed; // Može ako nije iskorišćeno
}
```

### 3. Provera monthly/yearly limita

```dart
static Future<bool> _canGenerateMonthly(String userId) async {
  final now = DateTime.now();
  final monthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
  
  final doc = await _firestore
    .collection('user_analyses')
    .doc(userId)
    .get();
  
  if (!doc.exists) return true; // Prvi put
  
  final data = doc.data();
  final monthlyCounts = data?['monthlyCounts'] as Map<String, dynamic>? ?? {};
  final currentMonthCount = monthlyCounts[monthKey] ?? 0;
  
  return currentMonthCount < 5; // Limit je 5 analiza mesečno
}
```

### 4. Povećanje broja analiza

```dart
static Future<void> incrementAnalysisCount() async {
  final userId = await RevenueCatService.getUserId();
  final subscriptionType = await RevenueCatService.getSubscriptionType();
  
  final now = DateTime.now();
  final monthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
  
  final docRef = _firestore.collection('user_analyses').doc(userId);
  final doc = await docRef.get();
  
  if (subscriptionType == 'one_time') {
    // One-time: samo označi kao iskorišćeno
    await docRef.set({
      'userId': userId,
      'oneTimeUsed': true,
      'lastAnalysis': FieldValue.serverTimestamp(),
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  } else {
    // Monthly/Yearly: povećaj broj za trenutni mesec
    final data = doc.data() ?? {};
    final monthlyCounts = Map<String, dynamic>.from(
      data['monthlyCounts'] ?? {}
    );
    monthlyCounts[monthKey] = (monthlyCounts[monthKey] ?? 0) + 1;
    
    await docRef.set({
      'userId': userId,
      'monthlyCounts': monthlyCounts,
      'lastAnalysis': FieldValue.serverTimestamp(),
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
```

---

## 🎯 SCENARIJI KORIŠĆENJA

### Scenario 1: One-Time Purchase

1. Korisnik kupi `one_time_purchase` ($9.99)
2. RevenueCat vraća: `isPremium = true`, `subscriptionType = 'one_time'`
3. Korisnik klikne "Generate Premium Analysis"
4. App proverava Firebase: `oneTimeUsed == false` → ✅ može
5. Generiše se analiza
6. Firebase se ažurira: `oneTimeUsed = true`
7. Korisnik više ne može da generiše analizu (ali ima lifetime access do rezultata)

### Scenario 2: Monthly Subscription (Prvi Mesec)

1. Korisnik kupi `monthly_subscription` ($4.99)
2. RevenueCat vraća: `isPremium = true`, `subscriptionType = 'monthly'`
3. Korisnik klikne "Generate Premium Analysis"
4. App proverava Firebase: `monthlyCounts["2025-02"] = 0` → ✅ može
5. Generiše se analiza
6. Firebase se ažurira: `monthlyCounts["2025-02"] = 1`
7. Korisnik može još 4 analize ovog meseca

### Scenario 3: Monthly Subscription (Limit Dostignut)

1. Korisnik već generisao 5 analiza ovog meseca
2. Korisnik klikne "Generate Premium Analysis"
3. App proverava Firebase: `monthlyCounts["2025-02"] = 5` → ❌ ne može
4. Prikazuje se poruka: "You have reached your monthly limit (5 analyses). Please wait until next month."

### Scenario 4: Subscription Istekao

1. Korisnik imao monthly subscription, ali je istekao
2. RevenueCat vraća: `isPremium = false`
3. Korisnik klikne "Generate Premium Analysis"
4. App proverava RevenueCat: `isPremium = false` → ❌ ne može
5. Prikazuje se SubscriptionScreen

---

## 🔒 BEZBEDNOST

### Trenutno (Test Mode):
- Firebase Security Rules: `allow read, write: if true` (otvoreno za sve)
- ⚠️ **Nije sigurno za produkciju!**

### Za Produkciju (Preporučeno):

**Opcija 1: Firebase Authentication**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /user_analyses/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

**Opcija 2: Backend Validacija**
- Koristi backend API za validaciju
- Backend proverava RevenueCat status
- Backend ažurira Firebase
- Flutter app samo poziva backend API

---

## 📊 ANALITIKA

### Šta možeš pratiti u Firebase:

1. **Broj analiza po korisniku:**
   - Koliko korisnika je generisalo analizu
   - Koliko analiza je generisano ukupno

2. **Subscription tipovi:**
   - Koliko korisnika ima one-time
   - Koliko korisnika ima monthly
   - Koliko korisnika ima yearly

3. **Mesečne statistike:**
   - Koliko analiza je generisano po mesecu
   - Koji mesec je najaktivniji

4. **Retencija:**
   - Koliko korisnika generiše više od jedne analize
   - Koliko korisnika koristi monthly/yearly subscription

---

## ✅ CHECKLIST

- [ ] Firebase Firestore Database kreiran
- [ ] Collection `user_analyses` kreirana
- [ ] Security Rules postavljene (privremeno otvoreno)
- [ ] RevenueCat povezan sa Google Play Console
- [ ] RevenueCat povezan sa App Store Connect
- [ ] Entitlement `premium` kreiran
- [ ] Svi proizvodi povezani sa `premium` entitlement-om
- [ ] `AnalysisTracker` implementiran
- [ ] `incrementAnalysisCount()` implementiran
- [ ] Testiranje urađeno

---

**Sve je spremno! Firebase i RevenueCat rade zajedno za praćenje analiza i subscription-a! 🎉**
