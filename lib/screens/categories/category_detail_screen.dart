import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/category_model.dart';
import '../../providers/question_provider.dart';
import '../../providers/favorite_provider.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/question/question_card.dart';
import '../question/question_detail_screen.dart';

/// Tela de detalhe de uma categoria: lista todas as perguntas
/// pertencentes a ela, em ordem ([QuestionModel.order]).
class CategoryDetailScreen extends StatelessWidget {
  final CategoryModel category;

  const CategoryDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final questionProvider = context.watch<QuestionProvider>();
    final favoriteProvider = context.watch<FavoriteProvider>();
    final questions = questionProvider.byCategory(category.id);

    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: questions.isEmpty
          ? const EmptyState(
              icon: Icons.help_outline_rounded,
              title: 'Nenhuma pergunta nesta categoria ainda',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                return QuestionCard(
                  question: question,
                  isFavorite: favoriteProvider.isFavorite(question.id),
                  onToggleFavorite: () => favoriteProvider.toggle(question.id),
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
