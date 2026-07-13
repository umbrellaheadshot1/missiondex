import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/note_provider.dart';
import '../../providers/question_provider.dart';
import '../../widgets/common/empty_state.dart';

/// Tela "Minhas Anotações": lista todas as anotações pessoais
/// (observações, testemunhos, experiências) já registradas, de todas
/// as perguntas, com as mais recentes primeiro.
///
/// Para editar/excluir uma anotação específica de uma pergunta, veja
/// a seção de anotações dentro de [QuestionDetailScreen] — esta tela
/// serve como uma visão consolidada de tudo que já foi escrito.
class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final noteProvider = context.watch<NoteProvider>();
    final questionProvider = context.watch<QuestionProvider>();

    final notes = List.of(noteProvider.notes)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Anotações')),
      body: notes.isEmpty
          ? const EmptyState(
              icon: Icons.edit_note_rounded,
              title: 'Nenhuma anotação ainda',
              subtitle: 'Adicione observações, testemunhos e experiências em cada pergunta.',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                final question = questionProvider.questions
                    .where((q) => q.id == note.questionId)
                    .firstOrNull;

                return Card(
                  child: ListTile(
                    title: Text(note.content),
                    subtitle: Text(
                      question != null
                          ? question.title
                          : 'Pergunta removida',
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'delete') {
                          context.read<NoteProvider>().deleteNote(note.id);
                        }
                        // 'edit' fica preparado para uma futura tela/diálogo
                        // de edição, reutilizando NoteProvider.updateNote.
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'edit', child: Text('Editar')),
                        PopupMenuItem(value: 'delete', child: Text('Excluir')),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
