import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialcraft/utils/widgets.dart';
import 'package:socialcraft/utils/fonts.dart';
import 'package:socialcraft/utils/images.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Settings extends StatefulWidget {
  static String tag = '/settings';

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Configuración'),
          backgroundColor: azul_logo,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              30.height,
              15.height,
              Text(
                'Configuración',
                style: TextStyle(fontSize: 28),
              ),
              20.height,
              Align(
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    label: Text('Cerrar Sesión'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(140, 40),
                      //primary: Colors.lightBlueAccent[200],
                      primary: Colors.red[400],
                      onPrimary: Colors.white,
                      onSurface: Colors.grey,
                    ),
                    icon: Icon(Icons.close, size: 18),
                    onPressed: () async {
                      final storage = new FlutterSecureStorage();
                      await storage.deleteAll();
                      String token = await storage.read(key: 'jwt');
                      print(token);
                      Navigator.pushNamedAndRemoveUntil(
                          context, 'login', (Route<dynamic> route) => false);
                    },
                  )).paddingTop(10),
            ],
          ),
        ),
      ),
    );
  }
}
