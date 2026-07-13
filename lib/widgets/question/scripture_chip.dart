import 'package:flutter/material.dart';

import '../../data/models/scripture_reference_model.dart';

/// Chip visual para uma referência de escritura anexada a uma pergunta
/// (ex.: "Livro de Mórmon · Alma 32:21").
class ScriptureChip extends StatelessWidget {
  final ScriptureReferenceModel scripture;
  final VoidCallback? onTap;

  const ScriptureChip({super.key, required this.scripture, this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ActionChip(
      avatar: Icon(Icons.menu_book_rounded, size: 16, color: scheme.primary),
      label: Text('${scripture.book} · ${scripture.reference}'),
      onPressed: onTap,
      backgroundColor: scheme.surfaceContainerHigh,
    );
  }
}
