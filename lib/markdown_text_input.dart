import 'dart:io';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:translator/translator.dart';

/// Widget with markdown buttons
class MarkdownTextInput extends StatefulWidget {
  /// Callback called when text changed
  final Function onTextChanged;

  /// Initial value you want to display
  final String initialValue;

  /// Validator for the TextFormField
  final String? Function(String? value)? validators;

  /// String displayed at hintText in TextFormField
  final String? label;

  /// Change the text direction of the input (RTL / LTR)
  final TextDirection textDirection;

  /// The maximum of lines that can be display in the input
  final int? maxLines;

  /// List of action the component can handle
  final List<MarkdownType> actions;

  /// Optional controller to manage the input
  final TextEditingController? controller;

  /// Overrides input text style
  final TextStyle? textStyle;

  /// If you prefer to use the dialog to insert links, you can choose to use the markdown syntax directly by setting [insertLinksByDialog] to false. In this case, the selected text will be used as label and link.
  /// Default value is true.
  final bool insertLinksByDialog;

  /// Constructor for [MarkdownTextInput]
  MarkdownTextInput(
    this.onTextChanged,
    this.initialValue, {
    this.label = '',
    this.validators,
    this.textDirection = TextDirection.ltr,
    this.maxLines = 10,
    this.actions = const [
      MarkdownType.bold,
      MarkdownType.italic,
      MarkdownType.title,
      MarkdownType.link,
      MarkdownType.list
    ],
    this.textStyle,
    this.controller,
    this.insertLinksByDialog = true,
  });

  @override
  _MarkdownTextInputState createState() => _MarkdownTextInputState(controller ?? TextEditingController());
}

class _MarkdownTextInputState extends State<MarkdownTextInput> {
  final TextEditingController _controller;
  TextSelection textSelection = const TextSelection(baseOffset: 0, extentOffset: 0);
  FocusNode focusNode = FocusNode();

  _MarkdownTextInputState(this._controller);

  void onTap(MarkdownType type, {int titleSize = 1, String? link, String? selectedText}) {
    final basePosition = textSelection.baseOffset;
    var noTextSelected = (textSelection.baseOffset - textSelection.extentOffset) == 0;

    var fromIndex = textSelection.baseOffset;
    var toIndex = textSelection.extentOffset;

    final result = FormatMarkdown.convertToMarkdown(type, _controller.text, fromIndex, toIndex,
        titleSize: titleSize, link: link, selectedText: selectedText ?? _controller.text.substring(fromIndex, toIndex));

    _controller.value = _controller.value
        .copyWith(text: result.data, selection: TextSelection.collapsed(offset: basePosition + result.cursorIndex));

    if (noTextSelected) {
      _controller.selection = TextSelection.collapsed(offset: _controller.selection.end - result.replaceCursorIndex);
      focusNode.requestFocus();
    }
  }

  @override
  void initState() {
    _controller.text = widget.initialValue;
    _controller.addListener(() {
      if (_controller.selection.baseOffset != -1) textSelection = _controller.selection;
      widget.onTextChanged(_controller.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).colorScheme.secondary, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: <Widget>[
          TextFormField(
            focusNode: focusNode,
            textInputAction: TextInputAction.newline,
            maxLines: widget.maxLines,
            controller: _controller,
            textCapitalization: TextCapitalization.sentences,
            validator: widget.validators != null ? (value) => widget.validators!(value) : null,
            style: widget.textStyle ?? Theme.of(context).textTheme.bodyText1,
            cursorColor: Theme.of(context).primaryColor,
            textDirection: widget.textDirection,
            decoration: InputDecoration(
              enabledBorder:
                  UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)),
              focusedBorder:
                  UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)),
              hintText: widget.label,
              hintStyle: const TextStyle(color: Color.fromRGBO(63, 61, 86, 0.5)),
              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            ),
          ),
          SizedBox(
            height: 44,
            child: Material(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: widget.actions.map((type) {
                  switch (type) {
                    case MarkdownType.title:
                      return ExpandableNotifier(
                        child: Expandable(
                          key: Key('H#_button'),
                          collapsed: ExpandableButton(
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'H#',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                          expanded: Container(
                            color: Colors.white10,
                            child: Row(
                              children: [
                                for (int i = 1; i <= 6; i++)
                                  InkWell(
                                    key: Key('H${i}_button'),
                                    onTap: () => onTap(MarkdownType.title, titleSize: i),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        'H$i',
                                        style: TextStyle(fontSize: (18 - i).toDouble(), fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ExpandableButton(
                                  child: const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Icon(
                                      Icons.close,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    case MarkdownType.link:
                      return _basicInkwell(
                        type,
                        customOnTap: !widget.insertLinksByDialog
                            ? null
                            : () async {
                                var text =
                                    _controller.text.substring(textSelection.baseOffset, textSelection.extentOffset);

                                var textController = TextEditingController()..text = text;
                                var linkController = TextEditingController();
                                var textFocus = FocusNode();
                                var linkFocus = FocusNode();

                                var color = Theme.of(context).colorScheme.secondary;
                                var language = Platform.localeName.substring(0, 2);

                                var textLabel = 'Text';
                                var linkLabel = 'Link';
                                try {
                                  var textTranslation = await GoogleTranslator().translate(textLabel, to: language);
                                  textLabel = textTranslation.text;

                                  var linkTranslation = await GoogleTranslator().translate(linkLabel, to: language);
                                  linkLabel = linkTranslation.text;
                                } catch (e) {
                                  textLabel = 'Text';
                                  linkLabel = 'Link';
                                }

                                await showDialog<void>(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                                child: Icon(Icons.close), onTap: () => Navigator.pop(context))
                                          ],
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: textController,
                                              decoration: InputDecoration(
                                                hintText: 'example',
                                                label: Text(textLabel),
                                                labelStyle: TextStyle(color: color),
                                                focusedBorder:
                                                    OutlineInputBorder(borderSide: BorderSide(color: color, width: 2)),
                                                enabledBorder:
                                                    OutlineInputBorder(borderSide: BorderSide(color: color, width: 2)),
                                              ),
                                              autofocus: text.isEmpty,
                                              focusNode: textFocus,
                                              textInputAction: TextInputAction.next,
                                              onSubmitted: (value) {
                                                textFocus.unfocus();
                                                FocusScope.of(context).requestFocus(linkFocus);
                                              },
                                            ),
                                            SizedBox(height: 10),
                                            TextField(
                                              controller: linkController,
                                              decoration: InputDecoration(
                                                hintText: 'https://example.com',
                                                label: Text(linkLabel),
                                                labelStyle: TextStyle(color: color),
                                                focusedBorder:
                                                    OutlineInputBorder(borderSide: BorderSide(color: color, width: 2)),
                                                enabledBorder:
                                                    OutlineInputBorder(borderSide: BorderSide(color: color, width: 2)),
                                              ),
                                              autofocus: text.isNotEmpty,
                                              focusNode: linkFocus,
                                            ),
                                          ],
                                        ),
                                        contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              onTap(type, link: linkController.text, selectedText: textController.text);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    });
                              },
                      );
                    default:
                      return _basicInkwell(type);
                  }
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _basicInkwell(MarkdownType type, {Function? customOnTap}) {
    return InkWell(
      key: Key(type.key),
      onTap: () => customOnTap != null ? customOnTap() : onTap(type),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Icon(type.icon),
      ),
    );
  }
}
