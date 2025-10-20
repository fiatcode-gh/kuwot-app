part of 'in_app_purchase_bloc.dart';

abstract class InAppPurchaseState extends Equatable {
  const InAppPurchaseState();
}

class InAppPurchaseInitialState extends InAppPurchaseState {
  const InAppPurchaseInitialState();

  @override
  List<Object> get props => [];
}

class GettingConsumableProductsState extends InAppPurchaseState {
  const GettingConsumableProductsState();

  @override
  List<Object> get props => [];
}

class ConsumableProductsLoadedState extends InAppPurchaseState {
  final List<ProductDetails> products;

  const ConsumableProductsLoadedState(this.products);

  @override
  List<Object> get props => [products];
}

class PurchasingConsumableProductState extends InAppPurchaseState {
  final ProductDetails productDetails;

  const PurchasingConsumableProductState(this.productDetails);

  @override
  List<Object> get props => [productDetails];
}

class ConsumableProductPurchasedState extends InAppPurchaseState {
  const ConsumableProductPurchasedState({required this.result});

  final bool result;

  @override
  List<Object> get props => [result];
}

class PurchaseErrorState extends InAppPurchaseState implements ErrorState {
  @override
  final String message;

  @override
  final Exception? cause;

  const PurchaseErrorState({required this.message, this.cause});

  @override
  List<Object?> get props => [message, cause];
}
