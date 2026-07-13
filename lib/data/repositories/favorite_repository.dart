import '../../core/services/storage_service.dart';
import '../models/favorite_model.dart';

/// Repositório de Favoritos.
///
/// Guardamos apenas o vínculo (questionId -> data de favoritado); os
/// dados completos da pergunta são buscados via [QuestionRepository]
/// quando a tela de Favoritos precisar exibi-los.
class FavoriteRepository {
  final _box = StorageService.instance.favoritesBox;

  List<FavoriteModel> getAll() {
    final list = _box.values.toList();
    list.sort((a, b) => b.favoritedAt.compareTo(a.favoritedAt));
    return list;
  }

  bool isFavorite(String questionId) => _box.containsKey(questionId);

  Future<void> toggle(String questionId) async {
    if (_box.containsKey(questionId)) {
      await _box.delete(questionId);
    } else {
      await _box.put(questionId, FavoriteModel(questionId: questionId));
    }
  }

  Future<void> remove(String questionId) => _box.delete(questionId);
}
