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

void main() {
  runApp(const W3DatingApp());
}

class W3DatingApp extends StatelessWidget {
  const W3DatingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = const Color(0xFF2E2E34);
    final accent = const Color(0xFFFE5F9F);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'W3 Dating',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: dark,
        primaryColor: accent,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF333238),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        ),
      ),
      initialRoute: '/onboarding',
      routes: {
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
