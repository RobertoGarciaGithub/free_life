import 'package:flutter/material.dart';
import 'package:free_life/pages/home_page.dart';
import 'package:free_life/widgets/auth_check.dart';

import 'package:free_life/pages/auth/sign_in.dart';
import 'package:free_life/pages/auth/sign_up.dart';
import 'package:free_life/pages/auth/forgot_password.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list =
      <String, WidgetBuilder>{
        '/': (_) => const HomePage(),
        '/auth-check': (_) => const AuthCheck(),
        '/sign-in': (_) => const SignInPage(),
        '/sign-up': (_) => const SignUpPage(),
        '/forgot-password': (_) => const ForgotPasswordPage(),
      };

  static final navigatorKey = GlobalKey<NavigatorState>();
  static String initial = '/';
  static String authCheck = '/auth-check';

  static String signIn = '/sign-in';
  static String signUp = '/sign-up';
  static String forgotPassword = '/forgot-password';

  static NavigatorState to = Routes.navigatorKey.currentState!;
}

// dentro da lista:
