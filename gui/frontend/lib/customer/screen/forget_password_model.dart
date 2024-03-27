class ForgetPasswordModel {
  final String? newPassword;
  final String? confirmPassword;
  String email;

  String otp;
  ForgetPasswordModel(
      {required this.email,
      this.confirmPassword,
      this.newPassword,
      required this.otp});
  factory ForgetPasswordModel.fromJson(Map<String, dynamic> json) {
    return ForgetPasswordModel(
      email: json['email'],
      confirmPassword: json['confirm_password'],
      otp: json['otp'],
      newPassword: json['new_password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'new_password': newPassword,
      'otp': otp,
      'confirm_password': confirmPassword
    };
  }
}
