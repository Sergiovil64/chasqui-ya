import 'package:chasqui_ya/config/app_theme.dart';
import 'package:chasqui_ya/ui/restaurant/restaurant_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/auth/login_ui.dart';
import 'ui/auth/register_selection_ui.dart';
import 'ui/auth/customer_register_form_ui.dart';
import 'ui/auth/restaurant_register_form_ui.dart';
import 'ui/auth/delivery_register_form_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chasqui Ya',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginUI(),
        '/register': (context) => const RegisterSelectionUI(),
        '/register/customer': (context) => const CustomerRegisterFormUI(),
        '/register/restaurant': (context) => const RestaurantRegisterFormUI(),
        '/register/delivery': (context) => const DeliveryRegisterFormUI(),
      },
    );
  }
}
