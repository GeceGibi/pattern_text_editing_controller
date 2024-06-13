
Basically this package working for stylize to input text.

```dart
final controller = PatternTextEditingController(
    patterns: [
        TextPattern(
            pattern: RegExp('blue', multiLine: true),
            style: const TextStyle(
                color: Color(0xff0000ff),
            ),
        ),
        TextPattern(
            pattern: RegExp('red', multiLine: true),
            style: const TextStyle(
                color: Color(0xffff0000),
            ),
        ),
    ]
)

TextField(
    controller: controller,
)
```




![Example](https://raw.githubusercontent.com/GeceGibi/pattern_text_editing_controller/main/example.png)
Basic json editor example code in [example.dart](https://github.com/GeceGibi/pattern_text_editing_controller/blob/main/example/main.dart)
