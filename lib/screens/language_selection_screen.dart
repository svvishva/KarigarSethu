import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karigarsethu/l10n/app_localizations.dart';
import '../core/theme.dart';
import '../core/locale_notifier.dart';
import '../widgets/glass_container.dart';
import 'login_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final LocaleNotifier localeNotifier;
  
  const LanguageSelectionScreen({super.key, required this.localeNotifier});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'hi', 'name': 'हिन्दी'},
    {'code': 'mr', 'name': 'मराठी'},
    {'code': 'te', 'name': 'తెలుగు'},
    {'code': 'ta', 'name': 'தமிழ்'},
    {'code': 'ml', 'name': 'മലയാളം'},
  ];

  late String _selectedCode;

  @override
  void initState() {
    super.initState();
    _selectedCode = widget.localeNotifier.value.languageCode;
  }

  void _continue() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [AppTheme.backgroundDark, AppTheme.secondaryIndigo.withValues(alpha: 0.5)]
                      : [AppTheme.primaryLight, AppTheme.secondaryLight],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.language_rounded,
                    size: 64,
                    color: AppTheme.primaryTerracotta,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n?.selectLanguage ?? 'Select Language',
                    textAlign: TextAlign.center,
                    style: widget.localeNotifier.value.languageCode == 'ta'
                        ? GoogleFonts.notoSansTamil(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppTheme.textLight : AppTheme.textDark,
                          )
                        : theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppTheme.textLight : AppTheme.textDark,
                          ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Language Grid
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: _languages.length,
                      itemBuilder: (context, index) {
                        final lang = _languages[index];
                        final isSelected = _selectedCode == lang['code'];
                        
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCode = lang['code']!;
                            });
                            widget.localeNotifier.setLocale(Locale(_selectedCode));
                          },
                          child: GlassContainer(
                            color: isSelected 
                                ? AppTheme.primaryTerracotta.withValues(alpha: 0.9)
                                : (isDark ? Colors.white10 : Colors.white60),
                            border: Border.all(
                              color: isSelected 
                                  ? AppTheme.primaryTerracotta 
                                  : AppTheme.borderSubtle,
                              width: 2,
                            ),
                            child: Center(
                                child: Text(
                                  lang['name']!,
                                  style: lang['code'] == 'ta'
                                      ? GoogleFonts.notoSansTamil(
                                          color: isSelected 
                                              ? Colors.white 
                                              : (isDark ? Colors.white : AppTheme.textDark),
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                          fontSize: 16,
                                        )
                                      : theme.textTheme.titleMedium?.copyWith(
                                          color: isSelected 
                                              ? Colors.white 
                                              : (isDark ? Colors.white : AppTheme.textDark),
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                        ),
                                ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Continue Button
                  ElevatedButton(
                    onPressed: _continue,
                    child: Text(l10n?.continueBtn ?? 'Continue'),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
