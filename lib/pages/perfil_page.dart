import 'dart:io';
import 'package:flutter/material.dart';
import 'package:treino_nutri_app/routes/app_routes.dart';
import 'package:treino_nutri_app/widgets/bottom_navigation_widget.dart';
import 'package:treino_nutri_app/controllers/AuthController.dart';
import 'package:treino_nutri_app/controllers/UsuarioController.dart';
import 'package:treino_nutri_app/models/Usuario.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  int _selectedIndex = 4;

  double _peso = 0.0;
  double _altura = 0.0;
  double _imc = 0.0;
  String _imcStatus = 'CALCULANDO...';
  Color _imcCor = Colors.grey;

  bool _isLoading = true;

  final UsuarioController _usuarioController = UsuarioController();

  @override
  void initState() {
    super.initState();
    _inicializarPerfil();
  }

  Future<void> _inicializarPerfil() async {
    if (AuthController.usuarioLogado == null) {
      await AuthController.recuperarSessao();
    }
    await _carregarDadosCorporais();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _carregarDadosCorporais() async {
    final usuarioLogado = AuthController.usuarioLogado;
    if (usuarioLogado?.email == null) return;

    final info = await _usuarioController.buscarInformacaoCorporal(
      usuarioLogado!.email!,
    );

    if (info != null && mounted) {
      setState(() {
        _peso = info['weight'] ?? 0.0;
        _altura = info['height'] ?? 0.0;

        if (_altura > 3.0) {
          _altura = _altura / 100;
        }

        if (_peso > 0 && _altura > 0) {
          _imc = _peso / (_altura * _altura);

          if (_imc < 18.5) {
            _imcStatus = 'ABAIXO DO PESO';
            _imcCor = Colors.orange;
          } else if (_imc < 24.9) {
            _imcStatus = 'PESO NORMAL';
            _imcCor = Colors.green;
          } else if (_imc < 29.9) {
            _imcStatus = 'SOBREPESO';
            _imcCor = Colors.red.shade400;
          } else {
            _imcStatus = 'OBESIDADE';
            _imcCor = Colors.red.shade900;
          }
        }
      });
    }
  }

  void _fazerLogout() async {
    await AuthController.sair();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    }
  }

  void _confirmarExclusaoConta() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Excluir Conta Definitivamente?'),
        content: const Text(
          'Tem certeza que deseja apagar sua conta? Todos os seus dados, treinos e fotos serão excluídos para sempre.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final email = AuthController.usuarioLogado?.email;
              if (email != null) {
                bool sucesso = await _usuarioController.deletarConta(email);
                if (sucesso) {
                  await AuthController.sair();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Conta excluída com sucesso!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                      (route) => false,
                    );
                  }
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sim, Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF1B7E3D)),
        ),
      );
    }

    final Usuario? usuarioLogado = AuthController.usuarioLogado;
    final String nomeExibir = usuarioLogado?.nome ?? 'Visitante';
    final String emailExibir = usuarioLogado?.email ?? 'Nenhum e-mail';

    final String? caminhoFoto = usuarioLogado?.path_foto_perfil?.trim();
    final bool temFoto =
        caminhoFoto != null &&
        caminhoFoto.isNotEmpty &&
        File(caminhoFoto).existsSync();

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
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Perfil',
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF1B7E3D), width: 3),
                  color: Colors.grey[300],
                  image: temFoto
                      ? DecorationImage(
                          image: FileImage(File(caminhoFoto!)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: temFoto
                    ? null
                    : const Icon(Icons.person, color: Colors.grey, size: 60),
              ),
              const SizedBox(height: 16),
              Text(
                nomeExibir,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B1B1B),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'E-MAIL',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Text(
                        emailExibir,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1B1B1B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SENHA',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: const Text(
                        '••••••••••••',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1B1B1B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pushNamed(AppRoutes.editarPerfil).then((value) {
                      // Se voltou de Editar Perfil, recarrega a tela de Perfil para atualizar foto/IMC
                      if (value == true) {
                        setState(() => _isLoading = true);
                        _inicializarPerfil();
                      }
                    });
                  },
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Editar Perfil'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9FA8DA),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Centraliza os itens verticalmente na coluna
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Centraliza horizontalmente o título e o ícone
                      children: const [
                        Icon(Icons.scale, size: 18, color: Color(0xFF1B7E3D)),
                        SizedBox(width: 6),
                        Text(
                          'Minhas Taxas',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B1B1B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Peso: ${_peso.toStringAsFixed(1)}kg',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1B1B1B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Altura: ${_altura.toStringAsFixed(2)}m',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1B1B1B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Centraliza os dados de IMC na horizontal
                      children: [
                        const Text(
                          'IMC:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1B1B1B),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _imc.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _imcCor,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '•  $_imcStatus',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _imcCor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Sair da Conta?'),
                        content: const Text(
                          'Tem certeza que deseja sair do aplicativo?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _fazerLogout();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('Sair'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Sair do Aplicativo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _confirmarExclusaoConta,
                child: const Text(
                  'Deseja Excluir sua Conta?',
                  style: TextStyle(
                    color: Colors.redAccent,
                    decoration: TextDecoration.underline,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}
