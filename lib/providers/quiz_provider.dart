import 'package:flutter/material.dart';

import '../data/models/question_model.dart';
import '../data/models/quiz_attempt_model.dart';
import '../data/models/study_status.dart';
import '../data/repositories/quiz_repository.dart';
import '../data/repositories/question_repository.dart';

/// Provider do modo Quiz (estudo).
///
/// Fluxo: mostra apenas a pergunta -> usuário revela a resposta ->
/// usuário escolhe "Já sei" ou "Preciso revisar" -> avança para a
/// próxima pergunta da sessão, registrando a tentativa para estatísticas
/// e atualizando o status de estudo da pergunta.
class QuizProvider extends ChangeNotifier {
  final _quizRepository = QuizRepository();
  final _questionRepository = QuestionRepository();

  List<QuestionModel> _sessionQuestions = [];
  int _currentIndex = 0;
  bool _answerRevealed = false;

  List<QuestionModel> get sessionQuestions => _sessionQuestions;
  int get currentIndex => _currentIndex;
  bool get answerRevealed => _answerRevealed;
  bool get hasSession => _sessionQuestions.isNotEmpty;
  bool get isFinished => _currentIndex >= _sessionQuestions.length;

  QuestionModel? get currentQuestion =>
      isFinished ? null : _sessionQuestions[_currentIndex];

  /// Inicia uma sessão de quiz com as perguntas fornecidas (de uma
  /// categoria específica ou de todas as perguntas, a depender da tela).
  void startSession(List<QuestionModel> questions) {
    _sessionQuestions = List.of(questions)..shuffle();
    _currentIndex = 0;
    _answerRevealed = false;
    notifyListeners();
  }

  void revealAnswer() {
    _answerRevealed = true;
    notifyListeners();
  }

  Future<void> answer({required bool knewIt}) async {
    final question = currentQuestion;
    if (question == null) return;

    await _quizRepository.record(
      QuizAttemptModel(questionId: question.id, knewIt: knewIt),
    );

    await _questionRepository.updateStatus(
      question.id,
      knewIt ? StudyStatus.mastered : StudyStatus.studying,
    );

    _currentIndex++;
    _answerRevealed = false;
    notifyListeners();
  }

  void resetSession() {
    _sessionQuestions = [];
    _currentIndex = 0;
    _answerRevealed = false;
    notifyListeners();
  }
}
