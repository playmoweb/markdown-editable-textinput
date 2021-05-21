import 'package:flutter/material.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:expandable/expandable.dart';

/// Widget with markdown buttons
class MarkdownTextInput extends StatefulWidget {
  /// Callback called when text changed
  final Function onTextChanged;

  /// Initial value you want to display
  final String initialValue;

  /// Validator for the TextFormField
  final String Function(String? value)? validators;

  /// String displayed at hintText in TextFormField
  final String label;

  /// Change the text direction of the input (RTL / LTR)
  final TextDirection textDirection;

  /// The maximum of lines that can be display in the input
  final int maxLines;

  /// Constructor for [MarkdownTextInput]
  MarkdownTextInput(this.onTextChanged, this.initialValue,
      {this.label = '',
      this.validators,
      this.textDirection = TextDirection.ltr,
      this.maxLines = 10});

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
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).accentColor, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: <Widget>[
          TextFormField(
            textInputAction: TextInputAction.newline,
            maxLines: widget.maxLines,
            controller: _controller,
            textCapitalization: TextCapitalization.sentences,
            validator: (value) => widget.validators!(value),
            cursorColor: Theme.of(context).primaryColor,
            textDirection: widget.textDirection,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).accentColor)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).accentColor)),
              hintText: widget.label,
              hintStyle:
                  const TextStyle(color: Color.fromRGBO(63, 61, 86, 0.5)),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            ),
          ),
          SizedBox(
            height: 44,
            child: Material(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  InkWell(
                    key: const Key('bold_button'),
                    onTap: () => onTap(MarkdownType.bold),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.format_bold,
                      ),
                    ),
                  ),
                  InkWell(
                    key: const Key('italic_button'),
                    onTap: () => onTap(MarkdownType.italic),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.format_italic,
                      ),
                    ),
                  ),
                  InkWell(
                    key: const Key('strikethrough_button'),
                    onTap: () => onTap(MarkdownType.strikethrough),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.format_strikethrough,
                      ),
                    ),
                  ),
                  InkWell(
                    key: const Key('code_button'),
                    onTap: () => onTap(MarkdownType.code),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.code,
                      ),
                    ),
                  ),
                  ExpandableNotifier(
                    child: Expandable(
                      key: Key('H#_button'),
                      collapsed: ExpandableButton(
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'H#',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
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
                                onTap: () =>
                                    onTap(MarkdownType.title, titleSize: i),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    'H$i',
                                    style: TextStyle(
                                        fontSize: (18 - i).toDouble(),
                                        fontWeight: FontWeight.w700),
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
                  ),
                  InkWell(
                    key: const Key('link_button'),
                    onTap: () => onTap(MarkdownType.link),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.link,
                      ),
                    ),
                  ),
                  InkWell(
                    key: const Key('list_button'),
                    onTap: () => onTap(MarkdownType.list),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.list,
                      ),
                    ),
                  ),
                  InkWell(
                    key: const Key('quote_button'),
                    onTap: () => onTap(MarkdownType.blockquote),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.format_quote_rounded,
                      ),
                    ),
                  ),
                  InkWell(
                    key: const Key('separator_button'),
                    onTap: () => onTap(MarkdownType.separator),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.minimize_rounded,
                      ),
                    ),
                  ),
                  InkWell(
                    key: const Key('image_button'),
                    onTap: () => onTap(MarkdownType.image),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.image_rounded,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
