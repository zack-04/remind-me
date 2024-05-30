  class User {
  final String firstName;
  final String lastName;
    String email;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
    );
  }
}