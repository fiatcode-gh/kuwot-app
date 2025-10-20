import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kuwot/core/data/local/translation_target_config.dart';
import 'package:kuwot/core/presentation/bloc/config/translation_target_cubit.dart';
import 'package:kuwot/features/quote/presentation/bloc/translations_bloc.dart';

class TranslateTargetDialog extends StatefulWidget {
  const TranslateTargetDialog({super.key});

  @override
  State<TranslateTargetDialog> createState() => _TranslateTargetDialogState();
}

class _TranslateTargetDialogState extends State<TranslateTargetDialog> {
  @override
  void initState() {
    super.initState();

    // load translations
    context.read<TranslationsBloc>().add(const GetTranslationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final header = Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Quote Language', style: GoogleFonts.sriracha(fontSize: 24)),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop<TranslationTarget?>(null);
            },
            icon: const FaIcon(FontAwesomeIcons.xmark),
          ),
        ],
      ),
    );

    final currentTranslationTarget = context
        .read<TranslationTargetCubit>()
        .state;

    final languageList = SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: BlocBuilder<TranslationsBloc, TranslationsState>(
        builder: (context, state) {
          if (state is TranslationsLoadedState) {
            final translations = state.translations;

            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: translations.length,
              itemBuilder: (context, index) {
                final isSelected =
                    currentTranslationTarget.id == translations[index].id;
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  title: Text(
                    translations[index].language,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? const FaIcon(FontAwesomeIcons.check)
                      : null,
                  onTap: () {
                    final translationTarget = TranslationTarget(
                      id: translations[index].id,
                      name: translations[index].language,
                    );
                    context.read<TranslationTargetCubit>().set(
                      translationTarget,
                    );
                    Navigator.of(
                      context,
                    ).pop<TranslationTarget?>(translationTarget);
                  },
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );

    return Dialog(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [header, const Divider(height: 1), languageList],
      ),
    );
  }
}
