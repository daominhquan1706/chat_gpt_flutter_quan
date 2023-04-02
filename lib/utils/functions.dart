//copy text to clipboard
import 'package:flutter/services.dart';

class AppFunctions {
  static void copyTextToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
}
