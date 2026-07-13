import 'package:hive/hive.dart';

part 'category_model.g.dart';

/// Representa uma categoria (ex.: "Livro de Mórmon", "Ateus", etc.).
///
/// O sistema suporta um número ilimitado de categorias — novas categorias
/// são apenas novos registros desta classe, nunca exigem alteração de
/// código. [order] define a posição de exibição na tela de Categorias.
@HiveType(typeId: 0)
class CategoryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? description;

  /// Nome de um ícone (ex.: 'church', 'book') resolvido na camada de UI.
  @HiveField(3)
  String? iconName;

  @HiveField(4)
  int order;

  @HiveField(5)
  final DateTime createdAt;

  CategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.iconName,
    this.order = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
