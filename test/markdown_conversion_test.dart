import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';

void main() {
  group("test all convertToMarkdown function's cases", () {
    test('convert to bold', () {
      var testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      var from = 12;
      var to = 17;

      var formattedText = FormatMarkdown.convertToMarkdown(MarkdownType.bold, testString, from, to);

      expect(formattedText.cursorIndex, 9, reason: "dolor length = 5, '**' '**' = 4");
      expect(formattedText.data, 'Lorem ipsum **dolor** sit amet, consectetur adipiscing elit.');
    });

    test('convert to italic', () {
      var testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      var from = 12;
      var to = 17;

      var formattedText = FormatMarkdown.convertToMarkdown(MarkdownType.italic, testString, from, to);

      expect(formattedText.cursorIndex, 7, reason: "dolor length = 5, '_' '_' = 2");
      expect(formattedText.data, 'Lorem ipsum _dolor_ sit amet, consectetur adipiscing elit.');
    });

    test('convert to strikethrough', () {
      var testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      var from = 12;
      var to = 17;

      var formattedText = FormatMarkdown.convertToMarkdown(MarkdownType.strikethrough, testString, from, to);

      expect(formattedText.cursorIndex, 9, reason: "dolor length = 5, '~~' '~~' = 4");
      expect(formattedText.data, 'Lorem ipsum ~~dolor~~ sit amet, consectetur adipiscing elit.');
    });

    test('convert to H1', () {
      var testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      var from = 12;
      var to = 17;

      var formattedText = FormatMarkdown.convertToMarkdown(MarkdownType.title, testString, from, to, titleSize: 1);

      expect(formattedText.cursorIndex, 7, reason: "dolor length = 5, '# '= 2");
      expect(formattedText.data, 'Lorem ipsum # dolor sit amet, consectetur adipiscing elit.');
    });

    test('convert to H2', () {
      var testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      var from = 12;
      var to = 17;

      var formattedText = FormatMarkdown.convertToMarkdown(MarkdownType.title, testString, from, to, titleSize: 2);

      expect(formattedText.cursorIndex, 8, reason: "dolor length = 5, '## '= 3");
      expect(formattedText.data, 'Lorem ipsum ## dolor sit amet, consectetur adipiscing elit.');
    });

    test('convert to H3', () {
      var testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      var from = 12;
      var to = 17;

      var formattedText = FormatMarkdown.convertToMarkdown(MarkdownType.title, testString, from, to, titleSize: 3);

      expect(formattedText.cursorIndex, 9, reason: "dolor length = 5, '### '= 4");
      expect(formattedText.data, 'Lorem ipsum ### dolor sit amet, consectetur adipiscing elit.');
    });

    test('convert to H4', () {
      var testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      var from = 12;
      var to = 17;

      var formattedText = FormatMarkdown.convertToMarkdown(MarkdownType.title, testString, from, to, titleSize: 4);

      expect(formattedText.cursorIndex, 10, reason: "dolor length = 5, '#### '= 5");
      expect(formattedText.data, 'Lorem ipsum #### dolor sit amet, consectetur adipiscing elit.');
    });

    test('convert to H5', () {
      var testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      var from = 12;
      var to = 17;

      var formattedText = FormatMarkdown.convertToMarkdown(MarkdownType.title, testString, from, to, titleSize: 5);

      expect(formattedText.cursorIndex, 11, reason: "dolor length = 5, '##### '= 6");
      expect(formattedText.data, 'Lorem ipsum ##### dolor sit amet, consectetur adipiscing elit.');
    });

    test('convert to H6', () {
      var testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      var from = 12;
      var to = 17;

      var formattedText = FormatMarkdown.convertToMarkdown(MarkdownType.title, testString, from, to, titleSize: 6);

      expect(formattedText.cursorIndex, 12, reason: "dolor length = 5, '###### '= 7");
      expect(formattedText.data, 'Lorem ipsum ###### dolor sit amet, consectetur adipiscing elit.');
    });

    test('convert to List', () {
      var testString = 'Lorem ipsum\ndolor sit amet\nconsectetur adipiscing elit.';
      var from = 0;
      var to = testString.length;

      var formattedText = FormatMarkdown.convertToMarkdown(MarkdownType.list, testString, from, to);

      expect(formattedText.data, '* Lorem ipsum\n* dolor sit amet\n* consectetur adipiscing elit.');
      expect(formattedText.cursorIndex, 61, reason: "testString length = 55, '* * * '= 6");
    });

    test('convert to Link', () {
      var testString = 'Lorem ipsum dolor sit amet consectetur adipiscing elit.';
      var from = 12;
      var to = 17;

      var formattedText = FormatMarkdown.convertToMarkdown(MarkdownType.link, testString, from, to);

      expect(formattedText.data, 'Lorem ipsum [dolor](dolor) sit amet consectetur adipiscing elit.');
      expect(formattedText.cursorIndex, 14, reason: "dolor length = 5, '[](dolor)'= 9");
    });

    test('convert to code', () {
      var testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      var from = 12;
      var to = 17;

      var formattedText = FormatMarkdown.convertToMarkdown(MarkdownType.code, testString, from, to);

      expect(formattedText.cursorIndex, 11, reason: "dolor length = 5, '```' '```' = 6");
      expect(formattedText.data, 'Lorem ipsum ```dolor``` sit amet, consectetur adipiscing elit.');
    });

    test('convert to blockquote', () {
      var testString = 'Lorem ipsum\ndolor sit amet\nconsectetur adipiscing elit.';
      var from = 0;
      var to = testString.length;

      var formattedText = FormatMarkdown.convertToMarkdown(MarkdownType.blockquote, testString, from, to);

      expect(formattedText.data, '> Lorem ipsum\n> dolor sit amet\n> consectetur adipiscing elit.');
      expect(formattedText.cursorIndex, 61, reason: "testString length = 55, '> > > '= 6");
    });

    test('convert to image', () {
      var testString = 'Lorem ipsum dolor sit amet consectetur adipiscing elit.';
      var from = 12;
      var to = 17;

      var formattedText = FormatMarkdown.convertToMarkdown(MarkdownType.image, testString, from, to);

      expect(formattedText.data, 'Lorem ipsum ![dolor](dolor) sit amet consectetur adipiscing elit.');
      expect(formattedText.cursorIndex, 15, reason: "dolor length = 5, '![](dolor)'= 10");
    });

    test('convert to separator', () {
      var testString = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
      var from = 12;
      var to = 17;

      var formattedText = FormatMarkdown.convertToMarkdown(MarkdownType.separator, testString, from, to);

      expect(formattedText.cursorIndex, 13, reason: "dolor length = 5, '\n------\n' = 8");
      expect(formattedText.data, 'Lorem ipsum \n------\ndolor sit amet, consectetur adipiscing elit.');
    });
  });
}
