import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../data/models/category_model.dart';
import '../../data/models/question_model.dart';
import '../../data/models/scripture_reference_model.dart';
import '../../data/models/situation_model.dart';
import '../../data/seed/scripture_book_resolver.dart';
import 'storage_service.dart';

/// Importa o banco oficial de conteúdo (`assets/data/perguntas.json`)
/// para o armazenamento local (Hive) na primeira execução do app.
///
/// Todo o conteúdo vem exclusivamente do arquivo `perguntas.json`
/// fornecido pelo autor do app — nada é gerado ou inventado aqui. Este
/// serviço apenas:
/// 1. Lê o JSON.
/// 2. Cria as Categorias e Situações (deduplicando pelos nomes usados
///    em cada pergunta, na ordem em que aparecem pela primeira vez).
/// 3. Cria as Perguntas, separando o campo único "escrituras" nas
///    seções fixas de livro (usando [ScriptureBookResolver]) e mapeando
///    "dica" -> tipForMissionary, "palavras_chave" -> keywords,
///    "situacoes" -> situationIds.
///
/// A importação só roda uma vez: se já existir alguma pergunta salva,
/// [importIfNeeded] não faz nada, para nunca duplicar conteúdo nem
/// sobrescrever edições feitas depois pelo usuário (favoritos, notas,
/// nível de domínio, etc. seguem intactos entre execuções).
class OfficialContentSeedService {
  OfficialContentSeedService._();
  static final OfficialContentSeedService instance = OfficialContentSeedService._();

  static const _assetPath = 'assets/data/perguntas.json';

  Future<void> importIfNeeded() async {
    final storage = StorageService.instance;

    // Já existe conteúdo salvo (seja da importação anterior, seja
    // adicionado manualmente) — não reimporta.
    if (storage.questionsBox.isNotEmpty) return;

    final raw = await rootBundle.loadString(_assetPath);
    final List<dynamic> data = jsonDecode(raw) as List<dynamic>;

    final categoryIdByName = <String, String>{};
    final situationIdByName = <String, String>{};

    var categoryOrder = 0;
    var situationOrder = 0;

    for (final item in data) {
      final map = item as Map<String, dynamic>;

      // --- Categoria (criada uma única vez por nome distinto) ---
      final categoriaNome = (map['categoria'] as String).trim();
      final categoryId = categoryIdByName.putIfAbsent(categoriaNome, () {
        final id = 'cat_${_slug(categoriaNome)}';
        storage.categoriesBox.put(
          id,
          CategoryModel(id: id, name: categoriaNome, order: categoryOrder++),
        );
        return id;
      });

      // --- Situações (criadas uma única vez por nome distinto) ---
      final situacoes = (map['situacoes'] as List<dynamic>? ?? [])
          .map((s) => (s as String).trim())
          .where((s) => s.isNotEmpty)
          .toList();

      final situationIds = situacoes.map((nome) {
        return situationIdByName.putIfAbsent(nome, () {
          final id = 'sit_${_slug(nome)}';
          storage.situationsBox.put(
            id,
            SituationModel(id: id, name: nome, order: situationOrder++),
          );
          return id;
        });
      }).toList();

      // --- Escrituras: separa o texto único em livro + referência ---
      final escrituras = (map['escrituras'] as List<dynamic>? ?? [])
          .map((s) => s as String)
          .map((reference) => ScriptureReferenceModel(
                id: 'scr_${_slug(reference)}',
                book: ScriptureBookResolver.resolve(reference),
                reference: reference,
              ))
          .toList();

      final keywords = (map['palavras_chave'] as List<dynamic>? ?? [])
          .map((k) => k as String)
          .toList();

      final questionId = 'q_${map['id']}';

      await storage.questionsBox.put(
        questionId,
        QuestionModel(
          id: questionId,
          categoryId: categoryId,
          title: map['pergunta'] as String,
          shortAnswer: map['resposta_curta'] as String,
          fullAnswer: map['resposta_completa'] as String,
          scriptures: escrituras,
          tipForMissionary: map['dica'] as String?,
          keywords: keywords,
          situationIds: situationIds,
          order: map['id'] as int,
        ),
      );
    }
  }

  String _slug(String text) {
    final normalized = text
        .toLowerCase()
        .replaceAll(RegExp(r'[áàãâä]'), 'a')
        .replaceAll(RegExp(r'[éèêë]'), 'e')
        .replaceAll(RegExp(r'[íìîï]'), 'i')
        .replaceAll(RegExp(r'[óòõôö]'), 'o')
        .replaceAll(RegExp(r'[úùûü]'), 'u')
        .replaceAll('ç', 'c');
    return normalized.replaceAll(RegExp(r'[^a-z0-9]+'), '_').replaceAll(RegExp(r'^_+|_+$'), '');
  }
}
