import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:treino_nutri_app/models/Alimentacao.dart';
import 'package:treino_nutri_app/controllers/AlimentacaoController.dart';

class RefeicaoDetalhePage extends StatefulWidget {
  const RefeicaoDetalhePage({super.key});

  @override
  State<RefeicaoDetalhePage> createState() => _RefeicaoDetalhePageState();
}

class _RefeicaoDetalhePageState extends State<RefeicaoDetalhePage> {
  final AlimentacaoController _controller = AlimentacaoController();
  bool _isLoading = false;

  final Color corFundo = const Color(0xFFF4FAF1);
  final Color corPrimaria = const Color(0xFF0F7A40);

  @override
  Widget build(BuildContext context) {
    // 👉 Pega a refeição enviada por argumento da tela anterior
    final Alimentacao refeicao =
        ModalRoute.of(context)!.settings.arguments as Alimentacao;

    final bool temFoto =
        refeicao.foto.isNotEmpty && File(refeicao.foto).existsSync();
    final String dataFormatada = DateFormat(
      'dd/MM/yyyy',
    ).format(DateTime.parse(refeicao.dataCriacao));

    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        backgroundColor: corFundo,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detalhes da Refeição',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Categoria e Data
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: corPrimaria.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                refeicao.tipoRefeicao.toUpperCase(),
                style: TextStyle(
                  color: corPrimaria,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Registrada em: $dataFormatada',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),

            const SizedBox(height: 32),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'O que você comeu:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
              ),
              child: Text(
                refeicao.descricao,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1B1B1B),
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Card de Calorias
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Valor Calórico',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${refeicao.valorCalorico.toStringAsFixed(0)} Kcal',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Foto da Refeição
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Foto do Prato',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black12),
                image: temFoto
                    ? DecorationImage(
                        image: FileImage(File(refeicao.foto)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: temFoto
                  ? null
                  : const Icon(
                      Icons.fastfood_outlined,
                      size: 80,
                      color: Colors.black12,
                    ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: (refeicao.concluida || _isLoading)
                    ? null
                    : () async {
                        setState(() => _isLoading = true);
                        bool ok = await _controller.finalizarRefeicao(
                          refeicao.id!,
                        );
                        if (ok && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Bom apetite! Refeição finalizada.',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(
                            context,
                            true,
                          ); // Volta recarregando a lista
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: refeicao.concluida
                      ? Colors.grey
                      : corPrimaria,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        refeicao.concluida
                            ? 'REFEIÇÃO FINALIZADA ✓'
                            : 'FINALIZAR REFEIÇÃO',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
