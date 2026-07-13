import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/utils/reading_time_calculator.dart';
import '../../data/models/question_model.dart';
import 'study_status_badge.dart';

/// Card compacto de pergunta, usado em listas (tela de Categoria,
/// Favoritos, resultados de Pesquisa). Ao tocar, abre o detalhe
/// completo da pergunta.
class QuestionCard extends StatelessWidget {
  final QuestionModel question;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const QuestionCard({
    super.key,
    required this.question,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final readingMinutes =
        ReadingTimeCalculator.estimateMinutes(question.combinedTextForReadingTime);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      question.title,
                      style: AppTextStyles.questionTitle(context),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                      color: isFavorite ? Colors.amber : null,
                    ),
                    onPressed: onToggleFavorite,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                question.shortAnswer,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body(context),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  StudyStatusBadge(status: question.studyStatus),
                  const Spacer(),
                  Icon(Icons.schedule_rounded,
                      size: 14, color: Theme.of(context).colorScheme.outline),
                  const SizedBox(width: 4),
                  Text(
                    ReadingTimeCalculator.formatLabel(readingMinutes),
                    style: AppTextStyles.caption(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
