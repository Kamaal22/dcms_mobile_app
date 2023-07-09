// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Primary Color
const Color primaryColor = Color.fromARGB(255, 33, 33, 34);

// Secondary Color
const Color secondaryColor = Color(0xFFDF734E);

// Light Theme
ThemeData lightTheme = ThemeData(
  appBarTheme: AppBarTheme(backgroundColor: Colors.blueGrey[100]),
  scaffoldBackgroundColor: Colors.blueGrey[800],
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          textStyle:
              MaterialStateProperty.all<TextStyle?>(GoogleFonts.nunito()))),
);

ThemeData darkTheme = ThemeData(
  appBarTheme: AppBarTheme(backgroundColor: Colors.blueGrey[100]),
  scaffoldBackgroundColor: Colors.blueGrey[800],
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    elevation: MaterialStateProperty.all(0),
    textStyle: MaterialStateProperty.all<TextStyle?>(GoogleFonts.nunito()),
    backgroundColor: MaterialStateProperty.all<Color?>(Colors.transparent),
    foregroundColor: MaterialStateProperty.all<Color?>(Colors.blueGrey),
    padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
        EdgeInsets.symmetric(horizontal: 5)),
    side: MaterialStateProperty.all<BorderSide?>(
      BorderSide(width: 1, color: Colors.blueGrey),
    ),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    alignment: Alignment.center,
  )),
);

//////////////////////////////////
///
var transparent = Colors.transparent;

// var primary = Color(0xFF4E73DF);
var primary = Color(0xFF007BFF);
var secondary = Color(0xFF858796);
var success = Color(0xFF1CC88A);
var info = Color(0xFF36B9CC);
var warning = Color(0xFFF6C23E);
var danger = Color(0xFFE74A3B);
var light = Color(0xFFF8F9FC);
var dark = Color(0xFF5A5C69);
var grayDark = Color(0xFF5A5C69);

