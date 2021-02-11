import 'package:flutter/material.dart';

/// Use this class for converting String to [ResultMarkdown]
class FormatMarkdown {
  /// Convert [data] part into [ResultMarkdown] from [type].
  /// Use [fromIndex] and [toIndex] for converting part of [data]
  /// [titleSize] is used for markdown titles
  static ResultMarkdown convertToMarkdown(
      MarkdownType type, String data, int fromIndex, int toIndex,
      {int titleSize = 1}) {
    String changedData;
    int replaceCursorIndex;

    switch (type) {
      case MarkdownType.bold:
        changedData = '**${data.substring(fromIndex, toIndex)}**';
        replaceCursorIndex = 2;
        break;
      case MarkdownType.italic:
        changedData = '_${data.substring(fromIndex, toIndex)}_';
        replaceCursorIndex = 1;
        break;
      case MarkdownType.link:
        changedData =
            '[${data.substring(fromIndex, toIndex)}](${data.substring(fromIndex, toIndex)})';
        replaceCursorIndex = 3;
        break;
      case MarkdownType.title:
        changedData =
            "${"#" * titleSize} ${data.substring(fromIndex, toIndex)}";
        replaceCursorIndex = 0;
        break;
      case MarkdownType.list:
        var index = 0;
        final splitedData = data.substring(fromIndex, toIndex).split('\n');
        changedData = splitedData.map((value) {
          index++;
          return index == splitedData.length ? '* $value' : '* $value\n';
        }).join();
        replaceCursorIndex = 0;
        break;
    }

    final cursorIndex = changedData.length;

    return ResultMarkdown(
        data.substring(0, fromIndex) +
            changedData +
            data.substring(toIndex, data.length),
        cursorIndex,
        replaceCursorIndex);
  }
}

/// [ResultMarkdown] give you the converted [data] to markdown and the [cursorIndex]
class ResultMarkdown {
  /// String converted to mardown
  String data;

  /// cursor index just after the converted part in markdown
  int cursorIndex;

  /// index at which cursor need to be replaced if no text selected
  int replaceCursorIndex;

  /// Return [ResultMarkdown]
  ResultMarkdown(this.data, this.cursorIndex, this.replaceCursorIndex);
}

/// Represent markdown possible type to convert

enum MarkdownType {
  /// For **bold** text
  bold,

  /// For _italic_ text
  italic,

  /// For [link](https://flutter.dev)
  link,

  /// For # Title or ## Title or ### Title
  title,

  /// For :
  ///   * Item 1
  ///   * Item 2
  ///   * Item 3
  list
}

/// Extension to enable additional functionalities to the enum
extension MarkdownTypeExtension on MarkdownType {
  /// Gets the button widget associated to each type
  Widget widget(Function(MarkdownType, {int titleSize}) onTap) {
    switch (this) {
      case MarkdownType.bold:
        return InkWell(
          key: const Key('bold_button'),
          onTap: () => onTap(MarkdownType.bold),
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.format_bold,
            ),
          ),
        );
      case MarkdownType.italic:
        return InkWell(
          key: const Key('italic_button'),
          onTap: () => onTap(MarkdownType.italic),
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.format_italic,
            ),
          ),
        );
      case MarkdownType.title:
        return Row(
          children: [1, 2, 3]
              .map((i) => InkWell(
                    key: Key('H${i}_button'),
                    onTap: () => onTap(MarkdownType.title, titleSize: i),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'H$i',
                        style: TextStyle(
                            fontSize: (18 - i).toDouble(),
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ))
              .toList(),
        );
      case MarkdownType.link:
        return InkWell(
          key: const Key('link_button'),
          onTap: () => onTap(MarkdownType.link),
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.link,
            ),
          ),
        );
      case MarkdownType.list:
        return InkWell(
          key: const Key('list_button'),
          onTap: () => onTap(MarkdownType.list),
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.list,
            ),
          ),
        );
      default:
        return Container();
    }
  }
}
