// lib/widgets/previsao_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share_plus/share_plus.dart';
import '../models/previsao_model.dart';

class PrevisaoCard extends StatefulWidget {
  final Previsao previsao;
  final String titulo;
  final bool isInicialmenteExpandido;

  const PrevisaoCard({
    super.key,
    required this.previsao,
    required this.titulo,
    this.isInicialmenteExpandido = false,
  });

  @override
  PrevisaoCardState createState() => PrevisaoCardState();
}

class PrevisaoCardState extends State<PrevisaoCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isInicialmenteExpandido;
  }

  void _partilharPrevisao() {
    // Remove as tags HTML do conteúdo para partilhar como texto simples
    final textoSimples = widget.previsao.conteudoHtml
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .trim();

    // Constrói a mensagem completa
    final String textoParaPartilhar =
        'Horóscopo para ${widget.previsao.signo[0].toUpperCase()}${widget.previsao.signo.substring(1)} '
        '(${widget.previsao.dataPrevisao}) por ${widget.previsao.astrologoNome}:\n\n'
        '$textoSimples\n\n'
        '*Enviado pela app Horóscopo SAPO*';

    // Usa o pacote share_plus para partilhar
    Share.share(textoParaPartilhar, subject: 'Previsão de Horóscopo');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.titulo,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: widget.previsao.dataPrevisao.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      widget.previsao.dataPrevisao,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.share),
                  tooltip: 'Partilhar Previsão',
                  onPressed: _partilharPrevisao,
                ),
                IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
              ],
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
              child: Html(
                data: widget.previsao.conteudoHtml,
                style: {
                  "body": Style(
                    fontSize: FontSize(16.0),
                    lineHeight: const LineHeight(1.5),
                  ),
                },
              ),
            ),
        ],
      ),
    );
  }
}
