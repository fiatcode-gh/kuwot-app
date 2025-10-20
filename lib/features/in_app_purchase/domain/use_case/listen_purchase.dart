import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kuwot/core/domain/no_params.dart';
import 'package:kuwot/core/domain/use_case.dart';
import 'package:kuwot/core/error/failure.dart';
import 'package:kuwot/features/in_app_purchase/domain/repositories/in_app_purchase_repository.dart';

class ListenPurchase
    implements UseCase<Stream<List<PurchaseDetails>>, NoParams> {
  ListenPurchase(this.repository);

  final InAppPurchaseRepository repository;

  @override
  Future<Either<Failure, Stream<List<PurchaseDetails>>>> call(NoParams params) {
    // it always return right because I dont think it will throw an error
    return Future.value(right(repository.purchaseStream));
  }
}
