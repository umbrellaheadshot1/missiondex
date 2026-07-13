import 'package:flutter/material.dart';

/// Paleta de cores centralizada do MissionDex.
///
/// Trocar a identidade visual do app inteiro deve significar mudar
/// apenas os valores deste arquivo — nenhuma tela deve usar cores
/// "soltas" (Color(0xFF...)) diretamente.
class AppColors {
  AppColors._();

  // Cor-semente (seed color) usada pelo Material 3 para gerar todo o
  // esquema de cores claro/escuro automaticamente.
  static const Color seed = Color(0xFF2E5B4F); // verde profundo, sóbrio

  static const Color success = Color(0xFF3A8F5B); // "Já sei" / Dominada
  static const Color warning = Color(0xFFC98A2C); // "Preciso revisar"
  static const Color danger = Color(0xFFB3452E); // ações destrutivas

  static const Color favorite = Color(0xFFD8A93B); // estrela de favorito

  // Cores auxiliares para os status de estudo de cada pergunta.
  static const Color statusNotStudied = Color(0xFF9AA5A0);
  static const Color statusStudying = Color(0xFF4E8CBF);
  static const Color statusMastered = Color(0xFF3A8F5B);
}