//////////////////////////////////
///
///RED COLORS
var red = Colors.red;
var red50 = Colors.red[50];
var red100 = Colors.red[100];
var red200 = Colors.red[200];
var red300 = Colors.red[300];
var red400 = Colors.red[400];
var red500 = Colors.red[500];
var red600 = Colors.red[600];
var red700 = Colors.red[700];
var red800 = Colors.red[800];
var red900 = Colors.red[900];
//////////////////////////////////
///
///WHITE COLORS
var white = Colors.white;
var white12 = Colors.white12;
var white24 = Colors.white24;
var white30 = Colors.white30;
var white38 = Colors.white38;
var white54 = Colors.white54;
var white60 = Colors.white60;
var white70 = Colors.white70;
//////////////////////////////////
///
///BLACK COLORS
var black = Colors.black;
var black12 = Colors.black12;
var black26 = Colors.black26;
var black38 = Colors.black38;
var black45 = Colors.black45;
var black54 = Colors.black54;
var black87 = Colors.black87;
//////////////////////////////////
///
///ORANGE COLORS
var orange = Colors.orange;
var orange50 = Colors.orange[50];
var orange100 = Colors.orange[100];
var orange200 = Colors.orange[200];
var orange300 = Colors.orange[300];
var orange400 = Colors.orange[400];
var orange500 = Colors.orange[500];
var orange600 = Colors.orange[600];
var orange700 = Colors.orange[700];
var orange800 = Colors.orange[800];
var orange900 = Colors.orange[900];
//////////////////////////////////
///
///DEEPORANGE COLORS
var deepOrange = Colors.deepOrange;
var deepOrange50 = Colors.deepOrange[50];
var deepOrange100 = Colors.deepOrange[100];
var deepdeepOrange200 = Colors.deepOrange[200];
var deepOrange300 = Colors.deepOrange[300];
var deepOrange400 = Colors.deepOrange[400];
var deepOrange500 = Colors.deepOrange[500];
var deepOrange600 = Colors.deepOrange[600];
var deepOrange700 = Colors.deepOrange[700];
var deepOrange800 = Colors.deepOrange[800];
var deepOrange900 = Colors.deepOrange[900];
//////////////////////////////////
///
///GREEN COLORS
var green = Colors.green;
var green50 = Colors.green[50];
var green100 = Colors.green[100];
var green200 = Colors.green[200];
var green300 = Colors.green[300];
var green400 = Colors.green[400];
var green500 = Colors.green[500];
var green600 = Colors.green[600];
var green700 = Colors.green[700];
var green800 = Colors.green[800];
var green900 = Colors.green[900];
//////////////////////////////////
///
///BLUE COLORS
var blue = Colors.blue;
var blue50 = Colors.blue[50];
var blue100 = Colors.blue[100];
var blue200 = Colors.blue[200];
var blue300 = Colors.blue[300];
var blue400 = Colors.blue[400];
var blue500 = Colors.blue[500];
var blue600 = Colors.blue[600];
var blue700 = Colors.blue[700];
var blue800 = Colors.blue[800];
var blue900 = Colors.blue[900];
//////////////////////////////////
///
///LIGHTBLUE COLORS
var lightBlue = Colors.lightBlue;
var lightBlue50 = Colors.lightBlue[50];
var lightBlue100 = Colors.lightBlue[100];
var lightBlue200 = Colors.lightBlue[200];
var lightBlue300 = Colors.lightBlue[300];
var lightBlue400 = Colors.lightBlue[400];
var lightBlue500 = Colors.lightBlue[500];
var lightBlue600 = Colors.lightBlue[600];
var lightBlue700 = Colors.lightBlue[700];
var lightBlue800 = Colors.lightBlue[800];
var lightBlue900 = Colors.lightBlue[900];
//////////////////////////////////
///
///PURPLE COLORS
var purple = Colors.purple;
var purple50 = Colors.purple[50];
var purple100 = Colors.purple[100];
var purple200 = Colors.purple[200];
var purple300 = Colors.purple[300];
var purple400 = Colors.purple[400];
var purple500 = Colors.purple[500];
var purple600 = Colors.purple[600];
var purple700 = Colors.purple[700];
var purple800 = Colors.purple[800];
var purple900 = Colors.purple[900];
//////////////////////////////////
///
///DEEPPURPLE COLORS
var deepPurple = Colors.deepPurple;
var deepPurple50 = Colors.deepPurple[50];
var deepPurple100 = Colors.deepPurple[100];
var deepPurple200 = Colors.deepPurple[200];
var deepPurple300 = Colors.deepPurple[300];
var deepPurple400 = Colors.deepPurple[400];
var deepPurple500 = Colors.deepPurple[500];
var deepPurple600 = Colors.deepPurple[600];
var deepPurple700 = Colors.deepPurple[700];
var deepPurple800 = Colors.deepPurple[800];
var deepPurple900 = Colors.deepPurple[900];
//////////////////////////////////
///
///CYAN COLORS
var cyan = Colors.cyan;
var cyan50 = Colors.cyan[50];
var cyan100 = Colors.cyan[100];
var cyan200 = Colors.cyan[200];
var cyan300 = Colors.cyan[300];
var cyan400 = Colors.cyan[400];
var cyan500 = Colors.cyan[500];
var cyan600 = Colors.cyan[600];
var cyan700 = Colors.cyan[700];
var cyan800 = Colors.cyan[800];
var cyan900 = Colors.cyan[900];
//////////////////////////////////
///
///AMBER COLORS
var amber = Colors.amber;
var amber50 = Colors.amber[50];
var amber100 = Colors.amber[100];
var amber200 = Colors.amber[200];
var amber300 = Colors.amber[300];
var amber400 = Colors.amber[400];
var amber500 = Colors.amber[500];
var amber600 = Colors.amber[600];
var amber700 = Colors.amber[700];
var amber800 = Colors.amber[800];
var amber900 = Colors.amber[900];
//////////////////////////////////
///
///AMBER COLORS
var grey = Colors.grey;
var grey50 = Colors.grey[50];
var grey100 = Colors.grey[100];
var grey200 = Colors.grey[200];
var grey300 = Colors.grey[300];
var grey400 = Colors.grey[400];
var grey500 = Colors.grey[500];
var grey600 = Colors.grey[600];
var grey700 = Colors.grey[700];
var grey800 = Colors.grey[800];
var grey900 = Colors.grey[900];
//////////////////////////////////
///
///AMBER COLORS
var yellow = Colors.yellow;
var yellow50 = Colors.yellow[50];
var yellow100 = Colors.yellow[100];
var yellow200 = Colors.yellow[200];
var yellow300 = Colors.yellow[300];
var yellow400 = Colors.yellow[400];
var yellow500 = Colors.yellow[500];
var yellow600 = Colors.yellow[600];
var yellow700 = Colors.yellow[700];
var yellow800 = Colors.yellow[800];
var yellow900 = Colors.yellow[900];
//////////////////////////////////
///
///PINK COLORS
var pink = Colors.pink;
var pink50 = Colors.pink[50];
var pink100 = Colors.pink[100];
var pink200 = Colors.pink[200];
var pink300 = Colors.pink[300];
var pink400 = Colors.pink[400];
var pink500 = Colors.pink[500];
var pink600 = Colors.pink[600];
var pink700 = Colors.pink[700];
var pink800 = Colors.pink[800];
var pink900 = Colors.pink[900];
//////////////////////////////////
///
///INDIGO COLORS
var indigo = Colors.indigo;
var indigo50 = Colors.indigo[50];
var indigo100 = Colors.indigo[100];
var indigo200 = Colors.indigo[200];
var indigo300 = Colors.indigo[300];
var indigo400 = Colors.indigo[400];
var indigo500 = Colors.indigo[500];
var indigo600 = Colors.indigo[600];
var indigo700 = Colors.indigo[700];
var indigo800 = Colors.indigo[800];
var indigo900 = Colors.indigo[900];
//////////////////////////////////
///
///LIME COLORS
var lime = Colors.lime;
var lime50 = Colors.lime[50];
var lime100 = Colors.lime[100];
var lime200 = Colors.lime[200];
var lime300 = Colors.lime[300];
var lime400 = Colors.lime[400];
var lime500 = Colors.lime[500];
var lime600 = Colors.lime[600];
var lime700 = Colors.lime[700];
var lime800 = Colors.lime[800];
var lime900 = Colors.lime[900];
//////////////////////////////////
///
///LIGHTGREEN COLORS
var lightGreen = Colors.lightGreen;
var lightGreen50 = Colors.lightGreen[50];
var lightGreen100 = Colors.lightGreen[100];
var lightGreen200 = Colors.lightGreen[200];
var lightGreen300 = Colors.lightGreen[300];
var lightGreen400 = Colors.lightGreen[400];
var lightGreen500 = Colors.lightGreen[500];
var lightGreen600 = Colors.lightGreen[600];
var lightGreen700 = Colors.lightGreen[700];
var lightGreen800 = Colors.lightGreen[800];
var lightGreen900 = Colors.lightGreen[900];
//////////////////////////////////
///
///TEAL COLORS
var teal = Colors.teal;
var teal50 = Colors.teal[50];
var teal100 = Colors.teal[100];
var teal200 = Colors.teal[200];
var teal300 = Colors.teal[300];
var teal400 = Colors.teal[400];
var teal500 = Colors.teal[500];
var teal600 = Colors.teal[600];
var teal700 = Colors.teal[700];
var teal800 = Colors.teal[800];
var teal900 = Colors.teal[900];
//////////////////////////////////////////////////////////////////////////////// COLOR ACCENTS
///
///
///RED ACCENTS
var redAccent = Colors.redAccent;
var redAccent100 = Colors.redAccent[100];
var redAccent200 = Colors.redAccent[200];
var redAccent400 = Colors.redAccent[400];
var redAccent700 = Colors.redAccent[700];

