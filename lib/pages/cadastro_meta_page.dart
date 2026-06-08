import 'package:flutter/material.dart';
import 'package:treino_nutri_app/controllers/MetasController.dart';

class CadastrarMetaPage extends StatefulWidget {
  const CadastrarMetaPage({super.key});

  @override
  State<CadastrarMetaPage> createState() => _CadastrarMetaPageState();
}

class _CadastrarMetaPageState extends State<CadastrarMetaPage> {
  String objetivoSelecionado = 'Ganho de Massa';
  
  final TextEditingController pesoAtualController = TextEditingController();
  final TextEditingController pesoMetaController = TextEditingController();
  final TextEditingController dataInicioController = TextEditingController();
  final TextEditingController dataFinalController = TextEditingController();

  final Color corFundo = const Color(0xFFF4FAF1); 
  final Color corPrimaria = const Color(0xFF0F7A40); 
  final Color corChipSelecionado = const Color(0xFF28C25E); 

  final MetaController _metaController = MetaController();
  bool _isLoading = false;
  bool _isEditMode = false;
  int? _metaId;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null && args.isNotEmpty) {
        _isEditMode = true;
        _metaId = args['id'];
        
        objetivoSelecionado = args['objetivo'] ?? 'Ganho de Massa';
        pesoAtualController.text = args['peso_atual']?.toString() ?? '';
        pesoMetaController.text = args['peso_meta']?.toString() ?? '';
        dataInicioController.text = args['data_inicio'] ?? '';
        dataFinalController.text = args['data_fim'] ?? '';
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    pesoAtualController.dispose();
    pesoMetaController.dispose();
    dataInicioController.dispose();
    dataFinalController.dispose();
    super.dispose();
  }

  Future<void> _salvarMeta() async {
    if (pesoAtualController.text.isEmpty || pesoMetaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha os pesos para continuar.'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);
    String? erro;

    if (_isEditMode && _metaId != null) {
      erro = await _metaController.atualizarMeta(
        id: _metaId!,
        objetivo: objetivoSelecionado,
        pesoAtualStr: pesoAtualController.text,
        pesoMetaStr: pesoMetaController.text,
        dataInicioStr: dataInicioController.text,
        dataFimStr: dataFinalController.text,
      );
    } else {
      erro = await _metaController.salvarMeta(
        objetivo: objetivoSelecionado,
        pesoAtualStr: pesoAtualController.text,
        pesoMetaStr: pesoMetaController.text,
        dataInicioStr: dataInicioController.text,
        dataFimStr: dataFinalController.text,
      );
    }

    setState(() => _isLoading = false);

    if (erro == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditMode ? '🎯 Meta atualizada com sucesso!' : '🎯 Meta cadastrada com sucesso!'), 
          backgroundColor: Colors.green
        ),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro), backgroundColor: Colors.red),
      );
    }
  }

  // 👉 Abre o Calendário Nativo
  Future<void> _selecionarData(BuildContext context, TextEditingController controller) async {
    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: corPrimaria, onPrimary: Colors.white, onSurface: Colors.black),
          ),
          child: child!,
        );
      },
    );

    if (dataSelecionada != null) {
      setState(() {
        String dia = dataSelecionada.day.toString().padLeft(2, '0');
        String mes = dataSelecionada.month.toString().padLeft(2, '0');
        String ano = dataSelecionada.year.toString();
        controller.text = "$dia/$mes/$ano";
      });
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
        title: Text(
          _isEditMode ? 'Editar Meta' : 'Nova Meta',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Objetivo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildCustomChip(label: 'Emagrecimento', isSelected: objetivoSelecionado == 'Emagrecimento', onTap: () => setState(() => objetivoSelecionado = 'Emagrecimento')),
                _buildCustomChip(label: 'Ganho de Massa', isSelected: objetivoSelecionado == 'Ganho de Massa', onTap: () => setState(() => objetivoSelecionado = 'Ganho de Massa')),
                _buildCustomChip(label: 'Manutenção', isSelected: objetivoSelecionado == 'Manutenção', onTap: () => setState(() => objetivoSelecionado = 'Manutenção')),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Peso Atual', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      _buildTextField(pesoAtualController, 'Ex: 80', TextInputType.number),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Peso Almejado', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      _buildTextField(pesoMetaController, 'Ex: 75', TextInputType.number),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Data de início', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            _buildDateField(dataInicioController, 'Selecione a data'), // 👈 Usando o novo campo
            const SizedBox(height: 24),
            const Text('Data final da meta', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            _buildDateField(dataFinalController, 'Selecione a data'), // 👈 Usando o novo campo
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _salvarMeta,
                style: ElevatedButton.styleFrom(
                  backgroundColor: corPrimaria,
                  disabledBackgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        _isEditMode ? 'Atualizar Meta' : 'Salvar Meta',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, TextInputType type) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: corPrimaria)),
      ),
      keyboardType: type,
    );
  }

  // 👉 Widget exclusivo para pegar data (Bloqueia teclado e mostra o ícone)
  Widget _buildDateField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      readOnly: true, 
      onTap: () => _selecionarData(context, controller),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        fillColor: Colors.white,
        filled: true,
        suffixIcon: const Icon(Icons.calendar_month, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: corPrimaria)),
      ),
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
          style: TextStyle(color: isSelected ? Colors.white : Colors.black54, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
        ),
      ),
    );
  }
}