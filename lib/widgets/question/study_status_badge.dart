import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/study_status.dart';

/// Selo visual (chip) que indica o status de estudo de uma pergunta:
/// Não estudada / Em estudo / Dominada.
class StudyStatusBadge extends StatelessWidget {
  final StudyStatus status;

  const StudyStatusBadge({super.key, required this.status});

  Color get _color {
    switch (status) {
      case StudyStatus.notStudied:
        return AppColors.statusNotStudied;
      case StudyStatus.studying:
        return AppColors.statusStudying;
      case StudyStatus.mastered:
        return AppColors.statusMastered;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withValues(alpha: 0.4)),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _color,
        ),
      ),
    );
  }
}
