import '../../core/services/storage_service.dart';
import '../models/question_model.dart';
import '../models/study_status.dart';

/// Repositório de Perguntas.
///
/// Toda pergunta pertence a exatamente uma categoria ([categoryId]).
/// Nenhum método aqui gera conteúdo — apenas armazena/recupera o que
/// for explicitamente fornecido pelo usuário.
class QuestionRepository {
  final _box = StorageService.instance.questionsBox;

  List<QuestionModel> getAll() => _box.values.toList();

  List<QuestionModel> getByCategory(String categoryId) {
    final list = _box.values.where((q) => q.categoryId == categoryId).toList();
    list.sort((a, b) => a.order.compareTo(b.order));
    return list;
  }

  List<QuestionModel> getBySituation(String situationId) {
    final list = _box.values.where((q) => q.situationIds.contains(situationId)).toList();
    list.sort((a, b) => a.order.compareTo(b.order));
    return list;
  }

  QuestionModel? getById(String id) => _box.get(id);

  Future<void> add(QuestionModel question) => _box.put(question.id, question);

  Future<void> update(QuestionModel question) {
    question.updatedAt = DateTime.now();
    return _box.put(question.id, question);
  }

  Future<void> updateStatus(String id, StudyStatus status) async {
    final question = _box.get(id);
    if (question == null) return;
    question.studyStatus = status;
    question.updatedAt = DateTime.now();
    await question.save();
  }

  /// Registra que a pergunta foi aberta agora — usado para preencher
  /// "📅 Última revisão" automaticamente ao abrir a tela de detalhe.
  Future<void> markReviewed(String id) async {
    final question = _box.get(id);
    if (question == null) return;
    question.lastReviewedAt = DateTime.now();
    await question.save();
  }

  /// "🔁 Revisar novamente": devolve a pergunta para a fila de estudos,
  /// voltando o status de domínio para "Estudando" mesmo que já tivesse
  /// sido marcada como "Domino".
  Future<void> queueForReview(String id) async {
    final question = _box.get(id);
    if (question == null) return;
    question.studyStatus = StudyStatus.studying;
    await question.save();
  }

  Future<void> delete(String id) => _box.delete(id);

  /// Usado pela tela de Pesquisa: busca simples por texto em título,
  /// respostas e referências de escritura.
  List<QuestionModel> search(String query) {
    final lowerQuery = query.trim().toLowerCase();
    if (lowerQuery.isEmpty) return [];

    return _box.values.where((q) {
      final inTitle = q.title.toLowerCase().contains(lowerQuery);
      final inShort = q.shortAnswer.toLowerCase().contains(lowerQuery);
      final inFull = q.fullAnswer.toLowerCase().contains(lowerQuery);
      final inKeywords = q.keywords.any((k) => k.toLowerCase().contains(lowerQuery));
      final inScriptures = q.scriptures.any((s) =>
          s.book.toLowerCase().contains(lowerQuery) ||
          s.reference.toLowerCase().contains(lowerQuery) ||
          (s.excerpt?.toLowerCase().contains(lowerQuery) ?? false));

      return inTitle || inShort || inFull || inKeywords || inScriptures;
    }).toList();
  }
}
