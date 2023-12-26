// String genPrintRow(
//     String col1,
//     String col2,
//     String col3,
//     String col4,
//     String col5,
//     // int? colType,
//     int? col4Wid) {
//   String alignedColumn1 = col1.padLeft(5);
//   String alignedColumn2 = col2.padLeft(5);
//   String alignedColumn3 = col3.padLeft(10);
//   String alignedColumn4 = col4.padLeft(10);
//   String alignedColumn5 = col5.padLeft(10);

//   // Construct the final message string with appropriate spacing
//   String message =
//       "$alignedColumn1 $alignedColumn2 $alignedColumn3 $alignedColumn4 $alignedColumn5";

//   return message;
// }
String genPrintRow(String col1, String col2, String col3, String col4,
    String col5, int colType,
    {int? col4Wid}) {
  int column1Width, column2Width, column3Width, column4Width, column5Width;
  if (colType == 1) {
    column1Width = 2;
    column2Width = 8;
    column3Width = 11;
    column4Width = 11;
    column5Width = 11;
  } else {
    column1Width = 0;
    column2Width = 0;
    column3Width = 0;
    column4Width = 0;
    column5Width = col4Wid!;
  }

  String alignedColumn1 = col1.padLeft(column1Width);
  String alignedColumn2 = col2.padLeft(column2Width);
  String alignedColumn3 = col3.padLeft(column3Width);
  String alignedColumn4 = col4.padLeft(column4Width);
  String alignedColumn5 = col5.padLeft(column5Width);

  // Construct the final message string with appropriate spacing
  String message =
      "$alignedColumn1 $alignedColumn2 $alignedColumn3 $alignedColumn4 $alignedColumn5";

  return message;
}

String genPrintRow3(String col1, String col2, int colType, {int? col4Wid}) {
  int column1Width, column2Width;

  if (colType == 1) {
    column1Width = 10; // Adjusted based on available space
    column2Width = 30; // Adjusted based on available space
  } else {
    column1Width = 0;
    column2Width = 0;
  }

  String alignedColumn1 = col1.padLeft(column1Width);
  String alignedColumn2 = col2.padLeft(column2Width);

  // Construct the final message string with appropriate spacing
  String message = "$alignedColumn1 $alignedColumn2";

  return message;
}

String genPrintRow1(String col1) {
  String alignedColumn1 = col1.padRight(46);

  // Construct the final message string with appropriate spacing
  String message = "$alignedColumn1";

  return message;
}

String genPrintRow2(String col1, String col2, int colType, {int? col4Wid}) {
  int column1Width, column2Width;

  if (colType == 1) {
    column1Width = 23; // Adjusted based on available space
    column2Width = 23; // Adjusted based on available space
  } else if (colType == 2) {
    column1Width = 0;
    column2Width = 0;
  } else {
    column1Width = 0;
    column2Width = 0;
  }

  String alignedColumn1 = col1.padRight(column1Width);
  String alignedColumn2 = col2.padLeft(column2Width);

  // Construct the final message string with appropriate spacing
  String message = "$alignedColumn1 $alignedColumn2";

  return message;
}

String billdetils({required String col1, required String col2}) {
  String billNo1 = col1.padRight(30).padLeft(0);
  String date1 = col2;
  String message = "$billNo1 $date1 ";
  return message;
}

String title(String title) {
  String title1 = title;

  String message = "$title1";
  return message;
}
