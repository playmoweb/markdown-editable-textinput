import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:expandable/expandable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';

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

  /// List of custom action buttons
  final List<ActionButton> optionnalActionButtons;

  /// Optional controller to manage the input
  final TextEditingController? controller;

  /// Overrides input text style
  final TextStyle? textStyle;

  /// If you prefer to use the dialog to insert links, you can choose to use the markdown syntax directly by setting [insertLinksByDialog] to false. In this case, the selected text will be used as label and link.
  /// Default value is true.
  final bool insertLinksByDialog;

  ///Optional focusNode, the Widget creates it's own if not provided
  final FocusNode? focusNode;

  /// If you prefer to use the dialog to insert image, you can choose to use the markdown syntax directly by setting [insertImageByDialog] to false. In this case, the selected text will be used as label and link.
  /// Default value is true.
  final bool insertImageByDialog;

  /// InputDecoration for the text input of the link dialog
  final InputDecoration? linkDialogLinkDecoration;

  /// InputDecoration for the link input of the link dialog
  final InputDecoration? linkDialogTextDecoration;

  /// InputDecoration for the text input of the image dialog
  final InputDecoration? imageDialogLinkDecoration;

  /// InputDecoration for the link input of the image dialog
  final InputDecoration? imageDialogTextDecoration;

  /// Custom text for cancel button in dialogs
  final String? customCancelDialogText;

  /// Custom text for submit button in dialogs
  final String? customSubmitDialogText;

  /// Constructor for [MarkdownTextInput]
  MarkdownTextInput(this.onTextChanged, this.initialValue,
      {this.label = '',
      this.validators,
      this.textDirection = TextDirection.ltr,
      this.maxLines = 10,
      this.actions = const [MarkdownType.bold, MarkdownType.italic, MarkdownType.title, MarkdownType.link, MarkdownType.list],
      this.textStyle,
      this.controller,
      this.insertLinksByDialog = true,
      this.insertImageByDialog = true,
      this.focusNode,
      this.linkDialogLinkDecoration,
      this.linkDialogTextDecoration,
      this.imageDialogLinkDecoration,
      this.imageDialogTextDecoration,
      this.customCancelDialogText,
      this.customSubmitDialogText,
      this.optionnalActionButtons = const []});


  @override
  _MarkdownTextInputState createState() => _MarkdownTextInputState(controller ?? TextEditingController());
}

class _MarkdownTextInputState extends State<MarkdownTextInput> {
  final TextEditingController _controller;
  TextSelection textSelection = const TextSelection(baseOffset: 0, extentOffset: 0);
  late final FocusNode focusNode;

  _MarkdownTextInputState(this._controller);

  void onTap(MarkdownType type, {int titleSize = 1, String? link, String? selectedText}) {
    final basePosition = textSelection.baseOffset;
    var noTextSelected = (textSelection.baseOffset - textSelection.extentOffset) == 0;

    var fromIndex = min(textSelection.baseOffset, textSelection.extentOffset);
    var toIndex = max(textSelection.extentOffset, textSelection.baseOffset);

    final result =
        FormatMarkdown.convertToMarkdown(type, _controller.text, fromIndex, toIndex, titleSize: titleSize, link: link, selectedText: selectedText ?? _controller.text.substring(fromIndex, toIndex));

    _controller.value = _controller.value.copyWith(text: result.data, selection: TextSelection.collapsed(offset: basePosition + result.cursorIndex));

    if (noTextSelected) {
      _controller.selection = TextSelection.collapsed(offset: _controller.selection.end - result.replaceCursorIndex);
      focusNode.requestFocus();
    }
  }

  @override
  void initState() {
    focusNode = widget.focusNode ?? FocusNode();
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
    if (widget.focusNode == null) focusNode.dispose();
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
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)),
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
                children: <Widget>[
                  ...widget.actions.map((type) {
                    if (type == MarkdownType.title) {
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
                    } else if (type == MarkdownType.link || type == MarkdownType.image) {
                      return _basicInkwell(
                        type,
                        customOnTap: (type == MarkdownType.link ? !widget.insertLinksByDialog : !widget.insertImageByDialog)
                            ? null
                            : () async {
                                var text = _controller.text.substring(textSelection.baseOffset, textSelection.extentOffset);

                                var textController = TextEditingController()..text = text;
                                var linkController = TextEditingController();

                                var color = Theme.of(context).colorScheme.secondary;

                                await _basicDialog(textController, linkController, color, text, type);
                              },
                      );
                    } else {
                      return _basicInkwell(type);
                    }
                  }).toList(),


                  ...widget.optionnalActionButtons.map((ActionButton optionActionButton) {
                    return _basicInkwell(optionActionButton, customOnTap: optionActionButton.action);
                  }).toList()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _basicInkwell(dynamic item, {Function? customOnTap}) {
    Widget widgetToReturn = SizedBox.shrink();

    if (item is MarkdownType) {
      return InkWell(
        key: Key(item.key),
        onTap: () => customOnTap != null ? customOnTap() : onTap(item),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Icon(item.icon),
        ),
      );
    } else if (item is ActionButton) {
      return InkWell(
        onTap: item.action,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: item.widget,
        ),
      );
    }

    return widgetToReturn;
  }

  Future<void> _basicDialog(
    TextEditingController textController,
    TextEditingController linkController,
    Color color,
    String text,
    MarkdownType type,
  ) async {
    var finalTextInputDecoration = type == MarkdownType.link ? widget.linkDialogTextDecoration : widget.imageDialogTextDecoration;
    var finalLinkInputDecoration = type == MarkdownType.link ? widget.linkDialogLinkDecoration : widget.imageDialogLinkDecoration;

    var textFocus = FocusNode();
    var linkFocus = FocusNode();

    return await showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: textController,
                  decoration: finalTextInputDecoration ??
                      InputDecoration(
                        hintText: 'Example text',
                        label: Text('Text'),
                        labelStyle: TextStyle(color: color),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: color, width: 2)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: color, width: 2)),
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
                  decoration: finalLinkInputDecoration ??
                      InputDecoration(
                        hintText: 'https://example.com',
                        label: Text('Link'),
                        labelStyle: TextStyle(color: color),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: color, width: 2)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: color, width: 2)),
                      ),
                  autofocus: text.isNotEmpty,
                  focusNode: linkFocus,
                ),
              ],
            ),
            contentPadding: EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 12.0),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(widget.customCancelDialogText ?? 'Cancel'),
              ),
              TextButton(
                onPressed: () {
                  onTap(type, link: linkController.text, selectedText: textController.text);
                  Navigator.pop(context);
                },
                child: Text(widget.customSubmitDialogText ?? 'OK'),
              ),
            ],
          );
        });
  }
}
