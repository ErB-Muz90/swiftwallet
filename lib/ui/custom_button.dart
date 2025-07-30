import 'package:flutter/material.dart';
import '../utils/modern_theme.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;
  final bool useNeumorphicStyle;
  final bool isDarkMode;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.padding,
    this.isLoading = false,
    this.useNeumorphicStyle = false,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    
    return SizedBox(
      width: width,
      height: height,
      child: useNeumorphicStyle
        ? _buildNeumorphicButton(context, primaryColor)
        : _buildStandardButton(context, primaryColor),
    );
  }

  Widget _buildStandardButton(BuildContext context, Color primaryColor) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? primaryColor,
        foregroundColor: textColor ?? Colors.white,
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: ModernAppTheme.spacingLg,
          vertical: ModernAppTheme.spacingMd,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ModernAppTheme.radiusMd),
        ),
        elevation: ModernAppTheme.elevationSm,
      ),
      child: isLoading
        ? const CircularProgressIndicator(color: Colors.white)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: ModernAppTheme.spacingSm),
              ],
              Text(text),
            ],
          ),
    );
  }

  Widget _buildNeumorphicButton(BuildContext context, Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? ModernAppTheme.darkSurface : ModernAppTheme.lightSurface,
        borderRadius: BorderRadius.circular(ModernAppTheme.radiusMd),
        boxShadow: [
          BoxShadow(
            color: isDarkMode 
              ? Colors.black.withOpacity(0.3) 
              : Colors.grey.withOpacity(0.3),
            offset: const Offset(3, 3),
            blurRadius: 5,
          ),
          BoxShadow(
            color: isDarkMode 
              ? Colors.white.withOpacity(0.05) 
              : Colors.white.withOpacity(0.8),
            offset: const Offset(-3, -3),
            blurRadius: 5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(ModernAppTheme.radiusMd),
          child: Container(
            padding: padding ?? const EdgeInsets.symmetric(
              horizontal: ModernAppTheme.spacingLg,
              vertical: ModernAppTheme.spacingMd,
            ),
            child: isLoading
              ? const CircularProgressIndicator()
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 18),
                      const SizedBox(width: ModernAppTheme.spacingSm),
                    ],
                    Text(
                      text,
                      style: TextStyle(
                        color: backgroundColor ?? primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}
