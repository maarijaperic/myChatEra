import 'package:purchases_flutter/purchases_flutter.dart';

/// Service for managing RevenueCat subscriptions
class RevenueCatService {
  static const String _oneTimeProductId = 'one_time_purchase';
  static const String _monthlyProductId = 'monthly_subscription';
  static const String _yearlyProductId = 'yearly_subscription';
  static const String _entitlementId = 'premium';


  static bool _isConfigured = false;
  
  /// Check if RevenueCat is configured
  static bool get isConfigured => _isConfigured;
  
  /// Initialize RevenueCat
  static Future<void> initialize(String apiKey) async {
    try {
      if (apiKey == 'YOUR_REVENUECAT_PUBLIC_KEY_HERE' || apiKey.isEmpty) {
        print('⚠️ RevenueCat: API key not set - skipping initialization');
        _isConfigured = false;
        return;
      }
    await Purchases.setDebugLogsEnabled(true); // Set to false in production
    await Purchases.configure(
      PurchasesConfiguration(apiKey)
        ..appUserID = null, // RevenueCat will auto-generate
    );
      _isConfigured = true;
      print('✅ RevenueCat: Successfully configured');
    } catch (e) {
      print('❌ RevenueCat: Error initializing: $e');
      _isConfigured = false;
    }
  }

  /// Check if user has active premium subscription
  static Future<bool> isPremium() async {
    if (!_isConfigured) {
      print('⚠️ RevenueCat: Not configured - returning false for isPremium');
      return false;
    }
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.active.containsKey(_entitlementId);
    } catch (e) {
      print('❌ RevenueCat: Error checking premium status: $e');
      return false;
    }
  }

  /// Get subscription type (one_time, monthly, yearly, or null)
  static Future<String?> getSubscriptionType() async {
    if (!_isConfigured) {
      print('⚠️ RevenueCat: Not configured - returning null for getSubscriptionType');
      return null;
    }
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      final activeEntitlements = customerInfo.entitlements.active;
      
      if (activeEntitlements.isEmpty) return null;
      
      // Get the product identifier from the active entitlement
      final entitlement = activeEntitlements[_entitlementId];
      if (entitlement == null) return null;
      
      final productId = entitlement.productIdentifier;
      
      if (productId == _oneTimeProductId) return 'one_time';
      if (productId == _monthlyProductId) return 'monthly';
      if (productId == _yearlyProductId) return 'yearly';
      
      return null;
    } catch (e) {
      print('❌ RevenueCat: Error getting subscription type: $e');
      return null;
    }
  }

  /// Get RevenueCat User ID
  static Future<String> getUserId() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.originalAppUserId;
    } catch (e) {
      print('Error getting user ID: $e');
      return '';
    }
  }

  /// Purchase a subscription/product
  static Future<bool> purchaseProduct(String productId) async {
    if (!_isConfigured) {
      print('⚠️ RevenueCat: Not configured - cannot purchase product');
      return false;
    }
    
    try {
      print('🔴 RevenueCat: Attempting to purchase product: $productId');
      
      // Try direct purchase first (simpler and more reliable)
      print('🔴 RevenueCat: Attempting direct purchase with productId: $productId');
      final purchaseResult = await Purchases.purchaseProduct(productId);
      print('✅ RevenueCat: Purchase result received');
      final hasEntitlement = purchaseResult.customerInfo.entitlements.active.containsKey(_entitlementId);
      print('🔴 RevenueCat: Has premium entitlement: $hasEntitlement');
      
      if (!hasEntitlement) {
        print('⚠️ RevenueCat: Purchase successful but no premium entitlement found');
        print('🔴 RevenueCat: Active entitlements: ${purchaseResult.customerInfo.entitlements.active.keys.toList()}');
      }
      
      return hasEntitlement;
    } on PurchasesError catch (e) {
      print('❌ RevenueCat: PurchasesError purchasing product: ${e.code} - ${e.message}');
      print('❌ RevenueCat: Error underlyingErrorMessage: ${e.underlyingErrorMessage}');
      if (e.code == PurchasesErrorCode.purchaseCancelledError) {
        print('🔴 RevenueCat: User cancelled purchase');
      } else if (e.code == PurchasesErrorCode.productNotAvailableForPurchaseError) {
        print('❌ RevenueCat: Product not available in store');
      } else if (e.code == PurchasesErrorCode.purchaseNotAllowedError) {
        print('❌ RevenueCat: Purchase not allowed');
      } else if (e.code == PurchasesErrorCode.storeProductNotAvailableError) {
        print('❌ RevenueCat: Store product not available');
      } else {
        print('❌ RevenueCat: Other error code: ${e.code}');
      }
      return false;
    } catch (e, stackTrace) {
      print('❌ RevenueCat: Error purchasing product: $e');
      print('❌ RevenueCat: Stack trace: $stackTrace');
      return false;
    }
  }

  /// Get available products
  static Future<List<StoreProduct>> getAvailableProducts() async {
    try {
      final offerings = await Purchases.getOfferings();
      if (offerings.current == null) return [];
      
      return offerings.current!.availablePackages
          .map((package) => package.storeProduct)
          .toList();
    } catch (e) {
      print('Error getting products: $e');
      return [];
    }
  }

  /// Restore purchases (for users who reinstalled the app)
  static Future<bool> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      return customerInfo.entitlements.active.containsKey(_entitlementId);
    } catch (e) {
      print('Error restoring purchases: $e');
      return false;
    }
  }

  /// Get product ID based on subscription type
  static String getProductId(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return _oneTimeProductId;
      case 1:
        return _monthlyProductId;
      case 2:
        return _yearlyProductId;
      default:
        return _monthlyProductId;
    }
  }
}
