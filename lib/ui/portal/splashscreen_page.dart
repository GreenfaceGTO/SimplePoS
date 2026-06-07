import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/models/args_model.dart';
import 'package:simplepos/providers/master_provider.dart';
import 'package:simplepos/providers/startup_provider.dart';
import 'package:simplepos/services/startup_service.dart';
import 'package:simplepos/services/utils/enums.dart';
import 'package:simplepos/ui/dummy_page.dart';
import 'package:simplepos/ui/mainframe_page.dart';
import 'package:simplepos/ui/portal/register_page.dart';

class SplashscreenPage extends StatefulWidget {
  const SplashscreenPage({super.key});

  @override
  State<SplashscreenPage> createState() => _SplashscreenPageState();
}

class _SplashscreenPageState extends State<SplashscreenPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      log("$runtimeType : running microtask...");
      if (mounted) {
        log("$runtimeType : loading init in master provider...");
        context.read<MasterProvider>().init();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StartupProvider>(
      builder: (context, prov, _) {
        return prov.isLoading
            ? Scaffold(
                body: Center(
                  child: SizedBox(
                    width: 200,
                    height: 150,
                    child: Image.asset("assets/mbspos.png", fit: BoxFit.cover),
                  ),
                ),
              )
            : (prov.route == AppStartRoute.login
                  ? DummyPage(caption: "Login Page")
                  : (prov.route == AppStartRoute.register
                        ? RegisterPage()
                        : MainframePage(
                            args: ArgsModel(formMode: FormMode.view),
                          )));
      },
    );
  }
}
