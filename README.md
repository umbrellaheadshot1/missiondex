# MissionDex

Biblioteca missionária pessoal para estudo do evangelho e preparação
missionária. Projeto pessoal criado por **Umbrella Head**.

> Este app **não contém nenhuma pergunta, resposta ou categoria de
> exemplo**. Toda a estrutura está pronta; o conteúdo é inserido por
> você, exatamente como enviado — o app nunca reescreve, reformata ou
> reorganiza o que você adicionar.

## Banco de dados oficial

O conteúdo oficial do MissionDex vive em **`perguntas.json`** (na raiz
do projeto, sua cópia de referência/edição) e em
**`assets/data/perguntas.json`** (a cópia que o app efetivamente lê).
Sempre que editar o conteúdo, copie o arquivo da raiz para dentro de
`assets/data/` antes de rodar o app.

Na primeira execução, `OfficialContentSeedService.importIfNeeded()`
(chamado em `main.dart`) lê esse JSON e cria automaticamente:

- as **Categorias** (uma por valor distinto de `"categoria"`),
- as **Situações** (uma por valor distinto dentro de `"situacoes"`),
- as **Perguntas**, separando o campo único `"escrituras"` nas seções
  fixas de livro (Bíblia / Livro de Mórmon / D&C / Pérola de Grande
  Valor / etc., via `ScriptureBookResolver`), mapeando `"dica"` para a
  Dica para o Missionário e `"palavras_chave"` para a busca.

A importação só roda uma vez: se já existir alguma pergunta salva no
Hive, ela não roda de novo — então favoritos, anotações e nível de
domínio marcados pelo usuário nunca são apagados por uma reimportação
acidental. Para forçar uma reimportação (ex.: depois de adicionar mais
perguntas ao `perguntas.json`), desinstale o app ou limpe os dados do
app antes de rodar novamente.

## Como rodar o projeto

Este pacote contém apenas o código-fonte (`lib/` + `pubspec.yaml`). Ele
foi criado fora de um ambiente com Flutter SDK/rede, então antes de
rodar você precisa gerar o projeto Flutter completo em sua máquina:

```bash
# 1. Crie um projeto Flutter novo (gera android/, ios/, etc.)
flutter create missiondex
cd missiondex

# 2. Substitua o pubspec.yaml e a pasta lib/ gerados
#    pelos deste pacote (copie os arquivos por cima).

# 3. Baixe as dependências
flutter pub get

# 4. Gere os adapters do Hive (obrigatório — os models usam @HiveType)
dart run build_runner build --delete-conflicting-outputs

# 5. Rode o app
flutter run
```

O passo 4 é essencial: os arquivos `*.g.dart` (adapters do Hive,
gerados a partir de `part 'nome.g.dart';` em cada model) ainda não
existem neste pacote porque dependem do Flutter SDK para serem gerados.

## Arquitetura

```
lib/
  main.dart                 # inicializa Hive e roda o app
  app.dart                  # MaterialApp, tema, rotas, providers globais

  core/
    theme/                  # cores, tipografia, ThemeData (M3, claro/escuro)
    constants/              # nomes de rotas, constantes gerais
    utils/                  # cálculo de tempo de leitura, etc.
    services/
      storage_service.dart  # inicialização do Hive e das boxes
      backup_service.dart   # exportar/importar conteúdo em JSON
      sync_service.dart     # contrato preparado p/ sincronização futura (não implementada)

  data/
    models/                 # CategoryModel, QuestionModel, NoteModel, etc.
    repositories/           # camada de acesso ao Hive (uma por model)

  providers/                # estado global (ChangeNotifier) consumido pela UI

  screens/                  # uma pasta por tela, seguindo as rotas do app
  widgets/                  # componentes reutilizáveis (cards, chips, badges)
```

**Regra de ouro do projeto:** a UI nunca acessa o Hive diretamente —
sempre passa por um `Repository`, que por sua vez é usado por um
`Provider`. Isso significa que trocar o banco local no futuro (ou
plugar sincronização em nuvem) exige mudar apenas a camada de
repositórios/serviços, nunca as telas.

## Como adicionar categorias e perguntas

