class SigninModel {
  String email;
  final String password;
  SigninModel({required this.email, required this.password});
  factory SigninModel.fromJson(Map<String, dynamic> json) {
    return SigninModel(
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
