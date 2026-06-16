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
  int _selectedIndex = 1;

  List<Map<String, dynamic>> _treinos = [];
  bool _isLoading = true;

  final TreinoController _treinoController = TreinoController();

  @override
  void initState() {
    super.initState();
    _carregarTreinos();
  }

  Future<void> _confirmarExclusao(int treinoId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Excluir Treino',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Tem a certeza que deseja excluir este treino? Esta ação não pode ser desfeita.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                Navigator.pop(context); // Fecha o pop-up primeiro

                // Chama a função do controller para apagar do banco
                bool sucesso = await _treinoController.excluirTreino(treinoId);

                if (sucesso && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Treino excluído com sucesso!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  //  Atualiza a tela recarregando os treinos do banco
                  _carregarTreinos();
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Erro ao excluir o treino.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text(
                'Excluir',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
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
                    int idTreino =
                        treino['id'] ?? 0; // ID do treino para edição/exclusão
                    String nomeTreino = treino['tipo_nome'] ?? 'Treino';
                    String periodo =
                        'Período: ${treino['day_period'] ?? 'Não informado'}';
                    String calorias =
                        '${treino['calories']?.toInt() ?? 0} kcal';
                    bool concluido = treino['done'] == 1;
                    String dataBanco =
                        treino['date'] != null &&
                            treino['date'].toString().isNotEmpty
                        ? treino['date']
                        : 'Sem data';

                    // 2.  quebran de linha (\n)
                    String textoDataStatus = concluido
                        ? '$dataBanco\n✔ Concluído'
                        : '$dataBanco\nEm andamento';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Opacity(
                        opacity: concluido ? 0.5 : 1.0,
                        child: TreinoCardWidget(
                          onTap: () async {
                            final atualizou = await Navigator.of(context)
                                .pushNamed(
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
                            // Envia os dados do treino para a tela de edição
                            Navigator.of(context)
                                .pushNamed(
                                  AppRoutes.editarTreino,
                                  arguments: treino,
                                )
                                .then((value) {
                                  // Atualiza a lista quando voltar da edição
                                  _carregarTreinos();
                                });
                          },
                          //  CHAMA O MÉTODO DE EXCLUSÃO AQUI, PASSANDO O ID
                          onDelete: () {
                            _confirmarExclusao(idTreino);
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
                    Navigator.of(
                      context,
                    ).pushNamed(AppRoutes.treinoCadastro).then((_) {
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
