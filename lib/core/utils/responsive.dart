import 'package:flutter/widgets.dart';

/// Centralized breakpoints and helpers for responsive layouts.
class Breakpoints {
  static const double small = 600;   // phones
  static const double medium = 900;  // small tablets
  static const double large = 1200;  // tablets / desktop
}

extension MediaQueryExt on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  bool get isSmall => screenWidth < Breakpoints.small;
  bool get isMedium => screenWidth >= Breakpoints.small && screenWidth < Breakpoints.large;
  bool get isLarge => screenWidth >= Breakpoints.large;
}

/// Constrains content width on wide screens for readability.
class CenteredConstrained extends StatelessWidget {
  final double maxWidth;
  final EdgeInsetsGeometry? padding;
  final Widget child;

  const CenteredConstrained({
    super.key,
    this.maxWidth = 900,
    this.padding,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding ?? EdgeInsets.symmetric(horizontal: context.isSmall ? 12 : 16),
          child: child,
        ),
      ),
    );
  }
}
