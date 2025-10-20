import 'package:fpdart/fpdart.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kuwot/core/error/failure.dart';
import 'package:kuwot/features/in_app_purchase/data/data_sources/remote/in_app_purchase_remote_data_source.dart';
import 'package:kuwot/features/in_app_purchase/domain/repositories/in_app_purchase_repository.dart';

class InAppPurchaseRepositoryImpl implements InAppPurchaseRepository {
  InAppPurchaseRepositoryImpl({required this.inAppPurchaseDataSource});

  final InAppPurchaseRemoteDataSource inAppPurchaseDataSource;

  @override
  Stream<List<PurchaseDetails>> get purchaseStream =>
      inAppPurchaseDataSource.purchaseStream;

  @override
  Future<Either<Failure, List<ProductDetails>>> getConsumableProducts() async {
    try {
      final response = await inAppPurchaseDataSource.getConsumableProducts();
      return right(response);
    } catch (e) {
      return left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> purchaseConsumableProduct(
    ProductDetails product,
  ) async {
    try {
      final response = await inAppPurchaseDataSource.purchaseConsumableProduct(
        product,
      );
      return right(response);
    } catch (e) {
      return left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> completePurchase(
    PurchaseDetails purchaseDetails,
  ) async {
    try {
      await inAppPurchaseDataSource.completePurchase(purchaseDetails);
      return right(null);
    } on Exception catch (e) {
      return left(UnknownFailure(message: e.toString()));
    }
  }
}
