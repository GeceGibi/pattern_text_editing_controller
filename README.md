
Basically this package working for stylize to input text.

```dart
  final controller = PatternTextEditingController(
    patterns: [
      TextPattern(
        pattern: RegExp('0x(?:[0-9a-fA-F]{8})'),
        style: const TextStyle(
          color: Color(0xff0000ff),
        ),
        builder: (match, style) {
          return TextSpan(
            text: match.group(0),
            style: style.merge(
              TextStyle(
                color: Color(int.parse(match.group(0)!)),
              ),
            ),
          );
        },
      ),
      TextPattern(
        pattern: RegExp('red'),
        style: const TextStyle(
          color: Color(0xff0000ff),
        ),
      ),
      TextPattern(
        pattern: RegExp('blue'),
        style: const TextStyle(
          color: Color(0xffff0000),
        ),
      ),
      TextPattern(
        pattern: RegExp('italic'),
        style: const TextStyle(
          fontStyle: FontStyle.italic,
        ),
      ),
      TextPattern(
        pattern: RegExp('underline'),
        style: const TextStyle(
          decoration: TextDecoration.underline,
        ),
      ),
      TextPattern(
        pattern: RegExp('button'),
        style: const TextStyle(
          decoration: TextDecoration.underline,
        ),
        builder: (match, style) {
          return WidgetSpan(
            child: FilledButton(
              onPressed: () {},
              child: Text(match.group(0)!),
            ),
          );
        },
      ),
    ],
  );

TextField(
  maxLines: 20,
  controller: controller,
  style: const TextStyle(height: 2),
  decoration: const InputDecoration(
    contentPadding: EdgeInsets.all(20),
  ),
);
```

![Example](https://raw.githubusercontent.com/GeceGibi/pattern_text_editing_controller/main/example.png)
Basic json editor example code in [example.dart](https://github.com/GeceGibi/pattern_text_editing_controller/blob/main/example/main.dart)
