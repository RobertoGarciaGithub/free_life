class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String document;
  final String? token;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.document,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'].toString(),
    firstName: json['first_name'],
    lastName: json['last_name'],
    email: json['email'],
    document: json['document'],
    token: json['token'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'document': document,
  };

  String get fullName => '$firstName $lastName';
}
