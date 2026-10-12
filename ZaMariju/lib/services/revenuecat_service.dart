import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter/foundation.dart';

/// Service for managing RevenueCat subscriptions
class RevenueCatService {
  static const String _oneTimeProductId = 'one_time_purchase_v2';
  static const String _analysisPackProductId = 'analysis_pack_3';
  // Monthly/yearly are no longer sold, but existing subscribers keep access
  static const String _monthlyProductId = 'monthly_subscription_v2';
  static const String _yearlyProductId = 'yearly_subscription_v2';
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
    await Purchases.setDebugLogsEnabled(kDebugMode); // Only enable in debug mode, not in production
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
      // Refresh customer info to get latest subscription status
      final customerInfo = await Purchases.getCustomerInfo();
      final activeEntitlements = customerInfo.entitlements.active;
      
      print('🔴 RevenueCat: Active entitlements: ${activeEntitlements.keys.toList()}');
      
      if (activeEntitlements.isEmpty) {
        print('⚠️ RevenueCat: No active entitlements found');
        return null;
      }
      
      // Get the product identifier from the active entitlement
      final entitlement = activeEntitlements[_entitlementId];
      if (entitlement == null) {
        print('⚠️ RevenueCat: No premium entitlement found');
        return null;
      }
      
      final productId = entitlement.productIdentifier;
      print('🔴 RevenueCat: Entitlement product ID: $productId');
      
      // Check all active entitlements to find the highest priority subscription
      // Priority: yearly > monthly > one_time
      String? foundType;
      for (final ent in activeEntitlements.values) {
        final pid = ent.productIdentifier;
        if (pid == _yearlyProductId) {
          foundType = 'yearly';
          break; // Yearly has highest priority
        } else if (pid == _monthlyProductId && foundType != 'yearly') {
          foundType = 'monthly';
        } else if (_isCreditProduct(pid) && foundType == null) {
          foundType = 'one_time';
        }
      }
      
      if (foundType != null) {
        print('🔴 RevenueCat: Determined subscription type: $foundType');
        return foundType;
      }
      
      // Fallback to original logic
      if (_isCreditProduct(productId)) return 'one_time';
      if (productId == _monthlyProductId) return 'monthly';
      if (productId == _yearlyProductId) return 'yearly';
      
      print('⚠️ RevenueCat: Unknown product ID: $productId');
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
      print('🔴 RevenueCat: ========== PURCHASE START ==========');
      print('🔴 RevenueCat: Timestamp: ${DateTime.now().toIso8601String()}');
      print('🔴 RevenueCat: Attempting to purchase product: $productId');
      print('🔴 RevenueCat: Product ID type: ${productId.runtimeType}');
      print('🔴 RevenueCat: Product ID length: ${productId.length}');
      
      // Important note for physical device vs simulator
      print('🔴 RevenueCat: ⚠️ IMPORTANT:');
      print('   - Simulator uses Products.storekit (local file)');
      print('   - Physical device uses App Store Connect Sandbox');
      print('   - If testing on PHYSICAL DEVICE:');
      print('     1. Settings → App Store → Sign Out (OBVEZNO!)');
      print('     2. App Store Connect → Sandbox Testers → Create test account');
      print('     3. When purchase dialog appears, sign in with Sandbox Test Account');
      
      // Check RevenueCat configuration
      print('🔴 RevenueCat: Configuration check:');
      print('   - Is configured: $_isConfigured');
      print('   - Entitlement ID: $_entitlementId');
      
      // Check current customer info
      try {
        print('🔴 RevenueCat: Fetching customer info...');
        final customerInfo = await Purchases.getCustomerInfo();
        print('🔴 RevenueCat: ✅ Customer info received');
        print('🔴 RevenueCat: Current user ID: ${customerInfo.originalAppUserId}');
        print('🔴 RevenueCat: User ID type: ${customerInfo.originalAppUserId.runtimeType}');
        print('🔴 RevenueCat: User ID length: ${customerInfo.originalAppUserId.length}');
        print('🔴 RevenueCat: Active entitlements: ${customerInfo.entitlements.active.keys.toList()}');
        print('🔴 RevenueCat: All entitlements: ${customerInfo.entitlements.all.keys.toList()}');
        print('🔴 RevenueCat: Has premium: ${customerInfo.entitlements.active.containsKey(_entitlementId)}');
        
        // Check each entitlement
        for (final entry in customerInfo.entitlements.all.entries) {
          print('🔴 RevenueCat: Entitlement "${entry.key}":');
          print('   - Is active: ${entry.value.isActive}');
          print('   - Product ID: ${entry.value.productIdentifier}');
          print('   - Will renew: ${entry.value.willRenew}');
          print('   - Period type: ${entry.value.periodType}');
        }
      } catch (e, stackTrace) {
        print('⚠️ RevenueCat: Could not get customer info: $e');
        print('⚠️ RevenueCat: Stack trace: $stackTrace');
      }
      
