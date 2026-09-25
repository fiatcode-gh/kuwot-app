import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kuwot/core/presentation/theme/app_fonts.dart';
import 'package:kuwot/core/presentation/theme/app_palette.dart';
import 'package:kuwot/features/in_app_purchase/presentation/bloc/in_app_purchase_bloc.dart';

@RoutePage()
class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  final _donationMessage =
      'I built this app with love and coffee. If you find it useful, please consider buying me a coffee. Your donation will help me keep the app running and updated. Thank you! ☕';

  final List<ProductDetails> _products = [];

  @override
  void initState() {
    super.initState();

    // get consumable products
    context.read<InAppPurchaseBloc>().add(const GetConsumableProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Scaffold(
      backgroundColor: palette.desk,
      appBar: AppBar(title: const Text('Tip jar')),
      body: BlocListener<InAppPurchaseBloc, InAppPurchaseState>(
        listener: (context, state) {
          if (state is ConsumableProductsLoadedState) {
            setState(() {
              _products.clear();
              _products.addAll(state.products);
            });
          }
        },
        child: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                child: Text(
                  _donationMessage,
                  style: AppFonts.quoteBody(size: 18, color: palette.ink),
                ),
              ),
              ..._buildProductList(palette),
            ],
          ),
        ),
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
