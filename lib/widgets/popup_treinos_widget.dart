import 'package:flutter/material.dart';

class SelecaoExerciciosDialog extends StatefulWidget {
  final List<String> selecionadosPreviamente;
  final String tipoTreino; // <-- NOVO: Recebe o tipo selecionado (Ex: 'Yoga')

  const SelecaoExerciciosDialog({
    super.key,
    this.selecionadosPreviamente = const [],
    required this.tipoTreino, // Torna obrigatório
  });

  @override
  State<SelecaoExerciciosDialog> createState() => _SelecaoExerciciosDialogState();
}

class _SelecaoExerciciosDialogState extends State<SelecaoExerciciosDialog> {
  List<String> _selecionados = [];
  List<String> _exerciciosFiltrados = []; // <-- Lista que será exibida na tela

  // MOCK FORMATADO: Agora os exercícios são separados pelo tipo exato da tela
  final Map<String, List<String>> _exerciciosPorTipo = {
    'Musculação': [
      'Tríceps Pulley',
      'Supino Reto',
      'Rosca Direta',
      'Tríceps Corda',
      'Desenvolvimento',
      'Agachamento Livre',
    ],
    'Calistenia': [
      'Flexão de Braço (Push-up)',
      'Barra Fixa (Pull-up)',
      'Paralelas (Dips)',
      'Abdominal Infra',
      'Muscle-up',
    ],
    'Yoga': [
      'Saudação ao Sol (Surya Namaskar)',
      'Postura da Árvore (Vrikshasana)',
      'Cão Olhando para Baixo',
      'Postura do Guerreiro',
      'Postura da Criança (Balasana)',
    ],
    'Cardio': [
      'Corrida na Esteira',
      'Pular Corda',
      'Burpees',
      'Polichinelos',
      'Sprint de Bicicleta',
    ],
  };

  @override
  void initState() {
    super.initState();
    _selecionados = List.from(widget.selecionadosPreviamente);
    
    // FILTRAGEM MÁGICA: Pega apenas os exercícios do tipo escolhido
    _exerciciosFiltrados = _exerciciosPorTipo[widget.tipoTreino] ?? [];
  }

  void _toggleExercicio(String exercicio, bool? value) {
    setState(() {
      if (value == true) {
        _selecionados.add(exercicio);
      } else {
        _selecionados.remove(exercicio);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exibe dinamicamente o tipo no título para o usuário ver o filtro ativo
            Text(
              'Exercícios de ${widget.tipoTreino}', 
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B1B1B),
              ),
            ),
            const SizedBox(height: 24),
            
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  // Troca a lista antiga pela lista filtrada!
                  children: _exerciciosFiltrados.map((exercicio) {
                    final isSelected = _selecionados.contains(exercicio);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              exercicio,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF1B1B1B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: isSelected,
                              onChanged: (val) => _toggleExercicio(exercicio, val),
                              activeColor: const Color(0xFF0F7A40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: const BorderSide(color: Color(0xFF1B1B1B), width: 1.5),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Botões Cancelar e Confirmar
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context, _selecionados),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.green.shade50,
                    side: BorderSide(color: Colors.green.shade200),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: const Text('Confirmar', style: TextStyle(color: Color(0xFF1B7E3D), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}