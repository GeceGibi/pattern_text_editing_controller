
Basically this package working for stylize to input text.

```dart
final controller = PatternTextEditingController(
    patterns: [
        TextPattern(
            pattern: RegExp('blue', multiLine: true),
            style: const TextStyle(
                color: Color(0xff0000fff),
            ),
        ),
        TextPattern(
            pattern: RegExp('blue', multiLine: true),
            style: const TextStyle(
                color: Color(0xff0000fff),
            ),
        ),
    ]
)

TextField(
    controller: controller,
)
```

Full example code in [example.dart](https://github.com/GeceGibi/pattern_text_editing_controller/blob/main/example/main.dart) (basic json editor)
