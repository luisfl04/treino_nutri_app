import 'package:flutter/material.dart';

class TreinoDetalhePage extends StatelessWidget {
  const TreinoDetalhePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dados passados (você pode receber isso via construtor depois)
    const String nomeTreino = 'Peito e Tríceps';
    const String dataTreino = '17/06/2026';
    const String duracao = '45 Min';
    const String totalExercicios = '5 exercícios';

    return Scaffold(
      // Cor de fundo levemente esverdeada baseada na imagem
      backgroundColor: const Color(0xFFF4F7F4), 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
          nomeTreino,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B1B1B),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          // Subtítulo com Data, Duração e Qtd de Exercícios
          Center(
            child: Text(
              'Data: $dataTreino  •  $duracao  •  $totalExercicios',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Lista de Exercícios
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              itemCount: 3, // Aqui você colocaria o tamanho da sua lista real (ex: 5)
              itemBuilder: (context, index) {
                return _buildExercicioCard();
              },
            ),
          ),

          // Botão Finalizar Treino fixo na parte inferior
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Ação de finalizar o treino
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B7A38), // Verde escuro da imagem
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Finalizar Treino',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget separado para o Card do Exercício para manter o código limpo
  Widget _buildExercicioCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Ícone/Imagem do exercício
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.fitness_center, // TROQUE AQUI pelo seu asset (ex: Image.asset('assets/icons/rosca.png'))
              size: 32,
              color: Color(0xFF1B1B1B),
            ),
          ),
          const SizedBox(width: 16),
          
          // Informações do exercício
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rosca Direta',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B1B1B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tempo: 15 Min',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '10 series',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}