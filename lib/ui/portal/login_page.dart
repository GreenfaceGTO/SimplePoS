import 'package:flutter/material.dart';
import 'package:simplepos/services/utils/constant.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    ThemeData tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        leading: Icon(Icons.storefront_outlined),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(12, 4, 12, 12),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black38, width: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Login", style: tema.textTheme.titleMedium),
                  Text("Silahkan masukkan data login Anda."),
                  SizedBox(height: 30),
                  TextFormField(
                    decoration: InputDecoration(label: Text("Email Toko")),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(label: Text("Password")),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 4,
                        ),
                        child: Text(
                          "Lupa Password",
                          style: tema.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w700,
                            color: tema.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: SizedBox(
                      height: 45,
                      width: 200,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        label: Text("MASUK"),
                        icon: Icon(Icons.login),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(appCRight, style: tema.textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}
