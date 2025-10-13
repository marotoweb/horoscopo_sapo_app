// lib/screens/sobre_screen.dart

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SobreScreen extends StatefulWidget {
  const SobreScreen({super.key});

  @override
  State<SobreScreen> createState() => _SobreScreenState();
}

class _SobreScreenState extends State<SobreScreen> {
  String _appVersion = '...';

  @override
  void initState() {
    super.initState();
    _carregarInfoDaApp();
  }

  Future<void> _carregarInfoDaApp() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion =
          'Versão ${packageInfo.version} (build ${packageInfo.buildNumber})';
    });
  }

  Future<void> _abrirUrlGitHub() async {
    final Uri url = Uri.parse(
      'https://github.com/marotoweb/horoscopo_sapo_app',
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível abrir o link do GitHub.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre a Aplicação')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 80.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo e versão
              // Se não tiver, pode usar um Icon widget
              Image.asset('assets/icon/icon.png', width: 80, height: 80),
              const SizedBox(height: 16),
              const Text(
                'Horóscopo SAPO',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _appVersion,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),

              // Disclaimer
              Card(
                elevation: 0,
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Disclaimer',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Esta aplicação é uma prova de conceito desenvolvida para fins de estudo.\nO autor descarta qualquer respondabilidade pelo uso devido ou indevido desta aplicação bem como qualquer dano causado pela capacidade ou incapacidade do utilizador pelo uso da aplicação e revoga qualquer direito sobre a aplicação além da licença MIT.\nEsta aplicação não possui qualquer afiliação com o portal SAPO.\nTodos os dados são obtidos através de web scraping de conteúdo público e pertencem aos seus devidos autores.\nOs horóscopos apresentados são meramente ilustrativos e não devem ser considerados como aconselhamento profissional.\nO utilizador é responsável por interpretar e utilizar as informações fornecidas de forma crítica.\nO autor não se responsabiliza por quaisquer consequências resultantes do uso das informações apresentadas nesta aplicação.',
                        style: TextStyle(
                          height: 1.5,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Link GitHub
              ListTile(
                leading: const Icon(Icons.code),
                title: const Text('Ver o Projeto no GitHub'),
                trailing: const Icon(Icons.open_in_new),
                onTap: _abrirUrlGitHub,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
