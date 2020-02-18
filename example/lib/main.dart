import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String description = 'My great package';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Theme(
        data: ThemeData(
          primaryColor: const Color(0xFF2B3409),
          accentColor: const Color(0xFF71881B),
          cardColor: const Color(0xFFF7FBEA),
          textTheme: const TextTheme(body1: TextStyle(fontSize: 20)),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('EditableTextInput'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  MarkdownTextInput(
                    (String value) => setState(() => description = value),
                    description,
                    label: 'Description',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: MarkdownBody(
                      data: description,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
