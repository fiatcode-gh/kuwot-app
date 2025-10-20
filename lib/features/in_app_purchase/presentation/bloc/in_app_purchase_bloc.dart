import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kuwot/core/domain/no_params.dart';
import 'package:kuwot/core/presentation/bloc/error_state.dart';
import 'package:kuwot/features/in_app_purchase/domain/use_case/get_consumable_products.dart';
import 'package:kuwot/features/in_app_purchase/domain/use_case/purchase_consumable_product.dart';

part 'in_app_purchase_events.dart';
part 'in_app_purchase_states.dart';

class InAppPurchaseBloc extends Bloc<InAppPurchaseEvent, InAppPurchaseState> {
  InAppPurchaseBloc({
    required this.getConsumableProducts,
    required this.purchaseConsumableProduct,
  }) : super(const InAppPurchaseInitialState()) {
    on<GetConsumableProductsEvent>(_getConsumableProducts);
    on<PurchaseConsumableProductEvent>(_purchaseConsumableProduct);
  }

  final GetConsumableProducts getConsumableProducts;
  final PurchaseConsumableProduct purchaseConsumableProduct;

  Future<void> _getConsumableProducts(
    GetConsumableProductsEvent event,
    Emitter<InAppPurchaseState> emit,
  ) async {
    emit(const GettingConsumableProductsState());
    final result = await getConsumableProducts(const NoParams());
    result.fold(
      (failure) {
        emit(PurchaseErrorState(message: failure.message));
      },
      (products) {
        emit(ConsumableProductsLoadedState(products));
      },
    );
  }

  Future<void> _purchaseConsumableProduct(
    PurchaseConsumableProductEvent event,
    Emitter<InAppPurchaseState> emit,
  ) async {
    emit(PurchasingConsumableProductState(event.productDetails));
    final result = await purchaseConsumableProduct(
      PurchaseConsumableProductParams(productDetails: event.productDetails),
    );
    result.fold(
      (failure) {
        emit(PurchaseErrorState(message: failure.message));
      },
      (success) {
        emit(ConsumableProductPurchasedState(result: success));
      },
    );
  }
}
