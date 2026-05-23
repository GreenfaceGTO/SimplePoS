import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:simplepos/models/args_model.dart';
import 'package:simplepos/models/data/usaha_model.dart';
import 'package:simplepos/providers/portal_provider.dart';
import 'package:simplepos/services/utils/constant.dart';
import 'package:simplepos/services/utils/enums.dart';
import 'package:simplepos/ui/widget/reusable/public_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController txtToko = TextEditingController();
  final TextEditingController txtAlamat = TextEditingController();
  final TextEditingController txtOwner = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  String pathFileLogo = '';
  final formKey = GlobalKey<FormState>();
  late PortalProvider portalProv;

  @override
  void initState() {
    portalProv = Provider.of<PortalProvider>(context, listen: false);
    super.initState();
  }

  bool validateEmail(String email) {
    final emailRegEx = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    bool result = emailRegEx.hasMatch(email);
    log(result.toString());
    return result;
  }

  @override
  void dispose() {
    txtToko.dispose();
    txtAlamat.dispose();
    txtOwner.dispose();
    txtEmail.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme tema = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        leading: Icon(Icons.storefront_outlined),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.help_outline))],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(12, 4, 12, 12),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black45, width: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _form(tema, context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(appCRight, style: tema.bodySmall),
          ),
        ],
      ),
    );
  }

  Widget _form(TextTheme tema, BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Registrasi Toko", style: tema.titleMedium),
            Text("Lengkapi detail profil bisnis Anda untuk memulai."),
            PublicWidget.spasi(jarak: 24),
            _photoFrame(context, tema),
            PublicWidget.spasi(jarak: 24),
            TextFormField(
              controller: txtToko,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(label: Text("Nama Toko")),
              validator: (val) {
                if (val!.isEmpty) return "Wajib diisi";
                return null;
              },
            ),
            PublicWidget.spasi(),
            TextFormField(
              controller: txtAlamat,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.streetAddress,
              maxLines: 3,
              decoration: InputDecoration(label: Text("Alamat")),
            ),
            PublicWidget.spasi(),
            TextFormField(
              controller: txtOwner,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(label: Text("Nama Pemilik")),
              validator: (val) {
                if (val!.isEmpty) return "Wajib diisi";
                return null;
              },
            ),
            PublicWidget.spasi(),
            TextFormField(
              controller: txtEmail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(label: Text("Alamat Email")),
              validator: (val) {
                if (val!.isEmpty) {
                  return "Wajib diisi";
                } else if (!validateEmail(txtEmail.text)) {
                  return "Email tidak valid";
                }
                return null;
              },
            ),
            PublicWidget.spasi(jarak: 30),
            _tombolDaftar(context),
            PublicWidget.spasi(jarak: 12),
            Text.rich(
              TextSpan(
                text:
                    "Dengan melanjutkan pendaftaran, Anda menyatakan tunduk pada ",
                style: tema.bodyMedium,
                children: [
                  TextSpan(
                    text: "Syarat & Ketentuan",
                    style: tema.bodyMedium!.copyWith(
                      color: Colors.blue.shade600,
                      fontWeight: FontWeight.w700,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // TODO : lengkapi ini;
                      },
                  ),
                  TextSpan(text: " aplikasi."),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Center _tombolDaftar(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 45,
        width: 200,
        child: ElevatedButton.icon(
          iconAlignment: IconAlignment.end,
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              UsahaModel dataUsaha = UsahaModel(
                logoToko: pathFileLogo.isEmpty ? null : pathFileLogo,
                namaUsaha: txtToko.text,
                userName: txtOwner.text,
                alamat: txtAlamat.text,
                email: txtEmail.text,
              );
              log(dataUsaha.toMap().toString());
              if (await portalProv.submitRegister(dataUsaha)) {
                if (context.mounted) {
                  Navigator.pushReplacementNamed(
                    context,
                    rtMainFrame,
                    arguments: ArgsModel(formMode: FormMode.view),
                  );
                }
              }
            }
          },
          label: Text("DAFTAR SEKARANG"),
          icon: Icon(Icons.arrow_forward),
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
                clipBehavior: Clip.antiAlias,
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade100,
                  border: Border.all(color: Colors.black45, width: 0.5),

                  borderRadius: BorderRadius.circular(15),
                ),
                child: pathFileLogo.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_a_photo, color: Colors.grey),
                            PublicWidget.spasi(),
                            Text("Logo Toko"),
                          ],
                        ),
                      )
                    : Image.file(File(pathFileLogo), fit: BoxFit.cover),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () async {
                    if (pathFileLogo.isEmpty) {
                      ImageSource? source =
                          await PublicWidget.showImageSourceOption(context);
                      if (source != null) {
                        File? file = await PublicWidget.pickImage(
                          source: source,
                        );
                        if (file != null) {
                          String ext = p.extension(file.path).toLowerCase();
                          if (ext == '.png' ||
                              ext == '.jpg' ||
                              ext == '.jpeg') {
                            setState(() {
                              pathFileLogo = file.path;
                              log(pathFileLogo.toString());
                            });
                          } else {
                            PublicWidget.showMessage(
                              message: "Tipe file salah!",
                              mode: MessageMode.error,
                            );
                          }
                        }
                      }
                    } else {
                      setState(() {
                        pathFileLogo = '';
                      });
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: pathFileLogo.isEmpty
                        ? Theme.of(context).primaryColor
                        : Colors.red,
                    maxRadius: 15,
                    child: Icon(
                      pathFileLogo.isEmpty ? Icons.add : Icons.clear,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text("Maksimal 1MB (PNG/JPG/JPEG)", style: tema.bodySmall),
        ],
      ),
    );
  }
}
