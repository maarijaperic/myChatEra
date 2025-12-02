import 'package:purchases_flutter/purchases_flutter.dart';

/// Service for managing RevenueCat subscriptions
class RevenueCatService {
  static const String _oneTimeProductId = 'one_time_purchase';
  static const String _monthlyProductId = 'monthly_subscription';
  static const String _yearlyProductId = 'yearly_subscription';
  static const String _entitlementId = 'premium';

  /// Initialize RevenueCat
  static Future<void> initialize(String apiKey) async {
    await Purchases.setDebugLogsEnabled(true); // Set to false in production
    await Purchases.configure(
      PurchasesConfiguration(apiKey)
        ..appUserID = null, // RevenueCat will auto-generate
    );
  }

  /// Check if user has active premium subscription
  static Future<bool> isPremium() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.active.containsKey(_entitlementId);
    } catch (e) {
      print('Error checking premium status: $e');
      return false;
    }
  }

  /// Get subscription type (one_time, monthly, yearly, or null)
  static Future<String?> getSubscriptionType() async {
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
      print('Error getting subscription type: $e');
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
    try {
      final purchaseResult = await Purchases.purchaseProduct(productId);
      // In version 9.x, purchaseResult has customerInfo property
      return purchaseResult.customerInfo.entitlements.active.containsKey(_entitlementId);
    } catch (e) {
      print('Error purchasing product: $e');
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
