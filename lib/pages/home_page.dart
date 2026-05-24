import 'package:flutter/material.dart';
import 'package:treino_nutri_app/routes/app_routes.dart';
import 'package:treino_nutri_app/widgets/bottom_navigation_widget.dart';
import 'package:treino_nutri_app/models/Usuario.dart'; // Importe o seu model!

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Removido o _carregarUsuario() e o initState()! A Home agora é muito mais leve e rápida.

  void _fazerLogout() {
    // Retorna para o login destruindo as telas anteriores
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login, 
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. RECEBE O USUÁRIO QUE VEIO DA TELA DE LOGIN
    final Usuario? usuarioLogado = ModalRoute.of(context)?.settings.arguments as Usuario?;
    
    // 2. Pega o nome. Se por algum motivo for nulo, chama de 'Visitante'
    final String nomeExibir = usuarioLogado?.nome ?? 'Visitante';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Seção de boas-vindas com foto e botão Sair
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
                      image: const DecorationImage(
                        image: AssetImage('assets/images/profile.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Texto de boas-vindas
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bem vindo, $nomeExibir', // DINÂMICO DE VERDADE!
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
              
              // --- (TODO O RESTO DOS SEUS CARDS CONTINUAM IGUAIS AQUI) ---
              
              // Card de Meta
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Meta',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B1B1B),
                          ),
                        ),
                        Text(
                          '75%',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B7E3D),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Perde 5 Kg',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: 0.75,
                        minHeight: 8,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF1B7E3D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Card Treinos
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.treinos),
                child: _buildActionCard('Treinos', Icons.fitness_center, const Color(0xFF1B7E3D)),
              ),
              const SizedBox(height: 12),
              // Card Alimentação
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.alimentacao),
                child: _buildActionCard('Alimentação', Icons.restaurant, const Color(0xFFFF9800)),
              ),
              const SizedBox(height: 12),
              // Card Metas
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.metas),
                child: _buildActionCard('Metas', Icons.show_chart, const Color(0xFF9FA8DA)),
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

  // Refatorei os seus cards para um método só, para o código ficar mais limpo!
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