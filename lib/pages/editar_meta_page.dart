import 'package:flutter/material.dart';

class EditarMetaPage extends StatefulWidget {
  const EditarMetaPage({super.key});

  @override
  State<EditarMetaPage> createState() => _EditarMetaPageState();
}

class _EditarMetaPageState extends State<EditarMetaPage> {
  // Controladores pré-preenchidos com os dados simulados
  late TextEditingController tipoMetaController;
  late TextEditingController pesoAtualController;
  late TextEditingController pesoAlmejadoController;
  late TextEditingController dataFinalController;

  // Cores padrão do app
  final Color corFundo = const Color(0xFFF4FAF1);
  final Color corPrimaria = const Color(0xFF0F7A40);

  @override
  void initState() {
    super.initState();
    tipoMetaController = TextEditingController(text: 'Emagrecimento');
    pesoAtualController = TextEditingController(text: '89');
    pesoAlmejadoController = TextEditingController(text: '67');
    dataFinalController = TextEditingController(text: '17/06/2026');
  }

  @override
  void dispose() {
    tipoMetaController.dispose();
    pesoAtualController.dispose();
    pesoAlmejadoController.dispose();
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
          'Editar Meta',
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

            // --- Campo: Tipo de Meta / Objetivo ---
            _buildInputLabel('Objetivo Principal'),
            TextField(
              controller: tipoMetaController,
              decoration: _buildInputDecoration('Ex: Emagrecimento, Hipertrofia...'),
            ),
            
            const SizedBox(height: 24),

            // --- Campo: Peso Atual ---
            _buildInputLabel('Peso atual (kg)'),
            TextField(
              controller: pesoAtualController,
              keyboardType: TextInputType.number,
              decoration: _buildInputDecoration('Ex: 89.5'),
            ),

            const SizedBox(height: 24),

            // --- Campo: Peso Almejado ---
            _buildInputLabel('Peso almejado (kg)'),
            TextField(
              controller: pesoAlmejadoController,
              keyboardType: TextInputType.number,
              decoration: _buildInputDecoration('Ex: 67.0'),
            ),

            const SizedBox(height: 24),

            // --- Campo: Data Final ---
            _buildInputLabel('Data final da meta'),
            TextField(
              controller: dataFinalController,
              // Torna o campo somente leitura se quiser forçar o usuário a usar um DatePicker no futuro
              // readOnly: true, 
              decoration: _buildInputDecoration(
                'DD/MM/AAAA',
                suffixIcon: Icon(Icons.calendar_month_outlined, color: Colors.grey[600]),
              ),
            ),

            const SizedBox(height: 60),

            // --- Botão Salvar Alterações ---
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para salvar a meta
                  print("Objetivo: ${tipoMetaController.text}");
                  print("Peso Atual: ${pesoAtualController.text}");
                  print("Peso Almejado: ${pesoAlmejadoController.text}");
                  print("Data Final: ${dataFinalController.text}");
                  
                  // Retorna para a tela anterior após salvar
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

  // --- Widgets Auxiliares ---

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

  InputDecoration _buildInputDecoration(String hint, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      fillColor: Colors.white,
      filled: true,
      suffixIcon: suffixIcon,
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