class FormatMarkdown {
  static ResultMarkdown convertToMarkdown(MarkdownType type, String data, int fromIndex, int toIndex,
      {int titleSize = 1}) {
    String changedData;

    switch (type) {
      case MarkdownType.bold:
        changedData = '**${data.substring(fromIndex, toIndex)}**';
        break;
      case MarkdownType.italic:
        changedData = '_${data.substring(fromIndex, toIndex)}_';
        break;
      case MarkdownType.link:
        changedData = '[${data.substring(fromIndex, toIndex)}](${data.substring(fromIndex, toIndex)})';
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

class ResultMarkdown {
  String data;
  int cursorIndex;

  ResultMarkdown(this.data, this.cursorIndex);
}

enum MarkdownType { bold, italic, link, title, list }
