import 'dart:convert';
import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; 
import 'package:treino_nutri_app/controllers/TreinoController.dart';
import 'package:treino_nutri_app/controllers/MetasController.dart';
import 'package:treino_nutri_app/database/database_connection.dart'; 

class TreinoDetalhePage extends StatefulWidget {
  const TreinoDetalhePage({super.key});

  @override
  State<TreinoDetalhePage> createState() => _TreinoDetalhePageState();
}

class _TreinoDetalhePageState extends State<TreinoDetalhePage> {
  final TreinoController _treinoController = TreinoController();
  final MetaController _metaController =
      MetaController(); 
  final ImagePicker _picker = ImagePicker();

  // Variáveis de estado locais
  bool _isInitialized = false;
  late int _treinoId;
  late bool _isConcluido;
  String? _fotoCaminho;
  String _metaVinculadaNome =
      'Nenhuma meta associada'; 

  // Dados estáticos que vêm por argumento
  late String _nomeTreino;
  late String _dataTreino;
  late String _duracao;
  late String _totalSeries;
  late String _descricao; 
  List<String> _exerciciosReais = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Captura os argumentos apenas uma vez na inicialização da tela
    if (!_isInitialized) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
          {};

      _treinoId = args['id'] ?? 0;
      _isConcluido = args['done'] == 1;
      _fotoCaminho =
          args['photo'] != null && args['photo'].toString().isNotEmpty
          ? args['photo']
          : null;

      _nomeTreino = args['tipo_nome'] ?? 'Treino';
      _dataTreino = args['date'] != null && args['date'].toString().isNotEmpty
          ? args['date']
          : 'Sem data';
      _duracao = '${args['duration'] ?? 0} Min';
      _totalSeries = '${args['total_series'] ?? 0} Séries';

      //  Captura a descrição/observações do banco de dados
      _descricao = args['description'] != null && args['description'].toString().isNotEmpty
          ? args['description']
          : 'Nenhuma observação registrada para este treino.';

      // Verifica se já veio alguma informação de objetivo/meta associada de trás
      if (args['meta_objetivo'] != null) {
        _metaVinculadaNome = args['meta_objetivo'];
      }

      final String textoJson = args['exercicios_selecionados'] ?? '[]';
      try {
        final List<dynamic> listaDecodificada = jsonDecode(textoJson);
        _exerciciosReais = listaDecodificada.map((e) => e.toString()).toList();
      } catch (e) {
        _exerciciosReais = [];
      }

