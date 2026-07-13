import 'package:hive/hive.dart';

part 'situation_model.g.dart';

/// Representa uma "Situação" — um contexto de conversa missionária
/// (ex.: "Pessoa é evangélica", "Contato de rua", "Pessoa está
/// desanimada"). Cada Situação agrupa perguntas relacionadas através de
/// [QuestionModel.situationIds], permitindo que o missionário encontre
/// rapidamente o conteúdo mais adequado para aquele tipo de conversa.
///
/// O sistema suporta um número ilimitado de Situações — novas Situações
/// são apenas novos registros desta classe, nunca exigem alteração de
/// código. Nenhuma Situação é criada automaticamente pelo app.
@HiveType(typeId: 7)
class SituationModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  /// Emoji ou nome de ícone usado como identificador visual da situação
  /// (ex.: '🏠', '✝️'). Guardado como texto livre para máxima flexibilidade.
  @HiveField(2)
  String? icon;

  @HiveField(3)
  String? description;

  @HiveField(4)
  int order;

  @HiveField(5)
  final DateTime createdAt;

  SituationModel({
    required this.id,
    required this.name,
    this.icon,
    this.description,
    this.order = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
