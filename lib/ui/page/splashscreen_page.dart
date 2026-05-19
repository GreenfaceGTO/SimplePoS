import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/providers/startup_provider.dart';
import 'package:simplepos/services/startup_service.dart';
import 'package:simplepos/ui/dummy_page.dart';
import 'package:simplepos/ui/page/login_page.dart';

class SplashscreenPage extends StatefulWidget {
  const SplashscreenPage({super.key});

  @override
  State<SplashscreenPage> createState() => _SplashscreenPageState();
}

class _SplashscreenPageState extends State<SplashscreenPage> {
  @override
  void initState() {
    log("$runtimeType : splash init...");

    super.initState();
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
                  : LoginPage()
              // (prov.route == AppStartRoute.register
              //       ? RegisterPage()
              //       : DummyPage(caption: "Dashboard Page"))
              );
      },
    );
  }
}
