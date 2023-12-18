String genPrintRow(
    {String? col1,
    String? col2,
    String? col3,
    String? col4,
    String? col5,
    // int? colType,
    int? col4Wid}) {
  // Assuming an 80mm paper size, you may need to adjust these values
  int column1Width = 5; // Adjusted based on available space
  int column2Width = 5; // Adjusted based on available space
  int column3Width = 15; // Adjusted based on available space
  int column4Width = 10; // Adjusted based on available space
  // int column5Width = 15; // Adjusted based on available space

  String alignedColumn1 = col1?.padRight(column1Width).padLeft(5) ?? '';
  String alignedColumn2 = col2?.padRight(column2Width) ?? '';
  String alignedColumn3 = col3?.padRight(column3Width) ?? '';
  String alignedColumn4 = col4?.padRight(column4Width) ?? '';
  String alignedColumn5 = col5 ?? '';

  // Construct the final message string with appropriate spacing
  String message =
      "$alignedColumn1 $alignedColumn2 $alignedColumn3 $alignedColumn4 $alignedColumn5";

  return message;
}

String genPrintRow1(String col1, String col2, int colType, {int? col4Wid}) {
  int column1Width, column2Width;

  if (colType == 1) {
    column1Width = 30; // Adjusted based on available space
    column2Width = 10; // Adjusted based on available space
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

String genPrintRow2(String col1, String col2, int colType, {int? col4Wid}) {
  int column1Width, column2Width;

  if (colType == 1) {
    column1Width = 30; // Adjusted based on available space
    column2Width = 10; // Adjusted based on available space
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