      // First, try to get the product from offerings
      print('🔴 RevenueCat: ========== FETCHING OFFERINGS ==========');
      print('🔴 RevenueCat: Timestamp: ${DateTime.now().toIso8601String()}');
      print('🔴 RevenueCat: Fetching offerings...');
      
      final offeringsStartTime = DateTime.now();
      final offerings = await Purchases.getOfferings();
      final offeringsEndTime = DateTime.now();
      final offeringsDuration = offeringsEndTime.difference(offeringsStartTime);
      
      print('🔴 RevenueCat: ✅ Offerings fetched in ${offeringsDuration.inMilliseconds}ms');
      print('🔴 RevenueCat: All offerings: ${offerings.all.keys.toList()}');
      print('🔴 RevenueCat: Offerings count: ${offerings.all.length}');
      
      if (offerings.current == null) {
        print('❌ RevenueCat: ❌ NO CURRENT OFFERING FOUND');
        print('🔴 RevenueCat: Available offerings: ${offerings.all.keys.toList()}');
        print('❌ RevenueCat: This means:');
        print('   1. No Current Offering configured in RevenueCat Dashboard');
        print('   2. Go to RevenueCat Dashboard → Offerings → Set Current Offering');
        print('   3. Make sure products are synced (RevenueCat Dashboard → Products)');
        print('   4. Make sure products are "Ready to Submit" in App Store Connect');
        return false;
      }
      
      print('🔴 RevenueCat: ========== CURRENT OFFERING ==========');
      print('✅ RevenueCat: Found current offering: ${offerings.current!.identifier}');
      print('🔴 RevenueCat: Available packages: ${offerings.current!.availablePackages.map((p) => p.identifier).toList()}');
      print('🔴 RevenueCat: Packages count: ${offerings.current!.availablePackages.length}');
      print('🔴 RevenueCat: Package products: ${offerings.current!.availablePackages.map((p) => p.storeProduct.identifier).toList()}');
      
      // Check if products are available for purchase
      print('🔴 RevenueCat: ========== PRODUCT DETAILS ==========');
      for (final package in offerings.current!.availablePackages) {
        final product = package.storeProduct;
        print('🔴 RevenueCat: Package: ${package.identifier}');
        print('   - Product ID: ${product.identifier}');
        print('   - Price: ${product.price}');
        print('   - Currency: ${product.currencyCode}');
        print('   - Title: ${product.title}');
        print('   - Description: ${product.description}');
        print('   - Subscription period: ${product.subscriptionPeriod}');
        print('   - Introductory price: ${product.introductoryPrice}');
      }
      
      // Find the package with the matching product
      print('🔴 RevenueCat: ========== SEARCHING FOR PRODUCT ==========');
      print('🔴 RevenueCat: Looking for product ID: "$productId"');
      print('🔴 RevenueCat: Product ID bytes: ${productId.codeUnits}');
      
      Package? targetPackage;
      for (final package in offerings.current!.availablePackages) {
        final packageProductId = package.storeProduct.identifier;
        print('🔴 RevenueCat: Checking package "${package.identifier}"');
        print('   - Package product ID: "$packageProductId"');
        print('   - Match: ${packageProductId == productId}');
        print('   - Case sensitive: ${packageProductId == productId}');
        print('   - Length match: ${packageProductId.length == productId.length}');
        
        if (packageProductId == productId) {
          targetPackage = package;
          print('✅ RevenueCat: ✅✅✅ FOUND MATCHING PACKAGE ✅✅✅');
          print('✅ RevenueCat: Package identifier: ${package.identifier}');
          print('✅ RevenueCat: Product ID: ${package.storeProduct.identifier}');
          break;
        }
      }
      
