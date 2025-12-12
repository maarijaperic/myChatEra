# 🔒 Firestore Security Rules - Setup Guide

## 📋 Pregled

Ova aplikacija koristi Firebase Firestore za praćenje broja analiza po korisniku. Security Rules su važne za sigurnost podataka.

---

## 🎯 KORAK 1: Firebase Console Setup

### 1.1. Otvori Firebase Console

1. Idi na https://console.firebase.google.com
2. Odaberi svoj projekat
3. Idi na **Firestore Database** → **Rules**

### 1.2. Kopiraj Security Rules

Kopiraj sledeće pravila u Firebase Console:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Collection za praćenje analiza
    match /user_analyses/{userId} {
      // Dozvoli čitanje i pisanje za sve (PRIVREMENO - za testiranje)
      allow read, write: if true;
    }
  }
}
```

**⚠️ VAŽNO:** Ovo je za **testiranje**. Za produkciju, koristi pravila iz `firestore.rules` fajla.

---

## 🔐 KORAK 2: Produkcija Security Rules

### 2.1. Osnovna Validacija (Preporučeno)

Za produkciju, koristi osnovnu validaciju koja proverava da `userId` u path-u odgovara `userId` u dokumentu:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /user_analyses/{userId} {
      // Dozvoli čitanje i pisanje ako userId u path-u odgovara userId u dokumentu
      allow read, write: if request.resource.data.userId == userId 
                        || resource.data.userId == userId;
    }
  }
}
```

### 2.2. Sa Firebase Authentication (Najsigurnije)

Ako koristiš Firebase Authentication, možeš koristiti `request.auth.uid`:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /user_analyses/{userId} {
      // Dozvoli čitanje i pisanje samo ako je korisnik autentifikovan
      // i userId odgovara auth.uid
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

**Napomena:** Ovo zahteva da korisnici budu autentifikovani preko Firebase Auth, što trenutno nije implementirano u aplikaciji.

---

## 📊 Struktura Podataka

### Collection: `user_analyses`

#### Document ID: `{userId}` (RevenueCat User ID)

```json
{
  "userId": "$RCAnonymousID:xxx",
  "oneTimePurchases": 2,        // Broj kupljenih one_time_purchase
  "oneTimeUsed": 1,              // Broj korišćenih one_time analiza
  "monthlyCounts": {
    "2025-01": 3,                // Broj analiza u januaru 2025
    "2025-02": 1                 // Broj analiza u februaru 2025
  },
  "lastAnalysis": "2025-01-15T10:30:00Z",
  "lastUpdated": "2025-01-15T10:30:00Z"
}
```

---

## ✅ Checklist

- [ ] Firebase projekat kreiran
- [ ] Firestore Database kreiran
- [ ] Collection `user_analyses` kreirana
- [ ] Security Rules postavljene (test mode za početak)
- [ ] Security Rules ažurirane za produkciju
- [ ] Testirano da li aplikacija može da čita/piše u Firestore

---

## 🐛 Troubleshooting

### "Permission denied" greška

1. Proveri da li su Security Rules postavljene u Firebase Console
2. Proveri da li je `userId` u path-u isti kao `userId` u dokumentu
3. Za testiranje, koristi `allow read, write: if true;`

### "Collection does not exist"

1. Kreiraj collection `user_analyses` u Firestore Database
2. Ili dozvoli aplikaciji da automatski kreira dokumente

---

## 📝 Napomene

- **Test Mode:** Koristi `allow read, write: if true;` samo za testiranje
- **Produkcija:** Uvek koristi validaciju (osnovnu ili sa Firebase Auth)
- **Backend Validacija:** Za dodatnu sigurnost, razmotri backend validaciju preko Firebase Functions

