import 'package:flutter/material.dart';
import 'package:treino_nutri_app/routes/app_routes.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BottomNavigationWidget({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          onTap(index);
          _navigateToPage(context, index);
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: const Color(0xFF1B7E3D),
        unselectedItemColor: Colors.grey[400],
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Home',
            backgroundColor: const Color(0xFF1B7E3D),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.fitness_center),
            label: 'Treinos',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.restaurant),
            label: 'Alimentação',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.show_chart),
            label: 'Metas',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}


void _navigateToPage(BuildContext context, int index) {
  // 1. Descobre o nome da rota atual para evitar recarregar a mesma página
  String? currentRoute = ModalRoute.of(context)?.settings.name;

  switch (index) {
    case 0:
      // Se já estiver na Home, não faz nada
      if (currentRoute == AppRoutes.home) return;
      
      // Volta para a Home limpando todas as outras telas da pilha
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
      break;

    case 1:
      if (currentRoute == AppRoutes.treinos) return;
      
      // Primeiro volta para a Home (base) e depois abre Treinos por cima.
      // Isso garante que se o usuário voltar, ele cai na Home em vez de uma tela preta.
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
      Navigator.pushNamed(context, AppRoutes.treinos);
      break;

    case 2:
      if (currentRoute == AppRoutes.alimentacao) return;
      
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
      Navigator.pushNamed(context, AppRoutes.alimentacao);
      break;

    case 3:
      if (currentRoute == AppRoutes.metas) return;
      
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
      Navigator.pushNamed(context, AppRoutes.metas);
      break;

    case 4:
      if (currentRoute == AppRoutes.perfil) return;
      
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
      Navigator.pushNamed(context, AppRoutes.perfil);
      break;
  }
}
 