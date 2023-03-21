enum Flavor {
  PROD,
}

class F {
  static Flavor appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.PROD:
        return 'Chatty GPT';
      default:
        return 'title';
    }
  }

  static String apiTokenChatGPT;
  static String bannerAdUnitBottomBanner;
}
