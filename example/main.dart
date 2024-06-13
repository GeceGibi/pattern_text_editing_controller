import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pattern_text_editing_controller/pattern_text_editing_controller.dart';

class JsonViewer extends StatefulWidget {
  const JsonViewer(this.data, {this.onChanged, super.key});
  final String data;
  final void Function(String data)? onChanged;

  @override
  State<JsonViewer> createState() => _JsonViewerState();
}

class _JsonViewerState extends State<JsonViewer> {
  static const encoder = JsonEncoder.withIndent('      ');
  final focusNode = FocusNode();

  final controller = PatternTextEditingController(
    patterns: [
      TextPattern(
        pattern: RegExp('(".+?"):', multiLine: true),
        style: const TextStyle(
          color: Color(0xff98c379),
        ),
        builder: (match, _) {
          return TextSpan(
            text: match.group(1),
            children: const [TextSpan(text: ':')],
          );
        },
      ),
      TextPattern(
        pattern: RegExp('".*?"', multiLine: true),
        style: const TextStyle(
          color: Color(0xff98c379),
        ),
      ),
      TextPattern(
        pattern: RegExp(r'-?[0-9]\d*(\.\d+)?', multiLine: true),
        style: const TextStyle(
          color: Color(0xff56B6C2),
        ),
      ),
      TextPattern(
        pattern: RegExp('(true|false)', multiLine: true),
        style: const TextStyle(
          color: Color(0xffE5C07B),
        ),
      ),
      TextPattern(
        pattern: RegExp('null', multiLine: true),
        style: const TextStyle(
          color: Color(0xffE06C75),
        ),
      ),
    ],
  );

  var error = '';

  void check(String data) {
    try {
      final selection = controller.selection;

      /// Test json
      jsonDecode(data);
      error = '';

      controller
        ..text = encoder.convert(jsonDecode(data))
        ..selection = selection;

      widget.onChanged?.call(controller.text);
    } catch (e) {
      error = e.toString();
    }

    setState(() {});
  }

  Timer? timer;
  void onKeyEventHandler(KeyEvent event) {
    timer?.cancel();

    timer = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) {
        return;
      }

      check(controller.text);
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      check(widget.data);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: focusNode,
      onKeyEvent: onKeyEventHandler,
      child: Column(
        children: [
          if (error.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: ColoredBox(
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(error.trim()),
                ),
              ),
            ),
          Expanded(
            child: TextField(
              maxLines: 60,
              controller: controller,
              scrollPadding: const EdgeInsets.all(20).copyWith(bottom: 120),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(8),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
