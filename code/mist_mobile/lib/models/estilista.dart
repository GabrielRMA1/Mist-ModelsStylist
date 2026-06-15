class Estilista {
  final int id;
  final String nome;
  final String? telefone;
  final String especialidade;
  final String? descricao;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Estilista({
    required this.id,
    required this.nome,
    this.telefone,
    required this.especialidade,
    this.descricao,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Estilista.fromJson(Map<String, dynamic> json) {
    return Estilista(
      id: json['id'],
      nome: json['nome'],
      telefone: json['telefone'],
      especialidade: json['especialidade'],
      descricao: json['descricao'],
      userId: json['userId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'especialidade': especialidade,
      'descricao': descricao,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
