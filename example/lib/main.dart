import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pattern_text_editing_controller/pattern_text_editing_controller.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: FutureBuilder(
          future: http.get(Uri.parse('https://dummyjson.com/users?limit=3')),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return JsonViewer(snapshot.requireData.body);
          },
        ),
      ),
    );
  }
}

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
        pattern: RegExp(r'("[^"]*?")\s*:'),
        builder: (match) {
          return TextSpan(
            text: match.group(1),
            style: const TextStyle(fontWeight: FontWeight.w600),
            children: const [TextSpan(text: ':')],
          );
        },
      ),
      TextPattern(
        pattern: RegExp('".*?"'),
        style: const TextStyle(
          color: Color(0xff98c379),
        ),
      ),
      TextPattern(
        pattern: RegExp(r'-?[0-9]\d*(\.\d+)?'),
        style: const TextStyle(
          color: Color(0xff56B6C2),
        ),
      ),
      TextPattern(
        pattern: RegExp('(true|false)'),
        style: const TextStyle(
          color: Color(0xffE5C07B),
        ),
      ),
      TextPattern(
        pattern: RegExp('null'),
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

      controller
        ..text = encoder.convert(jsonDecode(data))
        ..selection = selection;

      error = '';
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
