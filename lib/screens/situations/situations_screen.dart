import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/situation_provider.dart';
import '../../providers/question_provider.dart';
import '../../widgets/common/empty_state.dart';
import 'situation_detail_screen.dart';

/// Tela "🧭 Situações": lista os contextos de conversa missionária
/// cadastrados (ex.: "Pessoa é evangélica", "Contato de rua"...).
///
/// Ao tocar em uma situação, o app mostra automaticamente todas as
/// perguntas associadas a ela (via [QuestionModel.situationIds]).
/// Nenhuma situação de exemplo é criada por padrão — a lista é
/// preenchida conforme o usuário adicionar novas situações.
class SituationsScreen extends StatelessWidget {
  const SituationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final situationProvider = context.watch<SituationProvider>();
    final questionProvider = context.watch<QuestionProvider>();
    final situations = situationProvider.situations;

    return Scaffold(
      appBar: AppBar(title: const Text('Situações')),
      body: situations.isEmpty
          ? const EmptyState(
              icon: Icons.explore_outlined,
              title: 'Nenhuma situação cadastrada ainda',
              subtitle:
                  'Situações agrupam perguntas por contexto de conversa (ex.: '
                  '"Pessoa é evangélica", "Contato de rua").',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: situations.length,
              itemBuilder: (context, index) {
                final situation = situations[index];
                final questionCount = questionProvider.bySituation(situation.id).length;

                return Card(
                  child: ListTile(
                    leading: situation.icon != null
                        ? Text(situation.icon!, style: const TextStyle(fontSize: 22))
                        : const Icon(Icons.explore_rounded),
                    title: Text(situation.name),
                    subtitle: Text(
                      questionCount == 1
                          ? '1 pergunta relacionada'
                          : '$questionCount perguntas relacionadas',
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SituationDetailScreen(situation: situation),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