///
///
///BLUE ACCENTS
var blueAccent = Colors.blueAccent;
var blueAccent100 = Colors.blueAccent[100];
var blueAccent200 = Colors.blueAccent[200];
var blueAccent400 = Colors.blueAccent[400];
var blueAccent700 = Colors.blueAccent[700];

///
///
///LIGHTBLUE ACCENTS
var lightBlueAccent = Colors.lightBlueAccent;
var lightBlueAccent100 = Colors.lightBlueAccent[100];
var lightBlueAccent200 = Colors.lightBlueAccent[200];
var lightBlueAccent400 = Colors.lightBlueAccent[400];
var lightlightBlueAccent700 = Colors.lightBlueAccent[700];

///
///
///CYAN ACCENTS
var cyanAccent = Colors.cyanAccent;
var cyanAccent100 = Colors.cyanAccent[100];
var cyanAccent200 = Colors.cyanAccent[200];
var cyanAccent400 = Colors.cyanAccent[400];
var cyanAccent700 = Colors.cyanAccent[700];

///
///
///YELLLOW ACCENTS
var yellowAccent = Colors.yellowAccent;
var yellowAccent100 = Colors.yellowAccent[100];
var yellowAccent200 = Colors.yellowAccent[200];
var yellowAccent400 = Colors.yellowAccent[400];
var yellowAccent700 = Colors.yellowAccent[700];

