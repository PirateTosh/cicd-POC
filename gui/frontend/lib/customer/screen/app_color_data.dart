import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xffFAF9FF);
  static const Color secondaryColor = Color(0xff353535);
  static const Color textPrimaryColor = Color(0xffffffff);
  static const Color blueShade_1 = Color(0xFF9DADDF);
  static const Color blueShade_2 = Color(0xff062DAE);
  static const Color blueShade_3 = Color(0xff043EFF);
  static const Color blueShade_4 = Color(0xffB2C4FF);
  static const Color blueShade_5 = Color(0xff052CAD);
  static const Color blueShade_6 = Color(0xffE7EAF7);
  static const Color blueShade_7 = Color(0xff043FFF);

  static const Color greenShade_1 = Color(0xff30C19D);
  static const Color greenShade_2 = Color(0xff38ACB1);
  static const Color greenShade_3 = Color(0xff05AD83);
  static const Color greenShade_4 = Color(0xffB2FFEC);
  static const Color greenShade_5 = Color(0xff32BDA1);

  static const Color yellowShade_1 = Color(0xffF2E18D);
  static const Color yellowShade_2 = Color(0xffF0C907);
  static const Color yellowShade_3 = Color(0xffFFD607);

  static const Color redColor = Color(0xffF74317);
  static const Color dropdownArrowColor = Color(0xff50C6E8);
  static const Color greyColor = Color(0xffcccccc);
  static const Color greyShade_1 = Color(0xffD9D9D9);
  static const Color greyShade_2 = Color(0xffDBDBDB);

  static const Color dividerColor = Color.fromARGB(255, 245, 245, 245);

  static const LinearGradient blueGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.blueShade_2, Color(0xcc062DAE)],
  );
  static const LinearGradient blueRingGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.blueShade_2, AppColors.blueShade_4],
  );
  static LinearGradient cardsGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.blueShade_2, AppColors.blueShade_3.withOpacity(0.58)],
  );
  static const LinearGradient greenRingGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xff06AE84), Color.fromARGB(255, 82, 248, 206)],
  );
  static const LinearGradient yellowRingGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.yellowShade_2, Color.fromARGB(255, 247, 228, 137)],
  );
  static const LinearGradient yellowIconGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [AppColors.yellowShade_3, AppColors.yellowShade_1]);
}
