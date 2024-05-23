import 'dart:math';

class Images {
  /// WebApps Logo ///
  static String logoIcon = 'assets/logo/foodLogo.png';
  static String logoMiwa = 'assets/logo/logo.png';

  /// Background ///
  static String background = 'assets/images/home/background.jpg';

  /// Auth Side Image ///
  static String authSideImage = 'assets/images/home/auth_side_image.png';

  static String noImage = 'assets/images/home/no_image.jpg';

  static String randomImage(List<String> images) {
    return images[Random().nextInt(images.length)];
  }
}
