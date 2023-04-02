import 'dart:math';

class StringUtils {
  static String randomString(int length) {
    const String chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    Random rng = Random();

    String result = '';
    for (int i = 0; i < length; i++) {
      result += chars[rng.nextInt(chars.length)];
    }

    return result;
  }
}
