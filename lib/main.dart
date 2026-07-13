import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/services/storage_service.dart';
import 'core/services/official_content_seed_service.dart';

/// Ponto de entrada do MissionDex.
///
/// Responsabilidades desta função:
/// 1. Garantir que o binding do Flutter esteja pronto antes de qualquer
///    chamada assíncrona (necessário para usar plugins nativos).
/// 2. Inicializar o Hive (nosso banco local, 100% offline).
/// 3. Registrar os adapters dos models (feito dentro do StorageService).
/// 4. Importar o banco oficial de conteúdo (perguntas.json) na
///    primeira execução — veja OfficialContentSeedService.
/// 5. Rodar o app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageService.instance.init();
  await OfficialContentSeedService.instance.importIfNeeded();

  runApp(const MissionDexApp());
}
