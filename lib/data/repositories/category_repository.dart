import '../../core/services/storage_service.dart';
import '../models/category_model.dart';

/// Repositório de Categorias.
///
/// Camada fina sobre o Hive: os Providers nunca acessam o Hive
/// diretamente, sempre passam por um repositório. Isso facilita trocar
/// o mecanismo de armazenamento no futuro sem tocar na UI.
class CategoryRepository {
  final _box = StorageService.instance.categoriesBox;

  List<CategoryModel> getAll() {
    final list = _box.values.toList();
    list.sort((a, b) => a.order.compareTo(b.order));
    return list;
  }

  CategoryModel? getById(String id) => _box.get(id);

  Future<void> add(CategoryModel category) => _box.put(category.id, category);

  Future<void> update(CategoryModel category) => _box.put(category.id, category);

  Future<void> delete(String id) => _box.delete(id);
}
