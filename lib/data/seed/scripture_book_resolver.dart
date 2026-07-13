/// Identifica a qual dos livros de escritura padrão uma referência em
/// texto livre pertence (ex.: "2 Néfi 25:26" -> "Livro de Mórmon"),
/// usado para separar o campo único "escrituras" do banco oficial
/// (perguntas.json) nas seções fixas exibidas na tela da pergunta.
///
/// Não interpreta nem reescreve o conteúdo da referência em si — apenas
/// decide em qual seção ela deve aparecer.
class ScriptureBookResolver {
  ScriptureBookResolver._();

  // Livros/nomes do Livro de Mórmon.
  static const _bookOfMormon = [
    '1 néfi', '2 néfi', 'jacó', 'enos', 'jarom', 'omni',
    'palavras de mórmon', 'mosias', 'alma', 'helamã', '3 néfi', '4 néfi',
    'mórmon', 'éter', 'morôni',
  ];

  // Doutrina e Convênios.
  static const _dc = ['doutrina e convênios', 'd&c'];

  // Pérola de Grande Valor.
  static const _pearlOfGreatPrice = [
    'moisés', 'abraão', 'joseph smith—história', 'joseph smith - história',
    'joseph smith—mateus', 'artigos de fé', 'artigo de fé',
  ];

  /// Retorna o nome do livro (uma das 6 seções fixas) para a referência
  /// fornecida. Quando não reconhece o padrão, assume "Bíblia" — que é
  /// a origem da grande maioria dos livros/capítulos não listados acima
  /// (Antigo e Novo Testamento).
  static String resolve(String reference) {
    final normalized = reference.toLowerCase();

    for (final prefix in _dc) {
      if (normalized.contains(prefix)) return 'Doutrina e Convênios';
    }
    for (final prefix in _pearlOfGreatPrice) {
      if (normalized.contains(prefix)) return 'Pérola de Grande Valor';
    }
    for (final prefix in _bookOfMormon) {
      if (normalized.startsWith(prefix)) return 'Livro de Mórmon';
    }
    // Referências gerais que citam o livro pelo nome (ex.: "Introdução
    // do Livro de Mórmon", "Título do Livro de Mórmon") em vez de um
    // capítulo específico.
    if (normalized.contains('livro de mórmon')) return 'Livro de Mórmon';

    return 'Bíblia';
  }
}
