import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/category_provider.dart';
import '../../providers/question_provider.dart';
import '../../widgets/common/empty_state.dart';
import 'category_detail_screen.dart';

/// Tela de listagem de todas as categorias cadastradas.
///
/// O sistema suporta um número ilimitado de categorias — esta tela
/// apenas exibe o que existir no armazenamento local, sem nenhum dado
/// de exemplo.
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final questionProvider = context.watch<QuestionProvider>();
    final categories = categoryProvider.categories;

    return Scaffold(
      appBar: AppBar(title: const Text('Categorias')),
      body: categories.isEmpty
          ? const EmptyState(
              icon: Icons.category_outlined,
              title: 'Nenhuma categoria cadastrada ainda',
              subtitle: 'As categorias aparecerão aqui assim que forem adicionadas.',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final questionCount = questionProvider.byCategory(category.id).length;

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.folder_rounded),
                    title: Text(category.name),
                    subtitle: Text(
                      questionCount == 1
                          ? '1 pergunta'
                          : '$questionCount perguntas',
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CategoryDetailScreen(category: category),
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