      _isInitialized = true;
    }
  }

  // Função para tirar foto usando a Câmera
  Future<void> _tirarFoto() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );
    if (file != null) {
      setState(() {
        _fotoCaminho = file.path;
      });
    }
  }

  // Lógica do botão finalizar com atualização automática do progresso da Meta
  Future<void> _executarFinalizacao() async {
    dynamic resultado;
    
    try {
      // 1. Executa a finalização padrão do treino
      resultado = await (_treinoController as dynamic).finalizarTreino(_treinoId, _fotoCaminho);
    } catch (_) {
      try {
        resultado = await (_treinoController as dynamic).finalizarTreino(_treinoId);
      } catch (e) {
        resultado = 'Erro interno ao chamar finalização: $e';
      }
    }

    // Se a finalização do treino deu certo
    if (resultado == null || resultado.toString().isEmpty || resultado == true || resultado == 1) {
      
      // 🚀 NOVO: Atualizar a porcentagem da meta vinculada se ela existir
      try {
        final dbConnection = DatabaseConnection();
        final db = await dbConnection.db;
        
        // Busca o treino atual para ver se ele possui um meta_id gravado
        final List<Map<String, dynamic>> dadosTreino = await db.query(
          'Treino',
          columns: ['meta_id'],
          where: 'id = ?',
          whereArgs: [_treinoId],
        );

        if (dadosTreino.isNotEmpty && dadosTreino.first['meta_id'] != null) {
          int metaId = dadosTreino.first['meta_id'] as int;
          
          // Chama o MetaController para recalcular a porcentagem da meta
          await _metaController.atualizarPorcentagemMeta(metaId);
        }
      } catch (e) {
        debugPrint('Aviso: Não foi possível atualizar a porcentagem da meta: $e');
      }

      // Continua com o fluxo normal de sucesso na tela
      setState(() {
        _isConcluido = true;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🎉 Treino finalizado e progresso da meta atualizado!'), backgroundColor: Colors.green),
      );

      // Espera 1.5 segundos e volta avisando a tela anterior que houve mudança
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resultado.toString()), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _mostrarDialogoVincularMeta() async {
    final metas = await _metaController.buscarMetas();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text(
            'Associar a uma Meta',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: metas.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Você ainda não tem metas cadastradas de peso/massa no momento.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: metas.length,
                    itemBuilder: (context, index) {
                      final meta = metas[index];
                      String objetivo = meta['objetivo'] ?? 'Meta';
                      String pesoAlvo = '${meta['peso_meta'] ?? 0.0} kg';

                      return ListTile(
                        leading: const Icon(
                          Icons.flag,
                          color: Color(0xFF0F7A40),
                        ),
                        title: Text(objetivo),
                        subtitle: Text('Foco: Chegar em $pesoAlvo'),
                        trailing: const Icon(Icons.link, color: Colors.grey),
                        onTap: () async {
                          final metaId = meta['id'] as int;

                          
                          final erro = await _metaController
                              .vincularTreinoAMeta(_treinoId, metaId); 

                          if (!context.mounted) return;
                          Navigator.pop(ctx); // Fecha o Dialog

                          if (erro == null) {
                            setState(() {
                              _metaVinculadaNome = objetivo;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Treino vinculado à meta: $objetivo! 🔗',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(erro),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        );
      },
    );
  }

  // Abre a foto em tela cheia com possibilidade de Zoom
  void _abrirFotoExpandida() {
    if (_fotoCaminho == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black.withOpacity(
            0.9,
          ), 
          insetPadding: EdgeInsets.zero, 
          child: Stack(
            alignment: Alignment.center,
            children: [
              InteractiveViewer(
                panEnabled: true,
                minScale: 0.5,
                maxScale: 4.0, // Zoom de até 4x
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Image.file(
                    File(_fotoCaminho!),
                    fit: BoxFit.contain, // Mostra a foto inteira sem cortar
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAF1),
      appBar: AppBar(
        title: Text(
          _nomeTreino,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Cabeçalho de Resumo ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildHeaderItem(Icons.calendar_today, 'Data', _dataTreino),
                  _buildHeaderItem(Icons.timer, 'Duração', _duracao),
                  _buildHeaderItem(Icons.repeat, 'Séries', _totalSeries),
                ],
              ),
            ),
            const SizedBox(height: 16),

            //  INDICADOR DE META VINCULADA ATUALMENTE
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFC8E6C9)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.flag, color: Color(0xFF0F7A40)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Meta: $_metaVinculadaNome',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F7A40),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

          
            const Text(
              'Observações / Instruções',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                _descricao,
                style: TextStyle(
                  fontSize: 14, 
                  color: _descricao.contains('Nenhuma observação') ? Colors.grey : Colors.black87,
                  fontStyle: _descricao.contains('Nenhuma observação') ? FontStyle.italic : FontStyle.normal,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- Seção da Foto de Conclusão ---
            const Text(
              'Foto de Conclusão',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildFotoSection(),
            const SizedBox(height: 24),

            // --- Lista de Exercícios ---
            const Text(
              'Exercícios',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (_exerciciosReais.isEmpty)
              const Center(
                child: Text('Nenhum exercício registrado para este treino.'),
              )
            else
              ..._exerciciosReais.map((nome) => _buildExercicioCard(nome)),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: _mostrarDialogoVincularMeta,
                icon: const Icon(Icons.link),
                label: const Text(
                  'Associar a uma Meta existente',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1B7E3D),
                  side: const BorderSide(color: Color(0xFF1B7E3D), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- Botão Dinâmico de Finalização ---
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isConcluido ? null : _executarFinalizacao,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F7A40),
                  disabledBackgroundColor: Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  _isConcluido ? 'Treino Concluído ✅' : 'Finalizar Treino',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Widget para os itens do cabeçalho
  Widget _buildHeaderItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF0F7A40)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }

  // Widget da área de foto dinâmica
  Widget _buildFotoSection() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: _fotoCaminho != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  GestureDetector(
                    onTap: _abrirFotoExpandida,
                    child: Image.file(File(_fotoCaminho!), fit: BoxFit.cover),
                  ),
                  if (!_isConcluido)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: _tirarFoto,
                        ),
                      ),
                    ),
                ],
              ),
            )
          : Center(
              child: _isConcluido
                  ? const Text(
                      'Nenhuma foto adicionada neste treino.',
                      style: TextStyle(color: Colors.grey),
                    )
                  : OutlinedButton.icon(
                      onPressed: _tirarFoto,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Tirar Foto de Progresso (Opcional)'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0F7A40),
                        side: const BorderSide(color: Color(0xFF0F7A40)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
            ),
    );
  }

  // Card do Exercício
  Widget _buildExercicioCard(String nome) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.fitness_center, color: Color(0xFF0F7A40)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              nome,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}