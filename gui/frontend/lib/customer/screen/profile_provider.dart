import 'package:flutter/material.dart';
import 'package:omegatron/customer/screen/profile_model.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileModel profileModelDetails = ProfileModel(
    userTelegramID: 144418392,
    userEmail: 'sanjanasingh@gmail.com',
    userMobileNumber: 9876543210,
    userName: 'Sanjana Singh',
    userDOB: '9 June 1999',
  );
  getprofiledModelDetails() async {
    notifyListeners();
  }
}
