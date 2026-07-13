import '../../core/services/storage_service.dart';
import '../models/note_model.dart';

/// Repositório de Anotações pessoais (observações, testemunhos,
/// experiências) vinculadas a perguntas.
class NoteRepository {
  final _box = StorageService.instance.notesBox;

  List<NoteModel> getAll() => _box.values.toList();

  List<NoteModel> getByQuestion(String questionId) {
    final list = _box.values.where((n) => n.questionId == questionId).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Future<void> add(NoteModel note) => _box.put(note.id, note);

  Future<void> update(NoteModel note) {
    note.updatedAt = DateTime.now();
    return _box.put(note.id, note);
  }

  Future<void> delete(String id) => _box.delete(id);
}