      if (targetPackage == null) {
        print('❌ RevenueCat: ❌ PRODUCT NOT FOUND IN OFFERINGS');
        print('🔴 RevenueCat: Looking for product: $productId');
        print('🔴 RevenueCat: Available products: ${offerings.current!.availablePackages.map((p) => p.storeProduct.identifier).toList()}');
        print('❌ RevenueCat: This means:');
        print('   1. Product $productId is not in Current Offering packages');
        print('   2. Go to RevenueCat Dashboard → Offerings → Current Offering → Add Package');
        print('   3. Make sure product is synced (RevenueCat Dashboard → Products)');
        print('   4. Make sure product ID matches exactly: $productId');
        
        // Fallback: try direct purchase
        print('🔴 RevenueCat: Attempting direct purchase as fallback...');
        print('⚠️ RevenueCat: This might not work if product is not properly configured');
        try {
          final purchaseResult = await Purchases.purchaseProduct(productId);
          print('✅ RevenueCat: Direct purchase result received');
          final hasEntitlement = purchaseResult.customerInfo.entitlements.active.containsKey(_entitlementId);
          print('🔴 RevenueCat: Has premium entitlement: $hasEntitlement');
          if (!hasEntitlement) {
            print('⚠️ RevenueCat: Purchase succeeded but no entitlement found');
            print('⚠️ RevenueCat: Check RevenueCat Dashboard → Entitlements → Verify "premium" entitlement is attached to product');
          }
          return hasEntitlement;
        } catch (directError) {
          print('❌ RevenueCat: Direct purchase failed: $directError');
          rethrow;
        }
      }
      
      // Purchase using package
      print('🔴 RevenueCat: ========== PURCHASING PACKAGE ==========');
      print('🔴 RevenueCat: Timestamp: ${DateTime.now().toIso8601String()}');
      print('🔴 RevenueCat: Purchasing package: ${targetPackage.identifier}');
      print('🔴 RevenueCat: Package product ID: ${targetPackage.storeProduct.identifier}');
      print('🔴 RevenueCat: Package price: ${targetPackage.storeProduct.price}');
      print('🔴 RevenueCat: Package currency: ${targetPackage.storeProduct.currencyCode}');
      print('🔴 RevenueCat: Package title: ${targetPackage.storeProduct.title}');
      
