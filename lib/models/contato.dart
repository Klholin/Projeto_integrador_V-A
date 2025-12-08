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

  // Use Object? para não forçar String em todos os valores
  Map<String, Object?> toMap() {
    final map = <String, Object?>{
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'uf': uf,
      'municipio': municipio,
    };

    // Evita problema de promoção nula em campo público
    final int? contatoId = id;
    if (contatoId != null) {
      map['id'] = contatoId; // id como int
    }

    return map;
  }

factory Contato.fromMap(Map<String, Object?> map) {
  return Contato(
    id: map['id'] is int ? map['id'] as int : int.tryParse(map['id'].toString()),
    nome: map['nome']?.toString() ?? '',
    telefone: map['telefone']?.toString() ?? '',
    email: map['email']?.toString() ?? '',
    uf: map['uf']?.toString() ?? '',
    municipio: map['municipio']?.toString() ?? '',
  );
}

}
