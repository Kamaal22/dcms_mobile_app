// ignore_for_file: unused_local_variable, prefer_const_constructors, non_constant_identifier_names
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
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
void modal(
    BuildContext context, List<Widget> title, List<Widget> content, List<Widget> actions) {
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