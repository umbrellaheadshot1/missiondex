import '../constants/app_constants.dart';

/// Calcula o tempo estimado de leitura de um texto, em minutos.
///
/// Usado automaticamente ao salvar/exibir uma pergunta, para preencher
/// o campo "Tempo estimado de leitura" sem que o usuário precise
/// informar isso manualmente.
class ReadingTimeCalculator {
  ReadingTimeCalculator._();

  static int estimateMinutes(String text) {
    if (text.trim().isEmpty) return 0;
    final wordCount = text.trim().split(RegExp(r'\s+')).length;
    final minutes = wordCount / AppConstants.averageWordsPerMinute;
    // Arredonda para cima e garante no mínimo 1 minuto para textos curtos.
    return minutes.ceil().clamp(1, 999);
  }

  static String formatLabel(int minutes) {
    return minutes == 1 ? '1 min de leitura' : '$minutes min de leitura';
  }
}
