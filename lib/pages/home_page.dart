import 'dart:io';
import 'package:flutter/material.dart';
import 'package:treino_nutri_app/routes/app_routes.dart';
import 'package:treino_nutri_app/widgets/bottom_navigation_widget.dart';
import 'package:treino_nutri_app/models/Usuario.dart';
import 'package:treino_nutri_app/widgets/metas_carousel_widget.dart';
import 'package:treino_nutri_app/controllers/AuthController.dart';
import 'package:treino_nutri_app/controllers/MetasController.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isLoading = true;

  final MetaController _metaController = MetaController();
  List<Map<String, dynamic>> _minhasMetas = [];

  @override
  void initState() {
    super.initState();
    _verificarSessao();
  }

  Future<void> _verificarSessao() async {
    await AuthController.recuperarSessao();
    await _carregarMetasReal(); // Busca as metas no SQLite
    if (mounted) {
      setState(() {
        _isLoading = false; // Retira o loading da tela
      });
    }
  }

  // Busca as metas
  Future<void> _carregarMetasReal() async {
    final metasDoBanco = await _metaController
        .buscarMetas(); 
    if (mounted) {
      setState(() {
        _minhasMetas = metasDoBanco;
      });
    }
  }

  void _fazerLogout() async {
    await AuthController.sair();

    if (!mounted) return;
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF1B7E3D)),
        ),
      );
    }

    final Usuario? usuarioLogado = AuthController.usuarioLogado;
    final String nomeExibir = usuarioLogado?.nome ?? 'Visitante';
    final String? caminhoFoto = usuarioLogado?.path_foto_perfil?.trim();

    final bool temFoto =
        caminhoFoto != null &&
        caminhoFoto.isNotEmpty &&
        File(caminhoFoto).existsSync();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SEÇÃO DE PERFIL ---
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF1B7E3D),
                        width: 2,
                      ),
                      color: Colors.grey[300],
                      image: temFoto
                          ? DecorationImage(
                              image: FileImage(File(caminhoFoto)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: temFoto
                        ? null
                        : const Icon(
                            Icons.person,
                            color: Colors.grey,
                            size: 30,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bem vindo, $nomeExibir',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1B1B1B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _fazerLogout,
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: Colors.redAccent,
                      size: 28,
                    ),
                    tooltip: 'Sair',
                  ),
                ],
              ),
              const SizedBox(height: 32),

              //  Condição: A seção e o Carrossel só aparecem se houverem metas salvas no banco
              if (_minhasMetas.isNotEmpty) ...[
                const Text(
                  'Minhas Metas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B1B1B),
                  ),
                ),
                const SizedBox(height: 16),
                // UniqueKey força o carrossel a redesenhar-se do zero após alterações nas metas
                MetasCarouselWidget(key: UniqueKey()),
                const SizedBox(height: 24),
              ],

              // --- SEÇÃO DE BOTÕES ---
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.treinos).then((_) {
                    _carregarMetasReal(); // Recarrega se o treino atualizar a meta
                  });
                },
                child: _buildActionCard(
                  'Treinos',
                  Icons.fitness_center,
                  const Color(0xFF1B7E3D),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.alimentacao).then((
                    _,
                  ) {
                    _carregarMetasReal();
                  });
                },
                child: _buildActionCard(
                  'Alimentação',
                  Icons.restaurant,
                  const Color(0xFFFF9800),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  // Ao voltar da tela de gerenciar metas, recarrega o estado atualizado do banco
                  Navigator.of(context).pushNamed(AppRoutes.metas).then((_) {
                    _carregarMetasReal();
                  });
                },
                child: _buildActionCard(
                  'Gerenciar Metas',
                  Icons.show_chart,
                  const Color(0xFF9FA8DA),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          if (index != _selectedIndex) {
            setState(() => _selectedIndex = index);
          }
        },
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1B1B1B),
            ),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }
}
