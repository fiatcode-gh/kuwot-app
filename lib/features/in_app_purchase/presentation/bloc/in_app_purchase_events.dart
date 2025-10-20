part of 'in_app_purchase_bloc.dart';

abstract class InAppPurchaseEvent extends Equatable {
  const InAppPurchaseEvent();
}

class GetConsumableProductsEvent extends InAppPurchaseEvent {
  const GetConsumableProductsEvent();

  @override
  List<Object> get props => [];
}

class PurchaseConsumableProductEvent extends InAppPurchaseEvent {
  final ProductDetails productDetails;

  const PurchaseConsumableProductEvent(this.productDetails);

  @override
  List<Object> get props => [productDetails];
}
