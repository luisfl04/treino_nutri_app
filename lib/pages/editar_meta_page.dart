import 'package:flutter/material.dart';
import 'package:treino_nutri_app/controllers/MetasController.dart';

class EditarMetaPage extends StatefulWidget {
  const EditarMetaPage({super.key});

  @override
  State<EditarMetaPage> createState() => _EditarMetaPageState();
}

class _EditarMetaPageState extends State<EditarMetaPage> {
  late TextEditingController tipoMetaController;
  late TextEditingController pesoAtualController;
  late TextEditingController pesoAlmejadoController;
  late TextEditingController dataFinalController;

  final Color corFundo = const Color(0xFFF4FAF1);
  final Color corPrimaria = const Color(0xFF0F7A40);

  final MetaController _metaController = MetaController();
  bool _isLoading = false;

  int? _metaId;
  String _dataInicioOriginal = '';
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    tipoMetaController = TextEditingController();
    pesoAtualController = TextEditingController();
    pesoAlmejadoController = TextEditingController();
    dataFinalController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 👉 CAPTURAMOS OS DADOS VINDOS DA TELA ANTERIOR
    if (!_isInitialized) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null) {
        _metaId = args['id'];
        _dataInicioOriginal = args['data_inicio'] ?? '';

        tipoMetaController.text = args['objetivo'] ?? '';
        pesoAtualController.text = args['peso_atual']?.toString() ?? '';
        pesoAlmejadoController.text = args['peso_meta']?.toString() ?? '';
        dataFinalController.text = args['data_fim'] ?? '';
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    tipoMetaController.dispose();
    pesoAtualController.dispose();
    pesoAlmejadoController.dispose();
    dataFinalController.dispose();
    super.dispose();
  }

  // 👉 FUNÇÃO QUE SALVA NO BANCO DE DADOS
  Future<void> _salvarAlteracoes() async {
    if (_metaId == null) return;

    setState(() => _isLoading = true);

    final erro = await _metaController.atualizarMeta(
      id: _metaId!,
      objetivo: tipoMetaController.text,
      pesoAtualStr: pesoAtualController.text,
      pesoMetaStr: pesoAlmejadoController.text,
      dataInicioStr: _dataInicioOriginal,
      dataFimStr: dataFinalController.text,
    );

    setState(() => _isLoading = false);

    if (erro == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎯 Meta atualizada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true); // Volta avisando que atualizou
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro), backgroundColor: Colors.red),
      );
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
              decoration: _buildInputDecoration(
                'Ex: Emagrecimento, Hipertrofia...',
              ),
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
              decoration: _buildInputDecoration(
                'DD/MM/AAAA',
                suffixIcon: Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.grey[600],
                ),
              ),
            ),

            const SizedBox(height: 60),

            // --- Botão Salvar Alterações ---
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _salvarAlteracoes,
                style: ElevatedButton.styleFrom(
                  backgroundColor: corPrimaria,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
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
