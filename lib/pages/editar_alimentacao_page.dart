import 'package:flutter/material.dart';

class EditarRefeicaoPage extends StatefulWidget {
  const EditarRefeicaoPage({super.key});

  @override
  State<EditarRefeicaoPage> createState() => _EditarRefeicaoPageState();
}

class _EditarRefeicaoPageState extends State<EditarRefeicaoPage> {
  // Controladores pré-preenchidos com dados simulados de uma refeição
  late TextEditingController nomeRefeicaoController;
  late TextEditingController horarioController;
  late TextEditingController descricaoController;
  late TextEditingController caloriasController;

  // Cores padrão do seu app
  final Color corFundo = const Color(0xFFF4FAF1);
  final Color corPrimaria = const Color(0xFF0F7A40);

  @override
  void initState() {
    super.initState();
    nomeRefeicaoController = TextEditingController(text: 'Almoço');
    horarioController = TextEditingController(text: '12:30');
    descricaoController = TextEditingController(
      text: '200g de arroz integral, 150g de peito de frango grelhado e salada verde à vontade.',
    );
    caloriasController = TextEditingController(text: '550');
  }

  @override
  void dispose() {
    nomeRefeicaoController.dispose();
    horarioController.dispose();
    descricaoController.dispose();
    caloriasController.dispose();
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
          'Editar Refeição',
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

            // --- Campo: Nome da Refeição ---
            _buildInputLabel('Nome da Refeição'),
            TextField(
              controller: nomeRefeicaoController,
              decoration: _buildInputDecoration('Ex: Café da Manhã, Lanche...'),
            ),
            
            const SizedBox(height: 24),

            // --- Campo: Horário ---
            _buildInputLabel('Horário'),
            TextField(
              controller: horarioController,
              decoration: _buildInputDecoration(
                'HH:MM',
                suffixIcon: Icon(Icons.access_time, color: Colors.grey[600]),
              ),
            ),

            const SizedBox(height: 24),

            // --- Campo: Descrição / Alimentos (Multi-linha) ---
            _buildInputLabel('Alimentos / Descrição'),
            TextField(
              controller: descricaoController,
              maxLines: 4, // Espaço ideal para listar os alimentos
              keyboardType: TextInputType.multiline,
              decoration: _buildInputDecoration('Liste os alimentos e as quantidades...'),
            ),

            const SizedBox(height: 24),

            // --- Campo: Calorias ---
            _buildInputLabel('Calorias Estimadas (kcal)'),
            TextField(
              controller: caloriasController,
              keyboardType: TextInputType.number,
              decoration: _buildInputDecoration('Ex: 450'),
            ),

            const SizedBox(height: 60),

            // --- Botão Salvar Alterações ---
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para salvar as alterações da refeição
                  print("Refeição: ${nomeRefeicaoController.text}");
                  print("Horário: ${horarioController.text}");
                  print("Descrição: ${descricaoController.text}");
                  print("Calorias: ${caloriasController.text}");
                  
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