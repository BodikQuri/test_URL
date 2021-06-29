

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'screens/Home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: () => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Color.fromRGBO(50, 65, 85, 1),
                        textTheme:
                            // ignore: deprecated_member_use
                            TextTheme(
                              headline1: TextStyle(color: Colors.white, fontSize: 25.sp, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                              bodyText1: TextStyle(backgroundColor: Color.fromRGBO(50, 65, 85, 1), color: Colors.white, fontSize: 20.sp)
                              )
        ),
        home: Home(),
      ),
    );
  }
}
