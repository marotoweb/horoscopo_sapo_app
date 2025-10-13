// lib/screens/configuracoes_screen.dart

import 'package:flutter/material.dart';
import '../models/astrologo_model.dart';

// As listas estáticas de signos e periodos permanecem aqui
const List<Map<String, String>> signos = [
  {'id': 'carneiro', 'nome': 'Carneiro', 'simbolo': '♈'},
  {'id': 'touro', 'nome': 'Touro', 'simbolo': '♉'},
  {'id': 'gemeos', 'nome': 'Gémeos', 'simbolo': '♊'},
  {'id': 'caranguejo', 'nome': 'Caranguejo', 'simbolo': '♋'},
  {'id': 'leao', 'nome': 'Leão', 'simbolo': '♌'},
  {'id': 'virgem', 'nome': 'Virgem', 'simbolo': '♍'},
  {'id': 'balanca', 'nome': 'Balança', 'simbolo': '♎'},
  {'id': 'escorpiao', 'nome': 'Escorpião', 'simbolo': '♏'},
  {'id': 'sagitario', 'nome': 'Sagitário', 'simbolo': '♐'},
  {'id': 'capricornio', 'nome': 'Capricórnio', 'simbolo': '♑'},
  {'id': 'aquario', 'nome': 'Aquário', 'simbolo': '♒'},
  {'id': 'peixes', 'nome': 'Peixes', 'simbolo': '♓'},
];

const List<Map<String, String>> periodos = [
  {'id': 'diaria', 'nome': 'Diária'},
  {'id': 'semanal', 'nome': 'Semanal'},
];

class ConfiguracoesScreen extends StatefulWidget {
  final List<Astrologo> astrologos;
  final Function(String signo, String periodo, String astrologo) onSalvar;

  // Parâmetros opcionais para o modo de edição
  final String? signoAtual;
  final String? periodoAtual;
  final String? astrologoAtual;
  final bool isModoEdicao;

  const ConfiguracoesScreen({
    super.key,
    required this.astrologos,
    required this.onSalvar,
    this.signoAtual,
    this.periodoAtual,
    this.astrologoAtual,
    this.isModoEdicao = false, // Por defeito, não está em modo de edição
  });

  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  String? _signoSelecionado;
  String? _periodoSelecionado;
  String? _astrologoSelecionado;

  @override
  void initState() {
    super.initState();
    // Pré-seleciona os valores se eles forem passados (modo de edição)
    _signoSelecionado = widget.signoAtual;
    _periodoSelecionado = widget.periodoAtual ?? 'diaria';
    _astrologoSelecionado = widget.astrologoAtual;

    // Garante um valor padrão se nada estiver selecionado e a lista existir
    if (_astrologoSelecionado == null && widget.astrologos.isNotEmpty) {
      _astrologoSelecionado = widget.astrologos.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Mostra o título correto dependendo do modo
        title: Text(
          widget.isModoEdicao
              ? 'Editar Preferências'
              : 'Configurações Iniciais',
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'As suas Preferências',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Seletor de Astrólogo
            DropdownButtonFormField<String>(
              initialValue: _astrologoSelecionado,
              decoration: const InputDecoration(
                labelText: 'Astrólogo Favorito',
                border: OutlineInputBorder(),
              ),
              items: widget.astrologos.map((astrologo) {
                return DropdownMenuItem(
                  value: astrologo.id,
                  child: Text(astrologo.nome),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _astrologoSelecionado = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Seletor de Período
            DropdownButtonFormField<String>(
              initialValue: _periodoSelecionado,
              decoration: const InputDecoration(
                labelText: 'Período em Destaque',
                border: OutlineInputBorder(),
              ),
              items: periodos.map((periodo) {
                return DropdownMenuItem(
                  value: periodo['id']!,
                  child: Text(periodo['nome']!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _periodoSelecionado = value!;
                });
              },
            ),
            const SizedBox(height: 24),

            // Seletor de Signo
            const Text(
              'Signo Favorito',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: signos.length,
              itemBuilder: (context, index) {
                final signo = signos[index];
                final isSelected = _signoSelecionado == signo['id'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _signoSelecionado = signo['id'];
                    });
                  },
                  child: Card(
                    color: isSelected
                        ? Colors.deepPurple.shade100
                        : Colors.white,
                    elevation: isSelected ? 4 : 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          signo['simbolo']!,
                          style: const TextStyle(fontSize: 28),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          signo['nome']!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            // Botão Salvar
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              onPressed:
                  (_signoSelecionado != null && _astrologoSelecionado != null)
                  ? () {
                      widget.onSalvar(
                        _signoSelecionado!,
                        _periodoSelecionado!,
                        _astrologoSelecionado!,
                      );
                      // Se estamos em modo de edição, voltamos para o ecrã anterior
                      if (widget.isModoEdicao) {
                        Navigator.of(context).pop();
                      }
                    }
                  : null,
              child: const Text('Guardar', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
