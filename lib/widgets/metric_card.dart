import 'package:flutter/material.dart';
import 'package:karigarsethu/core/theme.dart';

import 'package:karigarsethu/widgets/glass_container.dart';

// This is a reusable widget (a component) that displays a number and a label.
// It is used on the Dashboard to show 'Total Products', 'Total Sales', etc.
class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).brightness == Brightness.dark 
                        ? AppTheme.textMutedDark 
                        : AppTheme.textMutedLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).brightness == Brightness.dark 
                  ? AppTheme.textLight 
                  : AppTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
