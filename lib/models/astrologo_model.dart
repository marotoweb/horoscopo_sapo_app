// lib/models/astrologo_model.dart

class Astrologo {
  final String id;
  final String nome;
  final String? fotoUrl;
  final String? especialidade;

  Astrologo({
    required this.id,
    required this.nome,
    this.fotoUrl,
    this.especialidade,
  });
}
