import 'dart:convert';
import 'dart:io'; // Necessário para carregar a foto do arquivo local
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Pacote para tirar/escolher foto
import 'package:treino_nutri_app/controllers/TreinoController.dart';

class TreinoDetalhePage extends StatefulWidget {
  const TreinoDetalhePage({super.key});

  @override
  State<TreinoDetalhePage> createState() => _TreinoDetalhePageState();
}

class _TreinoDetalhePageState extends State<TreinoDetalhePage> {
  final TreinoController _treinoController = TreinoController();
  final ImagePicker _picker = ImagePicker();

  // Variáveis de estado locais
  bool _isInitialized = false;
  late int _treinoId;
  late bool _isConcluido;
  String? _fotoCaminho;

  // Dados estáticos que vêm por argumento
  late String _nomeTreino;
  late String _dataTreino;
  late String _duracao;
  late String _totalSeries;
  List<String> _exerciciosReais = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Captura os argumentos apenas uma vez na inicialização da tela
    if (!_isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};

      _treinoId = args['id'] ?? 0;
      _isConcluido = args['done'] == 1;
      _fotoCaminho = args['photo'] != null && args['photo'].toString().isNotEmpty ? args['photo'] : null;

      _nomeTreino = args['tipo_nome'] ?? 'Treino';
      _dataTreino = args['date'] != null && args['date'].toString().isNotEmpty ? args['date'] : 'Sem data';
      _duracao = '${args['duration'] ?? 0} Min';
      _totalSeries = '${args['total_series'] ?? 0} Séries';

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
    final XFile? file = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (file != null) {
      setState(() {
        _fotoCaminho = file.path;
      });
    }
  }

  // Lógica do botão finalizar
  Future<void> _executarFinalizacao() async {
    final erro = await _treinoController.finalizarTreino(_treinoId, _fotoCaminho);

    if (erro == null) {
      setState(() {
        _isConcluido = true;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🎉 Treino finalizado com sucesso!'), backgroundColor: Colors.green),
      );

      // Espera 1.5 segundos e volta para a tela anterior avisando que mudou (passando true)
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          Navigator.of(context).pop(true); // O 'true' avisa a tela de trás que houve alteração
        }
      });

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro), backgroundColor: Colors.red),
      );
    }
  }

  // Abre a foto em tela cheia com possibilidade de Zoom
  void _abrirFotoExpandida() {
    if (_fotoCaminho == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black.withOpacity(0.9), // Fundo escuro para destacar a foto
          insetPadding: EdgeInsets.zero, // Remove as bordas padrão
          child: Stack(
            alignment: Alignment.center,
            children: [
              // InteractiveViewer permite dar zoom na foto
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
              // Botão de fechar (X) no canto superior direito
              Positioned(
                top: 40,
                right: 20,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
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
        title: Text(_nomeTreino, style: const TextStyle(fontWeight: FontWeight.bold)),
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
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildHeaderItem(Icons.calendar_today, 'Data', _dataTreino),
                  _buildHeaderItem(Icons.timer, 'Duração', _duracao),
                  _buildHeaderItem(Icons.repeat, 'Séries', _totalSeries),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- Seção da Foto de Conclusão ---
            const Text('Foto de Conclusão', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildFotoSection(),
            const SizedBox(height: 24),

            // --- Lista de Exercícios ---
            const Text('Exercícios', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (_exerciciosReais.isEmpty)
              const Center(child: Text('Nenhum exercício registrado para este treino.'))
            else
              ..._exerciciosReais.map((nome) => _buildExercicioCard(nome)),
              
            const SizedBox(height: 32),

            // --- Botão Dinâmico de Finalização ---
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isConcluido ? null : _executarFinalizacao,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F7A40),
                  disabledBackgroundColor: Colors.grey[400],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                child: Text(
                  _isConcluido ? 'Treino Concluído ✅' : 'Finalizar Treino',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
                  // foto clicavel para expandir
                  GestureDetector(
                    onTap: _abrirFotoExpandida,
                    child: Image.file(File(_fotoCaminho!), fit: BoxFit.cover),
                  ),
                  
                  // Se o treino não estiver finalizado, permite trocar a foto
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
                  ? const Text('Nenhuma foto adicionada neste treino.', style: TextStyle(color: Colors.grey))
                  : OutlinedButton.icon(
                      onPressed: _tirarFoto,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Tirar Foto de Progresso (Opcional)'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0F7A40),
                        side: const BorderSide(color: Color(0xFF0F7A40)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
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