import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:treino_nutri_app/controllers/AuthController.dart';
import 'package:treino_nutri_app/controllers/AlimentacaoController.dart';
import 'package:treino_nutri_app/models/Alimentacao.dart';

class RefeicaoCadastroPage extends StatefulWidget {
  const RefeicaoCadastroPage({super.key});

  @override
  State<RefeicaoCadastroPage> createState() => _RefeicaoCadastroPageState();
}

class _RefeicaoCadastroPageState extends State<RefeicaoCadastroPage> {
  String tipoRefeicaoSelecionada = 'Café da Manhã';

  // Controladores de texto
  final TextEditingController alimentosController = TextEditingController();
  final TextEditingController caloriasController = TextEditingController();

  // Estados de controle para o Banco de Dados e Fotos
  bool _isLoading = false;
  String? _fotoPath; //  Guarda o caminho do arquivo de imagem capturado
  final ImagePicker _picker =
      ImagePicker(); //  Instancia o capturador de imagem
  final AlimentacaoController _alimentacaoController = AlimentacaoController();

  final Color corFundo = const Color(0xFFF4FAF1);
  final Color corPrimaria = const Color(0xFF0F7A40);
  final Color corChipSelecionado = const Color(0xFF28C25E);

  @override
  void dispose() {
    alimentosController.dispose();
    caloriasController.dispose();
    super.dispose();
  }

  // Função para capturar imagem da câmera ou galeria
  Future<void> _capturarFoto(ImageSource source) async {
    try {
      final XFile? imagemSelecionada = await _picker.pickImage(
        source: source,
        imageQuality: 70, // Reduz levemente para não estourar o limite do banco
      );
      if (imagemSelecionada != null) {
        setState(() {
          _fotoPath = imagemSelecionada.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao selecionar foto: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  //  Caixa de diálogo estilizada para escolher a origem da imagem
  void _mostrarOpcoesFoto() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Selecione a Foto da Refeição',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF0F7A40)),
                title: const Text('Tirar Foto com Câmera'),
                onTap: () {
                  Navigator.pop(context);
                  _capturarFoto(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: Color(0xFF0F7A40),
                ),
                title: const Text('Escolher da Galeria'),
                onTap: () {
                  Navigator.pop(context);
                  _capturarFoto(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _salvarRefeicao() async {
    final usuario = AuthController.usuarioLogado;
    if (usuario == null || usuario.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro: Usuário não logado.')),
      );
      return;
    }

    if (alimentosController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, digite os alimentos da refeição!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    double calorias = double.tryParse(caloriasController.text) ?? 0.0;

    Alimentacao novaRefeicao = Alimentacao(
      usuarioId: usuario.id!,
      tipoRefeicao: tipoRefeicaoSelecionada,
      descricao: alimentosController.text,
      concluida: false,
      valorCalorico: calorias,
      foto: _fotoPath ?? '',
      dataCriacao: DateTime.now().toIso8601String(),
    );

    String? erro = await _alimentacaoController.cadastrarRefeicao(novaRefeicao);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro), backgroundColor: Colors.red),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Refeição cadastrada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    }
  }

  DateTime dataSelecionada = DateTime.now();

  // Função para abrir o calendário do Android
  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? colhida = await showDatePicker(
      context: context,
      initialDate: dataSelecionada,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(
          context,
        ).copyWith(colorScheme: ColorScheme.light(primary: corPrimaria)),
        child: child!,
      ),
    );
    if (colhida != null && colhida != dataSelecionada) {
      setState(() => dataSelecionada = colhida);
    }
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
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Selecione a Categoria'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildCustomChip(
                  label: 'Café da Manhã',
                  isSelected: tipoRefeicaoSelecionada == 'Café da Manhã',
                  onTap: () =>
                      setState(() => tipoRefeicaoSelecionada = 'Café da Manhã'),
                ),
                _buildCustomChip(
                  label: 'Almoço',
                  isSelected: tipoRefeicaoSelecionada == 'Almoço',
                  onTap: () =>
                      setState(() => tipoRefeicaoSelecionada = 'Almoço'),
                ),
                _buildCustomChip(
                  label: 'Lanche',
                  isSelected: tipoRefeicaoSelecionada == 'Lanche',
                  onTap: () =>
                      setState(() => tipoRefeicaoSelecionada = 'Lanche'),
                ),
                _buildCustomChip(
                  label: 'Jantar',
                  isSelected: tipoRefeicaoSelecionada == 'Jantar',
                  onTap: () =>
                      setState(() => tipoRefeicaoSelecionada = 'Jantar'),
                ),
              ],
            ),
            const SizedBox(height: 25),

            //   Widget de upload visual de foto incorporado harmoniosamente
            _buildSectionTitle('Foto do Prato (Opcional)'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _mostrarOpcoesFoto,
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: _fotoPath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(_fotoPath!),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, size: 40, color: corPrimaria),
                          const SizedBox(height: 8),
                          const Text(
                            'Clique para registrar ou anexar foto',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 25),

            _buildSectionTitle('O que você comeu?'),
            const SizedBox(height: 8),
            TextField(
              controller: alimentosController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                    'Ex: 2 ovos mexidos, 2 fatias de pão integral e 1 copo de suco de laranja...',
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
            ),
            const SizedBox(height: 25),

            _buildSectionTitle('Calorias Estimadas (Kcal)'),
            const SizedBox(height: 8),
            TextField(
              controller: caloriasController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Ex: 350',
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
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _salvarRefeicao,
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
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Salvar',
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildCustomChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? corChipSelecionado : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? corChipSelecionado : Colors.black26,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
