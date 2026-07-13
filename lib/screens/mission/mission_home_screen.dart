import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/question_model.dart';
import '../../data/models/situation_model.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/question_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/situation_provider.dart';
import '../../widgets/common/empty_state.dart';
import 'mission_question_screen.dart';

/// Home do Modo Missão.
///
/// Abre diretamente na pesquisa (sem menus intermediários), permite
/// filtrar por Situação com um toque, e qualquer pergunta é aberta em
/// no máximo dois toques: (1) digitar/tocar num filtro, (2) tocar no
/// resultado.
class MissionHomeScreen extends StatefulWidget {
  const MissionHomeScreen({super.key});

  @override
  State<MissionHomeScreen> createState() => _MissionHomeScreenState();
}

class _MissionHomeScreenState extends State<MissionHomeScreen> {
  final _controller = TextEditingController();
  String _query = '';
  SituationModel? _selectedSituation;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<QuestionModel> _filteredQuestions(QuestionProvider questionProvider) {
    Iterable<QuestionModel> base = _selectedSituation != null
        ? questionProvider.bySituation(_selectedSituation!.id)
        : questionProvider.questions;

    if (_query.trim().isEmpty) return base.toList();

    final lowerQuery = _query.trim().toLowerCase();
    return base.where((q) {
      return q.title.toLowerCase().contains(lowerQuery) ||
          q.shortAnswer.toLowerCase().contains(lowerQuery) ||
          q.fullAnswer.toLowerCase().contains(lowerQuery) ||
          q.keywords.any((k) => k.toLowerCase().contains(lowerQuery)) ||
          q.scriptures.any((s) =>
              s.book.toLowerCase().contains(lowerQuery) ||
              s.reference.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final questionProvider = context.watch<QuestionProvider>();
    final situationProvider = context.watch<SituationProvider>();
    final results = _filteredQuestions(questionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modo Missão'),
        actions: [
          IconButton(
            icon: const Icon(Icons.school_rounded),
            tooltip: 'Voltar ao Modo Estudo',
            onPressed: () =>
                context.read<SettingsProvider>().setMissionModeEnabled(false),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              AppConstants.officialDisclaimer,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _controller,
              autofocus: true,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                hintText: 'Pesquisar por palavra-chave...',
                prefixIcon: const Icon(Icons.search_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                filled: true,
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),

          // Filtro rápido por Situação (Ateu, Evangélico, Bíblia, etc.).
          if (situationProvider.situations.isNotEmpty)
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  ChoiceChip(
                    label: const Text('Todas'),
                    selected: _selectedSituation == null,
                    onSelected: (_) => setState(() => _selectedSituation = null),
                  ),
                  const SizedBox(width: 8),
                  for (final situation in situationProvider.situations) ...[
                    ChoiceChip(
                      avatar: situation.icon != null ? Text(situation.icon!) : null,
                      label: Text(situation.name),
                      selected: _selectedSituation?.id == situation.id,
                      onSelected: (_) => setState(() => _selectedSituation = situation),
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),

          const SizedBox(height: 8),

          Expanded(
            child: results.isEmpty
                ? const EmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'Nenhuma pergunta encontrada',
                    subtitle: 'Ajuste a pesquisa ou o filtro de situação.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final question = results[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                                pageBuilder: (_, __, ___) => MissionQuestionScreen(
                                  question: question,
                                  relatedQuestions: results,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Text(
                              question.title,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
