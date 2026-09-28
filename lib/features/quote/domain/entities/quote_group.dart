/// A named theme the bundled quote set is organised into. Declaration order
/// matches the source/contract order. Each value carries the stable [id]
/// used by the bundled asset and saved settings, and the [label] shown in
/// Settings.
enum QuoteGroup {
  perspective('perspective', 'Perspective'),
  keepGoing('keep_going', 'Keep going'),
  heavyDays('heavy_days', 'Heavy days'),
  doTheWork('do_the_work', 'Do the work'),
  beginAgain('begin_again', 'Begin again'),
  breathe('breathe', 'Breathe'),
  grow('grow', 'Grow'),
  courage('courage', 'Courage'),
  smallJoys('small_joys', 'Small joys'),
  people('people', 'People'),
  believeInYourself('believe_in_yourself', 'Believe in yourself'),
  rest('rest', 'Rest');

  const QuoteGroup(this.id, this.label);

  /// Stable id used by the bundled asset and saved settings.
  final String id;

  /// Settings label.
  final String label;

  /// The group with [id], or null when no group has it.
  static QuoteGroup? tryParse(String id) {
    for (final group in values) {
      if (group.id == id) return group;
    }
    return null;
  }
}
