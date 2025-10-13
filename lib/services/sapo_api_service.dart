// lib/services/sapo_api_service.dart

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/previsao_model.dart';
import '../models/astrologo_model.dart';

class SapoApiService {
  final String _baseUrl = 'https://sapo.pt/cultura-lifestyle/signos/';

  // Extrair o JSON, com gestão de cache
  Future<Map<String, dynamic>> _extrairJsonDePagina(
    String url, {
    bool ignorarCache = false,
  } ) async {
    final prefs = await SharedPreferences.getInstance();
    final chaveCache = 'cache_$url';
    final chaveTimestamp = 'timestamp_$url';

    // Tenta ler do cache primeiro
    if (!ignorarCache && prefs.containsKey(chaveCache)) {
      final timestampString = prefs.getString(chaveTimestamp);
      if (timestampString != null) {
        final timestampCache = DateTime.parse(timestampString);
        // Define a validade do cache para 1 hora
        if (DateTime.now().difference(timestampCache).inHours < 1) {
          final dadosCacheados = prefs.getString(chaveCache)!;
          return json.decode(dadosCacheados);
        }
      }
    }

    // Se o cache não existir ou estiver expirado, busca na rede
    final response = await http.get(
      Uri.parse(url ),
      headers: { 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36', },
    );
    if (response.statusCode != 200) {
      throw Exception('Falha ao carregar a página: ${response.statusCode} URL: $url');
    }
    
    final document = parser.parse(response.body);
    String dadosJsonString = '';

    final scripts = document.getElementsByTagName('script');
    for (var script in scripts) {
      if (script.innerHtml.contains('window.SAPO.data.previsoesSignos')) {
        final scriptContent = script.innerHtml;
        final startIndex = scriptContent.indexOf('{');
        final endIndex = scriptContent.lastIndexOf(';');
        if (startIndex != -1 && endIndex != -1) {
          dadosJsonString = scriptContent.substring(startIndex, endIndex);
          break;
        }
      }
    }
    if (dadosJsonString.isEmpty) {
      throw Exception('Objeto JSON de previsões não encontrado no script da página. URL: $url');
    }

    // Guarda os novos dados e o timestamp no cache
    await prefs.setString(chaveCache, dadosJsonString);
    await prefs.setString(chaveTimestamp, DateTime.now().toIso8601String());

    return json.decode(dadosJsonString);
  }

  // Os métodos públicos agora aceitam um parâmetro para forçar o refresh
  Future<List<Astrologo>> fetchAstrologos({bool forcarRefresh = false}) async {
    final url = '${_baseUrl}maria-helena-martins/virgem';
    final todosOsDados = await _extrairJsonDePagina(url, ignorarCache: forcarRefresh);

    final List<Astrologo> listaAstrologos = [];
    todosOsDados.forEach((key, value) {
      if (value is Map && value.containsKey('Slug') && value.containsKey('Name') && value.containsKey('Previsoes')) {
        String descLimpa = value['Desc'] ?? 'Sem descrição';
        descLimpa = descLimpa.replaceAll(RegExp(r'<[^>]*>'), '').trim();
        listaAstrologos.add(
          Astrologo(
            id: value['Slug'],
            nome: value['Name'],
            fotoUrl: value['Photo'] ?? '',
            especialidade: descLimpa,
          ),
        );
      }
    });
    if (listaAstrologos.isEmpty) throw Exception('Nenhum astrólogo com previsões foi encontrado.');
    return listaAstrologos;
  }

  Future<Previsao> fetchPrevisao({
    required String astrologoId,
    required String signoId,
    required String periodoId,
    bool forcarRefresh = false,
  }) async {
    final url = '$_baseUrl$astrologoId/$signoId';
    final todosOsDados = await _extrairJsonDePagina(url, ignorarCache: forcarRefresh);

    String? nomeAstrologoEncontrado;
    String? conteudoPrevisao;
    String dataPrevisaoExtraida = '';

    final entradaAstrologo = todosOsDados.values.firstWhere(
      (value) => value is Map && value['Slug']?.toLowerCase() == astrologoId.toLowerCase(),
      orElse: () => null,
    );

    if (entradaAstrologo != null && entradaAstrologo.containsKey('Previsoes')) {
      nomeAstrologoEncontrado = entradaAstrologo['Name'];
      final previsoesDoAstrologo = entradaAstrologo['Previsoes'] as List;
      final previsaoDoSigno = previsoesDoAstrologo.firstWhere(
        (p) => p['Sign']?.toLowerCase() == signoId.toLowerCase(),
        orElse: () => null,
      );

      if (previsaoDoSigno != null) {
        final periodoNormalizado = periodoId.toLowerCase();
        String periodoFormatado;
        if (periodoNormalizado == 'diario') {
          periodoFormatado = 'Diaria';
        } else {
          periodoFormatado = periodoNormalizado[0].toUpperCase() + periodoNormalizado.substring(1);
        }
        
        if (previsaoDoSigno.containsKey('Periods') && previsaoDoSigno['Periods'].containsKey(periodoFormatado)) {
          conteudoPrevisao = previsaoDoSigno['Periods'][periodoFormatado];
        }

        if (previsaoDoSigno.containsKey('PeriodsLabels') && previsaoDoSigno['PeriodsLabels'].containsKey(periodoFormatado)) {
          dataPrevisaoExtraida = previsaoDoSigno['PeriodsLabels'][periodoFormatado];
        }
      }
    }

    if (conteudoPrevisao == null || conteudoPrevisao.isEmpty) {
      throw Exception('Previsão não encontrada para a combinação fornecida. URL: $url');
    }

    return Previsao(
      signo: signoId,
      astrologoNome: nomeAstrologoEncontrado ?? astrologoId.replaceAll('-', ' ').split(' ').map((l) => l[0].toUpperCase()+l.substring(1)).join(" "),
      astrologoId: astrologoId,
      periodo: periodoId,
      conteudoHtml: conteudoPrevisao,
      dataPrevisao: dataPrevisaoExtraida,
    );
  }
}
