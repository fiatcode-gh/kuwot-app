import 'package:in_app_purchase/in_app_purchase.dart';

const _consumableProductIds = <String>{
  'donate_consumable_low',
  'donate_consumable_mid',
  'donate_consumable_high',
};

abstract class InAppPurchaseRemoteDataSource {
  Stream<List<PurchaseDetails>> get purchaseStream;

  Future<List<ProductDetails>> getConsumableProducts();

  Future<bool> purchaseConsumableProduct(ProductDetails product);

  Future<void> completePurchase(PurchaseDetails purchaseDetails);
}

class InAppPurchaseRemoteDataSourceImpl
    implements InAppPurchaseRemoteDataSource {
  InAppPurchaseRemoteDataSourceImpl({required this.iap});

  final InAppPurchase iap;

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => iap.purchaseStream;

  @override
  Future<List<ProductDetails>> getConsumableProducts() async {
    final response = await iap.queryProductDetails(_consumableProductIds);
    final productDetails = response.productDetails;
    productDetails.sort((a, b) => a.price.compareTo(b.price));
    return productDetails;
  }

  @override
  Future<bool> purchaseConsumableProduct(ProductDetails product) async {
    final response = await iap.buyConsumable(
      purchaseParam: PurchaseParam(productDetails: product),
    );
    return response;
  }

  @override
  Future<void> completePurchase(PurchaseDetails purchaseDetails) {
    return iap.completePurchase(purchaseDetails);
  }
}
