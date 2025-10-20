import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kuwot/features/in_app_purchase/domain/repositories/in_app_purchase_repository.dart';

/// Cubit that listens to purchase details stream from [InAppPurchaseRepository]
class PurchaseDetailsCubit extends Cubit<List<PurchaseDetails>> {
  /// Repository to get purchase details stream
  final InAppPurchaseRepository repository;

  /// Subscription to purchase details stream
  StreamSubscription<List<PurchaseDetails>>? _purchaseDetailsSubscription;

  PurchaseDetailsCubit(this.repository) : super([]) {
    // listen to purchase details stream and emit the event to the UI
    _purchaseDetailsSubscription = repository.purchaseStream.listen((event) {
      emit(event);

      // complete the purchases
      event
          .where((element) => element.status == PurchaseStatus.purchased)
          .forEach((element) {
            unawaited(repository.completePurchase(element));
          });
    });
  }

  @override
  Future<void> close() {
    _purchaseDetailsSubscription?.cancel();
    return super.close();
  }
}
