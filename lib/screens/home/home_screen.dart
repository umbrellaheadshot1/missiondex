import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/route_names.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/home/home_menu_button.dart';

/// Tela inicial: logo, tagline e os grandes botões de navegação
/// principais do app.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 48),
              // TODO: substituir por Image.asset quando houver um logo definitivo.
              Icon(
                Icons.menu_book_rounded,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(AppConstants.appName, style: AppTextStyles.logo(context)),
              const SizedBox(height: 6),
              Text(
                AppConstants.appTagline,
                style: AppTextStyles.tagline(context),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        AppConstants.officialDisclaimer,
                        style: AppTextStyles.caption(context),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.05,
                  children: [
                    HomeMenuButton(
                      icon: Icons.category_rounded,
                      label: 'Categorias',
                      onTap: () => Navigator.pushNamed(context, RouteNames.categories),
                    ),
                    HomeMenuButton(
                      icon: Icons.explore_rounded,
                      label: 'Situações',
                      onTap: () => Navigator.pushNamed(context, RouteNames.situations),
                    ),
                    HomeMenuButton(
                      icon: Icons.star_rounded,
                      label: 'Favoritos',
                      onTap: () => Navigator.pushNamed(context, RouteNames.favorites),
                    ),
                    HomeMenuButton(
                      icon: Icons.search_rounded,
                      label: 'Pesquisar',
                      onTap: () => Navigator.pushNamed(context, RouteNames.search),
                    ),
                    HomeMenuButton(
                      icon: Icons.edit_note_rounded,
                      label: 'Minhas Anotações',
                      onTap: () => Navigator.pushNamed(context, RouteNames.notes),
                    ),
                    HomeMenuButton(
                      icon: Icons.psychology_rounded,
                      label: 'Quiz',
                      onTap: () => Navigator.pushNamed(context, RouteNames.quiz),
                    ),
                    HomeMenuButton(
                      icon: Icons.auto_stories_rounded,
                      label: 'Escrituras',
                      onTap: () => Navigator.pushNamed(context, RouteNames.scriptures),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                icon: const Icon(Icons.bolt_rounded),
                label: const Text('Ativar Modo Missão'),
                onPressed: () =>
                    context.read<SettingsProvider>().setMissionModeEnabled(true),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: IconButton(
                  icon: const Icon(Icons.settings_rounded),
                  tooltip: 'Configurações',
                  onPressed: () => Navigator.pushNamed(context, RouteNames.settings),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
