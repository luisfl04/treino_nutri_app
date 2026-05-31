import 'package:flutter/material.dart';
import 'package:treino_nutri_app/widgets/popup_treinos_widget.dart';

class TreinoCadastroPage extends StatefulWidget {
  const TreinoCadastroPage({super.key});

  @override
  _TreinoCadastroPageState createState() => _TreinoCadastroPageState();
}

class _TreinoCadastroPageState extends State<TreinoCadastroPage> {
  String tipoTreinoSelecionado = 'Musculação';
  String periodoSelecionado = 'Manhã';
  bool treinoConcluido = true;
  String? exercicioSelecionado;

  final Color corFundo = const Color(0xFFF4FAF1); // Verde bem clarinho do fundo
  final Color corPrimaria = const Color(0xFF0F7A40); // Verde escuro dos botões
  final Color corChipSelecionado = const Color(0xFF28C25E); // Verde claro ativo

  List<String> meusExerciciosSelecionados = [];

  // Função para abrir o popup
  Future<void> _abrirMenuDeExercicios() async {
    final List<String>? resultado = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return SelecaoExerciciosDialog(
          selecionadosPreviamente: meusExerciciosSelecionados,
          tipoTreino:
              tipoTreinoSelecionado, // <-- ENVIANDO O TIPO ATUAL DA TELA!
        );
      },
    );

    if (resultado != null) {
      setState(() {
        meusExerciciosSelecionados = resultado;
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
        title: const Text(
          'Novo Treino',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
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
              children: ['Musculação', 'Calistenia', 'Yoga', 'Cardio'].map((
                tipo,
              ) {
                return _buildCustomChip(
                  label: tipo,
                  isSelected: tipoTreinoSelecionado == tipo,
                  onTap: () => setState(() => tipoTreinoSelecionado = tipo),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // --- Período (No seu design repete 'Tipo de Treino', mudei para Período para fazer sentido) ---
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

            // --- Calorias Gastas ---
            _buildSectionTitle('Calorias Gastas'),
            TextField(
              decoration: InputDecoration(
                hintText: 'EX: 350 kcal', // Ajustado de Kg para kcal
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
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),

            // --- Adicionar Exercícios ---
            _buildSectionTitle('Adicione os Exercícios'),
            GestureDetector(
              onTap: _abrirMenuDeExercicios, // Chama a função aqui!
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
                          ? 'EX: Tríceps Pulley' // Texto default
                          : '${meusExerciciosSelecionados.length} selecionado(s)', // Mostra qtd
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
            const SizedBox(height: 24),

            // --- Botão Salvar ---
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Lógica de salvar
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: corPrimaria,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
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

  // Widget auxiliar para os títulos das seções
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

  // Widget auxiliar para os botões arredondados (Chips)
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
}
