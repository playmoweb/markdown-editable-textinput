/// Use this class for converting String to [ResultMarkdown]
class FormatMarkdown {
  /// Convert [data] part into [ResultMarkdown] from [type].
  /// Use [fromIndex] and [toIndex] for converting part of [data]
  /// [titleSize] is used for markdown titles
  static ResultMarkdown convertToMarkdown(
    MarkdownType type,
    String data,
    int fromIndex,
    int toIndex, {
    int titleSize = 1,
    String link,
  }) {
    String changedData;

    switch (type) {
      case MarkdownType.bold:
        changedData = '**${data.substring(fromIndex, toIndex)}**';
        break;
      case MarkdownType.italic:
        changedData = '_${data.substring(fromIndex, toIndex)}_';
        break;
      case MarkdownType.link:
        changedData = '[${data.substring(fromIndex, toIndex)}]($link)';
        break;
      case MarkdownType.title:
        changedData = "${"#" * titleSize} ${data.substring(fromIndex, toIndex)}";
        break;
      case MarkdownType.list:
        var index = 0;
        final splitedData = data.substring(fromIndex, toIndex).split('\n');
        changedData = splitedData.map((value) {
          index++;
          return index == splitedData.length ? '* $value' : '* $value\n';
        }).join();
        break;
    }
    final cursorIndex = changedData.length;

    return ResultMarkdown(
        data.substring(0, fromIndex) + changedData + data.substring(toIndex, data.length), cursorIndex);
  }
}

/// [ResultMarkdown] give you the converted [data] to markdown and the [cursorIndex]
class ResultMarkdown {
  /// String converted to mardown
  String data;

  /// cursor index just after the converted part in markdown
  int cursorIndex;

  /// Return [ResultMarkdown]
  ResultMarkdown(this.data, this.cursorIndex);
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
