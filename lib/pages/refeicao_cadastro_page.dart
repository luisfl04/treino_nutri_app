import 'package:flutter/material.dart';

class RefeicaoCadastroPage extends StatefulWidget {
  const RefeicaoCadastroPage({super.key});

  @override
  State<RefeicaoCadastroPage> createState() => _RefeicaoCadastroPageState();
}

class _RefeicaoCadastroPageState extends State<RefeicaoCadastroPage> {
  String tipoRefeicaoSelecionada = 'Café da Manhã';
  bool refeicaoConcluida = true;
  
  // Controlador para pegar o texto digitado nos alimentos
  final TextEditingController alimentosController = TextEditingController();

  final Color corFundo = const Color(0xFFF4FAF1); 
  final Color corPrimaria = const Color(0xFF0F7A40); 
  final Color corChipSelecionado = const Color(0xFF28C25E); 

  @override
  void dispose() {
    alimentosController.dispose();
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
          'Nova Refeição',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Tipo de Refeição ---
            _buildSectionTitle('Tipo de Refeição'),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: ['Café da Manhã', 'Almoço', 'Lanche', 'Jantar'].map((tipo) {
                return _buildCustomChip(
                  label: tipo,
                  isSelected: tipoRefeicaoSelecionada == tipo,
                  onTap: () => setState(() => tipoRefeicaoSelecionada = tipo),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // --- Calorias Estimadas ---
            _buildSectionTitle('Calorias Estimadas'),
            TextField(
              decoration: InputDecoration(
                hintText: 'EX: 450 kcal',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),

            // --- Adicionar Alimentos (Agora é um TextField livre) ---
            _buildSectionTitle('Adicione os Alimentos'),
            TextField(
              controller: alimentosController,
              maxLines: 2, // Permite digitar um pouquinho mais caso a refeição seja grande
              decoration: InputDecoration(
                hintText: 'EX: Frango com salada',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 24),

            // --- Foto da Refeição ---
            _buildSectionTitle('Foto da Refeição'),
            GestureDetector(
              onTap: () {
                // TODO: Lógica para abrir câmera/galeria
              },
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12),
                ),
                child: const Center(
                  child: Icon(Icons.add_photo_alternate_outlined, size: 80, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- Botão Salvar ---
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Aqui você pode acessar o texto digitado assim:
                  // print(alimentosController.text);
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
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
      ),
    );
  }

  Widget _buildCustomChip({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? corChipSelecionado : Colors.white,
          borderRadius: BorderRadius.circular(20),
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