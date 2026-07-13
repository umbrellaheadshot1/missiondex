import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/utils/reading_time_calculator.dart';
import '../../data/models/note_model.dart';
import '../../data/models/question_model.dart';
import '../../data/models/study_status.dart';
import '../../providers/favorite_provider.dart';
import '../../providers/note_provider.dart';
import '../../providers/question_provider.dart';
import '../../widgets/question/scripture_sections.dart';

/// Tela de detalhe completo de uma pergunta, seguindo a estrutura:
///
/// ❓ Pergunta · 💬 Resposta rápida (30s) · 📖 Resposta completa (2-5min)
/// · 📚 Escrituras (por seção) · 💡 Dica para o missionário ·
/// ⭐ Favoritar · 📝 Minhas Anotações (auto-save) · 🎯 Nível de domínio ·
/// ⏱ Tempo médio de leitura · 📅 Última revisão · 🔁 Revisar novamente
class QuestionDetailScreen extends StatefulWidget {
  final QuestionModel question;

  const QuestionDetailScreen({super.key, required this.question});

  @override
  State<QuestionDetailScreen> createState() => _QuestionDetailScreenState();
}

class _QuestionDetailScreenState extends State<QuestionDetailScreen> {
  late final TextEditingController _notesController;
  Timer? _debounce;
  NoteModel? _primaryNote;

