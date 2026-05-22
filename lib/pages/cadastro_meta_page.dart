import 'package:flutter/material.dart';

class CadastrarMetaPage extends StatefulWidget {
  const CadastrarMetaPage({super.key});

  @override
  State<CadastrarMetaPage> createState() => _CadastrarMetaPageState();
}

class _CadastrarMetaPageState extends State<CadastrarMetaPage> {
  String objetivoSelecionado = 'Ganho de Massa';
  
  // Controllers para capturar os dados (Atualizados conforme a imagem)
  final TextEditingController pesoAtualController = TextEditingController();
  final TextEditingController pesoMetaController = TextEditingController();
  final TextEditingController dataInicioController = TextEditingController();
  final TextEditingController dataFinalController = TextEditingController();

  final Color corFundo = const Color(0xFFF4FAF1); 
  final Color corPrimaria = const Color(0xFF0F7A40); 
  final Color corChipSelecionado = const Color(0xFF28C25E); 

  @override
  void dispose() {
    pesoAtualController.dispose();
    pesoMetaController.dispose();
    dataInicioController.dispose();
    dataFinalController.dispose();
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
          'Cadastrar Meta',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            
            // --- Seção: Objetivo ---
            _buildSectionTitle('Qual o seu objetivo ?'),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: ['Ganho de Massa', 'Emagrecimento', 'Manter peso'].map((objetivo) {
                return _buildCustomChip(
                  label: objetivo,
                  isSelected: objetivoSelecionado == objetivo,
                  onTap: () => setState(() => objetivoSelecionado = objetivo),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),

            // --- Campo: Peso Atual ---
            _buildSectionTitle('Peso Atual (kg)'),
            _buildTextField(
              controller: pesoAtualController,
              hint: 'Digite seu peso atual',
              type: TextInputType.number,
            ),
            const SizedBox(height: 30),

            // --- Campo: Meta de Peso ---
            _buildSectionTitle('Meta de Peso (kg)'),
            _buildTextField(
              controller: pesoMetaController,
              hint: 'Digite o peso desejado',
              type: TextInputType.number,
            ),
            const SizedBox(height: 30),

            // --- Campo: Data Início ---
            _buildSectionTitle('Data Início'),
            _buildTextField(
              controller: dataInicioController,
              hint: 'ddmmyyyy',
              type: TextInputType.datetime,
            ),
            const SizedBox(height: 30),

            // --- Campo: Data Final ---
            _buildSectionTitle('Até quando pretende atingir ?'),
            _buildTextField(
              controller: dataFinalController,
              hint: 'ddmmyyyy',
              type: TextInputType.datetime,
            ),
            
            const SizedBox(height: 50),

            // --- Botão Salvar ---
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Aqui você pode implementar a lógica de salvar no banco
                  debugPrint("Salvando meta: $objetivoSelecionado");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: corPrimaria,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Salvar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- Widgets Auxiliares ---
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black87),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller, 
    required String hint, 
    required TextInputType type
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
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
          borderSide: BorderSide(color: corPrimaria),
        ),
      ),
      keyboardType: type,
    );
  }

  Widget _buildCustomChip({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? corChipSelecionado : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: isSelected ? corChipSelecionado : Colors.black26),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}