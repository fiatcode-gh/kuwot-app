import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kuwot/core/presentation/theme/app_fonts.dart';
import 'package:kuwot/core/presentation/theme/app_palette.dart';
import 'package:kuwot/features/in_app_purchase/presentation/bloc/in_app_purchase_bloc.dart';

/// The Settings page's tip jar section: the donation message and the
/// purchasable product list, sourced from [InAppPurchaseBloc]. Dispatches
/// the same load event the old standalone tip-jar page dispatched, once,
/// when the section first mounts (i.e. when Settings opens).
class TipJarSection extends StatefulWidget {
  const TipJarSection({super.key});

  @override
  State<TipJarSection> createState() => _TipJarSectionState();
}

class _TipJarSectionState extends State<TipJarSection> {
  final _donationMessage =
      'I built this app with love and coffee. If you find it useful, please consider buying me a coffee. Your donation will help me keep the app running and updated. Thank you! ☕';

  final List<ProductDetails> _products = [];

  @override
  void initState() {
    super.initState();
    final bloc = context.read<InAppPurchaseBloc>();
    final currentState = bloc.state;
    if (currentState is ConsumableProductsLoadedState) {
      _products.addAll(currentState.products);
    }
    bloc.add(const GetConsumableProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return BlocListener<InAppPurchaseBloc, InAppPurchaseState>(
      listener: (context, state) {
        if (state is ConsumableProductsLoadedState) {
          setState(() {
            _products.clear();
            _products.addAll(state.products);
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tip jar', style: AppFonts.body(size: 16, color: palette.ink)),
          const SizedBox(height: 8),
          Text(
            _donationMessage,
            style: AppFonts.quoteBody(size: 18, color: palette.ink),
          ),
          const SizedBox(height: 16),
          ..._buildProductList(palette),
        ],
      ),
    );
  }

  List<Widget> _buildProductList(AppPalette palette) {
    return _products.map((product) {
      final title = product.title.replaceAll('(Kuwot)', '');
      final description = product.description.replaceAll(
        RegExp(r'[\r\n]+'),
        '',
      );
      final productCard = Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.read<InAppPurchaseBloc>().add(
            PurchaseConsumableProductEvent(product),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: AppFonts.body(
                    size: 16,
                    color: palette.ink,
                    weight: 600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppFonts.body(size: 14, color: palette.inkMuted),
                ),
                const SizedBox(height: 8),
                Text(
                  product.price,
                  style: AppFonts.label(size: 14, color: palette.ink),
                ),
              ],
            ),
          ),
        ),
      );

      return productCard;
    }).toList();
  }
}
