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
        builder: (context, child) {
          // Create a cohesive color scheme from a refined brand seed.
          final colorScheme = ColorScheme.fromSeed(
            seedColor: const Color(0xFF4F46E5), // refined indigo brand
            brightness: Brightness.light,
          );

          return Theme(
            data: ThemeData(
              // Use a refreshed brand seed (teal) and override the secondary accent
              colorScheme: (() {
                final base = colorScheme;
                return base.copyWith(
                  secondary: const Color(0xFFFF6B6B), // coral accent
                );
              })(),
              useMaterial3: true,
              scaffoldBackgroundColor: colorScheme.background,
              appBarTheme: AppBarTheme(
                centerTitle: true,
                elevation: 0,
                scrolledUnderElevation: 2,
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.15,
                  color: colorScheme.onPrimary,
                ),
                iconTheme: IconThemeData(color: colorScheme.onPrimary),
              ),
              cardTheme: CardThemeData(
                elevation: 0,
                color: colorScheme.surface,
                shadowColor: Colors.black.withOpacity(0.06),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: colorScheme.outline.withOpacity(0.12), width: 0.6),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: colorScheme.surfaceVariant,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.6), width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.6), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
                hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6), fontSize: 14),
                labelStyle: TextStyle(color: colorScheme.primary),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  minimumSize: const Size(120, 48),
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.primary,
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
            child: child!,
          );
        },
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
