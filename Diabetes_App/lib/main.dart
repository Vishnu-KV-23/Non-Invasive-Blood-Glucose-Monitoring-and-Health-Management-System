import 'package:flutter/material.dart';
import 'package:phase_1_app/screens/auth_ui.dart';
import 'package:phase_1_app/screens/doctor_info.dart';
import 'package:phase_1_app/utils/config.dart';
import 'package:phase_1_app/utils/main_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Flutter Doctor App',
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          focusColor: Config.primaryColor,
          border: Config.OutlinedBorder,
          focusedBorder: Config.focusBorder,
          errorBorder: Config.errorBorder,
          enabledBorder: Config.OutlinedBorder,
          floatingLabelStyle: TextStyle(color: Config.primaryColor),
          prefixIconColor: Colors.black38,
        ),
        scaffoldBackgroundColor: Colors.white,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Config.primaryColor,
          selectedItemColor: Colors.white,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          unselectedItemColor: Colors.grey.shade700,
          elevation: 10,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthPage(),
        //'signup': (context) => const SignUpPage(),
        'main': (context) => const MainLayout(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == 'doc_details') {
          if (settings.arguments is Map<String, String>) {
            final args = settings.arguments as Map<String, String>;
            return MaterialPageRoute(
              builder: (context) => DoctorDetails(
                doctorName: args['doctorName']!,
                doctorImage: args['doctorImage']!,
              ),
            );
          }
        }
        // Default case for unknown routes
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text(
                '404: Page not found',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }
}
