import 'package:flutter/material.dart';

class RefeicaoCard extends StatelessWidget {
  final String categoria;
  final String nome;
  final String calorias;
  final VoidCallback onEdit;
  final VoidCallback onTap;

  const RefeicaoCard({
    super.key,
    required this.categoria,
    required this.nome,
    required this.calorias,
    required this.onEdit,
    required this.onTap,
  });

  // Função para obter a cor baseada na categoria
  Color _getCategoriaColor() {
    switch (categoria.toLowerCase()) {
      case 'café da manhã':
        return const Color(0xFF1B7E3D);
      case 'almoço':
        return const Color(0xFFFF9800);
      case 'lanche':
        return const Color(0xFFFFB74D);
      case 'jantar':
        return const Color(0xFF5C6BC0);
      default:
        return const Color(0xFF1B7E3D);
    }
  }

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
            // Categoria
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getCategoriaColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                categoria.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: _getCategoriaColor(),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Nome da refeição
            Text(
              nome,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B1B1B),
              ),
            ),
            const SizedBox(height: 12),
            // Calorias e botão
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Calorias
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      calorias,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B7E3D),
                      ),
                    ),
                    Text(
                      'Kcal',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}