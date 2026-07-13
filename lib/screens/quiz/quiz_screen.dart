import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_text_styles.dart';
import '../../providers/question_provider.dart';
import '../../providers/quiz_provider.dart';
import '../../widgets/common/empty_state.dart';

/// Tela do modo Quiz (estudo).
///
/// Fluxo pedido: mostra apenas a pergunta -> botão "Mostrar Resposta"
/// -> depois de revelada, botões "Já sei" e "Preciso revisar", que
/// avançam para a próxima pergunta da sessão e atualizam o status de
/// estudo + estatísticas automaticamente (via [QuizProvider]).
class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();
    final questionProvider = context.watch<QuestionProvider>();

    if (!quizProvider.hasSession) {
      return _StartSessionView(questions: questionProvider.questions);
    }

    if (quizProvider.isFinished) {
      return _SessionCompleteView(
        onRestart: () => context.read<QuizProvider>().resetSession(),
      );
    }

    final question = quizProvider.currentQuestion!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${quizProvider.currentIndex + 1} / ${quizProvider.sessionQuestions.length}',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pergunta', style: AppTextStyles.sectionTitle(context)),
            const SizedBox(height: 8),
            Text(question.title, style: AppTextStyles.questionTitle(context)),
            const SizedBox(height: 24),
            if (quizProvider.answerRevealed) ...[
              Text('Resposta', style: AppTextStyles.sectionTitle(context)),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(question.fullAnswer, style: AppTextStyles.body(context)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.read<QuizProvider>().answer(knewIt: false),
                      child: const Text('Preciso revisar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => context.read<QuizProvider>().answer(knewIt: true),
                      child: const Text('Já sei'),
                    ),
                  ),
                ],
              ),
            ] else ...[
              const Spacer(),
              FilledButton(
                onPressed: () => context.read<QuizProvider>().revealAnswer(),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text('Mostrar Resposta'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Tela exibida antes de iniciar uma sessão: escolher começar a
/// estudar com todas as perguntas disponíveis.
class _StartSessionView extends StatelessWidget {
  final List questions;

  const _StartSessionView({required this.questions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: questions.isEmpty
          ? const EmptyState(
              icon: Icons.psychology_outlined,
              title: 'Nenhuma pergunta disponível ainda',
              subtitle: 'Adicione perguntas às categorias para começar a estudar.',
            )
          : Center(
              child: FilledButton.icon(
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Iniciar sessão de estudo'),
                onPressed: () => context
                    .read<QuizProvider>()
                    .startSession(List.from(questions)),
              ),
            ),
    );
  }
}

class _SessionCompleteView extends StatelessWidget {
  final VoidCallback onRestart;

  const _SessionCompleteView({required this.onRestart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events_rounded,
                size: 56, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text('Sessão concluída!', style: AppTextStyles.sectionTitle(context)),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRestart, child: const Text('Voltar')),
          ],
        ),
      ),
    );
  }
}
