
Basically this package working for stylize to input text.

```dart
  final controller = PatternTextEditingController(
    patterns: [
      TextPattern(
        pattern: RegExp('(?:[0-9a-fA-F]{6})', multiLine: true),
        style: const TextStyle(
          color: Color(0xff0000ff),
        ),
        builder: (match, style) {
          return TextSpan(
            text: match.group(0),
            style: style.merge(
              TextStyle(
                color: Color(
                  int.parse('0xff${match.group(0)}'),
                ),
              ),
            ),
          );
        },
      ),
      TextPattern(
        pattern: RegExp('red', multiLine: true),
        style: const TextStyle(
          color: Color(0xff0000ff),
        ),
      ),
      TextPattern(
        pattern: RegExp('blue', multiLine: true),
        style: const TextStyle(
          color: Color(0xffff0000),
        ),
      ),
      TextPattern(
        pattern: RegExp('italic', multiLine: true),
        style: const TextStyle(
          fontStyle: FontStyle.italic,
        ),
      ),
      TextPattern(
        pattern: RegExp('underline', multiLine: true),
        style: const TextStyle(
          decoration: TextDecoration.underline,
        ),
      ),
    ],
  );

TextField(
  controller: controller,
  maxLines: 12,
  decoration: const InputDecoration(
    contentPadding: EdgeInsets.all(20),
  ),
);
```


![Example](https://raw.githubusercontent.com/GeceGibi/pattern_text_editing_controller/main/example.png)
Basic json editor example code in [example.dart](https://github.com/GeceGibi/pattern_text_editing_controller/blob/main/example/main.dart)
