import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/route_names.dart';

import 'providers/settings_provider.dart';
import 'providers/category_provider.dart';
import 'providers/situation_provider.dart';
import 'providers/question_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/note_provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/stats_provider.dart';
import 'providers/search_provider.dart';

import 'screens/root/root_screen.dart';
import 'screens/categories/categories_screen.dart';
import 'screens/situations/situations_screen.dart';
import 'screens/favorites/favorites_screen.dart';
import 'screens/search/search_screen.dart';
import 'screens/notes/notes_screen.dart';
import 'screens/quiz/quiz_screen.dart';
import 'screens/stats/stats_screen.dart';
import 'screens/scriptures/scriptures_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/about/about_screen.dart';

/// Widget raiz do MissionDex.
///
/// Aqui registramos todos os providers (estado global da aplicação) e
/// configuramos o MaterialApp com Material Design 3, modo claro/escuro
/// e rotas nomeadas — assim cada tela nova só precisa ser adicionada
/// em [RouteNames] e no [_buildRoutes] abaixo, sem tocar em mais nada.
class MissionDexApp extends StatelessWidget {
  const MissionDexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()..load()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()..load()),
        ChangeNotifierProvider(create: (_) => SituationProvider()..load()),
        ChangeNotifierProvider(create: (_) => QuestionProvider()..load()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()..load()),
        ChangeNotifierProvider(create: (_) => NoteProvider()..load()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => StatsProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'MissionDex',
            debugShowCheckedModeBanner: false,
            themeMode: settings.themeMode,
            theme: AppTheme.light(
              textScale: settings.textScale,
              highContrast: settings.highContrast,
              reducedMotion: settings.missionModeEnabled,
            ),
            darkTheme: AppTheme.dark(
              textScale: settings.textScale,
              highContrast: settings.highContrast,
              reducedMotion: settings.missionModeEnabled,
            ),
            initialRoute: RouteNames.home,
            routes: _buildRoutes(),
          );
        },
      ),
    );
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      RouteNames.home: (_) => const RootScreen(),
      RouteNames.categories: (_) => const CategoriesScreen(),
      RouteNames.situations: (_) => const SituationsScreen(),
      RouteNames.favorites: (_) => const FavoritesScreen(),
      RouteNames.search: (_) => const SearchScreen(),
      RouteNames.notes: (_) => const NotesScreen(),
      RouteNames.quiz: (_) => const QuizScreen(),
      RouteNames.stats: (_) => const StatsScreen(),
      RouteNames.scriptures: (_) => const ScripturesScreen(),
      RouteNames.settings: (_) => const SettingsScreen(),
      RouteNames.about: (_) => const AboutScreen(),
      // Categoria e Pergunta usam rotas dinâmicas (com argumentos),
      // então são navegadas via Navigator.push, não via rota nomeada fixa.
      // Veja: screens/categories/category_detail_screen.dart
      //       screens/question/question_detail_screen.dart
    };
  }
}
