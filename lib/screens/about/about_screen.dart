import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

/// Tela "Sobre" — créditos e informações do projeto.
///
/// O texto abaixo reproduz exatamente o conteúdo de créditos definido
/// pelo autor do app; não deve ser reescrito sem autorização.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppConstants.appName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text('Projeto criado por Umbrella Head.'),
            const SizedBox(height: 8),
            const Text('Conteúdo desenvolvido com auxílio do ChatGPT.'),
            const SizedBox(height: 8),
            const Text(
              'Este é um projeto pessoal para estudo do evangelho e '
              'preparação missionária.',
            ),
            const SizedBox(height: 8),
            const Text(
              'Não é um aplicativo oficial de A Igreja de Jesus Cristo '
              'dos Santos dos Últimos Dias.',
            ),
          ],
        ),
      ),
    );
  }
}
