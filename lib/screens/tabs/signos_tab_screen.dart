// Ficheiro: lib/screens/tabs/signos_tab_screen.dart

import 'package:flutter/material.dart';
import '../../models/signo_model.dart';
import '../signo_detalhe_screen.dart';

class SignosTabScreen extends StatelessWidget {
  final List<Signo> signos;
  final Signo signoFavorito;

  const SignosTabScreen({
    super.key,
    required this.signos,
    required this.signoFavorito,
  });

  Widget _buildSignoCard(BuildContext context, Signo signo) {
    final Color corPrimaria = Theme.of(context).primaryColor;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        onTap: () {
          final int indiceInicial = signos.indexWhere((s) => s.id == signo.id);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignoDetalheScreen(
                todosSignos: signos,
                indiceInicial: indiceInicial,
              ),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              signo.simbolo,
              style: TextStyle(fontSize: 70, color: corPrimaria),
            ),
            const SizedBox(height: 10),
            Text(
              signo.nome,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(signo.datas, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color corPrimaria = Theme.of(context).primaryColor;
    final outrosSignos = signos.where((s) => s.id != signoFavorito.id).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
      children: [
        Text(
          'O SEU SIGNO',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 4,
          color: corPrimaria.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            leading: Text(
              signoFavorito.simbolo,
              style: TextStyle(fontSize: 40, color: corPrimaria),
            ),
            title: Text(
              signoFavorito.nome,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(signoFavorito.datas),
            trailing: Icon(Icons.chevron_right, color: corPrimaria),
            onTap: () {
              final int indiceInicial = signos.indexWhere(
                (s) => s.id == signoFavorito.id,
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignoDetalheScreen(
                    todosSignos: signos,
                    indiceInicial: indiceInicial,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'TODOS OS SIGNOS',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.8,
          ),
          itemCount: outrosSignos.length,
          itemBuilder: (context, index) {
            return _buildSignoCard(context, outrosSignos[index]);
          },
        ),
      ],
    );
  }
}
