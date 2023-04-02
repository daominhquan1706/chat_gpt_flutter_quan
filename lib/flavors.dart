enum Flavor {
  prod,
}

class F {
  static late Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.prod:
        return 'Chatty GPT';
      default:
        return 'title';
    }
  }

  static late String? apiTokenChatGPT;
  static late String? bannerAdUnitBottomBanner;
}
