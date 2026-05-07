class Usuario {
  final String? id;
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
      nome: usuario_map['nome'],
      usuario: usuario_map['usuario'],
      data_nascimento: usuario_map['data_nascimento'],
      email: usuario_map['email'] ?? null,
      path_foto_perfil: usuario_map['foto'],
      sexo: usuario_map['sexo'],
      data_criacao: usuario_map['data_criacao'],
    );
  }




}