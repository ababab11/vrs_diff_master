import 'package:intl/intl.dart';

class GetDate {
  static String getCurrentDateTime() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyyMMdd').format(now);
    //String formattedTime = DateFormat('HHmmss').format(now);
    return formattedDate ; //+ formattedTime;
  }
}