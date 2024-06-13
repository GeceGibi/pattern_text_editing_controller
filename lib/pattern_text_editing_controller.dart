library pattern_text_editing_controller;

import 'package:flutter/widgets.dart';

part 'text_pattern.dart';

class PatternTextEditingController extends TextEditingController {
  PatternTextEditingController({required this.patterns});
  final List<TextPattern> patterns;

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final entries = <Object>[text];
    final baseStyle = style ?? DefaultTextStyle.of(context).style;

    for (final pattern in patterns) {
      final parsedEntries = <Object>[];

      for (final entry in entries) {
        if (entry is! String) {
          parsedEntries.add(entry);
          continue;
        }

        entry.splitMapJoin(
          pattern.pattern,
          onMatch: (match) {
            final span = pattern.builder?.call(match, baseStyle) ??
                TextSpan(
                  text: match.group(0),
                  style: baseStyle.merge(pattern.style),
                );

            parsedEntries.add(span);
            return '';
          },
          onNonMatch: (value) {
            parsedEntries.add(value);
            return '';
          },
        );
      }

      entries
        ..clear()
        ..addAll(parsedEntries);
    }

    return TextSpan(
      children: entries.map((entry) {
        if (entry is String) {
          return TextSpan(text: entry, style: baseStyle);
        }

        return entry as TextSpan;
      }).toList(),
    );
  }
}
