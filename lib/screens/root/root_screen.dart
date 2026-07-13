import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_provider.dart';
import '../home/home_screen.dart';
import '../mission/mission_home_screen.dart';

/// Ponto de entrada do app (rota [RouteNames.home]).
///
/// Decide, com base em [SettingsProvider.missionModeEnabled], se mostra
/// a Home completa do Modo Estudo ou a Home simplificada do Modo
/// Missão — sem duplicar rotas nem navegação.
class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final missionModeEnabled = context.watch<SettingsProvider>().missionModeEnabled;
    return missionModeEnabled ? const MissionHomeScreen() : const HomeScreen();
  }
}
