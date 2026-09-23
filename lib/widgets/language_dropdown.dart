import 'package:flutter/material.dart';
import '../main.dart'; // To access localeNotifier
import '../core/theme.dart';
import 'glass_container.dart';

class LanguageDropdown extends StatelessWidget {
  final bool isDarkTheme;
  
  const LanguageDropdown({super.key, this.isDarkTheme = false});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: localeNotifier,
      builder: (context, currentLocale, _) {
        return GlassContainer(
          borderRadius: 12.0,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
          color: isDarkTheme ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.2),
          border: Border.all(
            color: isDarkTheme ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.4),
            width: 1.0,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              borderRadius: BorderRadius.circular(24.0),
              elevation: 8,
              value: currentLocale.languageCode,
              icon: Icon(
                Icons.language, 
                color: isDarkTheme ? Colors.white : AppTheme.primaryTerracotta,
                size: 20,
              ),
              dropdownColor: isDarkTheme 
                  ? AppTheme.backgroundDark.withValues(alpha: 0.95) 
                  : Colors.white.withValues(alpha: 0.95),
              style: TextStyle(
                color: isDarkTheme ? Colors.white : AppTheme.textDark,
                fontWeight: FontWeight.w600,
              ),
            items: const [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'hi', child: Text('हिन्दी')),
              DropdownMenuItem(value: 'mr', child: Text('मराठी')),
              DropdownMenuItem(value: 'te', child: Text('తెలుగు')),
              DropdownMenuItem(value: 'ta', child: Text('தமிழ்')),
              DropdownMenuItem(value: 'ml', child: Text('മലയാളം')),
            ],
            onChanged: (String? newCode) {
              if (newCode != null) {
                localeNotifier.setLocale(Locale(newCode));
              }
            },
          ),
        ),
      );
    },
    );
  }
}
