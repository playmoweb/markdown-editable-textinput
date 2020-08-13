[![Build Status](https://travis-ci.org/playmoweb/markdown-editable-textinput.svg?branch=master)](https://travis-ci.org/playmoweb/markdown-editable-textinput)
[![pub package](https://img.shields.io/pub/v/markdown_editable_textinput.svg)](https://pub.dev/packages/markdown_editable_textinput)
[![codecov](https://codecov.io/gh/playmoweb/markdown-editable-textinput/branch/master/graph/badge.svg)](https://codecov.io/gh/playmoweb/markdown-editable-textinput)

# markdown_editable_textinput

MarkdownEditableTextInput is a TextField Widget that allow you to convert easily what's in the TextField to Markdown.

## Features
- [x] Convert to Bold, Italic, Title (h1,h2,h3), List and Link
- [x] Support text direction
- [ ] Customize textInput colors

## Demo
![](pictures/test_edition.gif)

## Usage
The color of the MarkdownTextInput is defined by the color set in your Theme :
- primaryColor: Cursor's color
- accentColor: MarkdownTextInput's borders
- cardColor: Background color of MarkdownTextInput

### Attributes
|      Attributes     | Example Value |                  Description                            |
|:-------------------:|:-------------:|:-------------------------------------------------------:|
| Function onTextChanged   |               | Callback used to retrieve the text in parent's Widget   |
| String initialValue | "Lorem Ipsum" | Display an initial value in MarkdownTextInput's field   |
| Function validators |               | Add validators to the MarkdownTextInput                 |
| String label        | "Description" | Display a label in MarkdownTextInput                    |
| TextDirection textDirection       | TextDirection.rtl | Change text direction                   |
| int maxLines       | 3 | The maximum of lines that can be display in the input                |

### Example
You can see an example of how to use this package [here](https://github.com/playmoweb/markdown-editable-textinput/tree/master/example)


