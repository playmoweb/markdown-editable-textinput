import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';

void main() {
  group("test all convertToMarkdown function's cases", () {
    test('convert to bold', () {
      var testString =
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      var from = 12;
      var to = 17;

      var formattedText = FormatMarkdown.convertToMarkdown(
          MarkdownType.bold, testString, from, to);

      expect(formattedText.cursorIndex, 9,
          reason: "dolor length = 5, '**' '**' = 4");
      expect(formattedText.data,
          'Lorem ipsum **dolor** sit amet, consectetur adipiscing elit.');
    });

    test('convert to italic', () {
      var testString =
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      var from = 12;
      var to = 17;

      var formattedText = FormatMarkdown.convertToMarkdown(
          MarkdownType.italic, testString, from, to);

      expect(formattedText.cursorIndex, 7,
          reason: "dolor length = 5, '_' '_' = 2");
      expect(formattedText.data,
          'Lorem ipsum _dolor_ sit amet, consectetur adipiscing elit.');
    });

    test('convert to H1', () {
      var testString =
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      var from = 12;
      var to = 17;

      var formattedText = FormatMarkdown.convertToMarkdown(
          MarkdownType.title, testString, from, to,
          titleSize: 1);

      expect(formattedText.cursorIndex, 7, reason: "dolor length = 5, '# '= 2");
      expect(formattedText.data,
          'Lorem ipsum # dolor sit amet, consectetur adipiscing elit.');
    });

    test('convert to H2', () {
      var testString =
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      var from = 12;
      var to = 17;

      var formattedText = FormatMarkdown.convertToMarkdown(
          MarkdownType.title, testString, from, to,
          titleSize: 2);

      expect(formattedText.cursorIndex, 8,
          reason: "dolor length = 5, '## '= 3");
      expect(formattedText.data,
          'Lorem ipsum ## dolor sit amet, consectetur adipiscing elit.');
    });

    test('convert to H3', () {
      var testString =
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      var from = 12;
      var to = 17;

      var formattedText = FormatMarkdown.convertToMarkdown(
          MarkdownType.title, testString, from, to,
          titleSize: 3);

      expect(formattedText.cursorIndex, 9,
          reason: "dolor length = 5, '### '= 4");
      expect(formattedText.data,
          'Lorem ipsum ### dolor sit amet, consectetur adipiscing elit.');
    });

    test('convert to List', () {
      var testString =
          'Lorem ipsum\ndolor sit amet\nconsectetur adipiscing elit.';
      var from = 0;
      var to = testString.length;

      var formattedText = FormatMarkdown.convertToMarkdown(
          MarkdownType.list, testString, from, to);

      expect(formattedText.data,
          '* Lorem ipsum\n* dolor sit amet\n* consectetur adipiscing elit.');
      expect(formattedText.cursorIndex, 61,
          reason: "testString length = 55, '* * * '= 6");
    });

    test('convert to Link', () {
      var testString =
          'Lorem ipsum dolor sit amet consectetur adipiscing elit.';
      var from = 12;
      var to = 17;

      var formattedText = FormatMarkdown.convertToMarkdown(
          MarkdownType.link, testString, from, to);

      expect(formattedText.data,
          'Lorem ipsum [dolor](dolor) sit amet consectetur adipiscing elit.');
      expect(formattedText.cursorIndex, 14,
          reason: "dolor length = 5, '[](dolor)'= 9");
    });
  });
}
