// ignore_for_file: unused_local_variable, prefer_const_constructors, non_constant_identifier_names
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'colors.dart';

/////////////////////////////////////////////////////
///Margin and Padding => MP
MP_LTRB(double Left, double Top, double Right, double Bottom) {
  return EdgeInsets.only(left: Left, top: Top, right: Right, bottom: Bottom);
}

MP_all(double number) {
  return EdgeInsets.all(number);
}

////////////////////////////////////////////////
///
// ToastListener
SToast(String message, var bgcolor, var Textcolor) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: bgcolor,
      textColor: Textcolor,
      fontSize: 16.0);
}

////////////////////////////////////////////////
///Fonts
///
var bold = FontWeight.bold;
var normal = FontWeight.normal;
var w100 = FontWeight.w100;
var w200 = FontWeight.w200;
var w300 = FontWeight.w300;
var w400 = FontWeight.w400;
var w500 = FontWeight.w500;
var w600 = FontWeight.w600;
var w700 = FontWeight.w700;
var w800 = FontWeight.w800;
var w900 = FontWeight.w900;

style(var fontFamily, var fontColor, double fontSize, var fontWeight) {
  return TextStyle(
      fontFamily: fontFamily,
      color: fontColor,
      fontSize: fontSize,
      fontWeight: fontWeight);
}

///Text direction
var rtl = TextDirection.rtl;
var ltr = TextDirection.ltr;
////////////////////////////////////////////////
///MainAxis Alignments
var start = MainAxisAlignment.start;
var spaceBetween = MainAxisAlignment.spaceBetween;
var spaceEvenly = MainAxisAlignment.spaceEvenly;
var center = MainAxisAlignment.center;
var spaceAround = MainAxisAlignment.spaceAround;
var end = MainAxisAlignment.end;
//////////////////////////////////////////////
///Axis
var vertical = Axis.vertical;
var horizontal = Axis.horizontal;
/////////////////////////////////////////////
///CORNER RADIUS
radius(double rad, var bgcolor, var color) {
  return BoxDecoration(
    color: bgcolor,
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(rad)),
  );
}

radiusellipse(double rad, var color) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.all(Radius.elliptical(rad, rad)),
  );
}

radiusLTRB(double TopLeft, double BottomLeft, double TopRight,
    double BottomRight, var color) {
  return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TopLeft),
          bottomLeft: Radius.circular(BottomLeft),
          topRight: Radius.circular(TopRight),
          bottomRight: Radius.circular(BottomRight)));
}

radiusTops(double topLeft, double topRight) {
  return BorderRadius.only(
      topLeft: Radius.circular(topLeft), topRight: Radius.circular(topRight));
}

radiusBottoms(double bottomLeft, double bottomRight) {
  return BorderRadius.only(
      bottomLeft: Radius.circular(bottomLeft),
      bottomRight: Radius.circular(bottomRight));
}

fitX(var context) {
  return MediaQuery.of(context).size.width;
}

fitY(var context) {
  return MediaQuery.of(context).size.height;
}

toPage(var context, var screen) {
  return Navigator.pushReplacement(
      context, MaterialPageRoute(builder: ((context) => screen)));
}

icon(var icon, var color, double size) {
  return Icon(
    icon,
    color: color,
    size: size,
  );
}

cancel(var context) {
  return Navigator.of(context).pop();
}

/////////////////////////////////////////////////////////////////////////////////////////////////
///
void modal(BuildContext context, List<Widget> title, List<Widget> content,
    List<Widget> actions) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        elevation: 0,
        title: Column(children: title),
        content: Column(children: content),
        actions: actions,
      );
    },
  );
}

Future<bool> checkNetConn() async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult == ConnectivityResult.none) {
    // No network connection
    return false;
  } else {
    // Network connection available
    return true;
  }
}

Future<TimeOfDay?> showCustomTimePicker(BuildContext context) async {
  TimeOfDay? selectedTime;
  String? selectedPeriod;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            elevation: 0,
            titlePadding: EdgeInsets.all(0),
            contentPadding: EdgeInsets.symmetric(horizontal: 2),
            title: Container(
              alignment: Alignment.center,
              // color: Colors.blueGrey[100],
              height: 50,
              padding: EdgeInsets.all(5),
              child: Text(
                'SELECT TIME',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            content: Container(
              width: 200,
              height: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: Colors.blueGrey[50],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedPeriod = 'AM';
                                });
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: selectedPeriod == 'AM'
                                    ? Colors.blueAccent
                                    : null,
                              ),
                              child: Text(
                                'AM',
                                style: GoogleFonts.nunito(
                                  color: selectedPeriod == 'AM'
                                      ? Colors.white
                                      : Colors.blueGrey[800],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedPeriod = 'PM';
                                });
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: selectedPeriod == 'PM'
                                    ? Colors.blueAccent
                                    : null,
                              ),
                              child: Text(
                                'PM',
                                style: GoogleFonts.nunito(
                                  color: selectedPeriod == 'PM'
                                      ? Colors.white
                                      : Colors.blueGrey[800],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 200,
                    child: Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: 48,
                        itemBuilder: (BuildContext context, int index) {
                          final hour =
                              index ~/ 2 % 12 == 0 ? 12 : index ~/ 2 % 12;
                          final minute = (index % 2) * 30;
                          final isAM = selectedPeriod == 'AM';
                          final formattedTime =
                              '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} ${isAM ? 'AM' : 'PM'}';
                          return Column(
                            children: [
                              ListTile(
                                // tileColor: Colors.blueGrey[300],
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                title: Text(
                                  formattedTime,
                                  style: GoogleFonts.nunito(
                                    color: selectedTime != null &&
                                            selectedTime!.hour == hour &&
                                            selectedTime!.minute == minute
                                        ? Colors.blueAccent
                                        : Colors.blueGrey[700],
                                    fontWeight: selectedTime != null &&
                                            selectedTime!.hour == hour &&
                                            selectedTime!.minute == minute
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedTime =
                                        TimeOfDay(hour: hour, minute: minute);
                                  });
                                },
                              ),
                              Divider(indent: 0, endIndent: 0, height: 0.5),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.all(Radius.circular(0))),
                  elevation: 0,
                  // backgroundColor: Colors.blueAccent,
                  fixedSize: Size(
                    MediaQuery.of(context).size.width,
                    30,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
                  // style: GoogleFonts.nunito(
                  //   color: Colors.white,
                  // ),
                ),
              )
            ],
            actionsAlignment: MainAxisAlignment.center,
          );
        },
      );
    },
  );

  return selectedTime;
}

API_ENDPOINT(String path) {
  return "http://192.168.133.163/DCMS/app/mobile/" + path;
}
