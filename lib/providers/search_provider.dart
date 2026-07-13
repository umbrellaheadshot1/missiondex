import 'package:flutter/material.dart';

import '../data/models/question_model.dart';
import '../data/repositories/question_repository.dart';

/// Provider de Pesquisa instantânea.
///
/// Busca por palavra, tema, pergunta, resposta ou referência de
/// escritura (livro/versículo) — veja [QuestionRepository.search] para
/// os campos exatamente pesquisados.
class SearchProvider extends ChangeNotifier {
  final _repository = QuestionRepository();

  String _query = '';
  List<QuestionModel> _results = [];

  String get query => _query;
  List<QuestionModel> get results => _results;

  void search(String query) {
    _query = query;
    _results = query.trim().isEmpty ? [] : _repository.search(query);
    notifyListeners();
  }

  void clear() {
    _query = '';
    _results = [];
    notifyListeners();
  }
}
