import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_exports.dart';



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Flutter Posts App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      home: const HomePage(),
      routes: {
        '/posts': (context) => const PostsPage(),
        '/favorites': (context) => const FavoritePostsPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}

void main() => runApp(
  DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => const ProviderScope(child: MyApp()),
    defaultDevice: Devices.ios.iPhone16Pro,
  ),
);
