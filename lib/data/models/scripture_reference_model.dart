import 'package:hive/hive.dart';

part 'scripture_reference_model.g.dart';

/// Uma referência de escritura anexada a uma pergunta.
///
/// [book] é livre (ex.: "Bíblia", "Livro de Mórmon", "Pregai Meu
/// Evangelho"...) para permitir que o usuário adicione novas fontes
/// no futuro sem alterar código — veja [AppConstants.defaultScriptureBooks]
/// para as sugestões padrão exibidas na UI.
@HiveType(typeId: 2)
class ScriptureReferenceModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String book;

  /// Ex.: "Alma 32:21" ou "João 3:16".
  @HiveField(2)
  String reference;

  /// Texto opcional do versículo/trecho, caso o usuário queira colar.
  @HiveField(3)
  String? excerpt;

  ScriptureReferenceModel({
    required this.id,
    required this.book,
    required this.reference,
    this.excerpt,
  });
}
