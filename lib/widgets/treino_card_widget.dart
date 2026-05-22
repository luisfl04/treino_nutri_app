import 'package:flutter/material.dart';

class TreinoCardWidget extends StatelessWidget {
  final String nome;
  final String exercicios;
  final String duracao;
  final String data;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const TreinoCardWidget({
    super.key,
    required this.nome,
    required this.exercicios,
    required this.duracao,
    required this.data,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título do treino
            Text(
              nome,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B1B1B),
              ),
            ),
            const SizedBox(height: 8),
            // Info: exercícios e duração
            Row(
              children: [
                // Exercícios
                Row(
                  children: [
                    const Icon(
                      Icons.fitness_center,
                      size: 16,
                      color: Color(0xFF1B1B1B),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      exercicios,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1B1B1B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // Duração
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: Color(0xFF1B1B1B),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      duracao,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1B1B1B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Data
            Text(
              'Data: $data',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            // Botões de ação
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Botão Editar
                OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Editar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1B7E3D),
                    side: const BorderSide(
                      color: Color(0xFF1B7E3D),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Botão Excluir
                OutlinedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, size: 16),
                  label: const Text('Excluir'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(
                      color: Colors.red,
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