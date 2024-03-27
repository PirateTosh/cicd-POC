import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:omegatron/customer/screen/app_color_data.dart' as colordata;

class DatePickerContainer extends StatefulWidget {
  const DatePickerContainer({super.key});

  @override
  State<DatePickerContainer> createState() => DatePickerContainerState();
}

class DatePickerContainerState extends State<DatePickerContainer> {
  DateTime date = DateTime.now();
  void _decrementMonth() {
    setState(() {
      date = DateTime(date.year, date.month - 1, date.day);
    });
  }

  void _incrementMonth() {
    setState(() {
      date = DateTime(date.year, date.month + 1, date.day);
    });
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Stack(
        alignment: Alignment.topRight,
        children: [
          Positioned(
            top: 220, // Adjust this value based on your needs
            right: 68, // Adjust this value based on your needs
            child: child,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String monthInText = DateFormat('MMM').format(date);

//     // Get year
    int year = date.year;
    return Row(
      children: [
        Container(
            height: MediaQuery.of(context).size.width * 0.025,
            width: MediaQuery.of(context).size.width * 0.1,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.5,
                color: colordata.AppColors.blueShade_1, // Border color
              ),
            ),
            child: CupertinoPageScaffold(
              child: CupertinoButton(
                padding: const EdgeInsets.all(0),
                onPressed: () => _showDialog(
                  Container(
                    width: 350,
                    height: 150,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CupertinoDatePicker(
                          backgroundColor: colordata.AppColors.textPrimaryColor,
                          initialDateTime: date,
                          mode: CupertinoDatePickerMode.date,
                          use24hFormat: true,
                          showDayOfWeek: true,
                          onDateTimeChanged: (DateTime newDate) {
                            setState(() => date = newDate);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(
                        flex: 3,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Icon(
                            Icons.calendar_month,
                            color: colordata.AppColors.secondaryColor,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            '$monthInText-$year',
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                color: colordata.AppColors.secondaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
        const SizedBox(width: 20),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _decrementMonth,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: colordata.AppColors.blueRingGradient,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(8, 5, 2, 5),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: colordata.AppColors.textPrimaryColor,
                  size: MediaQuery.of(context).size.width * 0.015,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _incrementMonth,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: colordata.AppColors.blueRingGradient,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: colordata.AppColors.textPrimaryColor,
                  size: MediaQuery.of(context).size.width * 0.015,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
