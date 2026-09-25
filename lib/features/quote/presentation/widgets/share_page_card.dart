import 'package:flutter/material.dart';
import 'package:kuwot/features/quote/domain/entities/pad_page.dart';
import 'package:kuwot/features/quote/presentation/widgets/page_face.dart';

/// The share image: the same [PageFace] as the on-screen pad, but at a fixed
/// logical size and with text scaling disabled (contract G10). Rendering it
/// off-screen at a fixed size, independent of window size or the device's
/// text scale setting, means the share image is never cut off by whatever
/// happened to be visible on screen.
///
/// The capture step (`ScreenshotController.captureFromWidget`) is added in a
/// later task; this widget only defines what gets captured.
class SharePageCard extends StatelessWidget {
  const SharePageCard({super.key, required this.page});

  final PadPage page;

  static const logicalSize = Size(360, 640);
  static const pixelRatio = 3.0;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withNoTextScaling(
      child: SizedBox.fromSize(
        size: logicalSize,
        child: PageFace(page: page),
      ),
    );
  }
}
