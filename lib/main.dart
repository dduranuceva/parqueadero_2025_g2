import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parqueadero_2025_g2/firebase_options.dart';
import 'package:parqueadero_2025_g2/routes/app_router.dart';
import 'provider/theme_provider.dart';
import 'themes/app_theme.dart'; // Importa el tema
import 'package:provider/provider.dart';

void main() async {
  // Asegurarse de que los widgets de Flutter estén inicializados
  WidgetsFlutterBinding.ensureInitialized();
  // Optimizar la carga del .env
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Error loading .env file: $e');
  }
  // Inicializar dotenv para cargar las variables de entorno
  // await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    //! MultiProvider permite usar varios providers en la app
    //! En este caso solo se usa el ThemeProvider, pero se pueden agregar más
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          //* El provider se encarga de gestionar el color del tema de la app
          //* y notificar a los widgets que lo usan cuando cambia
          create: (_) => ThemeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer escucha los cambios del ThemeProvider y reconstruye la app
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp.router(
          theme: AppTheme.lightTheme(themeProvider.color),
          title: 'Flutter - UCEVA',
          routerConfig: appRouter,
        );
      },
    );
  }
}