  @override
  void initState() {
    super.initState();

    // "📅 Última revisão": registrada automaticamente ao abrir a tela.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuestionProvider>().markReviewed(widget.question.id);
    });

    final existingNotes = context.read<NoteProvider>().byQuestion(widget.question.id);
    _primaryNote = existingNotes.isNotEmpty ? existingNotes.first : null;
    _notesController = TextEditingController(text: _primaryNote?.content ?? '');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _notesController.dispose();
    super.dispose();
  }

  /// "As anotações devem ser salvas automaticamente": salva com um
  /// pequeno atraso (debounce) a cada alteração, sem precisar de botão.
  void _onNotesChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () async {
      final noteProvider = context.read<NoteProvider>();

      if (_primaryNote == null) {
        if (text.trim().isEmpty) return;
        final note = NoteModel(
          id: const Uuid().v4(),
          questionId: widget.question.id,
          content: text,
        );
        await noteProvider.addNote(note);
        _primaryNote = note;
      } else {
        _primaryNote!.content = text;
        await noteProvider.updateNote(_primaryNote!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.question;
    final favoriteProvider = context.watch<FavoriteProvider>();
    final questionProvider = context.read<QuestionProvider>();

    final isFavorite = favoriteProvider.isFavorite(question.id);
    final readingMinutes =
        ReadingTimeCalculator.estimateMinutes(question.combinedTextForReadingTime);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pergunta'),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.star_rounded : Icons.star_border_rounded),
            tooltip: 'Favoritar',
            onPressed: () => favoriteProvider.toggle(question.id),
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            tooltip: 'Compartilhar',
            onPressed: () => Share.share('${question.title}\n\n${question.fullAnswer}'),
          ),
          IconButton(
            icon: const Icon(Icons.copy_rounded),
            tooltip: 'Copiar texto',
            onPressed: () {
              Clipboard.setData(
                ClipboardData(text: '${question.title}\n\n${question.fullAnswer}'),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Texto copiado.')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ❓ Pergunta
          Row(
            children: [
              const Text('❓ ', style: TextStyle(fontSize: 18)),
              Expanded(
                child: Text(question.title, style: AppTextStyles.questionTitle(context)),
              ),
            ],
          ),

          const _SectionDivider(),

          // 💬 Resposta rápida (30 segundos)
          const _SectionLabel(emoji: '💬', title: 'Resposta rápida (30 segundos)'),
          const SizedBox(height: 8),
          Text(question.shortAnswer, style: AppTextStyles.body(context)),

          const _SectionDivider(),

          // 📖 Resposta completa (2 a 5 minutos)
          const _SectionLabel(emoji: '📖', title: 'Resposta completa (2 a 5 minutos)'),
          const SizedBox(height: 8),
          Text(question.fullAnswer, style: AppTextStyles.body(context)),

          const _SectionDivider(),

          // 📚 Escrituras
          const _SectionLabel(emoji: '📚', title: 'Escrituras'),
          const SizedBox(height: 4),
          ScriptureSections(scriptures: question.scriptures),

          const _SectionDivider(),

          // 💡 Dica para o missionário
          const _SectionLabel(emoji: '💡', title: 'Dica para o missionário'),
          const SizedBox(height: 8),
          Text(
            (question.tipForMissionary?.trim().isNotEmpty ?? false)
                ? question.tipForMissionary!
                : 'Nenhuma dica adicionada ainda.',
            style: AppTextStyles.body(context),
          ),

          const _SectionDivider(),

          // 📝 Minhas Anotações (salvamento automático)
          const _SectionLabel(emoji: '📝', title: 'Minhas Anotações'),
          const SizedBox(height: 8),
          TextField(
            controller: _notesController,
            maxLines: null,
            minLines: 3,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Escreva uma observação, testemunho ou experiência...',
            ),
            onChanged: _onNotesChanged,
          ),

          const _SectionDivider(),

          // 🎯 Nível de domínio
          const _SectionLabel(emoji: '🎯', title: 'Nível de domínio'),
          const SizedBox(height: 8),
          _MasteryLevelSelector(
            status: question.studyStatus,
            onChanged: (status) => questionProvider.updateStatus(question.id, status),
          ),

          const _SectionDivider(),

          // ⏱ Tempo médio de leitura
          Row(
            children: [
              const Text('⏱ ', style: TextStyle(fontSize: 16)),
              Text(
                'Tempo médio de leitura: ${ReadingTimeCalculator.formatLabel(readingMinutes)}',
                style: AppTextStyles.body(context),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 📅 Última revisão
          Row(
            children: [
              const Text('📅 ', style: TextStyle(fontSize: 16)),
              Text(
                'Última revisão: ${_formatLastReviewed(question.lastReviewedAt)}',
                style: AppTextStyles.body(context),
              ),
            ],
          ),

          const _SectionDivider(),

          // 🔁 Revisar novamente
          OutlinedButton.icon(
            icon: const Text('🔁'),
            label: const Text('Revisar novamente'),
            onPressed: () async {
              await questionProvider.queueForReview(question.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pergunta adicionada à fila de estudos.')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  String _formatLastReviewed(DateTime? date) {
    if (date == null) return 'ainda não revisada';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} às '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}

class _SectionLabel extends StatelessWidget {
  final String emoji;
  final String title;

  const _SectionLabel({required this.emoji, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 6),
        Text(title, style: AppTextStyles.sectionTitle(context)),
      ],
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Divider(height: 1),
    );
  }
}

/// Seletor "○ Não estudei / ○ Estudando / ○ Domino" pedido para o
/// Nível de domínio — reaproveita o enum [StudyStatus] já usado em todo
/// o app para badges e estatísticas.
class _MasteryLevelSelector extends StatelessWidget {
  final StudyStatus status;
  final ValueChanged<StudyStatus> onChanged;

  const _MasteryLevelSelector({required this.status, required this.onChanged});

  static const _labels = {
    StudyStatus.notStudied: 'Não estudei',
    StudyStatus.studying: 'Estudando',
    StudyStatus.mastered: 'Domino',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: StudyStatus.values.map((value) {
        return RadioListTile<StudyStatus>(
          contentPadding: EdgeInsets.zero,
          dense: true,
          title: Text(_labels[value]!),
          value: value,
          groupValue: status,
          onChanged: (v) => onChanged(v!),
        );
      }).toList(),
    );
  }
}
