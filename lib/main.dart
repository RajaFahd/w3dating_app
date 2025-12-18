import 'package:flutter/material.dart';
import 'package:w3dating_app/welcome/onboarding_page.dart';
import 'package:w3dating_app/welcome/login_page.dart';
import 'package:w3dating_app/welcome/otp_page.dart';
import 'package:w3dating_app/welcome/first_name.dart';
import 'package:w3dating_app/welcome/enter_birth_date.dart';
import 'package:w3dating_app/welcome/your_gender.dart';
import 'package:w3dating_app/welcome/orientation.dart';
import 'package:w3dating_app/welcome/intrested.dart';
import 'package:w3dating_app/welcome/looking_for.dart';
import 'package:w3dating_app/welcome/recent_pics.dart';
import 'package:w3dating_app/home/home_screen.dart';
import 'package:w3dating_app/home/match_screen_page.dart';
import 'package:w3dating_app/explore/explore_screen.dart';
import 'package:w3dating_app/chat/chat_list.dart';
import 'package:w3dating_app/chat/chat_screen.dart';
import 'package:w3dating_app/wishlist/wishlist_screen.dart';
import 'package:w3dating_app/wishlist/profile_detail.dart';
import 'package:w3dating_app/profile/profile_screen.dart';
import 'package:w3dating_app/profile/edit_profile.dart';
import 'package:w3dating_app/profile/filter.dart';
import 'package:w3dating_app/profile/setting_page.dart';
import 'package:w3dating_app/profile/subscription_page.dart';
import 'package:w3dating_app/theme/app_theme.dart';

void main() {
  runApp(const W3DatingApp());
}

class W3DatingApp extends StatefulWidget {
  const W3DatingApp({Key? key}) : super(key: key);

  static _W3DatingAppState of(BuildContext context) => context.findAncestorStateOfType<_W3DatingAppState>()!;

  @override
  State<W3DatingApp> createState() => _W3DatingAppState();
}

class _W3DatingAppState extends State<W3DatingApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'W3 Dating',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _themeMode,
      initialRoute: '/match_screen',
      routes: {
        '/match_screen': (ctx) => const MatchScreenPage(),
        '/onboarding': (ctx) => const OnboardingPage(),
        '/login': (ctx) => const LoginPage(),
        '/otp': (ctx) => const OtpPage(),
        '/first_name': (ctx) => const FirstNamePage(),
        '/birth_date': (ctx) => const EnterBirthDate(),
        '/your_gender': (ctx) => const YourGenderPage(),
        '/orientation': (ctx) => const OrientationPage(),
        '/interested': (ctx) => const InterestedPage(),
        '/looking_for': (ctx) => const LookingForPage(),
        '/recent_pics': (ctx) => const RecentPicsPage(),
        '/home': (ctx) => const HomeScreen(),
        '/explore': (ctx) => const ExploreScreen(),
        '/chat_list': (ctx) => const ChatListPage(),
        '/chat_screen': (ctx) => const ChatScreen(),
        '/wishlist': (ctx) => const WishlistScreen(),
        '/wishlist_profile': (ctx) => const ProfileDetail(),
        '/profile': (ctx) => const ProfileScreen(),
        '/profile/edit': (ctx) => const EditProfile(),
        '/profile/filter': (ctx) => const ProfileFilterPage(),
        '/profile/setting': (ctx) => const SettingPage(),
        '/profile/subscription': (ctx) => const SubscriptionPage(),
      },
    );
  }
}
