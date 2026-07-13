import 'package:flutter/material.dart';

import '../data/models/question_model.dart';
import '../data/models/study_status.dart';
import '../data/repositories/question_repository.dart';

/// Provider de Perguntas — expõe todas as perguntas carregadas e
/// operações de CRUD, mantendo os widgets sempre sincronizados com
/// o armazenamento local.
class QuestionProvider extends ChangeNotifier {
  final _repository = QuestionRepository();

  List<QuestionModel> _questions = [];
  List<QuestionModel> get questions => _questions;

  void load() {
    _questions = _repository.getAll();
    notifyListeners();
  }

  List<QuestionModel> byCategory(String categoryId) {
    return _questions.where((q) => q.categoryId == categoryId).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  /// Todas as perguntas associadas a uma Situação (veja
  /// [QuestionModel.situationIds]), na ordem definida em cada pergunta.
  List<QuestionModel> bySituation(String situationId) {
    return _questions.where((q) => q.situationIds.contains(situationId)).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  Future<void> markReviewed(String id) async {
    await _repository.markReviewed(id);
    load();
  }

  Future<void> queueForReview(String id) async {
    await _repository.queueForReview(id);
    load();
  }

  Future<void> addQuestion(QuestionModel question) async {
    await _repository.add(question);
    load();
  }

  Future<void> updateQuestion(QuestionModel question) async {
    await _repository.update(question);
    load();
  }

  Future<void> updateStatus(String id, StudyStatus status) async {
    await _repository.updateStatus(id, status);
    load();
  }

  Future<void> deleteQuestion(String id) async {
    await _repository.delete(id);
    load();
  }
}
