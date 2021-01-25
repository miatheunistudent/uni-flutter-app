/* ************************************************************************
 * FILE : dateFormatting.dart
 * DESC : Handles formatting of date.
 * ************************************************************************
 */

import 'package:intl/intl.dart';

// Gets local version od date string
String localize(String dateStr) {
  if (dateStr == null)
    return '';
  return DateTime.parse(dateStr).toLocal().toString();
}

// Cleans up date for display
String niceDate(String str) {
  str = str.substring(0, str.indexOf(' '));
  var year = str.substring(0, 4);
  var month = str.substring(5, 7);
  var day = str.substring(8, 10);
  return month + "/" + day + "/" + year;
}

// Gets different between two date objects
int diffInDays (DateTime date1, DateTime date2) {
  return ((date1.difference(date2) - Duration(hours: date1.hour) 
    + Duration(hours: date2.hour)).inHours / 24).round();
}

// Adds suffix to date in month
String fancyDateNum (messageDate) {
  String num = DateFormat('d').format(messageDate).toString();
  if (num == '1' || num == '21' || num == '31') {
    return "st";
  }
  if (num == '2' || num == '22') {
    return "nd";
  }
  if (num == '3' || num == '23') {
    return "rd";
  }
  else {
    return "th";
  }
}

// Gives style to date object
String addFancyStuffToDate (messageDate) {
  String strDate = DateFormat.yMMMMd('en_US').format(messageDate).toString() ;
  int spaceIndex = strDate.indexOf(" ", strDate.indexOf(" ") + 1) - 1;
  return strDate.substring(0, spaceIndex) + fancyDateNum(messageDate) + strDate.substring(spaceIndex, strDate.length); 
}

// Creates a relative date
String dateToDisplay(messageDate) {
  int diff = diffInDays(DateTime.now(), DateTime.parse(messageDate));
  if(diff == 0) {
    return "Today";
  }
  if(diff == 1){
    return "Yesterday";
  }
  if(diff < 7){
    return DateFormat('EEEE').format(DateTime.parse(messageDate)).toString();
  }
  if(DateTime.parse(messageDate).toString().substring(0,4) != DateTime.now().toString().substring(0,4)){
    return addFancyStuffToDate(DateTime.parse(messageDate));
  }
  else{
    return DateFormat('MMMMd').format(DateTime.parse(messageDate)).toString() + fancyDateNum(DateTime.parse(messageDate));
  }
}
// Checks if two string representatations of dates are equivalent
bool sameDate(String dateStrOne, String dateStrTwo) {
  DateTime dateOne = DateTime.parse(dateStrOne);
  DateTime dateTwo = DateTime.parse(dateStrTwo);

  return (
    dateOne.day == dateTwo.day &&
    dateOne.month == dateTwo.month &&
    dateOne.year == dateTwo.year
  );
}

// Determines if two times within provided number of minutes of each other
bool withinMinutes(int minutes, String dateStrOne, String dateStrTwo) {
  DateTime dateOne = DateTime.parse(dateStrOne);
  DateTime dateTwo = DateTime.parse(dateStrTwo);

  return dateOne.difference(dateTwo).inMinutes.abs() < 15;
}