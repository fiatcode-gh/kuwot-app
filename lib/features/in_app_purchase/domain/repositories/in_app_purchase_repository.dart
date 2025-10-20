import 'package:fpdart/fpdart.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kuwot/core/error/failure.dart';

abstract class InAppPurchaseRepository {
  Stream<List<PurchaseDetails>> get purchaseStream;

  Future<Either<Failure, List<ProductDetails>>> getConsumableProducts();

  Future<Either<Failure, bool>> purchaseConsumableProduct(
    ProductDetails product,
  );

  Future<Either<Failure, void>> completePurchase(
    PurchaseDetails purchaseDetails,
  );
}
