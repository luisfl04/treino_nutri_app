import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:treino_nutri_app/widgets/popup_treinos_widget.dart';
import 'package:treino_nutri_app/controllers/TreinoController.dart';
import 'package:treino_nutri_app/models/Treino.dart';

class EditarTreinoPage extends StatefulWidget {
  const EditarTreinoPage({super.key});

  @override
  State<EditarTreinoPage> createState() => _EditarTreinoPageState();
}

class _EditarTreinoPageState extends State<EditarTreinoPage> {
  String tipoTreinoSelecionado = 'Musculação';
  String periodoSelecionado = 'Manhã';

  // Controladores
  late TextEditingController _caloriasController;
  late TextEditingController _dataController;
  late TextEditingController _duracaoController;
  late TextEditingController _seriesController;
  late TextEditingController _observacoesController;

  bool _foiInicializado = false;
  late Treino _treinoRecebido;
  List<String> meusExerciciosSelecionados = [];

  final TreinoController _treinoController = TreinoController();

  final Color corFundo = const Color(0xFFF4FAF1);
  final Color corPrimaria = const Color(0xFF0F7A40);
  final Color corChipSelecionado = const Color(0xFF28C25E);

  @override
  void initState() {
    super.initState();
    // Inicializa vazios antes de receber os argumentos
    _caloriasController = TextEditingController();
    _dataController = TextEditingController();
    _duracaoController = TextEditingController();
    _seriesController = TextEditingController();
    _observacoesController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_foiInicializado) {
      final argumentos = ModalRoute.of(context)?.settings.arguments;
      if (argumentos != null) {
        final Treino treino = Treino.fromMap(
          argumentos as Map<String, dynamic>,
        );
        _treinoRecebido = treino;

        setState(() {
          // Mapeia o ID numérico vindo do banco de volta para o texto do Chip correspondente
          if (treino.tipoTreinoId == 2) {
            tipoTreinoSelecionado = 'Calistenia';
          } else if (treino.tipoTreinoId == 3) {
            tipoTreinoSelecionado = 'Yoga';
          } else if (treino.tipoTreinoId == 4) {
            tipoTreinoSelecionado = 'Cardio';
          } else {
            tipoTreinoSelecionado = 'Musculação';
          }

          // Garante que o período possua um valor válido para os Chips
          periodoSelecionado = treino.periodoDia.isNotEmpty
              ? treino.periodoDia
              : 'Manhã';

          // Preenche os text controllers com os dados convertidos do modelo
          _dataController.text = treino.dataTreino;
          _duracaoController.text = treino.duracao.toString();
          _seriesController.text = treino.totalSeries.toString();
          _caloriasController.text = treino.calorias.toString();
          _observacoesController.text = treino.descricao ?? '';

          // Decodifica a String JSON dos exercícios guardada no banco de volta para List<String>
          if (treino.exerciciosSelecionados.isNotEmpty) {
            try {
              final List<dynamic> decoded = jsonDecode(
                treino.exerciciosSelecionados,
              );
              meusExerciciosSelecionados = decoded
                  .map((e) => e.toString())
                  .toList();
            } catch (e) {
              meusExerciciosSelecionados = [];
            }
          }
        });
      }
      _foiInicializado = true;
    }
  }

  @override
  void dispose() {
    _caloriasController.dispose();
    _dataController.dispose();
    _duracaoController.dispose();
    _seriesController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? selecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(
          context,
        ).copyWith(colorScheme: ColorScheme.light(primary: corPrimaria)),
        child: child!,
      ),
    );
    if (selecionada != null) {
      setState(
        () => _dataController.text =
            "${selecionada.day.toString().padLeft(2, '0')}/${selecionada.month.toString().padLeft(2, '0')}/${selecionada.year}",
      );
    }
  }

  Future<void> _abrirMenuDeExercicios() async {
    final List<String>? resultado = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) => SelecaoExerciciosDialog(
        selecionadosPreviamente: meusExerciciosSelecionados,
        tipoTreino: tipoTreinoSelecionado,
      ),
    );
    if (resultado != null) {
      setState(() => meusExerciciosSelecionados = resultado);
    }
  }

  Future<void> _executarAtualizacao() async {
    // Validação básica
    if (_dataController.text.isEmpty ||
        _duracaoController.text.isEmpty ||
        _caloriasController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha a Data, Duração e Calorias!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final bool sucesso = await _treinoController.atualizarTreino(
      idTreino: _treinoRecebido.id,
      tipoTreinoTexto: tipoTreinoSelecionado,
      periodoDia: periodoSelecionado,
      caloriasStr: _caloriasController.text,
      dataTreino: _dataController.text,
      duracaoStr: _duracaoController.text,
      seriesTotalStr: _seriesController.text,
      exerciciosSelecionados: meusExerciciosSelecionados,
      descricao: _observacoesController.text,
    );

    if (mounted) {
      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Treino atualizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(
          context,
          true,
        ); // Retorna true para recarregar a lista anterior
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao atualizar o treino no banco de dados.'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
          'Editar Treino',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Tipo de Treino'),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: ['Musculação', 'Calistenia', 'Yoga', 'Cardio'].map((
                tipo,
              ) {
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

            _buildSectionTitle('Data do Treino'),
            TextField(
              controller: _dataController,
              readOnly: true,
              onTap: () => _selecionarData(context),
              decoration: _buildInputDecoration(
                'Selecione a data',
                suffixIcon: const Icon(
                  Icons.calendar_today,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Duração do Treino (Minutos)'),
            TextField(
              controller: _duracaoController,
              keyboardType: TextInputType.number,
              decoration: _buildInputDecoration('EX: 45 min'),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Séries Totais'),
            TextField(
              controller: _seriesController,
              keyboardType: TextInputType.number,
              decoration: _buildInputDecoration('EX: 12 séries'),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Calorias Gastas Estimadas'),
            TextField(
              controller: _caloriasController,
              keyboardType: TextInputType.number,
              decoration: _buildInputDecoration('EX: 350 kcal'),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Observações / Instruções'),
            TextField(
              controller: _observacoesController,
              maxLines: 4,
              decoration: _buildInputDecoration('EX: Focar na cadência...'),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Exercícios Selecionados'),
            GestureDetector(
              onTap: _abrirMenuDeExercicios,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
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
                          ? 'Nenhum exercício selecionado'
                          : '${meusExerciciosSelecionados.length} selecionado(s)',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _executarAtualizacao,
                style: ElevatedButton.styleFrom(
                  backgroundColor: corPrimaria,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
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
            color: isSelected ? Colors.black87 : Colors.black54,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      suffixIcon: suffixIcon,
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
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: corPrimaria, width: 2),
      ),
    );
  }
}
