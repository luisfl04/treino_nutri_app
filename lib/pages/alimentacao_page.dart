import 'package:flutter/material.dart';
import 'package:treino_nutri_app/routes/app_routes.dart';
import 'package:treino_nutri_app/widgets/bottom_navigation_widget.dart';
import 'package:treino_nutri_app/widgets/refeicao_card_widget.dart';
import 'package:treino_nutri_app/controllers/AuthController.dart';
import 'package:treino_nutri_app/controllers/AlimentacaoController.dart';
import 'package:treino_nutri_app/models/Alimentacao.dart';

class AlimentacaoPage extends StatefulWidget {
  const AlimentacaoPage({super.key});

  @override
  State<AlimentacaoPage> createState() => _AlimentacaoPageState();
}

class _AlimentacaoPageState extends State<AlimentacaoPage> {
  int _selectedIndex = 2; // Alimentação está selecionado

  final AlimentacaoController _alimentacaoController = AlimentacaoController();
  List<Alimentacao> _minhasRefeicoes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarRefeicoesReal();
  }

  Future<void> _carregarRefeicoesReal() async {
    final usuario = AuthController.usuarioLogado;
    if (usuario != null && usuario.id != null) {
      final refeicoesDoBanco = await _alimentacaoController.listarRefeicoes(
        usuario.id!,
      );
      if (mounted) {
        setState(() {
          _minhasRefeicoes = refeicoesDoBanco;
          _isLoading = false;
        });
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  // Caixa de confirmação e exclusão direta pela lista
  void _confirmarExclusaoDireta(Alimentacao refeicao) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Refeição'),
          content: const Text(
            'Tem certeza de que deseja apagar esta refeição do seu histórico?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.black54),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Fecha o aviso
                setState(() => _isLoading = true);

                // Executa a deleção no banco de dados usando o seu método nativo 'deletarRefeicao'
                bool sucesso = await _alimentacaoController.deletarRefeicao(
                  (refeicao as dynamic).id,
                );

                if (sucesso) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Refeição excluída com sucesso!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }

                // Recarrega a lista atualizada do banco
                _carregarRefeicoesReal();
              },
              child: const Text(
                'Excluir',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
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
          'Alimentação',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B1B1B),
          ),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF1B7E3D)),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Meu Cardápio',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B1B1B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Acompanhe suas refeições diárias.',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 32),

                    if (_minhasRefeicoes.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.0),
                          child: Text(
                            'Nenhuma refeição cadastrada ainda!',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                      )
                    else
                      ..._minhasRefeicoes.map((refeicao) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          // 👉 Código totalmente limpo usando os parâmetros internos do seu Card!
                          child: RefeicaoCard(
                            categoria: refeicao.tipoRefeicao,
                            nome: refeicao.descricao.length > 35
                                ? '${refeicao.descricao.substring(0, 35)}...'
                                : refeicao.descricao,
                            calorias: refeicao.valorCalorico.toStringAsFixed(0),
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(
                                    AppRoutes.refeicaoDetalhe,
                                    arguments: refeicao,
                                  )
                                  .then((value) {
                                    _carregarRefeicoesReal();
                                  });
                            },
                            onEdit: () {
                              Navigator.of(context)
                                  .pushNamed(
                                    AppRoutes.editarRefeicao,
                                    arguments: refeicao,
                                  )
                                  .then((value) {
                                    _carregarRefeicoesReal();
                                  });
                            },
                            onDelete: () => _confirmarExclusaoDireta(refeicao),
                          ),
                        );
                      }).toList(),

                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.refeicaoCadastro).then((value) {
                            if (value == true) {
                              _carregarRefeicoesReal();
                            }
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
                          'Nova Refeição',
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
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