///
///
///PURPLE ACCENTS
var purpleAccent = Colors.purpleAccent;
var purpleAccent100 = Colors.purpleAccent[100];
var purpleAccent200 = Colors.purpleAccent[200];
var purpleAccent400 = Colors.purpleAccent[400];
var purpleAccent700 = Colors.purpleAccent[700];

///
///
///AMBER ACCENTS
var amberAccent = Colors.amberAccent;
var amberAccent100 = Colors.amberAccent[100];
var amberAccent200 = Colors.amberAccent[200];
var amberAccent400 = Colors.amberAccent[400];
var amberAccent700 = Colors.amberAccent[700];

///
///
///GREEN ACCENTS
var greenAccent = Colors.greenAccent;
var greenAccent100 = Colors.greenAccent[100];
var greenAccent200 = Colors.greenAccent[200];
var greenAccent400 = Colors.greenAccent[400];
var greenAccent700 = Colors.greenAccent[700];

///
///
///INDIGO ACCENTS
var indigoAccent = Colors.indigoAccent;
var indigoAccent100 = Colors.indigoAccent[100];
var indigoAccent200 = Colors.indigoAccent[200];
var indigoAccent400 = Colors.indigoAccent[400];
var indigoAccent700 = Colors.indigoAccent[700];

///
///
///LIME ACCENTS
var limeAccent = Colors.limeAccent;
var limeAccent100 = Colors.limeAccent[100];
var limeAccent200 = Colors.limeAccent[200];
var limeAccent400 = Colors.limeAccent[400];
var limeAccent700 = Colors.limeAccent[700];

///
///
///TEAL ACCENTS
var tealAccent = Colors.tealAccent;
var tealAccent100 = Colors.tealAccent[100];
var tealAccent200 = Colors.tealAccent[200];
var tealAccent400 = Colors.tealAccent[400];
var tealAccent700 = Colors.tealAccent[700];

///
///
///DEEPORANGE ACCENTS
var deepOrangeAccent = Colors.deepOrangeAccent;
var deepOrangeAccent100 = Colors.deepOrangeAccent[100];
var deepOrangeAccent200 = Colors.deepOrangeAccent[200];
var deepOrangeAccent400 = Colors.deepOrangeAccent[400];
var deepOrangeAccent700 = Colors.deepOrangeAccent[700];

///
///
///DEEPORANGE ACCENTS
var deepPurpleAccent = Colors.deepPurpleAccent;
var deepPurpleAccent100 = Colors.deepPurpleAccent[100];
var deepPurpleAccent200 = Colors.deepPurpleAccent[200];
var deepPurpleAccent400 = Colors.deepPurpleAccent[400];
var deepPurpleAccent700 = Colors.deepPurpleAccent[700];
////////////////////////////////////////////////////////////////////////////////
///
///
var blueGrey = Colors.blueGrey;

//
class BottomNavBarRaisedInsetFb1 extends StatefulWidget {
  const BottomNavBarRaisedInsetFb1({Key? key}) : super(key: key);

  @override
  _BottomNavBarRaisedInsetFb1State createState() =>
      _BottomNavBarRaisedInsetFb1State();
}

