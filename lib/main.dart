import 'package:flutter/material.dart';
import 'package:treino_nutri_app/pages/alimentacao_page.dart';
import 'package:treino_nutri_app/pages/cadastro_meta_page.dart';
import 'package:treino_nutri_app/pages/cadastro_page.dart';
import 'package:treino_nutri_app/pages/editar_alimentacao_page.dart';
import 'package:treino_nutri_app/pages/editar_meta_page.dart';
import 'package:treino_nutri_app/pages/editar_perfil_page.dart';
import 'package:treino_nutri_app/pages/editar_treino_page.dart';
import 'package:treino_nutri_app/pages/home_page.dart';
import 'package:treino_nutri_app/pages/login_page.dart';
import 'package:treino_nutri_app/pages/meta_detalhe_page.dart';
import 'package:treino_nutri_app/pages/metas_page.dart';
import 'package:treino_nutri_app/pages/perfil_page.dart';
import 'package:treino_nutri_app/pages/refeicao_cadastro_page.dart';
import 'package:treino_nutri_app/pages/refeicao_detalhe_page.dart';
import 'package:treino_nutri_app/pages/treino_cadastro_page.dart';
import 'package:treino_nutri_app/pages/treino_detalhe_page.dart';
import 'package:treino_nutri_app/pages/treinos_page.dart';
import 'package:treino_nutri_app/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TreinoNutri+',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B7E3D)),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      routes: {
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.cadastro: (context) => const CadastroPage(),
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.treinos: (context) => const TreinosPage(),
        AppRoutes.alimentacao: (context) => const AlimentacaoPage(),
        AppRoutes.metas: (context) => const MetasPage(),
        AppRoutes.perfil: (context) => const PerfilPage(),
        AppRoutes.treinoCadastro: (context) => const TreinoCadastroPage(),
        AppRoutes.refeicaoCadastro: (context) => const RefeicaoCadastroPage(),
        AppRoutes.metaCadasrto: (context) => const CadastrarMetaPage(),
        AppRoutes.editarPerfil: (context) => const EditarPerfilPage(),
        AppRoutes.treinoDetalhe: (context) => const TreinoDetalhePage(),
        AppRoutes.refeicaoDetalhe: (context) => const RefeicaoDetalhePage(),
        AppRoutes.metaDetalhe: (context) => const MetaDetalhe(),
        AppRoutes.editarMeta: (context) => const EditarMetaPage(),
        AppRoutes.editarTreino: (context) => const EditarTreinoPage(),
        AppRoutes.editarRefeicao: (context) => const EditarRefeicaoPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.home) {
          return MaterialPageRoute(
            builder: (context) => const HomePage(),
            settings: RouteSettings(name: '/home'),
          );
        }
        return null;
      },
    );
  }
}
