import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Border? border;
  final double blur;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.padding,
    this.color,
    this.border,
    this.blur = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Default glass gradient based on theme
    final defaultGlassGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark 
          ? [
              Colors.white.withValues(alpha: 0.1),
              Colors.white.withValues(alpha: 0.02),
            ]
          : [
              Colors.white.withValues(alpha: 0.9),
              Colors.white.withValues(alpha: 0.4),
            ],
    );
        
    final defaultBorder = Border.all(
      color: isDark 
          ? Colors.white.withValues(alpha: 0.15) 
          : Colors.white.withValues(alpha: 0.9),
      width: 1.5,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: color,
              gradient: color == null ? defaultGlassGradient : null,
              borderRadius: BorderRadius.circular(borderRadius),
              border: border ?? defaultBorder,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
