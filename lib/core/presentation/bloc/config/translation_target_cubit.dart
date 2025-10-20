import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuwot/core/data/local/config.dart';
import 'package:kuwot/core/data/local/translation_target_config.dart';

class TranslationTargetCubit extends Cubit<TranslationTarget> {
  TranslationTargetCubit({
    required this.translationTargetConfig,
    required this.initialTranslationTarget,
  }) : super(initialTranslationTarget);

  final Config<TranslationTarget> translationTargetConfig;
  final TranslationTarget initialTranslationTarget;

  void set(TranslationTarget translationTarget) {
    translationTargetConfig.set(translationTarget);
    emit(translationTarget);
  }
}
