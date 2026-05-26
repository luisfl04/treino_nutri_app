import 'package:flutter/material.dart';

class RefeicaoDetalhePage extends StatelessWidget {
  const RefeicaoDetalhePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dados simulados (você poderá receber por parâmetro depois)
    const String nomeRefeicao = 'Salada com Frango Grelhado';
    const String categoria = 'Almoço';
    const String calorias = '350 Kcal';

    final Color corFundo = const Color(0xFFF4FAF1);
    final Color corPrimaria = const Color(0xFF0F7A40);

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
          'Detalhes Refeição',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            
            // Título da Refeição
            Text(
              nomeRefeicao,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Categoria
            Text(
              categoria,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            
            const SizedBox(height: 48),

            // Seção Valor Calórico
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Valor Calórico Estimado',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    calorias,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  // Linha decorativa
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    height: 1,
                    width: 120,
                    color: Colors.black12,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Seção Foto
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Foto da Refeição',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            const SizedBox(height: 16),

            // Container da Foto (Placeholder)
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black12),
              ),
              child: const Center(
                child: Icon(
                  Icons.add_a_photo_outlined,
                  size: 80,
                  color: Colors.black,
                ),
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

