// lib/screens/signo_detalhe_screen.dart (REESCRITO)

import 'package:flutter/material.dart';
import '../models/signo_model.dart';
import '../widgets/signo_previsoes_pagina.dart';

class SignoDetalheScreen extends StatefulWidget {
  final List<Signo> todosSignos;
  final int indiceInicial;

  const SignoDetalheScreen({
    super.key,
    required this.todosSignos,
    required this.indiceInicial,
  });

  @override
  SignoDetalheScreenState createState() => SignoDetalheScreenState();
}

class SignoDetalheScreenState extends State<SignoDetalheScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.todosSignos.length,
      vsync: this,
      initialIndex: widget.indiceInicial,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previsões por Signo'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true, // Permite que as abas rolem horizontalmente
          tabs: widget.todosSignos.map((signo) {
            return Tab(text: signo.nome.toUpperCase());
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        // Cada página da TabBarView é agora um widget separado que busca os seus próprios dados
        children: widget.todosSignos.map((signo) {
          return SignoPrevisoesPagina(signo: signo);
        }).toList(),
      ),
    );
  }
}
