import 'package:flutter/material.dart';
import 'package:treino_nutri_app/widgets/popup_treinos_widget.dart';
import 'package:treino_nutri_app/controllers/TreinoController.dart'; 

class TreinoCadastroPage extends StatefulWidget {
  const TreinoCadastroPage({super.key});

  @override
  _TreinoCadastroPageState createState() => _TreinoCadastroPageState();
}

class _TreinoCadastroPageState extends State<TreinoCadastroPage> {
  String tipoTreinoSelecionado = 'Musculação';
  String periodoSelecionado = 'Manhã';

  // Controladores
  final TextEditingController _caloriasController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();    // NOVO
  final TextEditingController _duracaoController = TextEditingController(); // NOVO
  final TextEditingController _seriesController = TextEditingController(); // NOVO

  final Color corFundo = const Color(0xFFF4FAF1); 
  final Color corPrimaria = const Color(0xFF0F7A40); 
  final Color corChipSelecionado = const Color(0xFF28C25E); 

  List<String> meusExerciciosSelecionados = [];
  final TreinoController _treinoController = TreinoController(); 

  @override
  void dispose() {
    _caloriasController.dispose(); 
    _dataController.dispose();
    _duracaoController.dispose();
    super.dispose();
  }

  // FUNÇÃO NATIVA PARA SELECIONAR A DATA NO CALENDÁRIO
  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? selecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: corPrimaria, 
            ),
          ),
          child: child!,
        );
      },
    );

    if (selecionada != null) {
      setState(() {
        _dataController.text = "${selecionada.day.toString().padLeft(2, '0')}/${selecionada.month.toString().padLeft(2, '0')}/${selecionada.year}";
      });
    }
  }

  Future<void> _abrirMenuDeExercicios() async {
    final List<String>? resultado = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return SelecaoExerciciosDialog(
          selecionadosPreviamente: meusExerciciosSelecionados,
          tipoTreino: tipoTreinoSelecionado, 
        );
      },
    );

    if (resultado != null) {
      setState(() {
        meusExerciciosSelecionados = resultado;
      });
    }
  }

  Future<void> _executarSalvar() async {
    // Validação básica para garantir que não mandam campos vazios
    if (_dataController.text.isEmpty || _duracaoController.text.isEmpty || _caloriasController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha a Data, Duração e Calorias!'), backgroundColor: Colors.red),
      );
      return;
    }

    final String? erro = await _treinoController.salvarTreino(
      tipoTreinoTexto: tipoTreinoSelecionado,
      periodoDia: periodoSelecionado,
      caloriasStr: _caloriasController.text,
      dataTreino: _dataController.text,
      duracaoStr: _duracaoController.text,
      seriesTotalStr: _seriesController.text, // <-- MANDANDO AS SÉRIES TOTAIS
      exerciciosSelecionados: meusExerciciosSelecionados, 
    );

    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro), backgroundColor: Colors.red),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Treino registado com sucesso! 🎉'), backgroundColor: Colors.green),
      );
      Navigator.pop(context); 
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
          'Novo Treino',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Tipo de Treino ---
            _buildSectionTitle('Tipo de Treino'),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: ['Musculação', 'Calistenia', 'Yoga', 'Cardio'].map((tipo) {
                return _buildCustomChip(
                  label: tipo,
                  isSelected: tipoTreinoSelecionado == tipo,
                  onTap: () {
                    setState(() {
                      tipoTreinoSelecionado = tipo;
                      meusExerciciosSelecionados.clear(); 
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // --- Período ---
            _buildSectionTitle('Período do Treino'),
            Wrap(
              spacing: 10,
              children: ['Manhã', 'Tarde', 'Noite'].map((periodo) {
                return _buildCustomChip(
                  label: periodo,
                  isSelected: periodoSelecionado == periodo,
                  onTap: () => setState(() => periodoSelecionado = periodo),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // --- NOVO: Data do Treino ---
            _buildSectionTitle('Data do Treino'),
            TextField(
              controller: _dataController,
              readOnly: true, // Força o clique no calendário
              onTap: () => _selecionarData(context),
              decoration: InputDecoration(
                hintText: 'Selecione a data',
                suffixIcon: const Icon(Icons.calendar_today, color: Colors.black54),
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
            const SizedBox(height: 24),

            // --- NOVO: Duração ---
            _buildSectionTitle('Duração do Treino (Minutos)'),
            TextField(
              controller: _duracaoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'EX: 45 min',
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
            const SizedBox(height: 24),

            // --- NOVO: Séries Totais ---
            _buildSectionTitle('Séries Totais'),
            TextField(
              controller: _seriesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'EX: 12 séries',
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
            const SizedBox(height: 24),

            // --- Calorias Gastas ---
            _buildSectionTitle('Calorias Gastas Estimadas'),
            TextField(
              controller: _caloriasController, 
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'EX: 350 kcal',
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
            const SizedBox(height: 24),

            // --- Adicionar Exercícios ---
            _buildSectionTitle('Adicione os Exercícios'),
            GestureDetector(
              onTap: _abrirMenuDeExercicios,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      meusExerciciosSelecionados.isEmpty
                          ? 'EX: Selecionar do Catálogo'
                          : '${meusExerciciosSelecionados.length} selecionado(s)',
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // --- Botão Salvar ---
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _executarSalvar, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: corPrimaria,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text(
                  'Salvar Treino',
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
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
          border: Border.all(color: isSelected ? corChipSelecionado : Colors.black26),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black87 : Colors.black54,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}