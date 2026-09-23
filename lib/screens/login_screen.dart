import 'package:flutter/material.dart';
import 'package:karigarsethu/l10n/app_localizations.dart';
import '../core/theme.dart';
import '../core/constants.dart';
import '../widgets/glass_container.dart';
import '../widgets/language_dropdown.dart';
import '01_dashboard/dashboard_screen.dart';
import '../main.dart'; // For localeNotifier

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
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
          // Background Gradient / Pattern
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
          
          // Decorative Shapes
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryTerracotta.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.accentTeal.withValues(alpha: 0.1),
              ),
            ),
          ),
          
          // Language Dropdown in Top Right
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 16.0),
                child: GlassContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  borderRadius: 20.0,
                  color: isDark ? Colors.white10 : Colors.white60,
                  child: LanguageDropdown(isDarkTheme: isDark),
                ),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // App Logo / Title
                    Icon(
                      Icons.storefront_rounded,
                      size: 64,
                      color: AppTheme.primaryTerracotta,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n?.appTitle ?? 'KarigarSethu',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: AppTheme.primaryTerracotta,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n?.appTagline ?? AppConstants.appTagline,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Login Card (Glassmorphism)
                    GlassContainer(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l10n?.loginWelcome ?? 'Welcome Back',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Phone Number Field
                          TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: l10n?.phoneNumber ?? 'Phone Number',
                              prefixIcon: const Icon(Icons.phone_outlined),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Password Field
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: l10n?.password ?? 'Password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: isDark ? AppTheme.textMutedDark : AppTheme.textMutedLight,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                foregroundColor: AppTheme.primaryTerracotta,
                                textStyle: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              child: Text(l10n?.forgotPassword ?? 'Forgot Password?'),
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Login Button
                          ElevatedButton(
                            onPressed: _handleLogin,
                            child: Text(l10n?.login ?? 'Login'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Register link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            l10n?.registerPrompt ?? 'New to KarigarSethu?',
                            style: theme.textTheme.bodyMedium,
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Flexible(
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              foregroundColor: AppTheme.primaryTerracotta,
                              textStyle: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            child: Text(
                              l10n?.registerNow ?? 'Register Now',
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
