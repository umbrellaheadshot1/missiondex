import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/situation_model.dart';
import '../../providers/question_provider.dart';
import '../../providers/favorite_provider.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/question/question_card.dart';
import '../question/question_detail_screen.dart';

/// Mostra automaticamente todas as perguntas associadas a uma Situação
/// (ex.: "Pessoa acredita somente na Bíblia" -> lista de perguntas
/// sobre suficiência da Bíblia, revelação contínua, etc.).
class SituationDetailScreen extends StatelessWidget {
  final SituationModel situation;

  const SituationDetailScreen({super.key, required this.situation});

  @override
  Widget build(BuildContext context) {
    final questionProvider = context.watch<QuestionProvider>();
    final favoriteProvider = context.watch<FavoriteProvider>();
    final questions = questionProvider.bySituation(situation.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(situation.name),
      ),
      body: questions.isEmpty
          ? const EmptyState(
              icon: Icons.help_outline_rounded,
              title: 'Nenhuma pergunta associada a esta situação ainda',
              subtitle:
                  'Vincule perguntas a esta situação através de '
                  'QuestionModel.situationIds.',
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
