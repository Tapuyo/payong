import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payong/provider/agri_provider.dart';
import 'package:payong/provider/daily_provider.dart';
import 'package:payong/provider/init_provider.dart';
import 'package:payong/routes/route_generator.dart';
import 'package:payong/routes/routes.dart';
import 'package:payong/splash_page.dart';
import 'package:payong/ui/mob_main.dart';
import 'package:payong/utils/themes.dart';
import 'package:provider/provider.dart';

void main() {
   runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => InitProvider()),
      ChangeNotifierProvider(create: (_) => DailyProvider()),
      ChangeNotifierProvider(create: (_) => AgriProvider()),
    ],
    child:  MyApp(),
  ));
}

class MyApp extends StatelessWidget {

 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainPage(),
      title: 'Payong',
      initialRoute: Routes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        platform: TargetPlatform.iOS,
        scaffoldBackgroundColor: Colors.white,
        toggleableActiveColor: kColorPrimary,
        appBarTheme: const AppBarTheme(
          elevation: 1,
          color: Colors.white,
          iconTheme: IconThemeData(
            color: kColorPrimary,
          ),
          actionsIconTheme: IconThemeData(
            color: kColorPrimary,
          ),
          // ignore: deprecated_member_use
          textTheme: TextTheme(
            headline6: TextStyle(
              color: kColorDarkBlue,
              fontFamily: 'NunitoSans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        dividerColor: Colors.grey[300],
        textTheme: TextTheme(
          button: kTextStyleButton,
          subtitle1: kTextStyleSubtitle1.copyWith(color: kColorPrimaryDark),
          subtitle2: kTextStyleSubtitle2.copyWith(color: kColorPrimaryDark),
          bodyText2: kTextStyleBody2.copyWith(color: kColorPrimaryDark),
          headline6: kTextStyleHeadline6.copyWith(color: kColorPrimaryDark),
        ),
        iconTheme: const IconThemeData(
          color: kColorPrimary,
        ),
        fontFamily: 'NunitoSans',
        cardTheme: CardTheme(
          elevation: 0,
          color: const Color(0xffEBF2F5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            //side: BorderSide(width: 1, color: Colors.grey[200]),
          ),
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
