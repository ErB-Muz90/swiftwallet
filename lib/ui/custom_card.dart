import 'package:flutter/material.dart';
import '../utils/modern_theme.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Color? color;
  final bool useGlassEffect;
  final bool isDarkMode;

  const CustomCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.elevation,
    this.borderRadius,
    this.color,
    this.useGlassEffect = false,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: elevation ?? ModernAppTheme.elevationSm,
      margin: margin ?? const EdgeInsets.all(ModernAppTheme.spacingMd),
      color: color ?? (isDarkMode ? ModernAppTheme.darkSurface : ModernAppTheme.lightSurface),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(ModernAppTheme.radiusMd),
      ),
      child: Container(
        decoration: useGlassEffect 
          ? ModernAppTheme.getGlassCardDecoration(isDarkMode)
          : null,
        padding: padding ?? const EdgeInsets.all(ModernAppTheme.spacingMd),
        child: child,
      ),
    );
  }
}
