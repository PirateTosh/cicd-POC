class ProfileModel {
  String userName;
  String userEmail;
  int userMobileNumber;
  int userTelegramID;
  String userDOB;
  ProfileModel({
    required this.userTelegramID,
    required this.userEmail,
    required this.userMobileNumber,
    required this.userName,
    required this.userDOB,
  });
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
        userName: json['user_name'],
        userEmail: json['user_email'],
        userMobileNumber: json['user_mobile_number'],
        userTelegramID: json['user_telegram_id'],
        userDOB: json['user_DOB']);
  }

  Map<String, dynamic> toJson() {
    return {
      'user_name': userName,
      'user_email': userEmail,
      'user_mobile_number': userMobileNumber,
      'user_telegram_id': userTelegramID,
      'user_DOB': userDOB
    };
  }
}
