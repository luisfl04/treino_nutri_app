import 'package:flutter/material.dart';
import 'package:treino_nutri_app/routes/app_routes.dart';
import 'package:treino_nutri_app/widgets/bottom_navigation_widget.dart';
import 'package:treino_nutri_app/widgets/refeicao_card_widget.dart';

class AlimentacaoPage extends StatefulWidget {
  const AlimentacaoPage({super.key});

  @override
  State<AlimentacaoPage> createState() => _AlimentacaoPageState();
}

class _AlimentacaoPageState extends State<AlimentacaoPage> {
  int _selectedIndex = 2; // Alimentação está selecionado

  // Lista de refeições (dados de exemplo)
  final List<Map<String, String>> refeicoes = [
    {
      'categoria': 'Café da Manhã',
      'nome': 'Vitamina de Banana e Aveia',
      'calorias': '350 Kcal',
    },
    {
      'categoria': 'Almoço',
      'nome': 'Salada com Frango Grelhado',
      'calorias': '450 Kcal',
    },
    {
      'categoria': 'Lanche',
      'nome': 'Iogurte com Granola',
      'calorias': '200 Kcal',
    },
    {
      'categoria': 'Jantar',
      'nome': 'Peixe com Batata Doce',
      'calorias': '500 Kcal',
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
          'Minhas Refeições',
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
              // Lista de refeições
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: refeicoes.length,
                itemBuilder: (context, index) {
                  final refeicao = refeicoes[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: RefeicaoCard(
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.refeicaoDetalhe);
                      },
                      categoria: refeicao['categoria']!,
                      nome: refeicao['nome']!,
                      calorias: refeicao['calorias']!,
                      onEdit: () {
                        Navigator.of(context).pushNamed(AppRoutes.editarRefeicao);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Editar refeição'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              // Botão Novo Treino (texto diz "Novo Treino" mas é para nova refeição)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.refeicaoCadastro);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ir para criar nova refeição'),
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
                    'Nova Refeição',
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