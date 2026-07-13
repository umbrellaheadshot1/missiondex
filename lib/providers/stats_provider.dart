import 'package:flutter/material.dart';

import '../data/models/study_status.dart';
import '../data/repositories/question_repository.dart';
import '../data/repositories/category_repository.dart';
import '../data/repositories/quiz_repository.dart';

/// Provider de Estatísticas — calcula, sob demanda, os números exibidos
/// na tela de Estatísticas (total de perguntas, perguntas estudadas,
/// categorias concluídas/pendentes, etc.).
///
/// Não armazenamos estatísticas pré-calculadas: tudo é derivado dos
/// dados reais de perguntas/categorias/tentativas de quiz, para nunca
/// ficar dessincronizado.
class StatsProvider extends ChangeNotifier {
  final _questionRepository = QuestionRepository();
  final _categoryRepository = CategoryRepository();
  final _quizRepository = QuizRepository();

  int get totalQuestions => _questionRepository.getAll().length;

  int get studiedQuestions => _questionRepository
      .getAll()
      .where((q) => q.studyStatus != StudyStatus.notStudied)
      .length;

  int get masteredQuestions => _questionRepository
      .getAll()
      .where((q) => q.studyStatus == StudyStatus.mastered)
      .length;

  /// Categorias em que todas as perguntas estão "Dominadas".
  List<String> get completedCategoryNames {
    final categories = _categoryRepository.getAll();
    return categories
        .where((c) {
          final questions = _questionRepository.getByCategory(c.id);
          if (questions.isEmpty) return false;
          return questions.every((q) => q.studyStatus == StudyStatus.mastered);
        })
        .map((c) => c.name)
        .toList();
  }

  /// Categorias com ao menos uma pergunta ainda não estudada.
  List<String> get pendingCategoryNames {
    final categories = _categoryRepository.getAll();
    return categories
        .where((c) {
          final questions = _questionRepository.getByCategory(c.id);
          return questions.any((q) => q.studyStatus == StudyStatus.notStudied);
        })
        .map((c) => c.name)
        .toList();
  }

  int get totalQuizAttempts => _quizRepository.getAll().length;

  void refresh() => notifyListeners();
}
