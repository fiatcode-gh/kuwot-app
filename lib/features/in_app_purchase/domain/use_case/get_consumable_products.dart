import 'package:fpdart/fpdart.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kuwot/core/domain/no_params.dart';
import 'package:kuwot/core/domain/use_case.dart';
import 'package:kuwot/core/error/failure.dart';
import 'package:kuwot/features/in_app_purchase/domain/repositories/in_app_purchase_repository.dart';

class GetConsumableProducts extends UseCase<List<ProductDetails>, NoParams> {
  final InAppPurchaseRepository repository;

  GetConsumableProducts(this.repository);

  @override
  Future<Either<Failure, List<ProductDetails>>> call(NoParams params) async {
    return repository.getConsumableProducts();
  }
}
