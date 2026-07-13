import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/question_model.dart';
import '../../providers/favorite_provider.dart';
import '../../providers/question_provider.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/question/question_card.dart';
import '../question/question_detail_screen.dart';

/// Tela exclusiva de Favoritos — organizada automaticamente pela data
/// em que cada pergunta foi favoritada (mais recentes primeiro),
/// com opção de remover diretamente da lista.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = context.watch<FavoriteProvider>();
    final questionProvider = context.watch<QuestionProvider>();

    // Monta a lista de perguntas favoritas preservando a ordem de
    // favoritado (mais recente primeiro) — vindo de FavoriteProvider.
    final questionsById = {for (final q in questionProvider.questions) q.id: q};
    final questions = favoriteProvider.favorites
        .map((f) => questionsById[f.questionId])
        .whereType<QuestionModel>()
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: questions.isEmpty
          ? const EmptyState(
              icon: Icons.star_border_rounded,
              title: 'Nenhum favorito ainda',
              subtitle: 'Toque na estrela de uma pergunta para adicioná-la aqui.',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                return QuestionCard(
                  question: question,
                  isFavorite: true,
                  onToggleFavorite: () => favoriteProvider.remove(question.id),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuestionDetailScreen(question: question),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
