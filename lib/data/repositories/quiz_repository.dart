import '../../core/services/storage_service.dart';
import '../models/quiz_attempt_model.dart';

/// Repositório de tentativas do modo Quiz. Cada vez que o usuário
/// responde "Já sei" ou "Preciso revisar", um registro é adicionado
/// aqui — esse histórico alimenta a tela de Estatísticas.
class QuizRepository {
  final _box = StorageService.instance.quizAttemptsBox;

  List<QuizAttemptModel> getAll() => _box.values.toList();

  Future<void> record(QuizAttemptModel attempt) => _box.add(attempt);

  /// Retorna a última tentativa registrada para uma pergunta, se houver.
  QuizAttemptModel? lastAttemptFor(String questionId) {
    final attempts = _box.values.where((a) => a.questionId == questionId).toList();
    if (attempts.isEmpty) return null;
    attempts.sort((a, b) => b.answeredAt.compareTo(a.answeredAt));
    return attempts.first;
  }
}
