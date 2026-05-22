import 'package:flutter/material.dart';

class SelecaoExerciciosDialog extends StatefulWidget {
  // Recebe os exercícios que já estavam selecionados (se houver)
  final List<String> selecionadosPreviamente;

  const SelecaoExerciciosDialog({
    super.key,
    this.selecionadosPreviamente = const [],
  });

  @override
  State<SelecaoExerciciosDialog> createState() => _SelecaoExerciciosDialogState();
}

class _SelecaoExerciciosDialogState extends State<SelecaoExerciciosDialog> {
  // Lista que vai guardar o que o usuário marcar
  List<String> _selecionados = [];

  // MOCK: Simulação de dados que viriam da sua API
  final List<String> _exerciciosDaApi = [
    'Tríceps Pulley',
    'Supino Reto',
    'Rosca Direta',
    'Tríceps Corda',
    'Desenvolvimento',
    'Agachamento Livre',
  ];

  @override
  void initState() {
    super.initState();
    // Inicia com os exercícios que já vieram marcados da tela anterior
    _selecionados = List.from(widget.selecionadosPreviamente);
    
    // DICA: Se for chamar a API real, você faria isso aqui no initState 
    // ou usaria um FutureBuilder no body do Dialog.
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
          mainAxisSize: MainAxisSize.min, // O dialog se ajusta ao tamanho do conteúdo
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecione o Treino',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B1B1B),
              ),
            ),
            const SizedBox(height: 24),
            
            // Lista de exercícios com Scroll (caso a API retorne muitos)
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: _exerciciosDaApi.map((exercicio) {
                    final isSelected = _selecionados.contains(exercicio);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            exercicio,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF1B1B1B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // Customizamos o Checkbox para ficar parecido com a imagem
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: isSelected,
                              onChanged: (val) => _toggleExercicio(exercicio, val),
                              activeColor: const Color(0xFF1B1B1B),
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
                  onPressed: () {
                    // Fecha o dialog retornando null (cancelou)
                    Navigator.pop(context); 
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.green.shade200),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {
                    // Fecha o dialog retornando a lista do que foi selecionado
                    Navigator.pop(context, _selecionados); 
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.green.shade50, // Fundo levemente esverdeado
                    side: BorderSide(color: Colors.green.shade200),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: const Text(
                    'Confirmar',
                    style: TextStyle(
                      color: Color(0xFF1B7E3D), // Verde escuro
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}