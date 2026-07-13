import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/route_names.dart';
import '../../core/services/backup_service.dart';
import '../../providers/settings_provider.dart';

/// Tela de Configurações: tema, acessibilidade (fonte ajustável e alto
/// contraste) e backup (exportar/importar conteúdo).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        children: [
          const _SectionHeader('Aparência'),
          RadioListTile<ThemeMode>(
            title: const Text('Claro'),
            value: ThemeMode.light,
            groupValue: settings.themeMode,
            onChanged: (v) => context.read<SettingsProvider>().setThemeMode(v!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Escuro'),
            value: ThemeMode.dark,
            groupValue: settings.themeMode,
            onChanged: (v) => context.read<SettingsProvider>().setThemeMode(v!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Automático (sistema)'),
            value: ThemeMode.system,
            groupValue: settings.themeMode,
            onChanged: (v) => context.read<SettingsProvider>().setThemeMode(v!),
          ),
          const Divider(),
          const _SectionHeader('Modo Missão'),
          SwitchListTile(
            title: const Text('Ativar Modo Missão'),
            subtitle: const Text(
              'Interface simplificada, com botões maiores e menos animações, '
              'para uso durante visitas e conversas reais.',
            ),
            value: settings.missionModeEnabled,
            onChanged: (v) => context.read<SettingsProvider>().setMissionModeEnabled(v),
          ),
          const Divider(),
          const _SectionHeader('Acessibilidade'),
          ListTile(
            title: const Text('Tamanho da fonte'),
            subtitle: Slider(
              value: settings.textScale,
              min: 0.85,
              max: 1.4,
              divisions: 11,
              label: '${(settings.textScale * 100).round()}%',
              onChanged: (v) => context.read<SettingsProvider>().setTextScale(v),
            ),
          ),
          SwitchListTile(
            title: const Text('Alto contraste'),
            value: settings.highContrast,
            onChanged: (v) => context.read<SettingsProvider>().setHighContrast(v),
          ),
          const Divider(),
          const _SectionHeader('Backup'),
          ListTile(
            leading: const Icon(Icons.upload_rounded),
            title: const Text('Exportar conteúdo'),
            subtitle: const Text('Gera um arquivo JSON com todo o seu conteúdo.'),
            onTap: () {
              // A geração em si já está pronta em BackupService.exportToJson();
              // falta apenas conectar a um seletor de arquivos/compartilhamento
              // quando o fluxo de exportação for finalizado.
              BackupService.instance.exportToJson();
            },
          ),
          ListTile(
            leading: const Icon(Icons.download_rounded),
            title: const Text('Importar conteúdo'),
            subtitle: const Text('Restaura o conteúdo a partir de um backup.'),
            onTap: () {
              // TODO: conectar a um seletor de arquivos e chamar
              // BackupService.instance.importFromJson(conteudo).
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text('Sobre o MissionDex'),
            onTap: () => Navigator.pushNamed(context, RouteNames.about),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
