/// Constantes globais do MissionDex.
///
/// Centralizamos aqui os nomes das "boxes" (tabelas) do Hive e outros
/// valores fixos usados em múltiplos lugares do app, para evitar
/// strings mágicas espalhadas pelo código.
class AppConstants {
  AppConstants._();

  static const String appName = 'MissionDex';
  static const String appTagline = 'O evangelho restaurado ao alcance das mãos.';

  /// Aviso exibido logo na tela inicial, deixando claro desde o
  /// primeiro contato que este é um projeto pessoal e não um aplicativo
  /// oficial de A Igreja de Jesus Cristo dos Santos dos Últimos Dias —
  /// para que ninguém confunda o conteúdo com uma posição oficial da
  /// Igreja.
  static const String officialDisclaimer =
      'Aplicativo pessoal, não oficial e sem qualquer vínculo com '
      'A Igreja de Jesus Cristo dos Santos dos Últimos Dias.';

  // --- Nomes das boxes do Hive (banco local offline) ---
  static const String boxCategories = 'categories_box';
  static const String boxQuestions = 'questions_box';
  static const String boxNotes = 'notes_box';
  static const String boxFavorites = 'favorites_box';
  static const String boxSituations = 'situations_box';
  static const String boxStudyStatus = 'study_status_box';
  static const String boxQuizStats = 'quiz_stats_box';
  static const String boxSettings = 'settings_box';

  // --- Palavras por minuto usadas para estimar tempo de leitura ---
  static const int averageWordsPerMinute = 200;

  // --- Livros de escritura padrão (o usuário pode adicionar mais depois) ---
  static const List<String> defaultScriptureBooks = [
    'Bíblia',
    'Livro de Mórmon',
    'Doutrina e Convênios',
    'Pérola de Grande Valor',
    'Pregai Meu Evangelho',
    'Manual Geral',
    'Conferências Gerais',
  ];
}
