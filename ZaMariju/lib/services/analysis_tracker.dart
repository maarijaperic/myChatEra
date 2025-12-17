import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'revenuecat_service.dart';

/// Service for tracking analysis usage per user
class AnalysisTracker {
  static FirebaseFirestore get _firestore {
    try {
      if (Firebase.apps.isEmpty) {
        throw Exception('Firebase is not initialized - no apps found');
      }
      return FirebaseFirestore.instance;
    } catch (e) {
      print('❌ AnalysisTracker: Error accessing Firestore: $e');
      rethrow;
    }
  }
  static const String _collectionName = 'user_analyses';
  static const int _monthlyAnalysisLimit = 10; // Number of analyses allowed per month for monthly/yearly subscriptions
  
  // TEST MODE: Set to true to bypass RevenueCat checks for testing
  // Set to false before production release!
  static const bool ENABLE_TEST_MODE = false; // Disabled for Sandbox testing

  /// Check if user can generate a new analysis
  static Future<bool> canGenerateAnalysis() async {
    // TEST MODE: Allow analysis without RevenueCat
    if (ENABLE_TEST_MODE) {
      print('🧪 TEST MODE: Bypassing RevenueCat checks - allowing premium analysis');
      return true;
    }
    
    try {
      print('🔴 AnalysisTracker: Checking if can generate analysis...');
      
      // 1. Check if user has premium subscription
      final isPremium = await RevenueCatService.isPremium();
      print('🔴 AnalysisTracker: Is premium: $isPremium');
      if (!isPremium) {
        print('❌ AnalysisTracker: User does not have premium subscription');
        return false;
      }

      // 2. Get subscription type
      final subscriptionType = await RevenueCatService.getSubscriptionType();
      print('🔴 AnalysisTracker: Subscription type: $subscriptionType');
      if (subscriptionType == null) {
        print('❌ AnalysisTracker: Could not determine subscription type');
        return false;
      }

      // 3. Get user ID
      final userId = await RevenueCatService.getUserId();
      print('🔴 AnalysisTracker: User ID: $userId');
      if (userId.isEmpty) {
        print('❌ AnalysisTracker: Could not get user ID');
        return false;
      }

      // 4. Check limits based on subscription type
      if (subscriptionType == 'one_time') {
        final canGenerate = await _canGenerateOneTime(userId);
        print('🔴 AnalysisTracker: Can generate one-time: $canGenerate');
        
        // Fallback: If Firestore fails but user is premium, allow generation
        if (!canGenerate) {
          print('⚠️ AnalysisTracker: Firestore check failed, but user is premium - allowing generation as fallback');
          return true;
        }
        return canGenerate;
      } else {
        // monthly or yearly
        final canGenerate = await _canGenerateMonthly(userId);
        print('🔴 AnalysisTracker: Can generate monthly: $canGenerate');
        
        // Fallback: If Firestore fails but user is premium, allow generation
        if (!canGenerate) {
          print('⚠️ AnalysisTracker: Firestore check failed, but user is premium - allowing generation as fallback');
          return true;
        }
        return canGenerate;
      }
    } catch (e, stackTrace) {
      print('❌ AnalysisTracker: Error checking if can generate analysis: $e');
      print('❌ AnalysisTracker: Stack trace: $stackTrace');
      return false;
    }
  }

  /// Ensure Firebase is initialized
  static Future<bool> _ensureFirebaseInitialized() async {
    try {
      // Check if Firebase is already initialized by trying to access the default app
      if (Firebase.apps.isNotEmpty) {
        // Verify that Firebase is actually working by checking if we can access Firestore
        try {
          final test = FirebaseFirestore.instance;
          print('✅ AnalysisTracker: Firebase is initialized and accessible');
          return true;
        } catch (e) {
          print('⚠️ AnalysisTracker: Firebase apps exist but Firestore is not accessible: $e');
          // Continue to reinitialize
        }
      }
      
      print('⚠️ AnalysisTracker: Firebase not initialized - attempting to initialize...');
      await Firebase.initializeApp();
      
      // Verify initialization by accessing Firestore
      final test = FirebaseFirestore.instance;
      print('✅ AnalysisTracker: Firebase initialized successfully');
      return true;
    } catch (e, stackTrace) {
      print('❌ AnalysisTracker: Failed to initialize Firebase: $e');
      print('❌ AnalysisTracker: Stack trace: $stackTrace');
      return false;
    }
  }

