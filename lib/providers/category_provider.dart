import 'package:flutter/material.dart';

import '../data/models/category_model.dart';
import '../data/repositories/category_repository.dart';

/// Provider de Categorias — expõe a lista de categorias para a UI e
/// concentra as operações de criar/editar/remover.
///
/// Nenhuma categoria de exemplo é criada automaticamente: [load] apenas
/// lê o que já existir no armazenamento local.
class CategoryProvider extends ChangeNotifier {
  final _repository = CategoryRepository();

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  void load() {
    _categories = _repository.getAll();
    notifyListeners();
  }

  Future<void> addCategory(CategoryModel category) async {
    await _repository.add(category);
    load();
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _repository.update(category);
    load();
  }

  Future<void> deleteCategory(String id) async {
    await _repository.delete(id);
    load();
  }
}
