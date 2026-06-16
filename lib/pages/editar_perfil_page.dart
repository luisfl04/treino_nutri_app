import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:treino_nutri_app/controllers/AuthController.dart';
import 'package:treino_nutri_app/controllers/UsuarioController.dart';
import 'package:treino_nutri_app/models/Usuario.dart';

class EditarPerfilPage extends StatefulWidget {
  const EditarPerfilPage({super.key});

  @override
  State<EditarPerfilPage> createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  late TextEditingController _emailController;
  late TextEditingController _senhaController;
  late TextEditingController _pesoController;
  late TextEditingController _alturaController;

  bool _obscureSenha = true;
  bool _isLoading = false;
  bool _isFetchingData = true;

  String _emailOriginal = '';
  String? _fotoPath;

  final ImagePicker _picker = ImagePicker();
  final UsuarioController _usuarioController = UsuarioController();

  final Color corFundo = const Color(0xFFF5F5F5);
  final Color corPrimaria = const Color(0xFF1B7E3D);

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _senhaController = TextEditingController();
    _pesoController = TextEditingController();
    _alturaController = TextEditingController();

    _carregarDadosAtuais();
  }

  Future<void> _carregarDadosAtuais() async {
    //  RECUPERA A SESSÃO CASO A RAM TENHA SIDO APAGADA
    if (AuthController.usuarioLogado == null) {
      await AuthController.recuperarSessao();
    }

    final usuarioLogado = AuthController.usuarioLogado;

    if (usuarioLogado != null) {
      _emailOriginal = usuarioLogado.email ?? '';
      _emailController.text = usuarioLogado.email ?? '';
      _senhaController.text = usuarioLogado.hash_senha ?? '';
      _fotoPath = usuarioLogado.path_foto_perfil?.trim();

      final info = await _usuarioController.buscarInformacaoCorporal(
        _emailOriginal,
      );
      if (info != null) {
        _pesoController.text = info['weight']?.toString() ?? '';
        _alturaController.text = info['height']?.toString() ?? '';
      }
    }

    if (mounted) {
      setState(() => _isFetchingData = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _pesoController.dispose();
    _alturaController.dispose();
    super.dispose();
  }

  //  Salva a foto na pasta PERMANENTE
  Future<void> _escolherFoto(ImageSource source) async {
    final XFile? imagem = await _picker.pickImage(source: source);
    if (imagem != null) {
      // 1. Encontra a pasta "Forte" do Android para não apagar a foto
      final directory = await getApplicationDocumentsDirectory();

      // 2. Cria um nome único usando a data e hora atual
      final nomeArquivo = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final caminhoPermanente = '${directory.path}/$nomeArquivo';

      // 3. Copia da pasta temporária para a permanente
      final File arquivoTemp = File(imagem.path);
      final File arquivoSalvo = await arquivoTemp.copy(caminhoPermanente);

      setState(() {
        _fotoPath = arquivoSalvo.path; // Guarda o caminho permanente!
      });
    }
  }

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
                leading: Icon(Icons.photo_camera, color: corPrimaria),
                title: const Text('Tirar foto com a Câmera'),
                onTap: () {
                  Navigator.pop(context);
                  _escolherFoto(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: corPrimaria),
                title: const Text('Escolher da Galeria'),
                onTap: () {
                  Navigator.pop(context);
                  _escolherFoto(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _salvarAlteracoes() async {
    setState(() => _isLoading = true);

    String? erro = await _usuarioController.atualizarPerfil(
      emailOriginal: _emailOriginal,
      novoEmail: _emailController.text,
      novaSenha: _senhaController.text,
      pesoStr: _pesoController.text,
      alturaStr: _alturaController.text,
      pathFotoPerfil: _fotoPath,
    );

    if (erro != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(erro), backgroundColor: Colors.red),
        );
        setState(() => _isLoading = false);
      }
      return;
    }

    try {
      final AuthController authController = AuthController();
      Usuario usuarioAtualizado = await authController.entrar(
        login: _emailController.text,
        senha: _senhaController.text,
      );
      AuthController.usuarioLogado = usuarioAtualizado;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil atualizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isFetchingData) {
      return Scaffold(
        backgroundColor: corFundo,
        body: Center(child: CircularProgressIndicator(color: corPrimaria)),
      );
    }

    final bool temFoto =
        _fotoPath != null &&
        _fotoPath!.isNotEmpty &&
        File(_fotoPath!).existsSync();

    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        backgroundColor: corFundo,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Editar Perfil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _mostrarOpcoesFoto,
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: corPrimaria, width: 3),
                        image: temFoto
                            ? DecorationImage(
                                image: FileImage(File(_fotoPath!)),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: temFoto
                          ? null
                          : const Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: 60,
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: corPrimaria,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildTextField(
                label: 'E-mail',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              _buildPasswordField(label: 'Senha', controller: _senhaController),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Peso Atual (kg)',
                      controller: _pesoController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      label: 'Altura (m)',
                      controller: _alturaController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _salvarAlteracoes,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: corPrimaria,
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
                          'GUARDAR ALTERAÇÕES',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
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
              borderSide: BorderSide(color: corPrimaria, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: _obscureSenha,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
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
              borderSide: BorderSide(color: corPrimaria, width: 2),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureSenha ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[600],
              ),
              onPressed: () => setState(() => _obscureSenha = !_obscureSenha),
            ),
          ),
        ),
      ],
    );
  }
}
