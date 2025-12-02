# 🔥 Firebase iOS Setup - Detaljni Koraci

## 🎯 PREGLED:

Trebamo dodati iOS aplikaciju u Firebase i konfigurisati `GoogleService-Info.plist`.

---

## 📋 KORAK 1: Dodaj iOS App u Firebase

### **1.1. Idi na Firebase Console**

1. **Idi na:** https://console.firebase.google.com/
2. **Izaberi tvoj projekat** (isti kao za Android)

---

### **1.2. Dodaj iOS App**

1. **U Firebase Console:**
   - Klikni na **⚙️ Settings** (podešavanja) → **Project settings**
   - Idi na tab **General**
   - U sekciji **Your apps**, klikni na **+ Add app** → **iOS**

2. **Unesi informacije:**
   - **iOS bundle ID:** `com.mychatera` (ISTO KAO NA ANDROIDU!)
   - **App nickname:** `MyChatEra AI iOS` (opciono)
   - **App Store ID:** (ostavi prazno za sada)

3. **Klikni:** **Register app**

---

### **1.3. Preuzmi GoogleService-Info.plist**

1. **Firebase će generisati `GoogleService-Info.plist`**
2. **Klikni:** **Download GoogleService-Info.plist**
3. **Sačuvaj fajl** (nećeš moći ponovo da ga preuzmeš!)

---

### **1.4. Dodaj GoogleService-Info.plist u Projekat**

1. **Kopiraj `GoogleService-Info.plist` u:**
   ```
   ZaMariju/ios/Runner/GoogleService-Info.plist
   ```

2. **Proveri da je fajl na pravom mestu:**
   - ✅ `ios/Runner/GoogleService-Info.plist`

---

## 📋 KORAK 2: Konfiguriši Xcode Projekat

### **2.1. Dodaj GoogleService-Info.plist u Xcode**

**Ako imaš Mac:**
1. Otvori `ios/Runner.xcworkspace` u Xcode
2. Drag & drop `GoogleService-Info.plist` u `Runner` folder
3. Proveri da je **"Copy items if needed"** označeno
4. Klikni **Finish**

**Ako NEMAŠ Mac (Codemagic će to uraditi automatski):**
- ✅ Samo dodaj fajl u `ios/Runner/` folder
- ✅ Codemagic će automatski uključiti fajl u build

---

### **2.2. Proveri da li je Fajl Dodat**

**Proveri `project.pbxproj` da li sadrži:**
```
GoogleService-Info.plist
```

**Ako nije, možeš dodati ručno u `project.pbxproj`** (ali to nije obavezno - Codemagic će to uraditi).

---

## 📋 KORAK 3: Proveri Firebase Dependencies

### **3.1. Proveri pubspec.yaml**

✅ **Već imaš:**
```yaml
dependencies:
  firebase_core: ^3.6.0
  cloud_firestore: ^5.4.0
```

---

### **3.2. Proveri iOS Podfile**

**Codemagic će automatski install-ovati CocoaPods dependencies, ali proveri:**

1. **U `ios/Podfile`:**
   - Trebalo bi da ima Firebase pods

2. **Ako nema, dodaj:**
   ```ruby
   pod 'Firebase/Core'
   pod 'Firebase/Firestore'
   ```

**Codemagic će automatski pokrenuti `pod install`!**

---

## 📋 KORAK 4: Test Firebase Integracije

### **4.1. Proveri da li Firebase Radi**

**U `main.dart`:**
```dart
await Firebase.initializeApp();
```

✅ **Ovo već postoji!**

---

### **4.2. Proveri da li Firestore Radi**

**Firebase će automatski koristiti `GoogleService-Info.plist` za iOS!**

---

## ⚠️ VAŽNE NAPOMENE:

### **Bundle Identifier:**
- ✅ **Mora biti isti** kao na Androidu: `com.mychatera`
- ✅ **Mora biti isti** kao u Firebase: `com.mychatera`

### **GoogleService-Info.plist:**
- ✅ **Mora biti u `ios/Runner/` folderu**
- ✅ **Mora biti dodato u Xcode projekat** (Codemagic će to uraditi)

### **Firebase Projekat:**
- ✅ **Koristi isti Firebase projekat** kao za Android
- ✅ **Firestore baza je ista** za oba platforma

---

## 📋 CHECKLIST:

- [ ] ✅ Dodana iOS app u Firebase Console
- [ ] ✅ Preuzet `GoogleService-Info.plist`
- [ ] ✅ Dodat `GoogleService-Info.plist` u `ios/Runner/` folder
- [ ] ✅ Proveren bundle identifier (`com.mychatera`)
- [ ] ✅ Proveren Firebase initialization u `main.dart`
- [ ] ✅ Proveren Firestore setup

---

## 🔗 KORISNI LINKOVI:

- **Firebase Console:** https://console.firebase.google.com/
- **Firebase iOS Setup:** https://firebase.google.com/docs/ios/setup

---

**Firebase iOS setup je završen! 🔥**
