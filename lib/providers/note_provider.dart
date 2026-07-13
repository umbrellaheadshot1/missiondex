import 'package:flutter/material.dart';

import '../data/models/note_model.dart';
import '../data/repositories/note_repository.dart';

/// Provider de Anotações pessoais (observações, testemunhos, experiências).
class NoteProvider extends ChangeNotifier {
  final _repository = NoteRepository();

  List<NoteModel> _notes = [];
  List<NoteModel> get notes => _notes;

  void load() {
    _notes = _repository.getAll();
    notifyListeners();
  }

  List<NoteModel> byQuestion(String questionId) => _repository.getByQuestion(questionId);

  Future<void> addNote(NoteModel note) async {
    await _repository.add(note);
    load();
  }

  Future<void> updateNote(NoteModel note) async {
    await _repository.update(note);
    load();
  }

  Future<void> deleteNote(String id) async {
    await _repository.delete(id);
    load();
  }
}
