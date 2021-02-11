import 'package:flutter/material.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';

/// Widget with markdown buttons
class MarkdownTextInput extends StatefulWidget {
  /// Callback called when text changed
  final Function onTextChanged;

  /// Initial value you want to display
  final String initialValue;

  /// Validator for the TextFormField
  final String Function(String value) validators;

  /// String displayed at hintText in TextFormField
  final String label;

  /// Change the text direction of the input (RTL / LTR)
  final TextDirection textDirection;

  /// The maximum of lines that can be display in the input
  final int maxLines;

  /// Buttons to be shown on the editor
  final List<MarkdownType> availableFunctions;

  /// Text capitalization strategy
  final TextCapitalization textCapitalization;

  /// Cursor color, defaults to [Theme.of(context).primaryColor]
  final Color cursorColor;

  /// Outer box decoration
  final BoxDecoration decoration;

  /// TextFormField's inputDecoration
  final InputDecoration inputDecoration;

  /// Constructor for [MarkdownTextInput]
  MarkdownTextInput(
    this.onTextChanged,
    this.initialValue, {
    this.label = '',
    this.validators,
    this.textDirection = TextDirection.ltr,
    this.maxLines = 10,
    this.availableFunctions = const [
      MarkdownType.bold,
      MarkdownType.italic,
      MarkdownType.title,
      MarkdownType.link,
      MarkdownType.list,
    ],
    this.textCapitalization = TextCapitalization.sentences,
    this.cursorColor,
    this.decoration,
    this.inputDecoration,
  });

  @override
  _MarkdownTextInputState createState() => _MarkdownTextInputState();
}

class _MarkdownTextInputState extends State<MarkdownTextInput> {
  final _controller = TextEditingController();
  TextSelection textSelection =
      const TextSelection(baseOffset: 0, extentOffset: 0);

  void onTap(MarkdownType type, {int titleSize = 1}) {
    final basePosition = textSelection.baseOffset;
    var noTextSelected =
        (textSelection.baseOffset - textSelection.extentOffset) == 0;

    final result = FormatMarkdown.convertToMarkdown(type, _controller.text,
        textSelection.baseOffset, textSelection.extentOffset,
        titleSize: titleSize);

    _controller.value = _controller.value.copyWith(
        text: result.data,
        selection:
            TextSelection.collapsed(offset: basePosition + result.cursorIndex));

    if (noTextSelected) {
      _controller.selection = TextSelection.collapsed(
          offset: _controller.selection.end - result.replaceCursorIndex);
    }
  }

  @override
  void initState() {
    _controller.text = widget.initialValue;
    _controller.addListener(() {
      if (_controller.selection.baseOffset != -1)
        textSelection = _controller.selection;
      widget.onTextChanged(_controller.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var decoration = widget.decoration ??
        BoxDecoration(
          color: theme.cardColor,
          border: Border.all(color: theme.accentColor, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        );

    var inputDecoration = widget.inputDecoration ??
        InputDecoration(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: theme.accentColor)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: theme.accentColor)),
          hintText: widget.label,
          hintStyle: const TextStyle(color: Color.fromRGBO(63, 61, 86, 0.5)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        );

    return Container(
      decoration: decoration,
      child: Column(
        children: <Widget>[
          TextFormField(
            textInputAction: TextInputAction.newline,
            maxLines: widget.maxLines,
            controller: _controller,
            textCapitalization: widget.textCapitalization,
            validator: widget?.validators,
            cursorColor: widget.cursorColor,
            textDirection: widget.textDirection,
            decoration: inputDecoration,
          ),
          Material(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            child: Row(
              children: [
                ...widget.availableFunctions
                    .map((b) => b.widget(onTap))
                    .toList()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
