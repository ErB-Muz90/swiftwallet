import 'package:flutter/material.dart';
import '../utils/modern_theme.dart';

class CustomInput extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool isDarkMode;
  final int? maxLines;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;

  const CustomInput({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    required this.isDarkMode,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            color: isDarkMode 
              ? ModernAppTheme.darkOnSurface 
              : ModernAppTheme.lightOnSurface,
          ),
        ),
        const SizedBox(height: ModernAppTheme.spacingXs),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
          maxLines: maxLines,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null 
              ? Icon(prefixIcon, color: isDarkMode 
                ? ModernAppTheme.darkOutline 
                : ModernAppTheme.lightOutline) 
              : null,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: isDarkMode ? ModernAppTheme.darkSurface : ModernAppTheme.lightSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ModernAppTheme.radiusSm),
              borderSide: BorderSide(
                color: isDarkMode 
                  ? ModernAppTheme.darkOutline 
                  : ModernAppTheme.lightOutline,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ModernAppTheme.radiusSm),
              borderSide: BorderSide(
                color: isDarkMode 
                  ? ModernAppTheme.darkOutline 
                  : ModernAppTheme.lightOutline,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ModernAppTheme.radiusSm),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: ModernAppTheme.spacingMd,
              vertical: ModernAppTheme.spacingSm,
            ),
          ),
        ),
      ],
    );
  }
}
