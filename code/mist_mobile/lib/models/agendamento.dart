class Agendamento {
  final int id;
  final int clienteId;
  final int estilistaId;
  final DateTime data;
  final String tipoServico;
  final String? descricao;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Dados relacionados para exibição
  final String? nomeCliente;
  final String? nomeEstilista;

  Agendamento({
    required this.id,
    required this.clienteId,
    required this.estilistaId,
    required this.data,
    required this.tipoServico,
    this.descricao,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.nomeCliente,
    this.nomeEstilista,
  });

  factory Agendamento.fromJson(Map<String, dynamic> json) {
    return Agendamento(
      id: json['id'],
      clienteId: json['clienteId'],
      estilistaId: json['estilistaId'],
      data: DateTime.parse(json['data']),
      tipoServico: json['tipoServico'],
      descricao: json['descricao'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      nomeCliente: json['cliente']?['nome'],
      nomeEstilista: json['estilista']?['nome'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clienteId': clienteId,
      'estilistaId': estilistaId,
      'data': data.toIso8601String(),
      'tipoServico': tipoServico,
      'descricao': descricao,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
