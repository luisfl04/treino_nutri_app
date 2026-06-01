import 'package:flutter/material.dart';
import 'package:treino_nutri_app/routes/app_routes.dart';
import 'package:treino_nutri_app/widgets/bottom_navigation_widget.dart';
import 'package:treino_nutri_app/widgets/treino_card_widget.dart';
import 'package:treino_nutri_app/controllers/TreinoController.dart';

class TreinosPage extends StatefulWidget {
  const TreinosPage({super.key});

  @override
  State<TreinosPage> createState() => _TreinosPageState();
}

class _TreinosPageState extends State<TreinosPage> {
  int _selectedIndex = 1; // Treinos está selecionado

  List<Map<String, dynamic>> _treinos = [];
  bool _isLoading = true;

  // Instância do Controller
  final TreinoController _treinoController = TreinoController();

  @override
  void initState() {
    super.initState();
    _carregarTreinos();
  }

  // Função que pede os dados para o Controller e atualiza o estado
  Future<void> _carregarTreinos() async {
    setState(() => _isLoading = true);

    // O Controller faz a consulta SQL
    final resultado = await _treinoController.buscarTreinos();

    if (mounted) {
      setState(() {
        _treinos = resultado;
        _isLoading = false;
      });
    }
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
          'Meus Treinos',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- TRATAMENTO DE ESTADOS DA TELA ---
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(color: Color(0xFF1B7E3D)),
                  ),
                )
              else if (_treinos.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text(
                      'Nenhum treino cadastrado ainda.\nQue tal começar agora?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                )
              else
                // Lista de treinos renderizada
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _treinos.length,
                  itemBuilder: (context, index) {
                    final treino = _treinos[index];

                    // --- variáveis seguras ---
                    String nomeTreino = treino['tipo_nome'] ?? 'Treino';
                    String periodo = 'Período: ${treino['day_period'] ?? 'Não informado'}';
                    String calorias = '${treino['calories']?.toInt() ?? 0} kcal';
                    bool concluido = treino['done'] == 1;
                    String dataBanco = treino['date'] != null && treino['date'].toString().isNotEmpty 
                        ? treino['date'] 
                        : 'Sem data';
                    
                    // 2. Juntamos a data com o status quebrando a linha (\n)
                    String textoDataStatus = concluido 
                        ? '$dataBanco\n✔ Concluído' 
                        : '$dataBanco\nEm andamento';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Opacity(
                        opacity: concluido ? 0.5 : 1.0, 
                        child: TreinoCardWidget(
                          onTap: () async {
                            final atualizou = await Navigator.of(context).pushNamed(
                                  AppRoutes.treinoDetalhe,
                                  arguments: treino,
                                );

                            if (atualizou == true) {
                              _carregarTreinos(); 
                            }
                          },
                          nome: nomeTreino,
                          exercicios: periodo,
                          duracao: calorias,
                          data: textoDataStatus, 
                          onEdit: () {
                            Navigator.of(context).pushNamed(AppRoutes.editarTreino);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Editar')),
                            );
                          },
                          onDelete: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Excluir')),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),

              const SizedBox(height: 40),

              // Botão Novo Treino
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.treinoCadastro).then((_) {
                      _carregarTreinos();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B7E3D),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Novo Treino',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          if (index == 0) {
            Navigator.pop(context); // Voltar para Home
          }
        },
      ),
    );
  }
}