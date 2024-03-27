class UserDetails {
  final String name;
  final String userEmail;
  final String userPassword;

  UserDetails(
      {required this.name,
      required this.userEmail,
      required this.userPassword});
  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
        name: json['name'],
        userEmail: json['user_email'],
        userPassword: json['user_password']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'user_email': userEmail,
      'user_password': userPassword
    };
  }
}
