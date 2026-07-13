import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../providers/question_provider.dart';
import '../../widgets/common/empty_state.dart';

/// Tela "Escrituras": lista os livros de escritura disponíveis
/// ([AppConstants.defaultScriptureBooks] + quaisquer outros que o
/// usuário tenha usado em alguma pergunta) e, ao tocar em um livro,
/// mostra todas as perguntas que possuem referências daquele livro.
///
/// Nenhum texto de escritura é armazenado pelo app por padrão — apenas
/// as referências que o próprio usuário anexar a cada pergunta.
class ScripturesScreen extends StatelessWidget {
  const ScripturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final questionProvider = context.watch<QuestionProvider>();

    final booksInUse = <String>{
      ...AppConstants.defaultScriptureBooks,
      for (final q in questionProvider.questions)
        for (final s in q.scriptures) s.book,
    }.toList()
      ..sort();

    return Scaffold(
      appBar: AppBar(title: const Text('Escrituras')),
      body: booksInUse.isEmpty
          ? const EmptyState(
              icon: Icons.auto_stories_rounded,
              title: 'Nenhuma escritura cadastrada ainda',
              subtitle:
                  'As referências aparecem aqui conforme forem adicionadas às perguntas.',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: booksInUse.length,
              itemBuilder: (context, index) {
                final book = booksInUse[index];
                final count = questionProvider.questions
                    .where((q) => q.scriptures.any((s) => s.book == book))
                    .length;

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.menu_book_rounded),
                    title: Text(book),
                    subtitle: Text(
                      count == 1 ? '1 pergunta referenciada' : '$count perguntas referenciadas',
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      // TODO: navegar para uma lista filtrada de perguntas
                      // que referenciam este livro (reaproveitando o
                      // QuestionCard já existente).
                    },
                  ),
                );
              },
            ),
    );
  }
}
