// lib/screens/detalhe_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share_plus/share_plus.dart';
import '../models/signo_model.dart';
import '../models/previsao_model.dart';
import '../services/sapo_api_service.dart';

class DetalheScreen extends StatefulWidget {
  final Signo signo;
  final String astrologoId;

  const DetalheScreen({
    super.key,
    required this.signo,
    required this.astrologoId,
  });

  @override
  DetalheScreenState createState() => DetalheScreenState();
}

class DetalheScreenState extends State<DetalheScreen>
    with SingleTickerProviderStateMixin {
  final SapoApiService _apiService = SapoApiService();
  late TabController _tabController;

  final Map<String, Previsao> _cache = {};
  final Map<String, bool> _loadingStatus = {};
  final Map<String, String> _errorStatus = {};

  final List<String> _periodos = ['diario', 'semanal', 'mensal', 'anual'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _periodos.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    _fetchPrevisaoWrapper(_periodos.first);
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      _fetchPrevisaoWrapper(_periodos[_tabController.index]);
    }
  }

  Future<void> _fetchPrevisaoWrapper(String periodo) async {
    if (_cache.containsKey(periodo) || _loadingStatus[periodo] == true) return;

    setState(() {
      _loadingStatus[periodo] = true;
      _errorStatus.remove(periodo);
    });

    try {
      final resultado = await _apiService.fetchPrevisao(
        signoId: widget.signo.id,
        periodoId: periodo,
        astrologoId: widget.astrologoId,
      );
      if (mounted) setState(() => _cache[periodo] = resultado);
    } catch (e) {
      if (mounted) {
        setState(
          () => _errorStatus[periodo] = 'Falha ao carregar: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) setState(() => _loadingStatus[periodo] = false);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.star, size: 36),
            const SizedBox(width: 10),
            Text(widget.signo.nome),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              final periodoAtual = _periodos[_tabController.index];
              if (_cache.containsKey(periodoAtual)) {
                final previsao = _cache[periodoAtual]!;
                Share.share(
                  'Horóscopo de ${widget.signo.nome} (${previsao.periodo}): ${previsao.conteudoHtml.replaceAll(RegExp(r'<[^>]*>'), '')}',
                );
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _periodos.map((p) => Tab(text: p.toUpperCase())).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _periodos.map((periodo) {
          if (_loadingStatus[periodo] == true) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_errorStatus.containsKey(periodo)) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_errorStatus[periodo]!, textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => _fetchPrevisaoWrapper(periodo),
                      child: const Text('Tentar Novamente'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (!_cache.containsKey(periodo)) {
            return const Center(child: Text('A carregar...'));
          }

          final previsao = _cache[periodo]!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Html(data: previsao.conteudoHtml),
          );
        }).toList(),
      ),
    );
  }
}
