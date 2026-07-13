import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/stats_provider.dart';
import '../../widgets/stats/stats_pie_chart.dart';

/// Tela de Estatísticas: total de perguntas, quantas foram estudadas,
/// categorias concluídas/pendentes, e um gráfico visual do progresso.
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<StatsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Estatísticas')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Total de perguntas',
                  value: '${stats.totalQuestions}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  label: 'Estudadas',
                  value: '${stats.studiedQuestions}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Progresso geral', style: AppTextStyles.sectionTitle(context)),
          const SizedBox(height: 12),
          StatsPieChart(
            data: {
              'Dominadas': stats.masteredQuestions.toDouble(),
              'Em estudo': (stats.studiedQuestions - stats.masteredQuestions).toDouble(),
              'Não estudadas':
                  (stats.totalQuestions - stats.studiedQuestions).toDouble(),
            },
            colors: const {
              'Dominadas': AppColors.statusMastered,
              'Em estudo': AppColors.statusStudying,
              'Não estudadas': AppColors.statusNotStudied,
            },
          ),
          const SizedBox(height: 24),
          Text('Categorias concluídas', style: AppTextStyles.sectionTitle(context)),
          const SizedBox(height: 8),
          if (stats.completedCategoryNames.isEmpty)
            Text('Nenhuma ainda.', style: AppTextStyles.caption(context))
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: stats.completedCategoryNames
                  .map((name) => Chip(label: Text(name)))
                  .toList(),
            ),
          const SizedBox(height: 24),
          Text('Categorias pendentes', style: AppTextStyles.sectionTitle(context)),
          const SizedBox(height: 8),
          if (stats.pendingCategoryNames.isEmpty)
            Text('Nenhuma ainda.', style: AppTextStyles.caption(context))
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: stats.pendingCategoryNames
                  .map((name) => Chip(label: Text(name)))
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(label, style: AppTextStyles.caption(context)),
          ],
        ),
      ),
    );
  }
}
