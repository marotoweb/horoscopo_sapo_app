// lib/widgets/signo_previsoes_pagina.dart (NOVO)

import 'package:flutter/material.dart';
import '../models/signo_model.dart';
import '../models/previsao_model.dart';
import '../services/sapo_api_service.dart';
import 'previsao_card.dart';

class SignoPrevisoesPagina extends StatefulWidget {
  final Signo signo;

  const SignoPrevisoesPagina({super.key, required this.signo});

  @override
  SignoPrevisoesPaginaState createState() => SignoPrevisoesPaginaState();
}

class SignoPrevisoesPaginaState extends State<SignoPrevisoesPagina>
    with AutomaticKeepAliveClientMixin {
  final SapoApiService _apiService = SapoApiService();
  late Future<List<Previsao>> _previsoesFuture;

  @override
  void initState() {
    super.initState();
    _previsoesFuture = _fetchAllPrevisoesParaSigno();
  }

  Future<List<Previsao>> _fetchAllPrevisoesParaSigno() async {
    final List<Previsao> previsoesEncontradas = [];
    final todosAstrologos = await _apiService.fetchAstrologos();

    for (final astrologo in todosAstrologos) {
      try {
        final previsao = await _apiService.fetchPrevisao(
          astrologoId: astrologo.id,
          signoId: widget.signo.id,
          periodoId: 'diario',
        );
        previsoesEncontradas.add(previsao);
      } catch (e) {
        debugPrint(
          'Info: ${astrologo.nome} não tem previsão diária para ${widget.signo.nome}.',
        );
      }
    }
    return previsoesEncontradas;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Necessário para o AutomaticKeepAliveClientMixin
    return SafeArea(
      child: FutureBuilder<List<Previsao>>(
        future: _previsoesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nenhuma previsão encontrada para este signo.'),
            );
          }

          final previsoes = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
            itemCount: previsoes.length,
            itemBuilder: (context, index) {
              final previsao = previsoes[index];
              return PrevisaoCard(
                previsao: previsao,
                titulo: previsao.astrologoNome,
                isInicialmenteExpandido: true,
              );
            },
            separatorBuilder: (context, index) =>
                const SizedBox(height: 16.0), // Adiciona 16px de espaço
          );
        },
      ),
    );
  }

  // Mantém o estado de cada aba para não recarregar os dados ao deslizar
  @override
  bool get wantKeepAlive => true;
}
