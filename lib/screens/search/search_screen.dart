import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/favorite_provider.dart';
import '../../providers/search_provider.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/question/question_card.dart';
import '../question/question_detail_screen.dart';

/// Tela de Pesquisa instantânea.
///
/// A cada caractere digitado, [SearchProvider.search] é chamado e a
/// lista de resultados é atualizada imediatamente — sem necessidade de
/// apertar um botão "buscar". A busca cobre título, resposta curta,
/// resposta completa e referências de escritura (livro/versículo).
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();
    final favoriteProvider = context.watch<FavoriteProvider>();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Pesquisar por palavra, tema, livro, versículo...',
            border: InputBorder.none,
          ),
          onChanged: (value) => context.read<SearchProvider>().search(value),
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () {
                _controller.clear();
                context.read<SearchProvider>().clear();
              },
            ),
        ],
      ),
      body: searchProvider.query.isEmpty
          ? const EmptyState(
              icon: Icons.search_rounded,
              title: 'Digite algo para pesquisar',
              subtitle: 'Os resultados aparecem instantaneamente.',
            )
          : searchProvider.results.isEmpty
              ? const EmptyState(
                  icon: Icons.search_off_rounded,
                  title: 'Nenhum resultado encontrado',
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: searchProvider.results.length,
                  itemBuilder: (context, index) {
                    final question = searchProvider.results[index];
                    return QuestionCard(
                      question: question,
                      isFavorite: favoriteProvider.isFavorite(question.id),
                      onToggleFavorite: () => favoriteProvider.toggle(question.id),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuestionDetailScreen(question: question),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
