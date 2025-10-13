// lib/models/previsao_model.dart

class Previsao {
  final String signo;
  final String astrologoNome;
  final String astrologoId;
  final String periodo;
  final String conteudoHtml;
  final String dataPrevisao;

  Previsao({
    required this.signo,
    required this.astrologoNome,
    required this.astrologoId,
    required this.periodo,
    required this.conteudoHtml,
    required this.dataPrevisao,
  });
}
