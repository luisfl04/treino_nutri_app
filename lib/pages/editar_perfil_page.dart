import 'package:flutter/material.dart';

class EditarPerfilPage extends StatefulWidget {
  const EditarPerfilPage({super.key});

  @override
  State<EditarPerfilPage> createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  // Controladores para os campos de texto
  final TextEditingController emailController = 
      TextEditingController(text: 'lucas33@gmail.com');
  final TextEditingController senhaController = 
      TextEditingController(text: '12345678901'); 
  // Novo controlador para o peso
  final TextEditingController pesoController = 
      TextEditingController(text: '89'); 

  // Variável de estado para controlar a visibilidade da senha
  bool _obscureSenha = true;

  final Color corFundo = const Color(0xFFF4FAF1); 
  final Color corPrimaria = const Color(0xFF0F7A40); 

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    pesoController.dispose(); // Não esqueça de fazer o dispose do novo controlador
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
          'Editar Perfil',
          style: TextStyle(
            color: Colors.black, 
            fontWeight: FontWeight.bold, 
            fontSize: 24
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            
            // --- Seção de Foto ---
            Center(
              child: Column(
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.add_a_photo_outlined, 
                      size: 64, 
                      color: Colors.black
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Foto',
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.w600, 
                      color: Colors.black87
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 60),

            // --- Campo: E-mail ---
            _buildInputLabel('E-mail'),
            TextField(
              controller: emailController,
              decoration: _buildInputDecoration('lucas33@gmail.com'),
              keyboardType: TextInputType.emailAddress,
            ),
            
            const SizedBox(height: 24),

            // --- NOVO CAMPO: Peso Atual ---
            _buildInputLabel('Peso atual (kg)'),
            TextField(
              controller: pesoController,
              decoration: _buildInputDecoration('Ex: 89'),
              keyboardType: TextInputType.number, // Teclado numérico para o peso
            ),
            
            const SizedBox(height: 24),

            // --- Campo: Senha (com o olhinho) ---
            _buildInputLabel('Senha'),
            TextField(
              controller: senhaController,
              obscureText: _obscureSenha, // Usa a variável de estado aqui
              decoration: _buildInputDecoration(
                '**********',
                suffixIcon: IconButton(
                  icon: Icon(
                    // Altera o ícone dependendo do estado
                    _obscureSenha ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    // Atualiza a tela mudando o valor do booleano
                    setState(() {
                      _obscureSenha = !_obscureSenha;
                    });
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 80),

            // --- Botão Salvar ---
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para salvar as alterações
                  print("Novo e-mail: ${emailController.text}");
                  print("Novo peso: ${pesoController.text}");
                  print("Nova senha: ${senhaController.text}");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: corPrimaria,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Salvar',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.white
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
            color: Colors.black54
          ),
        ),
      ),
    );
  }

  // Ajustado para receber um parâmetro opcional de 'suffixIcon'
  InputDecoration _buildInputDecoration(String hint, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      fillColor: Colors.white,
      filled: true,
      suffixIcon: suffixIcon, // Adicionado aqui
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