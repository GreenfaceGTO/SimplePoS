import 'package:flutter/material.dart';
import 'package:simplepos/services/utils/constant.dart';
import 'package:simplepos/ui/widget/public_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    TextTheme tema = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        leading: Icon(Icons.storefront_outlined),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.help_outline))],
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(12, 4, 12, 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black45, width: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Registrasi Toko", style: tema.titleMedium),
              Text("Lengkapi detail profil bisnis Anda untuk memulai."),
              PublicWidget.spasi(jarak: 24),
              _photoFrame(context, tema),
              PublicWidget.spasi(jarak: 24),
              TextFormField(
                decoration: InputDecoration(label: Text("Nama Toko")),
              ),
              PublicWidget.spasi(),
              TextFormField(
                maxLines: 3,
                decoration: InputDecoration(label: Text("Alamat")),
              ),
              PublicWidget.spasi(),
              TextFormField(
                decoration: InputDecoration(label: Text("Nama Pemilik")),
              ),
              PublicWidget.spasi(),
              TextFormField(
                decoration: InputDecoration(label: Text("Alamat Email")),
              ),
              PublicWidget.spasi(jarak: 30),
              Center(
                child: SizedBox(
                  height: 45,
                  width: 200,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      elevation: WidgetStatePropertyAll(2),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    iconAlignment: IconAlignment.end,
                    onPressed: () {},
                    label: Text("Daftar Sekarang"),
                    icon: Icon(Icons.arrow_forward),
                  ),
                ),
              ),
              PublicWidget.spasi(),
              Center(
                child: Text(
                  "Dengan mendaftar, dengan sendirinya Anda menyatakan tunduk pada Syarat & Ketentuan penggunaan Aplikasi ini.",
                  style: tema.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Align _photoFrame(BuildContext context, TextTheme tema) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade100,
                  border: Border.all(color: Colors.black45, width: 0.5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_a_photo),
                      PublicWidget.spasi(),
                      Text("Logo Toko"),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  maxRadius: 15,
                  child: Icon(Icons.edit, size: 20, color: Colors.white),
                ),
              ),
            ],
          ),
          Text("Maksimal 1MB (PNG)", style: tema.bodySmall),
        ],
      ),
    );
  }
}
