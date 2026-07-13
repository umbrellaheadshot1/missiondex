import 'package:hive/hive.dart';

part 'study_status.g.dart';

/// Status de estudo de uma pergunta.
///
/// Usado tanto na tela de detalhe da pergunta quanto no modo Quiz
/// (respostas "Já sei" / "Preciso revisar" atualizam este status).
@HiveType(typeId: 1)
enum StudyStatus {
  @HiveField(0)
  notStudied,

  @HiveField(1)
  studying,

  @HiveField(2)
  mastered,
}

extension StudyStatusLabel on StudyStatus {
  String get label {
    switch (this) {
      case StudyStatus.notStudied:
        return 'Não estudada';
      case StudyStatus.studying:
        return 'Em estudo';
      case StudyStatus.mastered:
        return 'Dominada';
    }
  }
}
