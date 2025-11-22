class User {
  final int id;
  final String name;
  final String email;
  final String passwordHash;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      passwordHash: json['passwordHash'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'passwordHash': passwordHash,
    };
  }
}

