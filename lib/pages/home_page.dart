import 'dart:io'; // 👉 IMPORTANTE: Necessário para ler o arquivo da foto do celular!
import 'package:flutter/material.dart';
import 'package:treino_nutri_app/routes/app_routes.dart';
import 'package:treino_nutri_app/widgets/bottom_navigation_widget.dart';
import 'package:treino_nutri_app/models/Usuario.dart'; 
import 'package:treino_nutri_app/widgets/metas_carousel_widget.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _fazerLogout() {
    // Retorna para o login destruindo as telas anteriores
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    // 1. RECEBE O USUÁRIO QUE VEIO DA TELA DE LOGIN
    final Usuario? usuarioLogado =
        ModalRoute.of(context)?.settings.arguments as Usuario?;

    // 2. Pega o nome. Se por algum motivo for nulo, chama de 'Visitante'
    final String nomeExibir = usuarioLogado?.nome ?? 'Visitante';

    // 👉 NOVO: Lógica para verificar se o usuário tem uma foto salva no banco
    final String? caminhoFoto = usuarioLogado?.path_foto_perfil;
    final bool temFoto = caminhoFoto != null && caminhoFoto.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SEÇÃO DE BOAS VINDAS ---
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
                      // 👉 CORREÇÃO: Usa FileImage se a foto existir. Se não, fica nulo.
                      image: temFoto
                          ? DecorationImage(
                              image: FileImage(File(caminhoFoto)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    // 👉 CORREÇÃO: O Icon entra como "child" apenas se não houver foto.
                    child: temFoto
                        ? null
                        : const Icon(
                            Icons.person,
                            color: Colors.grey,
                            size: 30,
                          ),
                  ),
                  const SizedBox(width: 12),
                  // Texto de boas-vindas
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
                  // Botão de Logout
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

              // --- SEÇÃO DE METAS (CARROSSEL DINÂMICO) ---
              const Text(
                'Minhas Metas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B1B1B),
                ),
              ),
              const SizedBox(height: 16),

              // 👉 CHAMAMOS O CARROSSEL AQUI (ele faz tudo sozinho!)
              const MetasCarouselWidget(),

              const SizedBox(height: 24),

              // --- CARDS DE NAVEGAÇÃO ---
              // Card Treinos
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.treinos),
                child: _buildActionCard(
                  'Treinos',
                  Icons.fitness_center,
                  const Color(0xFF1B7E3D),
                ),
              ),
              const SizedBox(height: 12),
              // Card Alimentação
              GestureDetector(
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.alimentacao),
                child: _buildActionCard(
                  'Alimentação',
                  Icons.restaurant,
                  const Color(0xFFFF9800),
                ),
              ),
              const SizedBox(height: 12),
              // Card Metas (Abre a lista completa)
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.metas),
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
