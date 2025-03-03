import 'package:flutter/widgets.dart';

class ResponsiveUtils {
  final BuildContext context;

  ResponsiveUtils(this.context);

  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;

  bool get isMobile => width <= 479;
  bool get isTablet => width > 479 && width <= 767;
  bool get isTabletLarge => width > 767 && width <= 991;
  bool get isDesktop => width > 991 && width <= 1250;
  bool get isDesktopLarge => width > 1250;
}