import 'package:flutter/material.dart';

import '../data/models/situation_model.dart';
import '../data/repositories/situation_repository.dart';

/// Provider de Situações — expõe a lista de situações cadastradas
/// para a UI (tela "🧭 Situações" na Home) e as operações de CRUD.
///
/// Nenhuma situação de exemplo é criada automaticamente: [load] apenas
/// lê o que já existir no armazenamento local.
class SituationProvider extends ChangeNotifier {
  final _repository = SituationRepository();

  List<SituationModel> _situations = [];
  List<SituationModel> get situations => _situations;

  void load() {
    _situations = _repository.getAll();
    notifyListeners();
  }

  Future<void> addSituation(SituationModel situation) async {
    await _repository.add(situation);
    load();
  }

  Future<void> updateSituation(SituationModel situation) async {
    await _repository.update(situation);
    load();
  }

  Future<void> deleteSituation(String id) async {
    await _repository.delete(id);
    load();
  }
}
