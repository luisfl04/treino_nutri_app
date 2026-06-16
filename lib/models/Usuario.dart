class Usuario {
  final int? id;
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
    this.id,
    required this.nome,
    required this.username,
    this.hash_senha,
    required this.data_nascimento,
    this.email,
    this.path_foto_perfil,
    required this.sexo,
    required this.data_criacao,
    this.ativo,
  });

  factory Usuario.fromMap(Map<String, dynamic> usuario_map) {
    // Função auxiliar para converter com segurança a Data em Texto (SQLite) para DateTime (Dart)
    DateTime parseDataSegura(dynamic valorData) {
      if (valorData == null) return DateTime.now();
      if (valorData is String) {
        return DateTime.tryParse(valorData) ?? DateTime.now();
      }
      return DateTime.now();
    }

    return Usuario(
      id: usuario_map['id'],
      // Proteção contra nulos com fallbacks (?? '')
      nome: usuario_map['nome'] ?? '',
      username: usuario_map['username'] ?? usuario_map['usuario'] ?? '',
      hash_senha: usuario_map['hash_senha'] ?? usuario_map['senha'] ?? '',
      email: usuario_map['email'] ?? '',
      path_foto_perfil: usuario_map['path_foto_perfil'] ?? usuario_map['foto'] ?? '',
      sexo: usuario_map['sexo'] ?? 'Não informado',
      
      // Passando as datas pela conversão segura
      data_nascimento: parseDataSegura(usuario_map['data_nascimento']),
      data_criacao: parseDataSegura(usuario_map['data_criacao']),
      
      // Tratamento do booleano (SQLite salva true/false como 1/0)
      ativo: usuario_map['ativo'] == 1 || usuario_map['ativo'] == true,
    );
  }

  // O toMap é o Porteiro do Banco de Dados.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'username': username,
      'hash_senha': hash_senha ?? '', // Evita enviar nulo para o banco
      'email': email ?? '',
      'path_foto_perfil': path_foto_perfil ?? '',
      'sexo': sexo,
      // Convertemos DateTime para String (ISO 8601) pois o SQLite não aceita Data nativa
      'data_nascimento': data_nascimento.toIso8601String(),
      'data_criacao': data_criacao.toIso8601String(),
      // SQLite não tem "bool", então enviamos 1 para true e 0 para false
      'ativo': (ativo == true) ? 1 : 0, 
    };
  }

  Map<String, dynamic> toPublicJson() {
    return {
      'id': id,
      'nome': nome,
      'username': username,
      // Datas devem ir como String no JSON também
      'data_nascimento': data_nascimento.toIso8601String(),
      'email': email,
      'path_foto_perfil': path_foto_perfil,
      'sexo': sexo,
    };
  }
}