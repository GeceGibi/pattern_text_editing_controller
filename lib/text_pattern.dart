part of 'pattern_text_editing_controller.dart';

class TextPattern {
  const TextPattern({
    required this.pattern,
    this.builder,
    this.style,
  });

  final RegExp pattern;
  final TextStyle? style;
  final InlineSpan Function(Match match, TextStyle style)? builder;
}
