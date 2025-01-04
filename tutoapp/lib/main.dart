import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Tutoapp/providers/userProvider.dart';
import 'package:Tutoapp/providers/CitaProvider.dart';
import 'screens/SplashScreen.dart';
import 'package:Tutoapp/screens/avisoPriv.dart';
import 'screens/Signup.dart';
import 'screens/loginForm.dart';
import 'screens/AppNavegador.dart';
import 'screens/Perfil.dart';
import 'screens/Settings.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'screens/verificarCodigo.dart';

void main() {
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for test',
      ),
    ],
    debug: true,
  );

  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(
            create: (_) => UserProvider(),
          ),
          ChangeNotifierProvider<CitaProvider>(
            create: (_) => CitaProvider(),
          ),
        ],
        child: MaterialApp(
          //locale: const Locale('es', 'ES'), // Configura la localización deseada

          color: const Color.fromARGB(255, 82, 113, 255),
          debugShowCheckedModeBanner: false,
          routes: {
            '/registro': (context) => SignupScreen(),
            '/login': (context) => const LoginScreen(),
            '/Perfil': (context) => const ProfileScreen(),
            '/App': (context) => AppNavigator(),
            '/privacidad': (context) => const PoliticasScreen(),
            //'/noti': (context) => NotiScreen(),
            '/config': (context) => const SettingsScreen(),
            '/splash': (context) => const SplashScreen(),
            '/verify': (context) => const VerificationScreen(),
            '/verifymail': (context) => const VerifyMail(),
          },
          initialRoute: '/splash',
          home: const SplashScreen(),
        )),
  );
}
