import 'dart:io'; // 👉 NOVO: Para exibir a imagem
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // 👉 NOVO: Para abrir a galeria/câmera
import 'package:treino_nutri_app/routes/app_routes.dart';
import 'package:treino_nutri_app/controllers/UsuarioController.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  late TextEditingController _emailController;
  late TextEditingController _usuarioController;
  late TextEditingController _senhaController;
  late TextEditingController _confirmaSenhaController;

  late TextEditingController _pesoController;
  late TextEditingController _alturaController;

  String? _sexoSelecionado;
  bool _obscureSenha = true;
  bool _obscureConfirmaSenha = true;

  final UsuarioController _usuarioControllerObj = UsuarioController();

  bool _isLoading = false;

  // Variáveis para a foto
  String? _fotoPath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _usuarioController = TextEditingController();
    _senhaController = TextEditingController();
    _confirmaSenhaController = TextEditingController();
    _pesoController = TextEditingController();
    _alturaController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usuarioController.dispose();
    _senhaController.dispose();
    _confirmaSenhaController.dispose();
    _pesoController.dispose();
    _alturaController.dispose();
    super.dispose();
  }

  // 👉 ATUALIZADO: Função agora recebe de onde a imagem vem (câmera ou galeria)
  Future<void> _escolherFoto(ImageSource source) async {
    final XFile? imagem = await _picker.pickImage(source: source);
    if (imagem != null) {
      setState(() {
        _fotoPath = imagem.path;
      });
    }
  }

  // 👉 NOVO: Menu que sobe na tela perguntando qual opção o usuário prefere
  void _mostrarOpcoesFoto() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera, color: Color(0xFF1B7E3D)),
                title: const Text('Tirar foto com a Câmera'),
                onTap: () {
                  Navigator.of(context).pop(); // Fecha o menuzinho
                  _escolherFoto(ImageSource.camera); // Abre a câmera
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFF1B7E3D)),
                title: const Text('Escolher da Galeria'),
                onTap: () {
                  Navigator.of(context).pop(); // Fecha o menuzinho
                  _escolherFoto(ImageSource.gallery); // Abre a galeria
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleRegister() async {
    setState(() => _isLoading = true);

    // Chama o Controller passando todos os dados da tela
    String? erro = await _usuarioControllerObj.cadastrarUsuario(
      email: _emailController.text,
      usuario: _usuarioController.text,
      senha: _senhaController.text,
      confirmaSenha: _confirmaSenhaController.text,
      pesoStr: _pesoController.text,
      alturaStr: _alturaController.text,
      sexoSelecionado: _sexoSelecionado,
      pathFotoPerfil: _fotoPath, // Enviando a foto para o controller
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Se o controller retornou um erro, mostra a mensagem vermelha
    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro), backgroundColor: Colors.red),
      );
      return; // Para a execução aqui
    }

    // Se o erro for null, deu sucesso! Mostra mensagem verde e muda de tela
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Cadastro realizado com sucesso, ${_usuarioController.text}!',
        ),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF1B1B1B),
            size: 28,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Cadastro',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B1B1B),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Seção de Foto
              _buildPhotoSection(),
              const SizedBox(height: 40),

              // Campo E-mail
              _buildTextField(
                label: 'E-mail',
                controller: _emailController,
                hintText: 'Digite seu e-mail',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // Campo Usuário
              _buildTextField(
                label: 'Usuário',
                controller: _usuarioController,
                hintText: 'Digite seu usuário',
              ),
              const SizedBox(height: 20),

              // Campo Senha
              _buildPasswordField(
                label: 'Senha',
                controller: _senhaController,
                hintText: 'Digite sua senha',
                obscureText: _obscureSenha,
                onToggle: () {
                  setState(() => _obscureSenha = !_obscureSenha);
                },
              ),
              const SizedBox(height: 20),

              // Campo Confirma Senha
              _buildPasswordField(
                label: 'Confirma senha',
                controller: _confirmaSenhaController,
                hintText: 'Confirme sua senha',
                obscureText: _obscureConfirmaSenha,
                onToggle: () {
                  setState(
                    () => _obscureConfirmaSenha = !_obscureConfirmaSenha,
                  );
                },
              ),
              const SizedBox(height: 20),

              // Campo Peso Atual
              _buildTextField(
                label: 'Peso Atual (kg)',
                controller: _pesoController,
                hintText: 'Ex: 75.5',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 20),

              // Campo Altura
              _buildTextField(
                label: 'Altura (m)',
                controller: _alturaController,
                hintText: 'Ex: 1.75',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 20),

              // Campo Sexo
              _buildSexoField(),
              const SizedBox(height: 40),

              // Botão Cadastrar
              _buildRegisterButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return GestureDetector(
      onTap: _mostrarOpcoesFoto, 
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              image: _fotoPath != null
                  ? DecorationImage(
                      image: FileImage(File(_fotoPath!)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Imagem de placeholder com ícone (Só mostra se a foto for nula)
                if (_fotoPath == null) 
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/adicionar-foto.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                // Ícone de + no canto inferior direito
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B7E3D),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 24),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Foto',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1B1B1B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1B7E3D), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1B7E3D), width: 2),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[600],
              ),
              onPressed: onToggle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSexoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sexo',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSexoButton(
                label: 'Masculino',
                value: 'masculino',
                isSelected: _sexoSelecionado == 'masculino',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSexoButton(
                label: 'Feminino',
                value: 'feminino',
                isSelected: _sexoSelecionado == 'feminino',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSexoButton(
                label: 'Não Informar',
                value: 'nao_informar',
                isSelected: _sexoSelecionado == 'nao_informar',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSexoButton({
    required String label,
    required String value,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() => _sexoSelecionado = value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1B7E3D) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF1B7E3D) : Colors.grey[300]!,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1B7E3D),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
                'CADASTRAR',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}