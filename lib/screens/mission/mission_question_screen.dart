import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/models/question_model.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/mission/mission_big_button.dart';
import '../../widgets/question/scripture_sections.dart';

/// Tela de pergunta do Modo Missão: prioriza velocidade durante uma
/// conversa real — mostra primeiro a resposta curta (30s), com um
/// botão para expandir a resposta completa, escrituras rápidas,
/// compartilhamento e navegação para a próxima pergunta relacionada.
class MissionQuestionScreen extends StatefulWidget {
  final QuestionModel question;

  /// Lista de perguntas do mesmo contexto de busca/situação, usada
  /// pelo botão "Próxima Pergunta Relacionada" para continuar
  /// naturalmente a conversa sem voltar à tela de pesquisa.
  final List<QuestionModel> relatedQuestions;

  const MissionQuestionScreen({
    super.key,
    required this.question,
    required this.relatedQuestions,
  });

  @override
  State<MissionQuestionScreen> createState() => _MissionQuestionScreenState();
}

class _MissionQuestionScreenState extends State<MissionQuestionScreen> {
  bool _showFullAnswer = false;

  QuestionModel? get _nextQuestion {
    final currentIndex =
        widget.relatedQuestions.indexWhere((q) => q.id == widget.question.id);
    if (currentIndex == -1 || currentIndex + 1 >= widget.relatedQuestions.length) {
      return null;
    }
    return widget.relatedQuestions[currentIndex + 1];
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.question;
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modo Missão'),
        actions: [
          IconButton(
            icon: const Icon(Icons.text_increase_rounded),
            tooltip: 'Aumentar fonte',
            onPressed: () => context
                .read<SettingsProvider>()
                .setTextScale((settings.textScale + 0.1).clamp(0.85, 1.6)),
          ),
          IconButton(
            icon: const Icon(Icons.text_decrease_rounded),
            tooltip: 'Diminuir fonte',
            onPressed: () => context
                .read<SettingsProvider>()
                .setTextScale((settings.textScale - 0.1).clamp(0.85, 1.6)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            question.title,
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),

          // 💬 Resposta curta (30 segundos) — sempre visível primeiro.
          Text(
            question.shortAnswer,
            style: const TextStyle(fontSize: 18, height: 1.4),
          ),

          if (!_showFullAnswer) ...[
            const SizedBox(height: 16),
            MissionBigButton(
              icon: Icons.expand_more_rounded,
              label: 'Ver resposta completa',
              filled: false,
              onTap: () => setState(() => _showFullAnswer = true),
            ),
          ] else ...[
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              question.fullAnswer,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],

          if (question.scriptures.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              '📚 Escrituras',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            ScriptureSections(scriptures: question.scriptures),
            const SizedBox(height: 12),
            MissionBigButton(
              icon: Icons.share_rounded,
              label: 'Compartilhar Escritura',
              filled: false,
              onTap: () {
                final text = question.scriptures
                    .map((s) => '${s.book} ${s.reference}')
                    .join('\n');
                Share.share(text);
              },
            ),
          ],

          const SizedBox(height: 28),
          if (_nextQuestion != null)
            MissionBigButton(
              icon: Icons.arrow_forward_rounded,
              label: 'Próxima Pergunta Relacionada',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                    pageBuilder: (_, __, ___) => MissionQuestionScreen(
                      question: _nextQuestion!,
                      relatedQuestions: widget.relatedQuestions,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
