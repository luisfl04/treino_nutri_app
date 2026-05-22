class Usuario {
  final int? id;
  final int? uuid;
  final String nome;
  final String usuario;
  final String? hash_senha;
  final DateTime data_nascimento;
  final String? email;
  final String? path_foto_perfil;
  final String sexo;
  final DateTime data_criacao;

  Usuario({
   this.id,
   this.uuid,
   required this.nome,
   required this.usuario,
   this.hash_senha,
   required this.data_nascimento,
   this.email,
   this.path_foto_perfil,
   required this.sexo,
   required this.data_criacao
  });

  factory Usuario.fromMap(Map<String, dynamic> usuario_map) {
    return Usuario(
      id: usuario_map['id'],
      uuid: usuario_map['uuid'],
      nome: usuario_map['nome'],
      usuario: usuario_map['usuario'],
      hash_senha: usuario_map['senha'],
      data_nascimento: usuario_map['data_nascimento'],
      email: usuario_map['email'] ?? null,
      path_foto_perfil: usuario_map['foto'],
      sexo: usuario_map['sexo'],
      data_criacao: usuario_map['data_criacao'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uuid': uuid,
      'nome': nome,
      "usuario": usuario,
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
      'id': id,
      'uuid': uuid,
      'nome': nome,
      "usuario": usuario,
      "data_nascimento": data_nascimento,
      "email": email,
      "path_foto_perfil": path_foto_perfil,
      "sexo": sexo,
    };
  }

}