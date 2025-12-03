class Contato {
  final int? id;
  final String nome;
  final String telefone;
  final String email;
  final String uf;
  final String municipio;

  Contato({
    this.id,
    required this.nome,
    required this.telefone,
    required this.email,
    required this.uf,
    required this.municipio,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'uf': uf,
      'municipio': municipio,
    };
  }

  factory Contato.fromMap(Map<String, dynamic> map) {
    return Contato(
      id: map['id'],
      nome: map['nome'],
      telefone: map['telefone'],
      email: map['email'],
      uf: map['uf'],
      municipio: map['municipio'],
    );
  }
}
