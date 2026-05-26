import 'package:flutter/material.dart';
import 'package:treino_nutri_app/routes/app_routes.dart';
import 'package:treino_nutri_app/widgets/bottom_navigation_widget.dart';
import 'package:treino_nutri_app/widgets/treino_card_widget.dart';

class TreinosPage extends StatefulWidget {
  const TreinosPage({super.key});

  @override
  State<TreinosPage> createState() => _TreinosPageState();
}

class _TreinosPageState extends State<TreinosPage> {
  int _selectedIndex = 1; // Treinos está selecionado

  // Lista de treinos (dados de exemplo)
  final List<Map<String, String>> treinos = [
    {
      'nome': 'Peito e Tríceps',
      'exercicios': '5 exercícios',
      'duracao': '45 Min',
      'data': '17/06/2026',
    },
    {
      'nome': 'Peito e Tríceps',
      'exercicios': '5 exercícios',
      'duracao': '45 Min',
      'data': '17/06/2026',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF1B1B1B),
            size: 28,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Meus Treinos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B1B1B),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lista de treinos
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: treinos.length,
                itemBuilder: (context, index) {
                  final treino = treinos[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TreinoCardWidget(
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.treinoDetalhe);
                      },
                      nome: treino['nome']!,
                      exercicios: treino['exercicios']!,
                      duracao: treino['duracao']!,
                      data: treino['data']!,
                      onEdit: () {
                        Navigator.of(context).pushNamed(AppRoutes.editarTreino);
                        ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('Editar')));
                      },
                      onDelete: () {
                        ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('Excluir')));
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              // Botão Novo Treino
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of( context).pushNamed(AppRoutes.treinoCadastro);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ir para criar novo treino'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B7E3D),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Novo Treino',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          if (index == 0) {
            Navigator.pop(context); // Voltar para Home
          }
        },
      ),
    );
  }
}
