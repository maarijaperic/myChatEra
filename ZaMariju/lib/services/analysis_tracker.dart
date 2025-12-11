import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'revenuecat_service.dart';

/// Service for tracking analysis usage per user
class AnalysisTracker {
  static FirebaseFirestore get _firestore {
    if (Firebase.apps.isEmpty) {
      throw Exception('Firebase is not initialized');
    }
    return FirebaseFirestore.instance;
  }
  static const String _collectionName = 'user_analyses';
  
  // TEST MODE: Set to true to bypass RevenueCat checks for testing
  // Set to false before production release!
  static const bool ENABLE_TEST_MODE = true; // TEMPORARY: Enable for TestFlight testing

  /// Check if user can generate a new analysis
  static Future<bool> canGenerateAnalysis() async {
    // TEST MODE: Allow analysis without RevenueCat
    if (ENABLE_TEST_MODE) {
      print('🧪 TEST MODE: Bypassing RevenueCat checks - allowing premium analysis');
      return true;
    }
    
    try {
      // 1. Check if user has premium subscription
      final isPremium = await RevenueCatService.isPremium();
      if (!isPremium) {
        print('AnalysisTracker: User does not have premium subscription');
        return false;
      }

      // 2. Get subscription type
      final subscriptionType = await RevenueCatService.getSubscriptionType();
      if (subscriptionType == null) {
        print('AnalysisTracker: Could not determine subscription type');
        return false;
      }

      // 3. Get user ID
      final userId = await RevenueCatService.getUserId();
      if (userId.isEmpty) {
        print('AnalysisTracker: Could not get user ID');
        return false;
      }

      // 4. Check limits based on subscription type
      if (subscriptionType == 'one_time') {
        return await _canGenerateOneTime(userId);
      } else {
        // monthly or yearly
        return await _canGenerateMonthly(userId);
      }
    } catch (e) {
      print('Error checking if can generate analysis: $e');
      return false;
    }
  }

  /// Check if one-time user can generate analysis
  static Future<bool> _canGenerateOneTime(String userId) async {
    try {
      if (Firebase.apps.isEmpty) {
        print('⚠️ AnalysisTracker: Firebase not initialized - returning false');
        return false;
      }
      final doc = await _firestore.collection(_collectionName).doc(userId).get();
      
      if (!doc.exists) {
        // First time - can generate
        return true;
      }

      final data = doc.data();
      final oneTimeUsed = data?['oneTimeUsed'] as bool? ?? false;
      
      return !oneTimeUsed; // Can generate if not used
    } catch (e) {
      print('Error checking one-time limit: $e');
      return false;
    }
  }

  /// Check if monthly/yearly user can generate analysis
  static Future<bool> _canGenerateMonthly(String userId) async {
    try {
      if (Firebase.apps.isEmpty) {
        print('⚠️ AnalysisTracker: Firebase not initialized - returning false');
        return false;
      }
      final now = DateTime.now();
      final monthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
      
      final doc = await _firestore.collection(_collectionName).doc(userId).get();
      
      if (!doc.exists) {
        // First time - can generate (0 < 5)
        return true;
      }

      final data = doc.data();
      final monthlyCounts = data?['monthlyCounts'] as Map<String, dynamic>? ?? {};
      final currentMonthCount = monthlyCounts[monthKey] as int? ?? 0;
      
      return currentMonthCount < 5; // Can generate if less than 5
    } catch (e) {
      print('Error checking monthly limit: $e');
      return false;
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
  static Future<void> _incrementOneTime(String userId) async {
    try {
      if (Firebase.apps.isEmpty) {
        print('⚠️ AnalysisTracker: Firebase not initialized - skipping increment');
        return;
      }
      await _firestore.collection(_collectionName).doc(userId).set({
        'userId': userId,
        'oneTimeUsed': true,
        'lastAnalysis': FieldValue.serverTimestamp(),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      print('AnalysisTracker: One-time analysis marked as used for user $userId');
    } catch (e) {
      print('Error incrementing one-time count: $e');
    }
  }

  /// Increment monthly analysis count
  static Future<void> _incrementMonthly(String userId) async {
    try {
      if (Firebase.apps.isEmpty) {
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
      if (Firebase.apps.isEmpty) {
        print('⚠️ AnalysisTracker: Firebase not initialized - returning 0');
        return 0;
      }
      final subscriptionType = await RevenueCatService.getSubscriptionType();
      if (subscriptionType == null) return 0;

      final userId = await RevenueCatService.getUserId();
      if (userId.isEmpty) return 0;

      if (subscriptionType == 'one_time') {
        final canGenerate = await _canGenerateOneTime(userId);
        return canGenerate ? 1 : 0;
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
        
        return (5 - currentMonthCount).clamp(0, 5);
      }
    } catch (e) {
      print('Error getting remaining analyses: $e');
      return 0;
    }
  }

  /// Get analysis count for current month
  static Future<int> getCurrentMonthAnalysisCount() async {
    try {
      if (Firebase.apps.isEmpty) {
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
