import 'package:flutter/material.dart';
import 'package:treino_nutri_app/controllers/MetasController.dart';

class MetaDetalhe extends StatelessWidget {
  const MetaDetalhe({super.key});

  @override
  Widget build(BuildContext context) {
    final meta = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};

    final String tipoMeta = meta['objetivo'] ?? 'Sem Objetivo';
    final String dataInicio = meta['data_inicio'] ?? '--/--/----';
    final String dataFinal = meta['data_fim'] ?? '--/--/----';
    final String pesoAtual = '${meta['peso_atual'] ?? 0.0} kg';
    final String pesoAlmejado = '${meta['peso_meta'] ?? 0.0} kg';

    final Color corFundo = const Color(0xFFF4FAF1);

    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        backgroundColor: corFundo,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detalhes da Meta',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailSection('Objetivo Selecionado', tipoMeta, Icons.track_changes),
            const SizedBox(height: 16),
            _buildDetailSection('Data de início', dataInicio, Icons.calendar_today),
            const SizedBox(height: 16),
            _buildDetailSection('Peso Atual', pesoAtual, Icons.fitness_center),
            const SizedBox(height: 16),
            _buildDetailSection('Peso Almejado', pesoAlmejado, Icons.flag),
            const SizedBox(height: 16),
            _buildDetailSection('Data final da meta', dataFinal, Icons.calendar_month),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              // 👉 Chama o controller para finalizar a meta
              final erro = await MetaController().finalizarMeta(meta['id']);
              
              if (erro == null) {
                Navigator.pop(context, true); 
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('🎯 Meta concluída com orgulho!'), backgroundColor: Colors.green),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(erro), backgroundColor: Colors.red),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F7A34),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
            child: const Text(
              'Finalizar Meta',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String label, String value, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0F7A34), size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}