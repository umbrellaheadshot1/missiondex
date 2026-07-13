import 'package:hive/hive.dart';

part 'note_model.g.dart';

/// Anotação pessoal (observação, testemunho, experiência) vinculada
/// a uma pergunta específica. Uma pergunta pode ter várias anotações.
@HiveType(typeId: 4)
class NoteModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String questionId;

  @HiveField(2)
  String content;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  DateTime? updatedAt;

  NoteModel({
    required this.id,
    required this.questionId,
    required this.content,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
