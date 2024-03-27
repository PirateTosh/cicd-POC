import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omegatron/customer/screen/app_color_data.dart' as colordata;

class TableData extends StatelessWidget {
  final List<dynamic> tableContent;
  const TableData({required this.tableContent, super.key});
  @override
  Widget build(BuildContext context) {
    double tableHeight = MediaQuery.of(context).size.height * 0.3;
    double dataRowHeight = tableHeight / (tableContent.length + 1);
    double screenWidth = MediaQuery.of(context).size.width;
    final TextStyle dataColumn = GoogleFonts.poppins(
        textStyle: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 20 * screenWidth / 1440,
      color: colordata.AppColors.textPrimaryColor,
    ));
    final TextStyle dataRow = GoogleFonts.montserrat(
        textStyle: TextStyle(
      fontSize: 16 * screenWidth / 1440,
      color: Colors.black,
      fontWeight: FontWeight.w500,
    ));
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 20,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: DataTable(
          columnSpacing: 0.0,
          border: const TableBorder(
              horizontalInside:
                  BorderSide(width: 1, color: colordata.AppColors.blueShade_6)),
          headingRowHeight: dataRowHeight,
          headingRowColor: MaterialStateProperty.resolveWith(
              (states) => colordata.AppColors.blueShade_2.withOpacity(0.80)),
          dataRowMinHeight: dataRowHeight * 0.2,
          dataRowMaxHeight: dataRowHeight,
          columns: <DataColumn>[
            DataColumn(
              label: Expanded(
                child: Text('Count',
                    textAlign: TextAlign.center, style: dataColumn),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Center(
                  child: Text('Script Name', style: dataColumn),
                ),
              ),
              numeric: true,
            ),
            DataColumn(
              label: Expanded(
                child: Center(
                  child: Text('Spot', style: dataColumn),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Center(
                  child: Text('Lot Size', style: dataColumn),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Center(
                  child: Text('Status', style: dataColumn),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Center(
                  child: Text('Qty', style: dataColumn),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Center(
                  child: Text('Date', style: dataColumn),
                ),
              ),
            ),
          ],
          rows: List.generate(tableContent.length, (index) {
            final item = tableContent[index];
            return DataRow(
              color: index % 2 == 0
                  ? MaterialStateProperty.resolveWith(
                      ((states) => colordata.AppColors.blueShade_6))
                  : MaterialStateProperty.resolveWith(
                      ((states) => colordata.AppColors.textPrimaryColor)),
              cells: [
                DataCell(Center(
                  child: Text(item['Count'], style: dataRow),
                )),
                DataCell(Center(
                  child: Text(item['Script Name'], style: dataRow),
                )),
                DataCell(Center(
                  child: Text(item['Spot'], style: dataRow),
                )),
                DataCell(Center(
                  child: Text(item['Lot Size'], style: dataRow),
                )),
                DataCell(Center(
                  child: Text(item['Status'], style: dataRow),
                )),
                DataCell(Center(
                  child: Text(item['Qty'], style: dataRow),
                )),
                DataCell(Center(
                  child: Text(item['Date'], style: dataRow),
                )),
              ],
            );
          }),
        ),
      ),
    );
  }
}