class _BottomNavBarRaisedInsetFb1State
    extends State<BottomNavBarRaisedInsetFb1> {
  //- - - - - - - - - instructions - - - - - - - - - - - - - - - - - -
  // WARNING! MUST ADD extendBody: true; TO CONTAINING SCAFFOLD
  //
  // Instructions:
  //
  // add this widget to the bottomNavigationBar property of a Scaffold, along with
  // setting the extendBody parameter to true i.e:
  //
  // Scaffold(
  //  extendBody: true,
  //  bottomNavigationBar: BottomNavBarRaisedInsetFb1()
  // )
  //
  // Properties such as color and height can be set by changing the properties at the top of the build method
  //
  // For help implementing this in a real app, watch https://www.youtube.com/watch?v=C0_3w0kd0nc. The style is different, but connecting it to navigation is the same.
  //
  //- - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - -

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = 56;

    final primaryColor = Colors.blue;
    final secondaryColor = Colors.black54;
    final accentColor = const Color(0xffffffff);
    final backgroundColor = Colors.white;

    final shadowColor = Colors.grey; //color of Navbar shadow
    double elevation = 100; //Elevation of the bottom Navbar

    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(size.width, height),
            painter: BottomNavCurvePainter(
                backgroundColor: backgroundColor,
                shadowColor: shadowColor,
                elevation: elevation),
          ),
          Center(
            heightFactor: 0.6,
            child: FloatingActionButton(
                backgroundColor: primaryColor,
                child: Icon(Icons.shopping_basket),
                elevation: 0.1,
                onPressed: () {}),
          ),
          Container(
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NavBarIcon(
                  text: "Home",
                  icon: Icons.home_outlined,
                  selected: true,
                  onPressed: () {},
                  defaultColor: secondaryColor,
                  selectedColor: primaryColor,
                ),
                NavBarIcon(
                  text: "Search",
                  icon: Icons.search_outlined,
                  selected: false,
                  onPressed: () {},
                  defaultColor: secondaryColor,
                  selectedColor: primaryColor,
                ),
                SizedBox(width: 56),
                NavBarIcon(
                    text: "Cart",
                    icon: Icons.local_grocery_store_outlined,
                    selected: false,
                    onPressed: () {},
                    defaultColor: secondaryColor,
                    selectedColor: primaryColor),
                NavBarIcon(
                  text: "Calendar",
                  icon: Icons.date_range_outlined,
                  selected: false,
                  onPressed: () {},
                  selectedColor: primaryColor,
                  defaultColor: secondaryColor,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavCurvePainter extends CustomPainter {
  BottomNavCurvePainter(
      {this.backgroundColor = Colors.white,
      this.insetRadius = 38,
      this.shadowColor = Colors.grey,
      this.elevation = 100});

  Color backgroundColor;
  Color shadowColor;
  double elevation;
  double insetRadius;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    Path path = Path();

    double insetCurveBeginnningX = size.width / 2 - insetRadius;
    double insetCurveEndX = size.width / 2 + insetRadius;

    path.lineTo(insetCurveBeginnningX, 0);
    path.arcToPoint(Offset(insetCurveEndX, 0),
        radius: Radius.circular(41), clockwise: true);

    path.lineTo(size.width, 0);

    path.lineTo(size.width, size.height + 56);
    path.lineTo(
        0,
        size.height +
            56); //+56 here extends the navbar below app bar to include extra space on some screens (iphone 11)
    canvas.drawShadow(path, shadowColor, elevation, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class NavBarIcon extends StatelessWidget {
  const NavBarIcon(
      {Key? key,
      required this.text,
      required this.icon,
      required this.selected,
      required this.onPressed,
      this.selectedColor = const Color(0xffFF8527),
      this.defaultColor = Colors.black54})
      : super(key: key);
  final String text;
  final IconData icon;
  final bool selected;
  final Function() onPressed;
  final Color defaultColor;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPressed,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Icon(
            icon,
            size: 25,
            color: selected ? selectedColor : defaultColor,
          ),
        ),
      ],
    );
  }
}
