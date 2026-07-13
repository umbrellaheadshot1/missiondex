import 'package:hive/hive.dart';

import 'scripture_reference_model.dart';
import 'study_status.dart';

part 'question_model.g.dart';

/// Representa uma pergunta e suas respostas dentro de uma categoria.
///
/// IMPORTANTE: nenhuma pergunta é criada automaticamente pelo app.
/// Todo o conteúdo (título, respostas, escrituras, dica) é inserido
/// pelo usuário posteriormente, exatamente como enviado — o app nunca
/// reescreve ou reformata o conteúdo por conta própria.
///
/// Campos de resposta seguem a nomenclatura pedida na tela da pergunta:
/// [shortAnswer] = "Resposta rápida (30 segundos)"
/// [fullAnswer]  = "Resposta completa (2 a 5 minutos)"
@HiveType(typeId: 3)
class QuestionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String categoryId;

  @HiveField(2)
  String title;

  @HiveField(3)
  String shortAnswer;

  @HiveField(4)
  String fullAnswer;

  @HiveField(5)
  List<ScriptureReferenceModel> scriptures;

  @HiveField(6)
  StudyStatus studyStatus;

  @HiveField(7)
  int order;

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  DateTime? updatedAt;

  /// "💡 Dica para o missionário" — erros comuns, como explicar de
  /// forma simples, exemplos, perguntas que ajudam a conversa, cuidados
  /// ao ensinar, sugestões de estudo. Texto único, livre, inserido pelo
  /// usuário.
  @HiveField(10)
  String? tipForMissionary;

  /// "📅 Última revisão" — atualizado automaticamente sempre que a tela
  /// de detalhe desta pergunta é aberta (veja
  /// QuestionRepository.markReviewed).
  @HiveField(11)
  DateTime? lastReviewedAt;

  /// Ids das Situações (veja SituationModel) às quais esta pergunta está
  /// associada. Uma pergunta pode pertencer a várias situações ao mesmo
  /// tempo (ex.: "Pessoa acredita somente na Bíblia" e "Pessoa tem
  /// dúvidas sobre Joseph Smith").
  @HiveField(12)
  List<String> situationIds;

  /// Palavras-chave adicionais para a pesquisa (campo "palavras_chave"
  /// do banco oficial), além do que já é buscado em título/respostas/
  /// escrituras — veja QuestionRepository.search.
  @HiveField(13)
  List<String> keywords;

  QuestionModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.shortAnswer,
    required this.fullAnswer,
    List<ScriptureReferenceModel>? scriptures,
    this.studyStatus = StudyStatus.notStudied,
    this.order = 0,
    DateTime? createdAt,
    this.updatedAt,
    this.tipForMissionary,
    this.lastReviewedAt,
    List<String>? situationIds,
    List<String>? keywords,
  })  : scriptures = scriptures ?? [],
        situationIds = situationIds ?? [],
        keywords = keywords ?? [],
        createdAt = createdAt ?? DateTime.now();

  /// Tempo estimado de leitura é calculado sob demanda (não armazenado),
  /// veja [ReadingTimeCalculator], para nunca ficar desatualizado caso
  /// o texto da resposta seja editado.
  String get combinedTextForReadingTime => '$shortAnswer\n$fullAnswer';
}
