import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kuwot/features/quote/domain/entities/pad_page.dart';
import 'package:kuwot/features/quote/presentation/widgets/page_face.dart';
import 'package:screenshot/screenshot.dart';

/// Renders [page] off-screen at [SharePageCard.logicalSize] /
/// [SharePageCard.pixelRatio], producing the PNG bytes shared to other apps
/// (contract G10). Passing [context] lets `captureFromWidget` inherit the
/// on-screen `Theme` (the `AppPalette` extension) and `MediaQuery`; the
/// card itself disables text scaling regardless of the inherited value.
/// [locale] must be resolved by the caller from a real `View` ancestor
/// (`View.of(context).platformDispatcher.locale` in `QuotePage`): the
/// off-screen capture tree built by `captureFromWidget` has no `View`
/// ancestor of its own (contract G11 threading — see `page_header.dart`).
Future<Uint8List> renderSharePage(
  BuildContext context,
  PadPage page, {
  required Locale locale,
  ScreenshotController? controller,
}) {
  return (controller ?? ScreenshotController()).captureFromWidget(
    SharePageCard(page: page, locale: locale),
    context: context,
    targetSize: SharePageCard.logicalSize,
    pixelRatio: SharePageCard.pixelRatio,
    delay: const Duration(milliseconds: 100),
  );
}

/// The share image: the same [PageFace] as the on-screen pad, but at a fixed
/// logical size and with text scaling disabled (contract G10). Rendering it
/// off-screen at a fixed size, independent of window size or the device's
/// text scale setting, means the share image is never cut off by whatever
/// happened to be visible on screen.
class SharePageCard extends StatelessWidget {
  const SharePageCard({super.key, required this.page, required this.locale});

  final PadPage page;
  final Locale locale;

  static const logicalSize = Size(360, 640);
  static const pixelRatio = 3.0;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withNoTextScaling(
      child: SizedBox.fromSize(
        size: logicalSize,
        child: PageFace(page: page, locale: locale),
      ),
    );
  }
}