      try {
        print('🔴 RevenueCat: Calling Purchases.purchasePackage()...');
        final purchaseStartTime = DateTime.now();
        final purchaseResult = await Purchases.purchasePackage(targetPackage);
        final purchaseEndTime = DateTime.now();
        final purchaseDuration = purchaseEndTime.difference(purchaseStartTime);
        
        print('🔴 RevenueCat: ========== PURCHASE RESULT ==========');
        print('✅ RevenueCat: Purchase completed in ${purchaseDuration.inMilliseconds}ms');
        print('✅ RevenueCat: Purchase result received');
        print('🔴 RevenueCat: Customer info user ID: ${purchaseResult.customerInfo.originalAppUserId}');
        print('🔴 RevenueCat: Active entitlements: ${purchaseResult.customerInfo.entitlements.active.keys.toList()}');
        
        // Refresh customer info to ensure latest entitlement status
        print('🔴 RevenueCat: Refreshing customer info...');
        final refreshedCustomerInfo = await Purchases.getCustomerInfo();
        print('🔴 RevenueCat: Refreshed customer info received');
        
        final hasEntitlement = refreshedCustomerInfo.entitlements.active.containsKey(_entitlementId);
        print('🔴 RevenueCat: Has premium entitlement: $hasEntitlement');
        print('🔴 RevenueCat: Active entitlements: ${refreshedCustomerInfo.entitlements.active.keys.toList()}');
        
        if (hasEntitlement) {
          final entitlement = refreshedCustomerInfo.entitlements.active[_entitlementId];
          print('🔴 RevenueCat: Entitlement product ID: ${entitlement?.productIdentifier}');
          print('🔴 RevenueCat: Entitlement is active: ${entitlement?.isActive}');
        }
        
        if (!hasEntitlement) {
          print('⚠️ RevenueCat: Purchase successful but no premium entitlement found');
          print('🔴 RevenueCat: All entitlements: ${refreshedCustomerInfo.entitlements.all.keys.toList()}');
        }
        
        return hasEntitlement;
      } on PurchasesError catch (packageError) {
        // Check if it's a network error that might be retryable
        if (packageError.code == PurchasesErrorCode.networkError || 
            packageError.readableErrorCode == 'NETWORK_ERROR') {
          print('⚠️ RevenueCat: Network error during package purchase, retrying once...');
          print('⚠️ RevenueCat: Error details: ${packageError.message}');
          
          // Wait a bit before retry
          await Future.delayed(const Duration(seconds: 2));
          
          try {
            print('🔴 RevenueCat: Retrying package purchase...');
            final purchaseResult = await Purchases.purchasePackage(targetPackage);
            print('✅ RevenueCat: Retry purchase result received');
            final hasEntitlement = purchaseResult.customerInfo.entitlements.active.containsKey(_entitlementId);
            return hasEntitlement;
          } catch (retryError) {
            print('❌ RevenueCat: Retry also failed: $retryError');
            // Fall through to direct product purchase
          }
        }
        
        // If package purchase fails, try direct product purchase (for StoreKit Configuration File)
        print('⚠️ RevenueCat: Package purchase failed, trying direct product purchase: $packageError');
        print('🔴 RevenueCat: Attempting direct purchase with productId: $productId');
        
        try {
          final purchaseResult = await Purchases.purchaseProduct(productId);
          print('✅ RevenueCat: Direct purchase result received');
          final hasEntitlement = purchaseResult.customerInfo.entitlements.active.containsKey(_entitlementId);
          print('🔴 RevenueCat: Has premium entitlement: $hasEntitlement');
          return hasEntitlement;
        } on PurchasesError catch (directError) {
          // If direct purchase also fails with network error, retry once
          if (directError.code == PurchasesErrorCode.networkError || 
              directError.readableErrorCode == 'NETWORK_ERROR') {
            print('⚠️ RevenueCat: Network error during direct purchase, retrying once...');
            await Future.delayed(const Duration(seconds: 2));
            
            try {
              print('🔴 RevenueCat: Retrying direct purchase...');
              final purchaseResult = await Purchases.purchaseProduct(productId);
              final hasEntitlement = purchaseResult.customerInfo.entitlements.active.containsKey(_entitlementId);
              return hasEntitlement;
            } catch (retryError) {
              print('❌ RevenueCat: Direct purchase retry also failed: $retryError');
              rethrow;
            }
          }
          rethrow;
        }
      } catch (packageError) {
        // Generic catch for non-PurchasesError exceptions
        print('⚠️ RevenueCat: Package purchase failed with non-PurchasesError: $packageError');
        
        // Check if it's a network error that might be retryable
        final errorString = packageError.toString().toLowerCase();
        final isNetworkError = errorString.contains('network') || 
                               errorString.contains('connection') ||
                               errorString.contains('parse response') ||
                               errorString.contains('-1017') ||
                               errorString.contains('-1005');
        
        if (isNetworkError) {
          print('⚠️ RevenueCat: Network error detected, retrying after delay...');
          await Future.delayed(const Duration(seconds: 3));
          
          try {
            print('🔴 RevenueCat: Retrying package purchase after network error...');
            final purchaseResult = await Purchases.purchasePackage(targetPackage);
            print('✅ RevenueCat: Retry purchase result received');
            final hasEntitlement = purchaseResult.customerInfo.entitlements.active.containsKey(_entitlementId);
            return hasEntitlement;
          } catch (retryError) {
            print('❌ RevenueCat: Retry also failed: $retryError');
            // Fall through to direct purchase
          }
        }
        
        print('🔴 RevenueCat: Attempting direct purchase with productId: $productId');
        try {
          final purchaseResult = await Purchases.purchaseProduct(productId);
          print('✅ RevenueCat: Direct purchase result received');
          final hasEntitlement = purchaseResult.customerInfo.entitlements.active.containsKey(_entitlementId);
          return hasEntitlement;
        } catch (e) {
          print('❌ RevenueCat: Direct purchase also failed: $e');
          
          // If direct purchase also fails with network error, retry once
          final errorString2 = e.toString().toLowerCase();
          final isNetworkError2 = errorString2.contains('network') || 
                                  errorString2.contains('connection') ||
                                  errorString2.contains('parse response') ||
                                  errorString2.contains('-1017') ||
                                  errorString2.contains('-1005');
          
          if (isNetworkError2) {
            print('⚠️ RevenueCat: Direct purchase network error, retrying once more...');
            await Future.delayed(const Duration(seconds: 3));
            
            try {
              print('🔴 RevenueCat: Final retry for direct purchase...');
              final purchaseResult = await Purchases.purchaseProduct(productId);
              final hasEntitlement = purchaseResult.customerInfo.entitlements.active.containsKey(_entitlementId);
              return hasEntitlement;
            } catch (finalError) {
              print('❌ RevenueCat: Final retry also failed: $finalError');
              rethrow;
            }
          }
          
          rethrow;
        }
      }
    } on PurchasesError catch (e) {
      print('❌ RevenueCat: PurchasesError purchasing product: ${e.code} - ${e.message}');
      print('❌ RevenueCat: Error underlyingErrorMessage: ${e.underlyingErrorMessage}');
      print('❌ RevenueCat: Error readableErrorCode: ${e.readableErrorCode}');
      print('❌ RevenueCat: Full error details: ${e.toString()}');
      
      if (e.code == PurchasesErrorCode.purchaseCancelledError) {
        print('🔴 RevenueCat: User cancelled purchase');
      } else if (e.code == PurchasesErrorCode.productNotAvailableForPurchaseError) {
        print('❌ RevenueCat: Product not available in store');
        print('❌ RevenueCat: This usually means:');
        print('   1. Product is not created in App Store Connect');
        print('   2. Product is not "Ready to Submit" in App Store Connect');
        print('   3. Product is not synced with RevenueCat');
        print('   4. You are not signed in with Sandbox Test Account on physical device');
      } else if (e.code == PurchasesErrorCode.purchaseNotAllowedError) {
        print('❌ RevenueCat: Purchase not allowed');
        print('❌ RevenueCat: This usually means:');
        print('   1. Parental controls are enabled');
        print('   2. In-app purchases are disabled in device settings');
        print('   3. You are not signed in with Sandbox Test Account');
      } else if (e.code == PurchasesErrorCode.configurationError) {
        print('❌ RevenueCat: Configuration error - products not found in App Store Connect');
        print('❌ RevenueCat: Check RevenueCat Dashboard → Products → Verify all products are synced');
        print('❌ RevenueCat: Check App Store Connect → In-App Purchases → Verify products are "Ready to Submit"');
      } else if (e.code == PurchasesErrorCode.networkError || e.readableErrorCode == 'NETWORK_ERROR') {
        print('❌ RevenueCat: Network error occurred');
        print('❌ RevenueCat: Error code: ${e.code}, readable: ${e.readableErrorCode}');
        print('❌ RevenueCat: Underlying error: ${e.underlyingErrorMessage}');
        print('❌ RevenueCat: This might be due to:');
        print('   - StoreKit Configuration File (Products.storekit) not properly configured in Xcode Scheme');
        print('   - App Store Connect products not properly synced with RevenueCat');
        print('   - Network connectivity issues (code -1005 or -1017)');
        print('   - RevenueCat API temporarily unavailable');
        print('❌ RevenueCat: Try checking:');
        print('   1. Xcode → Product → Scheme → Edit Scheme → Run → StoreKit Configuration → Select Products.storekit');
        print('   2. RevenueCat Dashboard → Products → Verify products are synced');
        print('   3. App Store Connect → In-App Purchases → Verify products are "Ready to Submit"');
        print('   4. Check internet connection and try again');
        print('   5. Restart the app and try again');
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

  /// Get product ID for the paywall option (0 = single analysis, 1 = 3-analysis pack)
  static String getProductId(int selectedIndex) {
    return selectedIndex == 1 ? _analysisPackProductId : _oneTimeProductId;
  }

  /// Number of analyses a purchase of [productId] adds to the user's balance
  static int analysesForProduct(String productId) {
    if (productId == _analysisPackProductId) return 3;
    if (productId == _oneTimeProductId) return 1;
    return 0;
  }

  static bool _isCreditProduct(String productId) =>
      productId == _oneTimeProductId || productId == _analysisPackProductId;
}
