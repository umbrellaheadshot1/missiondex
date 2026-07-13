import 'package:flutter/material.dart';

import '../core/services/storage_service.dart';

/// Provider de Configurações: tema (claro/escuro/sistema), tamanho da
/// fonte e modo de alto contraste — tudo persistido localmente para
/// que a preferência do usuário sobreviva entre sessões.
class SettingsProvider extends ChangeNotifier {
  final _box = StorageService.instance.settingsBox;

  ThemeMode _themeMode = ThemeMode.system;
  double _textScale = 1.0;
  bool _highContrast = false;
  bool _missionModeEnabled = false;

  ThemeMode get themeMode => _themeMode;
  double get textScale => _textScale;
  bool get highContrast => _highContrast;

  /// Modo Missão: interface simplificada e mais rápida para uso durante
  /// visitas e conversas reais (veja MissionHomeScreen). Não altera o
  /// conteúdo do app, apenas a forma de apresentação/navegação.
  bool get missionModeEnabled => _missionModeEnabled;

  void load() {
    final themeIndex = _box.get('themeMode', defaultValue: ThemeMode.system.index) as int;
    _themeMode = ThemeMode.values[themeIndex];
    _textScale = (_box.get('textScale', defaultValue: 1.0) as num).toDouble();
    _highContrast = _box.get('highContrast', defaultValue: false) as bool;
    _missionModeEnabled = _box.get('missionModeEnabled', defaultValue: false) as bool;
    notifyListeners();
  }

  Future<void> setMissionModeEnabled(bool value) async {
    _missionModeEnabled = value;
    await _box.put('missionModeEnabled', value);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _box.put('themeMode', mode.index);
    notifyListeners();
  }

  Future<void> setTextScale(double scale) async {
    _textScale = scale;
    await _box.put('textScale', scale);
    notifyListeners();
  }

  Future<void> setHighContrast(bool value) async {
    _highContrast = value;
    await _box.put('highContrast', value);
    notifyListeners();
  }
}
