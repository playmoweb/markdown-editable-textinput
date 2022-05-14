import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';

/// Widget with markdown buttons
class MarkdownTextInput extends StatefulWidget {
  /// Callback called when text changed
  final Function(String text) onTextChanged;

  /// Initial value you want to display
  final String? initialValue;

  /// `Validator` for the `TextFormField`
  final String? Function(String? value)? validators;

  /// Change the text direction of the input (RTL / LTR)
  final TextDirection? textDirection;

  /// The maximum of lines that can be display in the input
  final int? maxLines;

  /// List of action the component can handle
  final List<MarkdownType> actions;

  /// Optional `controller` to manage the input
  final TextEditingController? controller;

  /// `InputDecoration` of `TextFormField`
  final InputDecoration? inputDecoration;

  /// Expands actions widget to full size
  final bool fillActions;

  /// `BoxDecoration` of actions `Container`
  final BoxDecoration? actionsBoxDecoration;

  /// Space between `actions` widget and `TextFormField` widget
  final double? separaterHeight;

  /// `Padding` of `Actions button` widget
  final EdgeInsets actionsButtonPadding;

  /// Color of `cursorColor`
  final Color? cursorColor;

  /// Constructor for [MarkdownTextInput]
  MarkdownTextInput(
    this.onTextChanged, {
    this.initialValue,
    this.controller,
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
    this.inputDecoration,
    this.fillActions = false,
    this.actionsBoxDecoration,
    this.separaterHeight = 15,
    this.actionsButtonPadding = const EdgeInsets.all(15),
    this.cursorColor,
  });

  @override
  _MarkdownTextInputState createState() =>
      _MarkdownTextInputState(controller ?? TextEditingController());
}

class _MarkdownTextInputState extends State<MarkdownTextInput> {
  final TextEditingController _controller;
  TextSelection textSelection =
      const TextSelection(baseOffset: 0, extentOffset: 0);

  _MarkdownTextInputState(this._controller);

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
    _controller.text = widget.initialValue ?? '';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: widget.actionsBoxDecoration ?? BoxDecoration(),
          width: widget.fillActions ? double.maxFinite : null,
          child: Material(
            color: Colors.transparent,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.actions.map((type) {
                  return type == MarkdownType.title
                      ? ExpandableNotifier(
                          child: Expandable(
                            key: Key('H#_button'),
                            collapsed: ExpandableButton(
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'H#',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                            expanded: Container(
                              color: Colors.white10,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: NeverScrollableScrollPhysics(),
                                child: Row(
                                  children: [
                                    for (int i = 1; i <= 6; i++)
                                      InkWell(
                                        key: Key('H${i}_button'),
                                        onTap: () => onTap(MarkdownType.title,
                                            titleSize: i),
                                        child: Padding(
                                          padding: widget.actionsButtonPadding,
                                          child: Text(
                                            'H$i',
                                            style: TextStyle(
                                                fontSize: (18 - i).toDouble(),
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ExpandableButton(
                                      child: Padding(
                                        padding: widget.actionsButtonPadding,
                                        child: Icon(
                                          Icons.close,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : InkWell(
                          key: Key(type.key),
                          onTap: () => onTap(type),
                          child: Padding(
                            padding: widget.actionsButtonPadding,
                            child: Icon(type.icon),
                          ),
                        );
                }).toList(),
              ),
            ),
          ),
        ),
        SizedBox(height: widget.separaterHeight),
        TextFormField(
          textInputAction: TextInputAction.newline,
          maxLines: widget.maxLines,
          controller: _controller,
          textCapitalization: TextCapitalization.sentences,
          validator: (value) => widget.validators!(value),
          textDirection: widget.textDirection,
          cursorColor: widget.cursorColor,
          decoration: widget.inputDecoration,
        ),
      ],
    );
  }
}