  /// Check if one-time user can generate analysis
  /// For one-time purchases: user can buy multiple times, each purchase = 1 analysis
  /// User can screenshot all screens but cannot access the same analysis again
  static Future<bool> _canGenerateOneTime(String userId) async {
    try {
      // Ensure Firebase is initialized before checking
      final firebaseReady = await _ensureFirebaseInitialized();
      if (!firebaseReady) {
        print('⚠️ AnalysisTracker: Firebase not initialized - allowing generation as fallback for premium user');
        return true; // Allow if Firebase not ready but user is premium
      }
      
      try {
        final doc = await _firestore.collection(_collectionName).doc(userId).get();
        
        if (!doc.exists) {
          // First time - can generate
          print('🔴 AnalysisTracker: Document does not exist - first time user, can generate');
          return true;
        }

        final data = doc.data();
        final oneTimePurchases = (data?['oneTimePurchases'] as int? ?? 0); // Total purchases
        final oneTimeUsed = (data?['oneTimeUsed'] as int? ?? 0); // Total used
        
        print('🔴 AnalysisTracker: oneTimePurchases: $oneTimePurchases, oneTimeUsed: $oneTimeUsed');
        
        // User can generate if they have unused purchases
        // Each purchase = 1 analysis
        final canGenerate = oneTimePurchases > oneTimeUsed;
        
        if (canGenerate) {
          print('🔴 AnalysisTracker: User has unused one-time purchases - can generate');
        } else {
          print('🔴 AnalysisTracker: User has used all one-time purchases - cannot generate');
          print('🔴 AnalysisTracker: User needs to purchase another one_time_purchase to generate new analysis');
        }
        
        return canGenerate;
      } on FirebaseException catch (e) {
        if (e.code == 'permission-denied') {
          print('⚠️ AnalysisTracker: Firestore permission denied - allowing generation as fallback for premium user');
          print('⚠️ AnalysisTracker: Please update Firestore Security Rules to allow read/write for user_analyses collection');
          return true; // Allow if permission denied but user is premium
        }
        rethrow;
      }
    } catch (e, stackTrace) {
      print('❌ AnalysisTracker: Error checking one-time limit: $e');
      print('❌ AnalysisTracker: Stack trace: $stackTrace');
      // If Firestore fails but user is premium, allow generation
      print('⚠️ AnalysisTracker: Firestore error, but user is premium - allowing generation as fallback');
      return true;
    }
  }

  /// Check if monthly/yearly user can generate analysis
  static Future<bool> _canGenerateMonthly(String userId) async {
    try {
      // Ensure Firebase is initialized before checking
      final firebaseReady = await _ensureFirebaseInitialized();
      if (!firebaseReady) {
        print('⚠️ AnalysisTracker: Firebase not initialized - allowing generation as fallback for premium user');
        return true; // Allow if Firebase not ready but user is premium
      }
      
      try {
        final now = DateTime.now();
        final monthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
        
        final doc = await _firestore.collection(_collectionName).doc(userId).get();
        
        if (!doc.exists) {
          // First time - can generate (0 < 5)
          print('🔴 AnalysisTracker: Document does not exist - first time user, can generate');
          return true;
        }

        final data = doc.data();
        final monthlyCounts = data?['monthlyCounts'] as Map<String, dynamic>? ?? {};
        final currentMonthCount = monthlyCounts[monthKey] as int? ?? 0;
        
        print('🔴 AnalysisTracker: Current month count: $currentMonthCount for month $monthKey (limit: $_monthlyAnalysisLimit)');
        return currentMonthCount < _monthlyAnalysisLimit; // Can generate if less than limit
      } on FirebaseException catch (e) {
        if (e.code == 'permission-denied') {
          print('⚠️ AnalysisTracker: Firestore permission denied - allowing generation as fallback for premium user');
          print('⚠️ AnalysisTracker: Please update Firestore Security Rules to allow read/write for user_analyses collection');
          return true; // Allow if permission denied but user is premium
        }
        rethrow;
      }
    } catch (e, stackTrace) {
      print('❌ AnalysisTracker: Error checking monthly limit: $e');
      print('❌ AnalysisTracker: Stack trace: $stackTrace');
      // If Firestore fails but user is premium, allow generation
      print('⚠️ AnalysisTracker: Firestore error, but user is premium - allowing generation as fallback');
      return true;
    }
  }