Como pedido, nenhum conteúdo é gerado automaticamente. Quando você
enviar as perguntas e respostas, elas serão adicionadas usando as
classes já prontas:

```dart
final category = CategoryModel(
  id: const Uuid().v4(),
  name: 'Livro de Mórmon',
  order: 0,
);
await categoryProvider.addCategory(category);

final question = QuestionModel(
  id: const Uuid().v4(),
  categoryId: category.id,
  title: '...',
  shortAnswer: '...',
  fullAnswer: '...',
  scriptures: [
    ScriptureReferenceModel(
      id: const Uuid().v4(),
      book: 'Livro de Mórmon',
      reference: 'Alma 32:21',
    ),
  ],
);
await questionProvider.addQuestion(question);
```

Nada disso reescreve ou reformata o texto — os campos `shortAnswer` e
`fullAnswer` são salvos exatamente como fornecidos.

## Funcionalidades já estruturadas

- Tela inicial com os atalhos principais (incluindo 🧭 Situações)
- Categorias ilimitadas, cada uma com perguntas ilimitadas
- 🧭 Situações ilimitadas (contextos de conversa), cada uma associada a
  N perguntas via `QuestionModel.situationIds`
- Detalhe da pergunta reestruturado: ❓ pergunta, 💬 resposta rápida
  (30s), 📖 resposta completa (2-5min), 📚 escrituras organizadas por
  seção (Bíblia, Livro de Mórmon, D&C, Pérola de Grande Valor, Pregai
  Meu Evangelho, Manual Geral), 💡 dica para o missionário, ⭐
  favoritar, 📝 anotação com salvamento automático (debounce), 🎯 nível
  de domínio (Não estudei / Estudando / Domino), ⏱ tempo médio de
  leitura, 📅 última revisão (atualizada automaticamente ao abrir a
  pergunta), 🔁 revisar novamente (volta a pergunta para a fila de
  estudos)
- Pesquisa instantânea (palavra, categoria, livro, versículo, tema)
- Favoritos com remoção
- Minhas Anotações: visão consolidada de todas as anotações já escritas
- Quiz (modo estudo) com "Mostrar Resposta" / "Já sei" / "Preciso revisar"
- Estatísticas com gráfico de progresso (fl_chart)
- **Modo Missão**: interface simplificada para uso durante visitas/conversas
  reais — ativável na Home ou em Configurações. Abre direto na pesquisa
  (por palavra-chave e/ou por Situação), botões grandes, transições de
  tela instantâneas, mostra a resposta curta primeiro com opção de
  expandir a completa, escrituras rápidas, "Compartilhar Escritura",
  controle rápido de tamanho de fonte e "Próxima Pergunta Relacionada"
  para continuar a conversa sem voltar à pesquisa. Não duplica conteúdo:
  reaproveita os mesmos dados do Modo Estudo, apenas apresentados de
  forma mais rápida (veja `screens/root/root_screen.dart`, que decide
  qual Home mostrar conforme `SettingsProvider.missionModeEnabled`)
- Configurações: tema claro/escuro/sistema, fonte ajustável, alto contraste
- Backup: exportação/importação em JSON (falta só ligar ao seletor de arquivos)
- 100% offline (Hive)
- Estrutura preparada (não implementada) para sincronização futura

## Como adicionar Situações

Assim como categorias e perguntas, nenhuma Situação é criada
automaticamente. Quando você enviar a lista de situações, elas serão
adicionadas assim:

```dart
final situation = SituationModel(
  id: const Uuid().v4(),
  name: 'Pessoa acredita somente na Bíblia',
  icon: '📖',
  order: 0,
);
await situationProvider.addSituation(situation);

// Depois, para vincular uma pergunta já existente a essa situação:
question.situationIds.add(situation.id);
await questionProvider.updateQuestion(question);
```

## Pendências intencionais (marcadas com `// TODO`)

- Ligar exportação/importação de backup a um seletor de arquivos real
- Tela/diálogo de criação e edição de anotações
- Tela de criação/edição de categorias e perguntas pela própria UI
  (hoje a inserção é feita programaticamente, conforme solicitado)
- Substituir o ícone provisório da tela inicial por um logo definitivo
