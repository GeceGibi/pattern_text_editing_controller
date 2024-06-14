library pattern_text_editing_controller;

import 'package:flutter/widgets.dart';

part 'text_pattern.dart';

class PatternTextEditingController extends TextEditingController {
  PatternTextEditingController({required this.patterns});
  final List<TextPattern> patterns;

  List<Object> splitMap(
    String value,
    RegExp pattern, {
    required Object Function(Match match) onMatch,
  }) {
    final output = <Object>[];
    var index = 0;

    for (final match in pattern.allMatches(value)) {
      // Handle the substring before the match (nonMatch)
      if (match.start > index) {
        output.add(value.substring(index, match.start));
      }

      // Handle the match (delimiter)
      output.add(onMatch(match));

      // Update startIndex for the next iteration
      index = match.end;
    }

    // Handle the substring after the last match
    if (index < value.length) {
      output.add(value.substring(index));
    }

    return output;
  }

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

        parsedEntries.addAll(
          splitMap(
            entry,
            pattern.pattern,
            onMatch: (match) {
              return pattern.builder?.call(match, baseStyle) ??
                  TextSpan(
                    text: match.group(0),
                    style: baseStyle.merge(pattern.style),
                  );
            },
          ),
        );
      }

      entries
        ..clear()
        ..addAll(parsedEntries);
    }

    return TextSpan(
      style: baseStyle,
      children: entries.map((entry) {
        if (entry is String) {
          return TextSpan(text: entry, style: baseStyle);
        }

        return entry as InlineSpan;
      }).toList(),
    );
  }
}
