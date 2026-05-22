import 'package:flutter/material.dart';

class EditarTreinoPage extends StatefulWidget {
  const EditarTreinoPage({super.key});

  @override
  State<EditarTreinoPage> createState() => _EditarTreinoPageState();
}

class _EditarTreinoPageState extends State<EditarTreinoPage> {
  // Controladores pré-preenchidos com dados simulados de um treino
  late TextEditingController nomeTreinoController;
  late TextEditingController focoTreinoController;
  late TextEditingController observacoesController;

  // Cores padrão do seu app
  final Color corFundo = const Color(0xFFF4FAF1);
  final Color corPrimaria = const Color(0xFF0F7A40);

  @override
  void initState() {
    super.initState();
    nomeTreinoController = TextEditingController(text: 'Treino A - Superior');
    focoTreinoController = TextEditingController(text: 'Hipertrofia e Força');
    observacoesController = TextEditingController(
      text: 'Focar na cadência do movimento. 60 segundos de descanso entre as séries.',
    );
  }

  @override
  void dispose() {
    nomeTreinoController.dispose();
    focoTreinoController.dispose();
    observacoesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          'Editar Treino',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 24),

            // --- Campo: Nome do Treino ---
            _buildInputLabel('Nome do Treino'),
            TextField(
              controller: nomeTreinoController,
              decoration: _buildInputDecoration('Ex: Treino A - Peito e Tríceps'),
            ),
            
            const SizedBox(height: 24),

            // --- Campo: Foco / Objetivo do Treino ---
            _buildInputLabel('Foco do Treino'),
            TextField(
              controller: focoTreinoController,
              decoration: _buildInputDecoration('Ex: Hipertrofia, Resistência, Cardio...'),
            ),

            const SizedBox(height: 24),

            // --- Campo: Observações (Multi-linha para detalhes/séries) ---
            _buildInputLabel('Observações / Instruções'),
            TextField(
              controller: observacoesController,
              maxLines: 4, // Permite que o campo seja maior para textos longos
              keyboardType: TextInputType.multiline,
              decoration: _buildInputDecoration('Adicione detalhes sobre séries, repetições ou descanso...'),
            ),

            const SizedBox(height: 60),

            // --- Botão Salvar Alterações ---
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para salvar as alterações do treino
                  print("Nome do Treino: ${nomeTreinoController.text}");
                  print("Foco: ${focoTreinoController.text}");
                  print("Observações: ${observacoesController.text}");
                  
                  // Retorna para a tela anterior
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: corPrimaria,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Salvar Alterações',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- Widgets Auxiliares Padronizados ---

  Widget _buildInputLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0, left: 4),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      fillColor: Colors.white,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: corPrimaria, width: 2),
      ),
    );
  }
}