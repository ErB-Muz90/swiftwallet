import 'package:flutter/material.dart';
import '../utils/modern_theme.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? responsiveScale;
  final bool isDarkMode;

  const CustomText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.responsiveScale = 1.0,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle = style ?? theme.textTheme.bodyMedium;
    
    // Apply responsive scaling if needed
    final scaledStyle = baseStyle?.copyWith(
      fontSize: baseStyle?.fontSize != null 
        ? baseStyle!.fontSize! * responsiveScale!
        : null,
    );

    return Text(
      text,
      style: scaledStyle?.copyWith(
        color: isDarkMode 
          ? ModernAppTheme.darkOnSurface 
          : ModernAppTheme.lightOnSurface,
      ),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}

class HeadingText extends CustomText {
  final int level; // 1-6, similar to HTML headings

  const HeadingText(
    String text, {
    super.key,
    this.level = 1,
    super.textAlign,
    super.overflow,
    super.maxLines,
    super.responsiveScale,
    required super.isDarkMode,
  }) : super(text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    late TextStyle? headingStyle;
    
    switch (level) {
      case 1:
        headingStyle = theme.textTheme.displayLarge;
      case 2:
        headingStyle = theme.textTheme.displayMedium;
      case 3:
        headingStyle = theme.textTheme.displaySmall;
      case 4:
        headingStyle = theme.textTheme.headlineMedium;
      case 5:
        headingStyle = theme.textTheme.headlineSmall;
      case 6:
        headingStyle = theme.textTheme.titleLarge;
      default:
        headingStyle = theme.textTheme.headlineSmall;
    }
    
    // Apply responsive scaling if needed
    final scaledStyle = headingStyle?.copyWith(
      fontSize: headingStyle?.fontSize != null 
        ? headingStyle!.fontSize! * responsiveScale!
        : null,
    );

    return Text(
      text,
      style: scaledStyle?.copyWith(
        color: isDarkMode 
          ? ModernAppTheme.darkOnSurface 
          : ModernAppTheme.lightOnSurface,
      ),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
