import 'dart:convert';

import 'storage_service.dart';
import '../../data/models/category_model.dart';
import '../../data/models/question_model.dart';
import '../../data/models/scripture_reference_model.dart';
import '../../data/models/study_status.dart';
import '../../data/models/note_model.dart';

/// Serviço responsável por exportar e importar todo o conteúdo do
/// MissionDex (categorias, perguntas, escrituras e anotações) em um
/// único arquivo JSON.
///
/// Isso permite ao usuário guardar uma cópia de segurança do conteúdo
/// que ele mesmo inseriu, e restaurá-lo em outro aparelho/instalação.
/// A escrita/leitura do arquivo em si (escolher pasta, compartilhar o
/// arquivo, etc.) fica a cargo da tela de Configurações, que apenas
/// consome os métodos [exportToJson] e [importFromJson] abaixo.
class BackupService {
  BackupService._();
  static final BackupService instance = BackupService._();

  final _storage = StorageService.instance;

  /// Gera uma string JSON com todo o conteúdo atual do app.
  String exportToJson() {
    final data = {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'categories': _storage.categoriesBox.values
          .map((c) => {
                'id': c.id,
                'name': c.name,
                'description': c.description,
                'iconName': c.iconName,
                'order': c.order,
                'createdAt': c.createdAt.toIso8601String(),
              })
          .toList(),
      'questions': _storage.questionsBox.values
          .map((q) => {
                'id': q.id,
                'categoryId': q.categoryId,
                'title': q.title,
                'shortAnswer': q.shortAnswer,
                'fullAnswer': q.fullAnswer,
                'studyStatus': q.studyStatus.name,
                'order': q.order,
                'scriptures': q.scriptures
                    .map((s) => {
                          'id': s.id,
                          'book': s.book,
                          'reference': s.reference,
                          'excerpt': s.excerpt,
                        })
                    .toList(),
              })
          .toList(),
      'notes': _storage.notesBox.values
          .map((n) => {
                'id': n.id,
                'questionId': n.questionId,
                'content': n.content,
                'createdAt': n.createdAt.toIso8601String(),
              })
          .toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// Restaura o conteúdo a partir de um JSON gerado por [exportToJson].
  ///
  /// Por padrão, ADICIONA os dados (não apaga o conteúdo já existente),
  /// respeitando a instrução de nunca reescrever/apagar conteúdo do
  /// usuário sem autorização explícita. Um botão separado na tela de
  /// Configurações pode oferecer "Importar e substituir tudo" caso
  /// o usuário deseje isso conscientemente.
  Future<void> importFromJson(String jsonString, {bool replaceExisting = false}) async {
    final Map<String, dynamic> data = jsonDecode(jsonString) as Map<String, dynamic>;

    if (replaceExisting) {
      await _storage.categoriesBox.clear();
      await _storage.questionsBox.clear();
      await _storage.notesBox.clear();
    }

    for (final c in (data['categories'] as List? ?? [])) {
      final category = CategoryModel(
        id: c['id'],
        name: c['name'],
        description: c['description'],
        iconName: c['iconName'],
        order: c['order'] ?? 0,
        createdAt: DateTime.tryParse(c['createdAt'] ?? '') ?? DateTime.now(),
      );
      await _storage.categoriesBox.put(category.id, category);
    }

    for (final q in (data['questions'] as List? ?? [])) {
      final scriptures = (q['scriptures'] as List? ?? [])
          .map((s) => ScriptureReferenceModel(
                id: s['id'],
                book: s['book'],
                reference: s['reference'],
                excerpt: s['excerpt'],
              ))
          .toList();

      final question = QuestionModel(
        id: q['id'],
        categoryId: q['categoryId'],
        title: q['title'],
        shortAnswer: q['shortAnswer'],
        fullAnswer: q['fullAnswer'],
        scriptures: scriptures,
        studyStatus: StudyStatus.values.firstWhere(
          (s) => s.name == q['studyStatus'],
          orElse: () => StudyStatus.notStudied,
        ),
        order: q['order'] ?? 0,
      );
      await _storage.questionsBox.put(question.id, question);
    }

    for (final n in (data['notes'] as List? ?? [])) {
      final note = NoteModel(
        id: n['id'],
        questionId: n['questionId'],
        content: n['content'],
        createdAt: DateTime.tryParse(n['createdAt'] ?? '') ?? DateTime.now(),
      );
      await _storage.notesBox.put(note.id, note);
    }
  }
}
