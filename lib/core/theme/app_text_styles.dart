import 'package:flutter/material.dart';

/// Estilos de texto reutilizáveis do MissionDex.
///
/// Usamos estilos relativos ao ColorScheme do contexto (não cores fixas)
/// para que tudo se adapte automaticamente entre modo claro e escuro.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle logo(BuildContext context) => TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: Theme.of(context).colorScheme.primary,
      );

  static TextStyle tagline(BuildContext context) => TextStyle(
        fontSize: 15,
        fontStyle: FontStyle.italic,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );

  static TextStyle questionTitle(BuildContext context) => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle sectionTitle(BuildContext context) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary,
      );

  static TextStyle body(BuildContext context) => TextStyle(
        fontSize: 15,
        height: 1.5,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle caption(BuildContext context) => TextStyle(
        fontSize: 12,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );
}