  /// Increment analysis count after generating analysis
  static Future<void> incrementAnalysisCount() async {
    // TEST MODE: Skip incrementing count
    if (ENABLE_TEST_MODE) {
      print('🧪 TEST MODE: Skipping analysis count increment');
      return;
    }
    
    try {
      final userId = await RevenueCatService.getUserId();
      if (userId.isEmpty) {
        print('AnalysisTracker: Could not get user ID for increment');
        return;
      }

      final subscriptionType = await RevenueCatService.getSubscriptionType();
      if (subscriptionType == null) {
        print('AnalysisTracker: Could not determine subscription type for increment');
        return;
      }

      if (subscriptionType == 'one_time') {
        await _incrementOneTime(userId);
      } else {
        await _incrementMonthly(userId);
      }
    } catch (e) {
      print('Error incrementing analysis count: $e');
    }
  }

  /// Increment one-time analysis count
  /// When user generates analysis, increment oneTimeUsed
  /// When user purchases one_time_purchase, increment oneTimePurchases
  static Future<void> _incrementOneTime(String userId) async {
    try {
      // Ensure Firebase is initialized before incrementing
      final firebaseReady = await _ensureFirebaseInitialized();
      if (!firebaseReady) {
        print('⚠️ AnalysisTracker: Firebase not initialized - skipping increment');
        return;
      }
      
      // Get current values
      final doc = await _firestore.collection(_collectionName).doc(userId).get();
      final currentUsed = doc.exists ? (doc.data()?['oneTimeUsed'] as int? ?? 0) : 0;
      
      await _firestore.collection(_collectionName).doc(userId).set({
        'userId': userId,
        'oneTimeUsed': currentUsed + 1, // Increment used count
        'lastAnalysis': FieldValue.serverTimestamp(),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      print('AnalysisTracker: One-time analysis count incremented for user $userId (used: ${currentUsed + 1})');
    } catch (e) {
      print('Error incrementing one-time count: $e');
    }
  }
  
  /// Increment one-time purchase count (called when user purchases one_time_purchase)
  static Future<void> incrementOneTimePurchase(String userId) async {
    try {
      final firebaseReady = await _ensureFirebaseInitialized();
      if (!firebaseReady) {
        print('⚠️ AnalysisTracker: Firebase not initialized - skipping purchase increment');
        return;
      }
      
      // Get current values
      final doc = await _firestore.collection(_collectionName).doc(userId).get();
      final currentPurchases = doc.exists ? (doc.data()?['oneTimePurchases'] as int? ?? 0) : 0;
      
      await _firestore.collection(_collectionName).doc(userId).set({
        'userId': userId,
        'oneTimePurchases': currentPurchases + 1, // Increment purchase count
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      print('AnalysisTracker: One-time purchase count incremented for user $userId (purchases: ${currentPurchases + 1})');
    } catch (e) {
      print('Error incrementing one-time purchase count: $e');
    }
  }

  /// Increment monthly analysis count
  static Future<void> _incrementMonthly(String userId) async {
    try {
      // Ensure Firebase is initialized before incrementing
      final firebaseReady = await _ensureFirebaseInitialized();
      if (!firebaseReady) {
        print('⚠️ AnalysisTracker: Firebase not initialized - skipping increment');
        return;
      }
      final now = DateTime.now();
      final monthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
      
      final docRef = _firestore.collection(_collectionName).doc(userId);
      final doc = await docRef.get();
      
      if (!doc.exists) {
        // Create new document
        await docRef.set({
          'userId': userId,
          'monthlyCounts': {
            monthKey: 1,
          },
          'lastAnalysis': FieldValue.serverTimestamp(),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      } else {
        // Update existing document
        final data = doc.data()!;
        final monthlyCounts = Map<String, dynamic>.from(
          data['monthlyCounts'] as Map<String, dynamic>? ?? {},
        );
        
        final currentCount = monthlyCounts[monthKey] as int? ?? 0;
        monthlyCounts[monthKey] = currentCount + 1;
        
        await docRef.update({
          'monthlyCounts': monthlyCounts,
          'lastAnalysis': FieldValue.serverTimestamp(),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
      
      print('AnalysisTracker: Monthly count incremented for user $userId, month $monthKey');
    } catch (e) {
      print('Error incrementing monthly count: $e');
    }
  }

  /// Get remaining analyses for current month
  static Future<int> getRemainingAnalyses() async {
    try {
      // Ensure Firebase is initialized before checking
      final firebaseReady = await _ensureFirebaseInitialized();
      if (!firebaseReady) {
        print('⚠️ AnalysisTracker: Firebase not initialized - returning 0');
        return 0;
      }
      final subscriptionType = await RevenueCatService.getSubscriptionType();
      if (subscriptionType == null) return 0;

      final userId = await RevenueCatService.getUserId();
      if (userId.isEmpty) return 0;

      if (subscriptionType == 'one_time') {
        try {
          final doc = await _firestore.collection(_collectionName).doc(userId).get();
          if (!doc.exists) return 0;
          
          final data = doc.data();
          final oneTimePurchases = (data?['oneTimePurchases'] as int? ?? 0);
          final oneTimeUsed = (data?['oneTimeUsed'] as int? ?? 0);
          
          return (oneTimePurchases - oneTimeUsed).clamp(0, oneTimePurchases);
        } catch (e) {
          print('Error getting remaining one-time analyses: $e');
          return 0;
        }
      } else {
        final now = DateTime.now();
        final monthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
        
        final doc = await _firestore.collection(_collectionName).doc(userId).get();
        
        if (!doc.exists) {
          return 5; // First time - all 5 available
        }

        final data = doc.data();
        final monthlyCounts = data?['monthlyCounts'] as Map<String, dynamic>? ?? {};
        final currentMonthCount = monthlyCounts[monthKey] as int? ?? 0;
        
        return (_monthlyAnalysisLimit - currentMonthCount).clamp(0, _monthlyAnalysisLimit);
      }
    } catch (e) {
      print('Error getting remaining analyses: $e');
      return 0;
    }
  }

  /// Get analysis count for current month
  static Future<int> getCurrentMonthAnalysisCount() async {
    try {
      // Ensure Firebase is initialized before checking
      final firebaseReady = await _ensureFirebaseInitialized();
      if (!firebaseReady) {
        print('⚠️ AnalysisTracker: Firebase not initialized - returning 0');
        return 0;
      }
      final userId = await RevenueCatService.getUserId();
      if (userId.isEmpty) return 0;

      final subscriptionType = await RevenueCatService.getSubscriptionType();
      if (subscriptionType == 'one_time') {
        final doc = await _firestore.collection(_collectionName).doc(userId).get();
        if (!doc.exists) return 0;
        final data = doc.data();
        final oneTimeUsed = data?['oneTimeUsed'] as bool? ?? false;
        return oneTimeUsed ? 1 : 0;
      } else {
        final now = DateTime.now();
        final monthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
        
        final doc = await _firestore.collection(_collectionName).doc(userId).get();
        if (!doc.exists) return 0;

        final data = doc.data();
        final monthlyCounts = data?['monthlyCounts'] as Map<String, dynamic>? ?? {};
        return monthlyCounts[monthKey] as int? ?? 0;
      }
    } catch (e) {
      print('Error getting current month count: $e');
      return 0;
    }
  }
}
