/// Use this class for converting String to [ResultMarkdown]
class FormatMarkdown {
  /// Convert [data] part into [ResultMarkdown] from [type].
  /// Use [fromIndex] and [toIndex] for converting part of [data]
  /// [titleSize] is used for markdown titles
  static ResultMarkdown convertToMarkdown(
      MarkdownType type, String data, int fromIndex, int toIndex,
      {int titleSize = 1}) {
    late String changedData;
    late int replaceCursorIndex;

    switch (type) {
      case MarkdownType.bold:
        changedData = '**${data.substring(fromIndex, toIndex)}**';
        replaceCursorIndex = 2;
        break;
      case MarkdownType.italic:
        changedData = '_${data.substring(fromIndex, toIndex)}_';
        replaceCursorIndex = 1;
        break;
      case MarkdownType.strikethrough:
        changedData = '~~${data.substring(fromIndex, toIndex)}~~';
        replaceCursorIndex = 2;
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
      case MarkdownType.code:
        changedData = '```${data.substring(fromIndex, toIndex)}```';
        replaceCursorIndex = 3;
        break;
      case MarkdownType.blockquote:
        var index = 0;
        final splitedData = data.substring(fromIndex, toIndex).split('\n');
        changedData = splitedData.map((value) {
          index++;
          return index == splitedData.length ? '> $value' : '> $value\n';
        }).join();
        replaceCursorIndex = 0;
        break;
      case MarkdownType.separator:
        changedData = '\n------\n${data.substring(fromIndex, toIndex)}';
        replaceCursorIndex = 0;
        break;
      case MarkdownType.image:
        changedData =
            '![${data.substring(fromIndex, toIndex)}](${data.substring(fromIndex, toIndex)})';
        replaceCursorIndex = 3;
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

  /// For ~~strikethrough~~ text
  strikethrough,

  /// For [link](https://flutter.dev)
  link,

  /// For # Title or ## Title or ### Title
  title,

  /// For :
  ///   * Item 1
  ///   * Item 2
  ///   * Item 3
  list,

  /// For ```code``` text
  code,

  /// For :
  ///   > Item 1
  ///   > Item 2
  ///   > Item 3
  blockquote,

  /// For adding ------
  separator,

  /// For ![Alt text](https://picsum.photos/500/500)
  image,
}
