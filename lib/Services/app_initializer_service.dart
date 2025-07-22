import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AppInitializerService {
  static Future<void> initialize() async {
    // Set default locale for the application
    Intl.defaultLocale = 'en_US';
    await Firebase.initializeApp();
    // Set Firebase Authentication language code to avoid "Ignoring header X-Firebase-Locale because its value was null" warning
    await FirebaseAuth.instance.setLanguageCode('en');
  }
}
