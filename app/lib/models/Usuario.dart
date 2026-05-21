class Usuario {
  final String? uuid;
  final String nome;
  final String username;
  final String? hash_senha;
  final DateTime data_nascimento;
  final String? email;
  final String? path_foto_perfil;
  final String sexo;
  final DateTime data_criacao;
  final bool? ativo;

  Usuario({
     this.uuid,
     required this.nome,
     required this.username,
     this.hash_senha,
     required this.data_nascimento,
     this.email,
     this.path_foto_perfil,
     required this.sexo,
     required this.data_criacao,
     this.ativo
  });

  factory Usuario.fromMap(Map<String, dynamic> usuario_map) {
    return Usuario(
      uuid: usuario_map['uuid'],
      nome: usuario_map['nome'],
      username: usuario_map['usuario'],
      hash_senha: usuario_map['senha'],
      data_nascimento: usuario_map['data_nascimento'],
      email: usuario_map['email'] ?? null,
      path_foto_perfil: usuario_map['foto'],
      sexo: usuario_map['sexo'],
      data_criacao: usuario_map['data_criacao'],
      ativo: usuario_map['ativo'] ?? false
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'nome': nome,
      "username": username,
      "hash_senha": hash_senha,
      "data_nascimento": data_nascimento,
      "email": email,
      "path_foto_perfil": path_foto_perfil,
      "sexo": sexo,
      "data_criacao": data_criacao
    };
  }

  Map<String, dynamic> toPublicJson() {
    return {
      'uuid': uuid,
      'nome': nome,
      "username": username,
      "data_nascimento": data_nascimento,
      "email": email,
      "path_foto_perfil": path_foto_perfil,
      "sexo": sexo,
    };
  }

}