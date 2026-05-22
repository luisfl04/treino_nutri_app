import 'package:flutter/material.dart';

class MetaDetalhe extends StatelessWidget {
  const MetaDetalhe({super.key});

  @override
  Widget build(BuildContext context) {
    // Dados simulados (você poderá receber isso via construtor da página)
    const String tipoMeta = 'Emagrecimento';
    const String dataInicio = '17/05/2026'; // NOVO CAMPO: Data de início
    const String pesoAtual = '89 kg';
    const String pesoAlmejado = '67 kg';
    const String dataFinal = '17/06/2026';

    // Cor de fundo padronizada das suas telas
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
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alinha os itens à esquerda
          children: [
            const SizedBox(height: 16),
            
            // Título Principal da Meta (Centralizado)
            const Center(
              child: Text(
                tipoMeta,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            
            const SizedBox(height: 8),

            // NOVO CAMPO: Data de Início (Centralizado)
            const Center(
              child: Text(
                dataInicio,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Peso Atual
            const Text(
              'Peso Atual',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              pesoAtual,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Peso Almejado
            const Text(
              'Peso Almejado',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              pesoAlmejado,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Data Final
            Text(
              'Data final da meta',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              dataFinal,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      // NOVO CAMPO: Botão "Finalizar Meta" fixado na parte inferior
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Lógica para finalizar a meta
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F7A34), // Cor verde do botão
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text(
              'Finalizar Meta',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}