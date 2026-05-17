import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/providers/providers.dart';
import 'package:simplepos/services/utils/routes.dart';
import 'package:simplepos/ui/page/splashscreen_page.dart';
import 'package:simplepos/ui/theme.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders().providers,
      child: MaterialApp(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        title: "Simple Pos",
        theme: AppTema.tema,
        onGenerateRoute: AppRoutes.generateRoute,
        home: SplashscreenPage(),
        routes: AppRoutes.routes,
      ),
    );
  }
}
