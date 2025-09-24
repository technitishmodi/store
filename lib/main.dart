import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ],
      child: MaterialApp(
        title: 'Shopping Store',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Modern Material 3 theme with dynamic color scheme
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6750A4), // Modern purple
            brightness: Brightness.light,
            primary: const Color(0xFF6750A4),
            secondary: const Color(0xFF03DAC6),
            tertiary: const Color(0xFFEFB8C8),
            surface: const Color(0xFFFFFBFE),
            background: const Color(0xFFF6F5FA),
            error: const Color(0xFFB3261E),
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF6F5FA),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            scrolledUnderElevation: 2,
            backgroundColor: Color(0xFFFFFBFE),
            foregroundColor: Color(0xFF1C1B1F),
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.15,
              color: Color(0xFF1C1B1F),
            ),
            iconTheme: IconThemeData(color: Color(0xFF6750A4)),
          ),
          cardTheme: CardThemeData(
            elevation: 0,
            color: const Color(0xFFFFFBFE),
            shadowColor: Colors.black.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200, width: 0.5),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFFFFFBFE),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6750A4), width: 2),
            ),
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            labelStyle: const TextStyle(color: Color(0xFF6750A4)),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xFF6750A4),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              minimumSize: const Size(120, 48),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF6750A4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400, letterSpacing: -0.25),
            displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
            displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
            headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
            headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
            headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
            titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, letterSpacing: 0),
            titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15),
            titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
            bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
            bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
            bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
            labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
            labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5),
            labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5),
          ),
        ),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return authProvider.isAuthenticated
                ? const HomeScreen()
                : const LoginScreen();
          },
        ),
      ),
    );
  }
}
