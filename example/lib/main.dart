import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';

void main() => runApp(MyApp());

// ignore: public_member_api_docs
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String description = 'My great package';
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      print(controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Theme(
        data: ThemeData(
          primaryColor: const Color(0xFF2C1C6B),
          colorScheme:
              ColorScheme.light().copyWith(secondary: const Color(0xFF200681)),
          cardColor: const Color(0xFFF8F9FC),
          textTheme: const TextTheme(bodyText2: TextStyle(fontSize: 20)),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('EditableTextInput'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 100),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        MarkdownTextInput(
                          (String value) => setState(() => description = value),
                          maxLines: 10,
                          controller: controller,
                          actionsBoxDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.lightBlue),
                          ),
                          actions: MarkdownType.values,
                          fillActions: false,
                          inputDecoration: InputDecoration(
                            hintText:
                                'I have been working for the weekend, but this weekend never came..',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            errorStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            hintMaxLines: 2,
                            errorMaxLines: 2,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xFF5856D6),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xFF5856D6),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            contentPadding: const EdgeInsets.all(20),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            controller.clear();
                          },
                          child: Text('Clear'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: MarkdownBody(
                            data: description,
                            shrinkWrap: true,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
