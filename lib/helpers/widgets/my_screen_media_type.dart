enum MyScreenMediaType {
  xs(1000, "xs"), //Mobile
  sm(1200, "sm"), //Tablet era 768
  md(1300, "md"), //Laptop era 1200
  lg(1400, "lg"), //Desktop
  xl(1800, "xl"), //Large Desktop
  xxl(4000, "xxl"); //Extra Large Desktop

  bool get isMobile => this == MyScreenMediaType.xs;

  bool get isTablet => this == MyScreenMediaType.sm;

  bool get isLaptop => this == MyScreenMediaType.md;

  bool get isMiniDesktop => this == MyScreenMediaType.lg;

  bool get isDesktop => this == MyScreenMediaType.xl;

  static List<MyScreenMediaType> list = [
    MyScreenMediaType.xs,
    MyScreenMediaType.sm,
    MyScreenMediaType.md,
    MyScreenMediaType.lg,
    MyScreenMediaType.xl,
    MyScreenMediaType.xxl
  ];

  const MyScreenMediaType(this.width, this.className);

  final double width;

  final String className;
}
