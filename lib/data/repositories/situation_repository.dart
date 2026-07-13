import '../../core/services/storage_service.dart';
import '../models/situation_model.dart';

/// Repositório de Situações.
class SituationRepository {
  final _box = StorageService.instance.situationsBox;

  List<SituationModel> getAll() {
    final list = _box.values.toList();
    list.sort((a, b) => a.order.compareTo(b.order));
    return list;
  }

  SituationModel? getById(String id) => _box.get(id);

  Future<void> add(SituationModel situation) => _box.put(situation.id, situation);

  Future<void> update(SituationModel situation) => _box.put(situation.id, situation);

  Future<void> delete(String id) => _box.delete(id);
}
