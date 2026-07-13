import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Gráfico de pizza simples mostrando a proporção de perguntas
/// estudadas vs. não estudadas (ou dominadas vs. em estudo, conforme
/// os dados passados pela tela de Estatísticas).
class StatsPieChart extends StatelessWidget {
  final Map<String, double> data;
  final Map<String, Color> colors;

  const StatsPieChart({super.key, required this.data, required this.colors});

  @override
  Widget build(BuildContext context) {
    final total = data.values.fold<double>(0, (sum, v) => sum + v);

    if (total == 0) {
      return const SizedBox(
        height: 180,
        child: Center(child: Text('Sem dados suficientes ainda.')),
      );
    }

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sectionsSpace: 3,
          centerSpaceRadius: 40,
          sections: data.entries.map((entry) {
            final percentage = (entry.value / total * 100);
            return PieChartSectionData(
              value: entry.value,
              title: '${percentage.toStringAsFixed(0)}%',
              color: colors[entry.key] ?? Colors.grey,
              radius: 60,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
