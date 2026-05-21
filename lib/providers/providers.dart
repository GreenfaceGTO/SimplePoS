import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:simplepos/providers/main_provider.dart';
import 'package:simplepos/providers/master_provider.dart';
import 'package:simplepos/providers/portal_provider.dart';
import 'package:simplepos/providers/startup_provider.dart';
import 'package:simplepos/services/connectivity_service.dart';
import 'package:simplepos/services/startup_service.dart';

class AppProviders {
  final startupService = AppStartUpService(ConnectivityService());

  List<SingleChildWidget> get providers => [
    ChangeNotifierProvider(create: (context) => MasterProvider()),
    ChangeNotifierProvider(create: (context) => PortalProvider()),
    ChangeNotifierProvider(create: (context) => MainProvider()),
    ChangeNotifierProvider(
      create: (context) => StartupProvider(startupService),
    ),
  ];
}
