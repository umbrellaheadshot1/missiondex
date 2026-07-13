import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/scripture_reference_model.dart';
import 'scripture_chip.dart';

/// Organiza as escrituras de uma pergunta em seções fixas, na ordem:
/// Bíblia, Livro de Mórmon, Doutrina e Convênios, Pérola de Grande
/// Valor, Pregai Meu Evangelho, Manual Geral (+ qualquer outro livro
/// que o usuário venha a usar no futuro, exibido ao final).
///
/// Seções sem nenhuma referência simplesmente não são exibidas — nada
/// de placeholders ou textos de exemplo.
class ScriptureSections extends StatelessWidget {
  final List<ScriptureReferenceModel> scriptures;

  const ScriptureSections({super.key, required this.scriptures});

  @override
  Widget build(BuildContext context) {
    if (scriptures.isEmpty) {
      return Text(
        'Nenhuma escritura adicionada ainda.',
        style: AppTextStyles.caption(context),
      );
    }

    // Ordem fixa pedida, seguida de quaisquer outros livros em uso.
    final knownBooks = AppConstants.defaultScriptureBooks;
    final otherBooks = scriptures
        .map((s) => s.book)
        .where((book) => !knownBooks.contains(book))
        .toSet()
        .toList();
    final orderedBooks = [...knownBooks, ...otherBooks];

    final sections = <Widget>[];
    for (final book in orderedBooks) {
      final items = scriptures.where((s) => s.book == book).toList();
      if (items.isEmpty) continue;

      sections.add(
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 6),
          child: Text(
            book,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      );
      sections.add(
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((s) => ScriptureChip(scripture: s)).toList(),
        ),
      );
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: sections);
  }
}
