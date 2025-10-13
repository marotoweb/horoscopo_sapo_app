// lib/screens/home_screen.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../models/signo_model.dart';
import 'tabs/previsores_tab_screen.dart';
import 'tabs/signos_tab_screen.dart';
import 'sobre_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedSignoId = 'carneiro';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ExpansibleController _expansionTileController = ExpansibleController();

  bool _isFirstTimeExpansion = false;
  bool _isDrawerTileExpanded = false;

  final List<Signo> _signos = const [
    Signo(
      id: 'carneiro',
      nome: 'Carneiro',
      datas: '21/03 a 20/04',
      simbolo: '\u2648',
    ),
    Signo(
      id: 'touro',
      nome: 'Touro',
      datas: '21/04 a 20/05',
      simbolo: '\u2649',
    ),
    Signo(
      id: 'gemeos',
      nome: 'Gémeos',
      datas: '21/05 a 20/06',
      simbolo: '\u264A',
    ),
    Signo(
      id: 'caranguejo',
      nome: 'Caranguejo',
      datas: '21/06 a 22/07',
      simbolo: '\u264B',
    ),
    Signo(id: 'leao', nome: 'Leão', datas: '23/07 a 22/08', simbolo: '\u264C'),
    Signo(
      id: 'virgem',
      nome: 'Virgem',
      datas: '23/08 a 22/09',
      simbolo: '\u264D',
    ),
    Signo(
      id: 'balanca',
      nome: 'Balança',
      datas: '23/09 a 22/10',
      simbolo: '\u264E',
    ),
    Signo(
      id: 'escorpiao',
      nome: 'Escorpião',
      datas: '23/10 a 21/11',
      simbolo: '\u264F',
    ),
    Signo(
      id: 'sagitario',
      nome: 'Sagitário',
      datas: '22/11 a 21/12',
      simbolo: '\u2650',
    ),
    Signo(
      id: 'capricornio',
      nome: 'Capricórnio',
      datas: '22/12 a 19/01',
      simbolo: '\u2651',
    ),
    Signo(
      id: 'aquario',
      nome: 'Aquário',
      datas: '20/01 a 18/02',
      simbolo: '\u2652',
    ),
    Signo(
      id: 'peixes',
      nome: 'Peixes',
      datas: '19/02 a 20/03',
      simbolo: '\u2653',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _carregarPreferenciasEVerificarPrimeiraExecucao();
  }

  Future<void> _carregarPreferenciasEVerificarPrimeiraExecucao() async {
    final prefs = await SharedPreferences.getInstance();
    final signoGuardado = prefs.getString('signoFavorito');
    if (signoGuardado != null) {
      setState(() {
        _selectedSignoId = signoGuardado;
      });
    }
    final bool jaAbriuAntes = prefs.getBool('jaAbriuAntes') ?? false;
    if (!jaAbriuAntes) {
      setState(() {
        _isFirstTimeExpansion = true;
        _isDrawerTileExpanded = true;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scaffoldKey.currentState?.openDrawer();
        if (_isFirstTimeExpansion) {
          _expansionTileController.expand();
        }
      });
      await prefs.setBool('jaAbriuAntes', true);
    }
  }

  Future<void> _guardarSignoFavorito(String signoId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('signoFavorito', signoId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _mostrarDialogoDeTema() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Escolher Tema'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                title: const Text('Claro'),
                value: ThemeMode.light,
                groupValue: MyApp.of(context).currentThemeMode,
                onChanged: (ThemeMode? value) {
                  MyApp.of(context).changeTheme(value!);
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Escuro'),
                value: ThemeMode.dark,
                groupValue: MyApp.of(context).currentThemeMode,
                onChanged: (ThemeMode? value) {
                  MyApp.of(context).changeTheme(value!);
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Padrão do Sistema'),
                value: ThemeMode.system,
                groupValue: MyApp.of(context).currentThemeMode,
                onChanged: (ThemeMode? value) {
                  MyApp.of(context).changeTheme(value!);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _abrirUrlDeOpiniao() async {
    final Uri url = Uri.parse(
      'https://github.com/marotoweb/horoscopo_sapo_app/issues/new',
    );
    if (!await launchUrl(url)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o link.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Signo signoAtivo = _signos.firstWhere(
      (s) => s.id == _selectedSignoId,
      orElse: () => _signos.first,
    );
    final Color corPrimaria = Theme.of(context).primaryColor;
    final Color corDeFundoDrawer = Theme.of(context).colorScheme.surface;

    final Color corTextoCabecalho = _isDrawerTileExpanded
        ? corPrimaria
        : Colors.white;

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: SafeArea(
          child: Material(
            color: corDeFundoDrawer,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: corPrimaria, // Cor de fallback
                    image: DecorationImage(
                      image: const AssetImage(
                        'assets/images/drawer_background.png',
                      ),
                      fit: BoxFit.cover,
                      // Adiciona uma sobreposição de cor para dar o tom roxo
                      colorFilter: ColorFilter.mode(
                        corPrimaria.withValues(alpha: 0.85),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                  child: ExpansionTile(
                    key: const Key('drawerExpansionTile'),
                    initiallyExpanded: _isFirstTimeExpansion,
                    controller: _expansionTileController,
                    onExpansionChanged: (isExpanded) {
                      setState(() {
                        _isDrawerTileExpanded = isExpanded;
                      });
                    },
                    title: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                      ), // Adiciona mais espaço vertical
                      child: Row(
                        children: [
                          Text(
                            signoAtivo.simbolo,
                            style: TextStyle(
                              fontSize: 40,
                              color: corTextoCabecalho,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                signoAtivo.nome,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: corTextoCabecalho,
                                ),
                              ),
                              Text(
                                signoAtivo.datas,
                                style: TextStyle(
                                  color: _isDrawerTileExpanded
                                      ? Colors.grey[400]
                                      : Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    trailing: Icon(Icons.expand_more, color: corTextoCabecalho),
                    children: _signos.map((signo) {
                      final isSelected = signo.id == _selectedSignoId;
                      final Color corTextoItem = isSelected
                          ? corPrimaria
                          : Theme.of(context).colorScheme.onSurface;
                      final Color corSimboloItem = isSelected
                          ? corPrimaria
                          : Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.7);

                      return Material(
                        color: isSelected
                            ? corPrimaria.withValues(alpha: 0.1)
                            : Colors.transparent,
                        child: ListTile(
                          leading: Text(
                            signo.simbolo,
                            style: TextStyle(
                              fontSize: 24,
                              color: corSimboloItem,
                            ),
                          ),
                          title: Text(
                            signo.nome,
                            style: TextStyle(
                              color: corTextoItem,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _selectedSignoId = signo.id;
                            });
                            _guardarSignoFavorito(signo.id);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.brightness_6_outlined,
                    color: Colors.grey[600],
                  ),
                  title: const Text('Mudar Tema'),
                  onTap: () {
                    Navigator.pop(context);
                    _mostrarDialogoDeTema();
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.rate_review_outlined,
                    color: Colors.grey[600],
                  ),
                  title: const Text('Deixar opinião'),
                  onTap: () {
                    Navigator.pop(context);
                    _abrirUrlDeOpiniao();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.info_outline, color: Colors.grey[600]),
                  title: const Text('Sobre'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SobreScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Horóscopo: ${signoAtivo.nome}'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'PREVISORES'),
            Tab(text: 'SIGNOS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          PrevisoresTabScreen(signoAtivo: signoAtivo),
          SignosTabScreen(signos: _signos, signoFavorito: signoAtivo),
        ],
      ),
    );
  }
}
