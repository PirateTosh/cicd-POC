import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:omegatron/customer/screen/app_color_data.dart' as colordata;
import 'package:omegatron/customer/screen/profile_provider.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  State<Profile> createState() => ProfilePage();
}

class ProfilePage extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colordata.AppColors.primaryColor,
      body: Consumer<ProfileProvider>(builder: (context, value, child) {
        final profileDetails = value.profileModelDetails;
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.edit,
                        color: colordata.AppColors.secondaryColor,
                      ),
                      label: Text(
                        'Edit Profile',
                        style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: colordata.AppColors.secondaryColor)),
                      ),
                      style: ElevatedButton.styleFrom(
                        surfaceTintColor: Colors.transparent,
                        elevation: 3,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        maximumSize: const Size(150, 45),
                        minimumSize: const Size(50, 45),
                        backgroundColor: Colors.white,
                      ),
                    )),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/profileimage.png',
                        width: 149,
                        height: 149,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              profileDetails.userName,
                              style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          colordata.AppColors.secondaryColor)),
                            ),
                          ),
                          Text(
                            profileDetails.userEmail,
                            style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: colordata.AppColors.secondaryColor)),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                const Divider(
                  height: 2,
                  thickness: 2,
                  color: colordata.AppColors.blueShade_2,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'My Profile Details',
                        style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xffB4B4B4))),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        maximumSize: const Size(150, 45),
                        minimumSize: const Size(50, 45),
                        backgroundColor:
                            const Color.fromARGB(207, 179, 194, 245),
                      ),
                      child: Text(
                        'Edit Details',
                        style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: colordata.AppColors.blueShade_2)),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _profileDetails(
                          'Mobile Number:',
                          profileDetails.userMobileNumber.toString(),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        _profileDetails(
                          'DOB:',
                          profileDetails.userDOB.toString(),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        _profileDetails(
                          'Telegram ID:',
                          profileDetails.userTelegramID.toString(),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _profileDetails(
    String data1,
    String data2,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: 5,
            child: Text(
              data1,
              style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: colordata.AppColors.secondaryColor)),
            )),
        Expanded(
            flex: 5,
            child: Text(
              data2,
              style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: colordata.AppColors.blueShade_2)),
            ))
      ],
    );
  }
}
