class SignupModel {
  final String name;
  final DateTime dob;
  final String password;
  final String email;

  final String confirmPassword;
  SignupModel(
      {required this.email,
      required this.confirmPassword,
      required this.dob,
      required this.name,
      required this.password});
  factory SignupModel.fromJson(Map<String, dynamic> json) {
    return SignupModel(
      name: json['name'],
      confirmPassword: json['confirm_password'],
      dob: json['dob'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'confirm_password': confirmPassword,
      'dob': dob,
      'email': email,
      'password': password,
    };
  }
}
