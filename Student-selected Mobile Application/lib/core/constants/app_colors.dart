import 'package:flutter/material.dart';

class AppColors {
  // Soft, Fresh, Modern Pastel/Mint Palette for Dashboard
  static const Color primary = Color(0xFF10B981); // Fresh Vibrant Emerald
  static const Color primaryDark = Color(0xFF059669);
  static const Color primaryLight = Color(0xFFECFDF5); // Soft Mint cream
  static const Color primaryGradientStart = Color(0xFF34D399); // Soft light emerald
  static const Color primaryGradientEnd = Color(0xFF059669);   // Deep mint accent

  static const Color secondary = Color(0xFF38BDF8); // Sky blue
  static const Color accent = Color(0xFF6366F1); // Soft indigo

  // Status & Transaction Colors
  static const Color income = Color(0xFF10B981); // Bright Emerald
  static const Color expense = Color(0xFFF43F5E); // Soft Coral
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF0EA5E9);

  // Clean, Airy Light Palette
  static const Color lightBg = Color(0xFFF8FAFC); // Very soft clean white/slate
  static const Color lightSurface = Colors.white;
  static const Color lightCard = Colors.white;
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Dark Palette (if toggled)
  static const Color darkBg = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkCard = Color(0xFF334155);

  // Typography Colors
  static const Color textPrimaryLight = Color(0xFF1E293B);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
}
