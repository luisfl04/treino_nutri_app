import 'package:flutter/material.dart';
import 'package:treino_nutri_app/controllers/MetasController.dart';
import 'package:treino_nutri_app/routes/app_routes.dart';
import 'package:treino_nutri_app/widgets/bottom_navigation_widget.dart';
import 'package:treino_nutri_app/widgets/meta_card_widget.dart';

class MetasPage extends StatefulWidget {
  const MetasPage({super.key});

  @override
  State<MetasPage> createState() => _MetasPageState();
}

class _MetasPageState extends State<MetasPage> {
  int _selectedIndex = 3; // Metas está selecionado

  // 👉 VARIÁVEIS DE ESTADO
  List<Map<String, dynamic>> _metas = [];
  bool _isLoading = true;

  // Instância do Controller
  final MetaController _metaController = MetaController();

  @override
  void initState() {
    super.initState();
    _carregarMetas(); // Busca as metas assim que a tela abre
  }

  // 👉 FUNÇÃO PARA BUSCAR AS METAS NO BANCO DE DADOS
  Future<void> _carregarMetas() async {
    setState(() => _isLoading = true);

    final resultado = await _metaController.buscarMetas();

    if (mounted) {
      setState(() {
        _metas = resultado;
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
          'Minhas Metas',
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
              Center(
                child: const Text(
                  'Acompanhe seu progresso',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 24),

              // --- TRATAMENTO DOS ESTADOS DA TELA ---
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(color: Color(0xFF1B7E3D)),
                  ),
                )
              else if (_metas.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text(
                      'Você ainda não possui metas.\nClique no botão abaixo para criar uma!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                )
              else
                // --- LISTAGEM DE METAS REAIS DO BANCO ---
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _metas.length,
                  itemBuilder: (context, index) {
                    final meta = _metas[index];

                    // Extraindo os dados do banco
                    String objetivo = meta['objetivo'] ?? 'Meta';
                    double pesoAtual = (meta['peso_atual'] ?? 0.0).toDouble();
                    double pesoMeta = (meta['peso_meta'] ?? 0.0).toDouble();
                    int porcentagem = meta['porcentagem'] ?? 0;
                    bool concluido = porcentagem >= 100;

                    // Montando uma descrição inteligente
                    String descricao = 'De $pesoAtual kg para $pesoMeta kg';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: MetaCardWidget(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(
                                '/meta_detalhe', // Use a rota configurada no seu app
                                arguments:
                                    meta, // Passa o Map inteiro da meta vinda do banco
                              )
                              .then(
                                (_) => _carregarMetas(),
                              ); // Recarrega se voltar de lá
                        },

                        // 👉 AÇÃO DE EDITAR (Passando os argumentos para a tela de cadastro se adaptar)
                        onEdit: () {
                          Navigator.of(context)
                              .pushNamed(
                                AppRoutes
                                    .editarMeta, // 👈 NOME DA ROTA ATUALIZADO AQUI
                                arguments: meta,
                              )
                              .then((_) => _carregarMetas());
                        },

                        // 👉 EXCLUSÃO COM CONFIRMAÇÃO DE VERDADE
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Excluir Meta'),
                              content: const Text(
                                'Tem certeza que deseja apagar essa meta permanentemente?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(ctx);
                                    final erro = await _metaController
                                        .excluirMeta(meta['id']);
                                    if (erro == null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Meta removida!'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      _carregarMetas(); // Atualiza a lista
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(erro),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text(
                                    'Excluir',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        titulo: objetivo,
                        descricao: descricao,
                        categoria: 'Corpo',
                        progresso: '$porcentagem%',
                        concluido: concluido,
                      ),
                    );
                  },
                ),

              const SizedBox(height: 40),

              // --- BOTÃO NOVA META ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // 👉 O .then() garante que a lista atualize após o cadastro!
                    Navigator.of(
                      context,
                    ).pushNamed(AppRoutes.metaCadasrto).then((_) {
                      _carregarMetas();
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
                    'Nova Meta',
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
