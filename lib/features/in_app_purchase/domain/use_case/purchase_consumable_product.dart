import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kuwot/core/domain/use_case.dart';
import 'package:kuwot/core/error/failure.dart';
import 'package:kuwot/features/in_app_purchase/domain/repositories/in_app_purchase_repository.dart';

class PurchaseConsumableProduct
    extends UseCase<bool, PurchaseConsumableProductParams> {
  final InAppPurchaseRepository repository;

  PurchaseConsumableProduct(this.repository);

  @override
  Future<Either<Failure, bool>> call(
    PurchaseConsumableProductParams params,
  ) async {
    return repository.purchaseConsumableProduct(params.productDetails);
  }
}

class PurchaseConsumableProductParams extends Equatable {
  final ProductDetails productDetails;

  const PurchaseConsumableProductParams({required this.productDetails});

  @override
  List<Object?> get props => [productDetails];
}
