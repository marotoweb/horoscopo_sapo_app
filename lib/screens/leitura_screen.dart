// lib/screens/leitura_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share_plus/share_plus.dart';
import '../models/previsao_model.dart';
import '../models/astrologo_model.dart';

class LeituraScreen extends StatelessWidget {
  final Previsao previsao;
  final Astrologo astrologo;

  const LeituraScreen({
    super.key,
    required this.previsao,
    required this.astrologo,
  });

  void _partilharPrevisao(BuildContext context) {
    // Remove as tags HTML para a partilha de texto simples
    final textoSemHtml = previsao.conteudoHtml
        .replaceAll(RegExp(r'<[^>]*>'), '\n')
        .trim();

    final textoPartilha =
        'Previsão ${previsao.periodo} para ${previsao.signo} por ${astrologo.nome}:\n\n'
        '$textoSemHtml\n\n'
        'Visto na App Horóscopo SAPO';

    Share.share(textoPartilha, subject: 'Previsão de Horóscopo');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(astrologo.nome),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _partilharPrevisao(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Cabeçalho com foto e nome do astrólogo
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  astrologo.fotoUrl != null && astrologo.fotoUrl!.isNotEmpty
                  ? NetworkImage(astrologo.fotoUrl!)
                  : null,
              child: (astrologo.fotoUrl == null || astrologo.fotoUrl!.isEmpty)
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              astrologo.nome,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              astrologo.especialidade ?? "Sem especialidade",
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),

            const Divider(height: 32),

            // Título da Previsão
            Text(
              'Previsão ${previsao.periodo} para ${previsao.signo.toUpperCase()}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),

            // Conteúdo da Previsão
            Card(
              elevation: 0,
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Html(
                  data: previsao.conteudoHtml,
                  style: {"body": Style(fontSize: FontSize.large)},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
