import 'package:flutter/material.dart';
import 'package:kuwot/core/presentation/theme/app_palette.dart';
import 'package:kuwot/features/quote/domain/entities/pad_page.dart';
import 'package:kuwot/features/quote/domain/entities/tear_kind.dart';
import 'package:kuwot/features/quote/presentation/widgets/page_face.dart';
import 'package:kuwot/features/quote/presentation/widgets/page_header.dart';
import 'package:kuwot/features/quote/presentation/widgets/perforation_line.dart';
import 'package:kuwot/features/quote/presentation/widgets/quote_strip.dart';
import 'package:kuwot/features/quote/presentation/widgets/tear_sheet.dart';

/// The pad's frame: binding bar, two faint stacked-page edges, and the
/// current page slot. The binding, current page and both edge sheets share
/// exactly the same left and right, and the page starts at the binding's
/// bottom — no overlap, no per-page inset, no rotation. One 6dp radius
/// ([PadFrame.cornerRadius]) rounds the binding's top corners, the page's
/// bottom corners and both edge sheets' bottom corners; every other corner
/// stays square, in particular where the page meets the binding (contract
/// G5, D6). The two under-sheets show only as a 4dp and an 8dp bottom edge
/// below the page.
class PadFrame extends StatelessWidget {
  const PadFrame({super.key, required this.page});

  final Widget page;

  static const bindingHeight = 34.0;
  static const edgeStep = 4.0;
  static const cornerRadius = 6.0;

  static const bindingKey = Key('pad.binding');
  static const pageKey = Key('pad.page');
  static const edgeKeys = [Key('pad.edge.1'), Key('pad.edge.2')];

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cornerRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            key: edgeKeys[1],
            left: 0,
            right: 0,
            top: bindingHeight,
            bottom: 0,
            child: _edgeSheet(palette.stackB, palette.divider),
          ),
          Positioned(
            key: edgeKeys[0],
            left: 0,
            right: 0,
            top: bindingHeight,
            bottom: edgeStep,
            child: _edgeSheet(palette.stackA, palette.divider),
          ),
          Positioned(
            key: pageKey,
            left: 0,
            right: 0,
            top: bindingHeight,
            bottom: edgeStep * 2,
            child: page,
          ),
          Positioned(
            key: bindingKey,
            left: 0,
            right: 0,
            top: 0,
            height: bindingHeight,
            child: _bindingBar(palette),
          ),
        ],
      ),
    );
  }

  Widget _edgeSheet(Color color, Color divider) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        border: Border(bottom: BorderSide(color: divider, width: 1)),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(cornerRadius),
          bottomRight: Radius.circular(cornerRadius),
        ),
      ),
    );
  }

  Widget _bindingBar(AppPalette palette) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(cornerRadius),
          topRight: Radius.circular(cornerRadius),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [palette.bindingHighlight, palette.binding],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(5, (_) => _staple(palette)),
      ),
    );
  }

  Widget _staple(AppPalette palette) {
    return Container(
      width: 16,
      height: 6,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [palette.staple, palette.stapleShadow],
        ),
      ),
    );
  }
}

/// The pad: a binding bar, a hint of the pages stacked underneath, and the
/// current page — which tears away, quote-only or whole-page, to reveal
/// [under] (contract G4: the next content is always drawn, never a blank
/// placeholder).
class CalendarPad extends StatefulWidget {
  const CalendarPad({
    super.key,
    required this.top,
    required this.under,
    required this.tearKind,
    required this.revision,
    required this.onTornAway,
    required this.locale,
  });

  final PadPage top;
  final PadPage under;
  final TearKind tearKind;

  /// Tags each commit; a new [revision] replaces the tear sheet with a
  /// fresh one at rest, so the next content is never shown mid-tear.
  final int revision;

  final VoidCallback onTornAway;
  final Locale locale;

  @override
  State<CalendarPad> createState() => CalendarPadState();
}

class CalendarPadState extends State<CalendarPad> {
  var _sheetKey = GlobalKey<TearSheetState>();

  @override
  void didUpdateWidget(covariant CalendarPad oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.revision != widget.revision) {
      _sheetKey = GlobalKey<TearSheetState>();
    }
  }

  /// Runs the same tear-away animation as a completed drag, for the
  /// on-screen control.
  Future<void> tearAway() async {
    await _sheetKey.currentState?.tearAway();
  }

  @override
  Widget build(BuildContext context) {
    final labels = padDateLabels(widget.locale, widget.top.day);
    return Semantics(
      container: true,
      label:
          '${labels.weekday} ${labels.month} ${widget.top.day.day}. '
          '${widget.top.quote.body} — ${widget.top.quote.author}',
      child: ExcludeSemantics(
        child: PadFrame(
          page: widget.tearKind == TearKind.page
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    RepaintBoundary(
                      child: PageFace(
                        page: widget.under,
                        locale: widget.locale,
                      ),
                    ),
                    TearSheet(
                      key: _sheetKey,
                      teethSeed: widget.revision,
                      onTornAway: widget.onTornAway,
                      child: PageFace(page: widget.top, locale: widget.locale),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Expanded(
                      flex: kHeaderFlex,
                      child: PageHeader(
                        day: widget.top.day,
                        style: widget.top.header,
                        locale: widget.locale,
                      ),
                    ),
                    const PerforationLine(),
                    Expanded(
                      flex: kQuoteFlex,
                      child: ClipRect(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            RepaintBoundary(
                              child: QuoteStrip(quote: widget.under.quote),
                            ),
                            TearSheet(
                              key: _sheetKey,
                              teethSeed: widget.revision,
                              onTornAway: widget.onTornAway,
                              child: QuoteStrip(quote: widget.top.quote),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
