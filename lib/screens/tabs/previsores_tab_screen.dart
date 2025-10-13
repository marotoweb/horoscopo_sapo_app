// Ficheiro: lib/screens/tabs/previsores_tab_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/astrologo_model.dart';
import '../../models/signo_model.dart';
import '../../services/sapo_api_service.dart';
import '../previsor_detalhe_screen.dart';

class PrevisoresTabScreen extends StatefulWidget {
  final Signo signoAtivo;
  const PrevisoresTabScreen({super.key, required this.signoAtivo});

  @override
  PrevisoresTabScreenState createState() => PrevisoresTabScreenState();
}

class PrevisoresTabScreenState extends State<PrevisoresTabScreen> {
  final SapoApiService _apiService = SapoApiService();
  late Future<List<Astrologo>> _astrologosFuture;
  List<Astrologo> _todosAstrologos = [];
  List<Astrologo> _recentesAstrologos = [];

  @override
  void initState() {
    super.initState();
    _astrologosFuture = _carregarAstrologos();
    _carregarRecentes();
  }

  @override
  void didUpdateWidget(PrevisoresTabScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.signoAtivo.id != oldWidget.signoAtivo.id) {
      _carregarRecentes();
    }
  }

  Future<List<Astrologo>> _carregarAstrologos({
    bool forcarRefresh = false,
  }) async {
    final astrologos = await _apiService.fetchAstrologos(
      forcarRefresh: forcarRefresh,
    );
    if (mounted) {
      setState(() {
        _todosAstrologos = astrologos;
      });
    }
    return astrologos;
  }

  Future<void> _carregarRecentes() async {
    final prefs = await SharedPreferences.getInstance();
    final chaveRecentes = 'recentes_${widget.signoAtivo.id}';
    final idsRecentes = prefs.getStringList(chaveRecentes) ?? [];

    if (_todosAstrologos.isEmpty) await _carregarAstrologos();

    if (mounted) {
      setState(() {
        _recentesAstrologos = idsRecentes
            .map((id) {
              return _todosAstrologos.firstWhere(
                (a) => a.id == id,
                orElse: () => Astrologo(id: '', nome: ''),
              );
            })
            .where((a) => a.id.isNotEmpty)
            .toList();
      });
    }
  }

  Future<void> _adicionarRecente(Astrologo previsor) async {
    final prefs = await SharedPreferences.getInstance();
    final chaveRecentes = 'recentes_${widget.signoAtivo.id}';
    List<String> idsRecentes = prefs.getStringList(chaveRecentes) ?? [];
    idsRecentes.remove(previsor.id);
    idsRecentes.insert(0, previsor.id);
    if (idsRecentes.length > 2) {
      idsRecentes = idsRecentes.sublist(0, 2);
    }
    await prefs.setStringList(chaveRecentes, idsRecentes);
    _carregarRecentes();
  }

  void _navigateToPrevisor(Astrologo previsor, Signo signo) {
    _adicionarRecente(previsor);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PrevisorDetalheScreen(previsor: previsor, signo: signo),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    await _carregarAstrologos(forcarRefresh: true);
    await _carregarRecentes();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: FutureBuilder<List<Astrologo>>(
        future: _astrologosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              _todosAstrologos.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError && _todosAstrologos.isEmpty) {
            return Center(
              child: Text('Erro ao carregar previsores: ${snapshot.error}'),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
            children: [
              if (_recentesAstrologos.isNotEmpty) ...[
                Text(
                  'RECENTES',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _recentesAstrologos.length,
                  itemBuilder: (context, index) =>
                      _buildPrevisorCardRecente(_recentesAstrologos[index]),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                ),
                const SizedBox(height: 24),
              ],
              Text(
                'TODOS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              ..._todosAstrologos.map(
                (previsor) => _buildPrevisorCardCompleto(previsor),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPrevisorCardRecente(Astrologo previsor) {
    final bool temFoto =
        previsor.fotoUrl != null && previsor.fotoUrl!.isNotEmpty;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey[200],
          child: temFoto
              ? ClipOval(
                  child: CachedNetworkImage(
                    imageUrl:
                        previsor.fotoUrl!, // Usamos '!' porque já verificámos
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.person, color: Colors.grey),
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                )
              : const Icon(Icons.person, color: Colors.grey),
        ),
        title: Text(
          previsor.nome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _navigateToPrevisor(previsor, widget.signoAtivo),
      ),
    );
  }

  Widget _buildPrevisorCardCompleto(Astrologo previsor) {
    final bool temFoto =
        previsor.fotoUrl != null && previsor.fotoUrl!.isNotEmpty;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _navigateToPrevisor(previsor, widget.signoAtivo),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.grey[200],
                child: temFoto
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: previsor
                              .fotoUrl!, // Usamos '!' porque já verificámos
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.person, color: Colors.grey),
                          fit: BoxFit.cover,
                          width: 70,
                          height: 70,
                        ),
                      )
                    : const Icon(Icons.person, size: 35, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      previsor.nome,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      previsor.especialidade ??
                          '', // Usamos '' como valor padrão se for nulo
                      style: TextStyle(color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
