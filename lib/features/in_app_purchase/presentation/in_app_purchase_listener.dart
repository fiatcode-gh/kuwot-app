import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kuwot/features/in_app_purchase/presentation/bloc/purchase_details_cubit.dart';
import 'package:kuwot/utilities.dart';

class InAppPurchaseListener extends StatelessWidget {
  const InAppPurchaseListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<PurchaseDetailsCubit, List<PurchaseDetails>>(
      listener: (context, state) {
        if (state.last.status == PurchaseStatus.purchased) {
          showSnackbar('Coffee received, thank you! ☕');
        }

        if (state.last.status == PurchaseStatus.pending) {
          showSnackbar('Coffee is on the way! ☕');
        }

        if (state.last.status == PurchaseStatus.error) {
          showSnackbar('Something went wrong, failed to send coffee 😢');
        }
      },
      child: child,
    );
  }
}
