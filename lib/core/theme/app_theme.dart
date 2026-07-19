import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'instant_page_transitions_builder.dart';

/// Fábrica central dos temas claro e escuro do MissionDex.
///
/// [textScale] vem das Configurações (acessibilidade — fonte ajustável)
/// e é aplicado a todo o app através do TextTheme, sem precisar mexer
/// em cada tela individualmente.
///
/// [reducedMotion] é ativado automaticamente quando o Modo Missão está
/// ligado: as transições de tela passam a ser instantâneas, para abrir
/// qualquer pergunta o mais rápido possível durante uma conversa real.
class AppTheme {
  AppTheme._();

  static ThemeData light({
    double textScale = 1.0,
    bool highContrast = false,
    bool reducedMotion = false,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: Brightness.light,
      contrastLevel: highContrast ? 1.0 : 0.0,
    );
    return _base(scheme, textScale, reducedMotion);
  }

  static ThemeData dark({
    double textScale = 1.0,
    bool highContrast = false,
    bool reducedMotion = false,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: Brightness.dark,
      contrastLevel: highContrast ? 1.0 : 0.0,
    );
    return _base(scheme, textScale, reducedMotion);
  }

  static ThemeData _base(ColorScheme scheme, double textScale, bool reducedMotion) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,

      // Fonte ajustável (acessibilidade) sem depender do textScale do SO.
      textTheme: Typography.material2021(platform: TargetPlatform.android)
          .black
          .apply(fontSizeFactor: textScale),

      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: scheme.surfaceTint,
      ),

      cardTheme: CardThemeData(
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // Transições suaves e consistentes entre telas em todas as plataformas
      // (ou instantâneas, quando o Modo Missão pede movimento reduzido).
      pageTransitionsTheme: reducedMotion
          ? const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: InstantPageTransitionsBuilder(),
                TargetPlatform.iOS: InstantPageTransitionsBuilder(),
              },
            )
          : const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: ZoomPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
    );
  }
}
