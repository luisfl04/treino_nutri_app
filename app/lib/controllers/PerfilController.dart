import 'package:app/repositorys/firestore/UsuarioFirestoreRepository.dart';
import 'package:app/repositorys/local/Endereco.dart';
import 'package:app/repositorys/local/InformacaoCorporal.dart';
import 'package:app/models/Usuario.dart';
import 'package:app/models/Endereco.dart';
import 'package:app/models/InformacaoCorporal.dart';


class PerfilController {
  final UsuarioFirestoreRepository _usuarioRepo;
  final EnderecoRepository _enderecoRepo;
  final InformacaoCorporalRepository _infoRepo;

  Usuario? usuarioAtual;
  Endereco? enderecoAtual;
  InformacaoCorporal? infoCorporalAtual;

  PerfilController(this._usuarioRepo, this._enderecoRepo, this._infoRepo);

  Future<void> carregarPerfilCompleto(String uuidUsuario) async {
    try {
      usuarioAtual = await _usuarioRepo.buscarPorId(uuidUsuario);

      if (usuarioAtual == null) {
        throw Exception("Usuário não encontrado na base de dados.");
      }

      enderecoAtual = await _buscarEnderecoDoUsuario(uuidUsuario);
      infoCorporalAtual = await _buscarInfoCorporalDoUsuario(uuidUsuario);

    } catch (e) {
      rethrow;
    }
  }

  Future<void> atualizarDadosPessoais(String uuid, {required String novoNome}) async {
    try {
      if (usuarioAtual == null) throw Exception("Perfil não carregado.");

      final usuarioAtualizado = Usuario(
        uuid: uuid,
        nome: novoNome,
        username: usuarioAtual!.username,
        email: usuarioAtual!.email,
        data_nascimento: usuarioAtual!.data_nascimento,
        hash_senha: usuarioAtual!.hash_senha,
        data_criacao: usuarioAtual!.data_criacao,
        ativo: usuarioAtual!.ativo,
        sexo: usuarioAtual!.sexo,
      );

      await _usuarioRepo.atualizarPorId(uuid, usuarioAtualizado);
      usuarioAtual = usuarioAtualizado;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> salvarEndereco(Endereco endereco) async {
    try {
      if (endereco.id == 0) {
        final novoId = await _enderecoRepo.inserir(endereco);
        enderecoAtual = Endereco(
          id: novoId,
          usuarioId: endereco.usuarioId,
          cep: endereco.cep,
          rua: endereco.rua,
          cidade: endereco.cidade,
          estado: endereco.estado,
          complemento: endereco.complemento,
        );
      } else {
        await _enderecoRepo.atualizarPorId(endereco.id, endereco);
        enderecoAtual = endereco;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> salvarInformacaoCorporal(InformacaoCorporal info) async {
    try {
      if (info.id == 0) {
        final novoId = await _infoRepo.inserir(info);
        infoCorporalAtual = InformacaoCorporal(
          id: novoId,
          usuarioId: info.usuarioId,
          peso: info.peso,
          altura: info.altura,
        );
      } else {
        await _infoRepo.atualizarPorId(info.id, info);
        infoCorporalAtual = info;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Endereco?> _buscarEnderecoDoUsuario(String uuid) async {
    final resultados = await _enderecoRepo.buscarPorSqlPersonalizado(
      'SELECT * FROM Endereco WHERE usuario_uuid = ? LIMIT 1',
      [uuid],
    );
    return resultados.isNotEmpty ? resultados.first : null;
  }

  Future<InformacaoCorporal?> _buscarInfoCorporalDoUsuario(String uuid) async {
    final resultados = await _infoRepo.buscarPorSqlPersonalizado(
      'SELECT * FROM InformacaoCorporal WHERE usuario_uuid = ? LIMIT 1',
      [uuid],
    );

    return resultados.isNotEmpty ? resultados.first : null;
  }
}