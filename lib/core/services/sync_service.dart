/// Estrutura preparada para uma futura sincronização em nuvem.
///
/// Conforme solicitado, NÃO implementamos sincronização agora — este
/// arquivo existe apenas para reservar o "contrato" (interface) que uma
/// implementação futura (ex.: Firebase, backend próprio, etc.) deverá
/// seguir, sem exigir mudanças em outras partes do app quando chegar a
/// hora.
abstract class SyncService {
  /// Envia o conteúdo local para o servidor remoto.
  Future<void> push();

  /// Baixa o conteúdo mais recente do servidor remoto.
  Future<void> pull();

  /// Indica se há um usuário/conta autenticada para sincronizar.
  bool get isAuthenticated;
}

/// Implementação "nula" usada enquanto a sincronização não existe.
/// Basta trocar por uma implementação real no futuro (ex.:
/// `FirebaseSyncService implements SyncService`) sem alterar quem a usa.
class NoopSyncService implements SyncService {
  @override
  bool get isAuthenticated => false;

  @override
  Future<void> pull() async {
    // Intencionalmente vazio: sincronização ainda não implementada.
  }

  @override
  Future<void> push() async {
    // Intencionalmente vazio: sincronização ainda não implementada.
  }
}
