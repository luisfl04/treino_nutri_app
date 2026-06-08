import 'dart:async';
import 'package:flutter/material.dart';
import 'package:treino_nutri_app/controllers/MetasController.dart';
import 'package:treino_nutri_app/routes/app_routes.dart';
import 'package:treino_nutri_app/widgets/meta_card_widget.dart';

class MetasCarouselWidget extends StatefulWidget {
  const MetasCarouselWidget({super.key});

  @override
  State<MetasCarouselWidget> createState() => _MetasCarouselWidgetState();
}

class _MetasCarouselWidgetState extends State<MetasCarouselWidget> {
  final MetaController _metaController = MetaController();
  List<Map<String, dynamic>> _metas = [];
  
  final PageController _pageController = PageController(viewportFraction: 0.9);
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _carregarMetas();
  }

  Future<void> _carregarMetas() async {
    final metas = await _metaController.buscarMetas();
    if (mounted) {
      setState(() {
        _metas = metas;
      });
      if (_metas.isNotEmpty) {
        _iniciarAutoScroll();
      }
    }
  }

  void _iniciarAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (!mounted) return;
      if (_currentPage < _metas.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_metas.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Text('Nenhuma meta cadastrada.', style: TextStyle(color: Colors.grey)),
      );
    }

    return SizedBox(
      height: 140, // Altura perfeita para um card sem botões
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        itemCount: _metas.length,
        itemBuilder: (context, index) {
          final meta = _metas[index];

          String objetivo = meta['objetivo'] ?? 'Meta';
          double pesoAtual = (meta['peso_atual'] ?? 0.0).toDouble();
          double pesoMeta = (meta['peso_meta'] ?? 0.0).toDouble();
          int porcentagem = meta['porcentagem'] ?? 0;
          bool concluido = porcentagem >= 100;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: MetaCardWidget(
              titulo: objetivo,
              descricao: 'De $pesoAtual kg para $pesoMeta kg',
              categoria: 'Corpo',
              progresso: '$porcentagem%',
              concluido: concluido,
              // 👉 NAVEGAÇÃO AO CLICAR NO CARD 
              onTap: () {
                Navigator.pushNamed(
                  context, 
                  AppRoutes.metaDetalhe, 
                  arguments: meta,
                ).then((_) => _carregarMetas()); // Recarrega se alterar a meta por lá
              },
              // NOTE: Não enviamos onEdit e onDelete aqui! Assim eles ficam invisíveis na Home.
            ),
          );
        },
      ),
    );
  }
}