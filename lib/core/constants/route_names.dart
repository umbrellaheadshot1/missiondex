/// Nomes das rotas nomeadas do app.
///
/// Ao criar uma nova tela "fixa" (sem parâmetros dinâmicos), adicione o
/// nome aqui e registre em `app.dart` -> `_buildRoutes()`.
class RouteNames {
  RouteNames._();

  static const String home = '/';
  static const String categories = '/categories';
  static const String situations = '/situations';
  static const String favorites = '/favorites';
  static const String search = '/search';
  static const String notes = '/notes';
  static const String quiz = '/quiz';
  static const String stats = '/stats';
  static const String scriptures = '/scriptures';
  static const String settings = '/settings';
  static const String about = '/about';

  // Rotas dinâmicas (navegadas via Navigator.push com argumentos,
  // não precisam de entrada no MaterialApp.routes):
  // - categoryDetail (recebe Category)
  // - situationDetail (recebe Situation)
  // - questionDetail (recebe Question)
}
