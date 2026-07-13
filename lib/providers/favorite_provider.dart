import 'package:flutter/material.dart';

import '../data/models/favorite_model.dart';
import '../data/repositories/favorite_repository.dart';

/// Provider de Favoritos.
class FavoriteProvider extends ChangeNotifier {
  final _repository = FavoriteRepository();

  List<FavoriteModel> _favorites = [];
  List<FavoriteModel> get favorites => _favorites;

  void load() {
    _favorites = _repository.getAll();
    notifyListeners();
  }

  bool isFavorite(String questionId) => _repository.isFavorite(questionId);

  Future<void> toggle(String questionId) async {
    await _repository.toggle(questionId);
    load();
  }

  Future<void> remove(String questionId) async {
    await _repository.remove(questionId);
    load();
  }
}
