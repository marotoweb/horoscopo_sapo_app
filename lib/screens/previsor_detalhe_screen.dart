// lib/screens/previsor_detalhe_screen.dart

import 'package:flutter/material.dart';
import '../models/astrologo_model.dart';
import '../models/signo_model.dart';
import '../models/previsao_model.dart';
import '../services/sapo_api_service.dart';
import '../widgets/previsao_card.dart';

class PrevisorDetalheScreen extends StatefulWidget {
  final Astrologo previsor;
  final Signo signo;

  const PrevisorDetalheScreen({
    super.key,
    required this.previsor,
    required this.signo,
  });

  @override
  PrevisorDetalheScreenState createState() => PrevisorDetalheScreenState();
}

class PrevisorDetalheScreenState extends State<PrevisorDetalheScreen> {
  final SapoApiService _apiService = SapoApiService();
  late Future<Map<String, Previsao>> _previsoesFuture;

  @override
  void initState() {
    super.initState();
    _previsoesFuture = _fetchAllPrevisoes();
  }

  Future<Map<String, Previsao>> _fetchAllPrevisoes() async {
    final periodos = ['diario', 'semanal', 'mensal', 'anual'];
    final Map<String, Previsao> previsoesEncontradas = {};

    for (final periodo in periodos) {
      try {
        final previsao = await _apiService.fetchPrevisao(
          astrologoId: widget.previsor.id,
          signoId: widget.signo.id.toLowerCase(),
          periodoId: periodo,
        );
        previsoesEncontradas[periodo] = previsao;
      } catch (e) {
        debugPrint(
          'Info: Previsão para o período "$periodo" não encontrada. Ignorando. Erro: $e',
        );
      }
    }

    return previsoesEncontradas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.signo.nome} por ${widget.previsor.nome}'),
      ),
      body: SafeArea(
        child: FutureBuilder<Map<String, Previsao>>(
          future: _previsoesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Ocorreu um erro inesperado: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'Nenhuma previsão foi encontrada para este astrólogo.',
                ),
              );
            }

            final previsoes = snapshot.data!;

            return ListView(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
              children: [
                // Cartão Diário
                if (previsoes.containsKey('diario')) ...[
                  PrevisaoCard(
                    previsao: previsoes['diario']!,
                    titulo: 'Previsão Diária',
                    isInicialmenteExpandido: true,
                  ),
                  const SizedBox(height: 16),
                ],

                // Cartão Semanal
                if (previsoes.containsKey('semanal')) ...[
                  PrevisaoCard(
                    previsao: previsoes['semanal']!,
                    titulo: 'Previsão Semanal',
                  ),
                  const SizedBox(height: 16),
                ],

                // Cartão Mensal
                if (previsoes.containsKey('mensal')) ...[
                  PrevisaoCard(
                    previsao: previsoes['mensal']!,
                    titulo: 'Previsão Mensal',
                  ),
                  const SizedBox(height: 16),
                ],

                // Cartão Anual
                if (previsoes.containsKey('anual')) ...[
                  PrevisaoCard(
                    previsao: previsoes['anual']!,
                    titulo: 'Previsão Anual',
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
