import 'package:hive_flutter/hive_flutter.dart';

import '../constants/app_constants.dart';
import '../../data/models/category_model.dart';
import '../../data/models/question_model.dart';
import '../../data/models/scripture_reference_model.dart';
import '../../data/models/study_status.dart';
import '../../data/models/note_model.dart';
import '../../data/models/favorite_model.dart';
import '../../data/models/situation_model.dart';
import '../../data/models/quiz_attempt_model.dart';

/// Ponto único de acesso ao banco local (Hive).
///
/// Todo o app funciona 100% offline: cada "box" do Hive funciona como
/// uma tabela. Este serviço é responsável por:
/// - Inicializar o Hive e registrar os adapters de cada model.
/// - Abrir todas as boxes usadas pelo app.
/// - Expor as boxes já tipadas para os repositórios.
///
/// Ao criar um novo model no futuro, registre o adapter aqui e adicione
/// a abertura da box correspondente em [init].
class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  late Box<CategoryModel> categoriesBox;
  late Box<QuestionModel> questionsBox;
  late Box<NoteModel> notesBox;
  late Box<FavoriteModel> favoritesBox;
  late Box<SituationModel> situationsBox;
  late Box<QuizAttemptModel> quizAttemptsBox;
  late Box settingsBox; // box dinâmica (chave/valor simples)

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    await Hive.initFlutter();

    _registerAdapters();

    categoriesBox = await Hive.openBox<CategoryModel>(AppConstants.boxCategories);
    questionsBox = await Hive.openBox<QuestionModel>(AppConstants.boxQuestions);
    notesBox = await Hive.openBox<NoteModel>(AppConstants.boxNotes);
    favoritesBox = await Hive.openBox<FavoriteModel>(AppConstants.boxFavorites);
    situationsBox = await Hive.openBox<SituationModel>(AppConstants.boxSituations);
    quizAttemptsBox = await Hive.openBox<QuizAttemptModel>(AppConstants.boxQuizStats);
    settingsBox = await Hive.openBox(AppConstants.boxSettings);

    _initialized = true;
  }

  void _registerAdapters() {
    // A ordem de registro não importa, mas os typeIds (definidos em cada
    // model com @HiveType(typeId: N)) devem ser únicos e nunca reutilizados
    // — se um model for removido no futuro, não reaproveite seu typeId.
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(CategoryModelAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(StudyStatusAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(ScriptureReferenceModelAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(QuestionModelAdapter());
    if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(NoteModelAdapter());
    if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(FavoriteModelAdapter());
    if (!Hive.isAdapterRegistered(6)) Hive.registerAdapter(QuizAttemptModelAdapter());
    if (!Hive.isAdapterRegistered(7)) Hive.registerAdapter(SituationModelAdapter());
  }
}
