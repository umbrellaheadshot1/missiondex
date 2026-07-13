import 'package:hive/hive.dart';

part 'favorite_model.g.dart';

/// Registro de favorito. Guardamos apenas o vínculo com o id da
/// pergunta e a data em que foi favoritada, para permitir ordenar
/// a tela de Favoritos por "mais recentes".
@HiveType(typeId: 5)
class FavoriteModel extends HiveObject {
  @HiveField(0)
  final String questionId;

  @HiveField(1)
  final DateTime favoritedAt;

  FavoriteModel({
    required this.questionId,
    DateTime? favoritedAt,
  }) : favoritedAt = favoritedAt ?? DateTime.now();
}
