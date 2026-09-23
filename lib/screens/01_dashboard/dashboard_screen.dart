import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:karigarsethu/core/constants.dart';
import 'package:karigarsethu/core/theme.dart';
import 'package:karigarsethu/services/mock_api_service.dart';
import 'package:karigarsethu/widgets/metric_card.dart';
import 'package:karigarsethu/widgets/glass_container.dart';
import 'package:karigarsethu/l10n/app_localizations.dart';
import 'dart:ui';
import 'profile_view.dart';
import '../add_product_screen.dart';

// This is the main Home/Dashboard screen.
// It is "Stateful" because it needs to load data from our Mock API when it opens.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  Map<String, dynamic> _metrics = {};

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  // Fetch the fake data from our service
  Future<void> _loadDashboardData() async {
    final metrics = await MockApiService.getDashboardMetrics();
    setState(() {
      _metrics = metrics;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: AppConstants.currencySymbol,
      decimalDigits: 0,
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(color: Colors.transparent),
          ),
        ),
        title: Text(l10n?.appTitle ?? 'KarigarSethu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Mesh Gradient Effect
          Positioned.fill(
            child: IgnorePointer(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60, tileMode: TileMode.decal),
                child: Stack(
                  children: [
                    Positioned(
                      top: -50,
                      left: -50,
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryTerracotta.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -50,
                      left: MediaQuery.of(context).size.width - 150,
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.accentJute.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -50,
                      right: -100,
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.accentTeal.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          SafeArea(
            bottom: false,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryTerracotta))
                : _buildBodyContent(currencyFormatter, l10n),
          ),
        ],
      ),
      
      // 4. Bottom Navigation Bar
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: GlassContainer(
            borderRadius: 50.0,
            color: AppTheme.primaryTerracotta.withValues(alpha: 0.15),
            border: Border.all(color: AppTheme.primaryTerracotta.withValues(alpha: 0.3), width: 1.5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppTheme.primaryTerracotta,
                unselectedItemColor: isDark ? Colors.white70 : AppTheme.textMuted,
                currentIndex: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.dashboard_outlined),
                    activeIcon: const Icon(Icons.dashboard),
                    label: l10n?.dashboardHome ?? 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.storefront_outlined),
                    activeIcon: const Icon(Icons.storefront),
                    label: l10n?.dashboardMarket ?? 'Market',
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.person_outline),
                    activeIcon: const Icon(Icons.person),
                    label: l10n?.dashboardProfile ?? 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBodyContent(NumberFormat currencyFormatter, AppLocalizations? l10n) {
    if (_selectedIndex == 2) {
      return const ProfileView();
    } else if (_selectedIndex == 1) {
      return const Center(
        child: Text('Marketplace coming soon!'),
      );
    }

    // Default: Dashboard / Home (_selectedIndex == 0)
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. The Large "Add New Product" Button
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddProductScreen()),
              );
            },
            child: SizedBox(
              width: double.infinity,
              child: GlassContainer(
                borderRadius: 50.0,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                color: AppTheme.primaryTerracotta.withValues(alpha: 0.8),
                border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, color: Colors.white, size: 24),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        l10n?.addNewProduct ?? 'Add New Product',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
            Text(
              l10n?.businessOverview ?? 'Business Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark 
                    ? AppTheme.textLight 
                    : AppTheme.textDark,
              ),
            ),
          const SizedBox(height: 16),

          // 2. Metrics (Products, Enquiries, Sales)
          Row(
            children: [
              Expanded(
                child: MetricCard(
                  title: l10n?.products ?? 'Products',
                  value: _metrics['totalProducts'].toString(),
                  icon: Icons.inventory_2_outlined,
                  color: AppTheme.secondaryIndigo,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: MetricCard(
                  title: l10n?.enquiries ?? 'Enquiries',
                  value: _metrics['newEnquiries'].toString(),
                  icon: Icons.chat_bubble_outline,
                  color: AppTheme.accentYellow,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          MetricCard(
            title: l10n?.totalSales ?? 'Total Sales (This Month)',
            value: currencyFormatter.format(_metrics['totalSales']),
            icon: Icons.trending_up,
            color: AppTheme.accentTeal,
          ),

          const SizedBox(height: 32),

          // 3. AI Insight Card
          GlassContainer(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryTerracotta,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.tips_and_updates, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n?.artisanInsight ?? 'Artisan Insight',
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark ? AppTheme.accentJute : AppTheme.secondaryIndigo,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n?.insightDescription ?? 'Your Terracotta Vases are receiving 30% more views than last week. Consider adding more clay products to your catalog to boost sales!',
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark 
                              ? AppTheme.textLight 
                              : AppTheme.textDark,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
