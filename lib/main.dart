import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'; // 👈 Шарт текшириш учун ушбу импорт шарт
import 'auth_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Агар илова браузерда (Web) очилмаган бўлсагина Firebase-ни ишга туширади
  if (!kIsWeb) {
    await Firebase.initializeApp();
  }
  
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class AppConfig {
  static const String appName = "Baraka Tezkor";
  static const String adminPhone = "+998906127747";
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConfig.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF10B981)),
        useMaterial3: true,
      ),
      // Илова ишга тушганда биринчи бўлиб телефон рақам киритиш ойнаси очилади
      home: const AuthScreen(), 
    );
  }
}
