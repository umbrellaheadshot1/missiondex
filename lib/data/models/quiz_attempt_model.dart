import 'package:hive/hive.dart';

part 'quiz_attempt_model.g.dart';

/// Um registro de tentativa no modo Quiz: o usuário viu a pergunta,
/// revelou a resposta e disse "Já sei" ou "Preciso revisar".
///
/// O histórico destes registros alimenta a tela de Estatísticas
/// (tempo estudado, categorias concluídas/pendentes, etc.).
@HiveType(typeId: 6)
class QuizAttemptModel extends HiveObject {
  @HiveField(0)
  final String questionId;

  @HiveField(1)
  final bool knewIt; // true = "Já sei" · false = "Preciso revisar"

  @HiveField(2)
  final DateTime answeredAt;

  QuizAttemptModel({
    required this.questionId,
    required this.knewIt,
    DateTime? answeredAt,
  }) : answeredAt = answeredAt ?? DateTime.now();
}
