import 'package:flutter/material.dart';
import 'package:treino_nutri_app/routes/app_routes.dart';
import 'package:treino_nutri_app/widgets/bottom_navigation_widget.dart';
import 'package:treino_nutri_app/widgets/meta_card_widget.dart';

class MetasPage extends StatefulWidget {
  const MetasPage({super.key});

  @override
  State<MetasPage> createState() => _MetasPageState();
}

class _MetasPageState extends State<MetasPage> {
  int _selectedIndex = 3; // Metas está selecionado

  // Lista de metas (dados de exemplo)
  final List<Map<String, dynamic>> metas = [
    {
      'titulo': 'Perder 5kg',
      'descricao': 'Faltam 1.2kg',
      'categoria': 'Nutrição',
      'progresso': '75%',
      'concluido': false,
    },
    {
      'titulo': 'Beber 3L de Água',
      'descricao': 'Concluído',
      'categoria': 'Hábito',
      'progresso': '100%',
      'concluido': true,
    },
    {
      'titulo': 'Treinar 4x por semana',
      'descricao': 'Faltam 2 treinos',
      'categoria': 'Exercício',
      'progresso': '50%',
      'concluido': false,
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
          'Minhas Metas',
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
              // Lista de metas
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: metas.length,
                itemBuilder: (context, index) {
                  final meta = metas[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: MetaCardWidget(
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.metaDetalhe);
                      },
                      titulo: meta['titulo'],
                      descricao: meta['descricao'],
                      categoria: meta['categoria'],
                      progresso: meta['progresso'],
                      concluido: meta['concluido'],
                      onEdit: () {
                        Navigator.of(context).pushNamed(AppRoutes.editarMeta);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Editar meta'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      onDelete: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Excluir meta'),
                            duration: Duration(seconds: 1),
                          ),
                        );
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
                    Navigator.of(context).pushNamed(AppRoutes.metaCadasrto);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ir para criar nova meta'),
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
                    'Nova Meta',
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