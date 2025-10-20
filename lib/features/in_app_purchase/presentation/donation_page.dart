import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Coffee time?')),
      body: BlocListener<InAppPurchaseBloc, InAppPurchaseState>(
        listener: (context, state) {
          if (state is ConsumableProductsLoadedState) {
            setState(() {
              _products.clear();
              _products.addAll(state.products);
            });
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
              child: Text(_donationMessage),
            ),
            ..._buildProductList(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildProductList() {
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
                Text(title, style: Theme.of(context).textTheme.bodyLarge),
                Text(description),
                const SizedBox(height: 8),
                Text(
                  product.price,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
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
