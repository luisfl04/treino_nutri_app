import 'package:flutter/material.dart';

class MetaCardWidget extends StatelessWidget {
  final String titulo;
  final String descricao;
  final String categoria;
  final String progresso; 
  final bool concluido;
  
  // 👉 VoidCallback com '?' os tornam opcionais
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback onTap;

  const MetaCardWidget({
    super.key,
    required this.titulo,
    required this.descricao,
    required this.categoria,
    required this.progresso,
    required this.concluido,
    this.onEdit,
    this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color corPrimaria = Color(0xFF1B7E3D);

    return GestureDetector(
      onTap: onTap, // O card inteiro é clicável!
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Row(
          children: [
            if (!concluido)
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: corPrimaria.withOpacity(0.1),
                  border: Border.all(color: corPrimaria, width: 3),
                ),
                child: Center(
                  child: Text(
                    progresso,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: corPrimaria),
                  ),
                ),
              )
            else
              Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: corPrimaria),
                child: const Icon(Icons.check, color: Colors.white, size: 36),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1B1B)),
                  ),
                  const SizedBox(height: 4),
                  Text(descricao, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      categoria,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // 👉 Se onEdit E onDelete forem nulos, não cria os botões no card (usado na Home)
            if (onEdit != null || onDelete != null)
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!concluido && onEdit != null)
                    OutlinedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, size: 14),
                      label: const Text('Editar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: corPrimaria,
                        side: const BorderSide(color: corPrimaria),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      ),
                    ),
                  if (onDelete != null) ...[
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete, size: 14),
                      label: const Text('Excluir'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      ),
                    ),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}