import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/language_dropdown.dart';
import '../login_screen.dart';
import 'package:karigarsethu/l10n/app_localizations.dart';
import '../../main.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  void _handleLogout(BuildContext context) {
    // Navigate back to the login screen and clear navigation history
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n?.dashboardProfile ?? 'Profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? AppTheme.textLight : AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 32),
            
            // Profile Card
            GlassContainer(
              padding: const EdgeInsets.all(24.0),
              color: isDark ? Colors.white10 : Colors.white60,
              border: Border.all(
                color: AppTheme.borderSubtle,
                width: 1.5,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: AppTheme.primaryTerracotta.withValues(alpha: 0.2),
                    child: const Icon(
                      Icons.person,
                      size: 48,
                      color: AppTheme.primaryTerracotta,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n?.artisanUser ?? 'Artisan User',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '+91 98765 43210',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Settings & Actions
            GlassContainer(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              color: isDark ? Colors.white10 : Colors.white60,
              border: Border.all(
                color: AppTheme.borderSubtle,
                width: 1.5,
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.language, color: isDark ? AppTheme.textLight : AppTheme.secondaryIndigo),
                    title: Text(l10n?.selectLanguage ?? 'Select Language'),
                    trailing: LanguageDropdown(isDarkTheme: isDark),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.dark_mode_outlined, color: isDark ? AppTheme.textLight : AppTheme.secondaryIndigo),
                    title: Text(l10n?.theme ?? 'Theme'),
                    trailing: ValueListenableBuilder<ThemeMode>(
                      valueListenable: themeNotifier,
                      builder: (context, themeMode, _) {
                        return GlassContainer(
                          borderRadius: 12.0,
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
                          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.2),
                          border: Border.all(
                            color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.4),
                            width: 1.0,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<ThemeMode>(
                              borderRadius: BorderRadius.circular(24.0),
                              elevation: 8,
                              value: themeMode,
                              icon: Icon(
                                Icons.dark_mode, 
                                color: isDark ? Colors.white : AppTheme.primaryTerracotta,
                                size: 20,
                              ),
                              dropdownColor: isDark 
                                  ? AppTheme.backgroundDark.withValues(alpha: 0.95) 
                                  : Colors.white.withValues(alpha: 0.95),
                              style: TextStyle(
                                color: isDark ? Colors.white : AppTheme.textDark,
                                fontWeight: FontWeight.w600,
                              ),
                              onChanged: (ThemeMode? newMode) {
                                if (newMode != null) {
                                  themeNotifier.setTheme(newMode);
                                }
                              },
                              items: [
                                DropdownMenuItem(
                                  value: ThemeMode.system,
                                  child: Text(l10n?.themeSystem ?? 'System Default'),
                                ),
                                DropdownMenuItem(
                                  value: ThemeMode.light,
                                  child: Text(l10n?.themeLight ?? 'Light'),
                                ),
                                DropdownMenuItem(
                                  value: ThemeMode.dark,
                                  child: Text(l10n?.themeDark ?? 'Dark'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.settings_outlined, color: isDark ? AppTheme.textLight : AppTheme.secondaryIndigo),
                    title: Text(l10n?.settings ?? 'Settings'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.help_outline, color: isDark ? AppTheme.textLight : AppTheme.secondaryIndigo),
                    title: Text(l10n?.helpSupport ?? 'Help & Support'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.redAccent),
                    title: Text(
                      l10n?.logout ?? 'Logout',
                      style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                    ),
                    onTap: () => _handleLogout(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
