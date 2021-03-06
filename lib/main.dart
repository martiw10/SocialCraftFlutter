//import 'dart:js';

//import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:socialcraft/provider/google_sign_in.dart';
import 'package:socialcraft/tienda.dart';
import 'buscar.dart';
import 'editpost.dart';
import 'home.dart';
import 'logged_in.dart';
import 'perfil2.dart';
import 'login.dart';
import 'register.dart';
import 'perfil.dart';
import 'barraNavegacion.dart';
import 'forgotPassword.dart';
import 'editar.dart';
import 'password.dart';
import 'settings.dart';
import 'transition.dart';
import 'post.dart';
import 'upload.dart';
import 'materiales.dart';
import 'subir_pasos.dart';
import 'package:google_fonts/google_fonts.dart';
import 'subir_comentario.dart';
import 'post_comentarios.dart';
import 'logros.dart';
import 'package:socialcraft/l10n/l10n.dart';
import 'package:socialcraft/provider/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/l10n.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => LocaleProvider()),
          ChangeNotifierProvider(create: (context) => GoogleSignInProvider())
        ],
        child: Consumer<LocaleProvider>(
            builder: (context, provider, child) => MaterialApp(
                supportedLocales: L10n.all,
                locale: provider.localee,
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                routes: <String, WidgetBuilder>{
                  //'subir_comentario': (BuildContext context) => SubirComentario(),
                  'login': (BuildContext context) => Login(),
                  'register': (BuildContext context) => Register(),
                  'barra': (BuildContext context) => barra(),
                  'perfil': (BuildContext context) => Perfil(),
                  //'perfil2': (BuildContext context) => Perfil2(),
                  'forgotPassword': (BuildContext context) => ForgotPassword(),
                  'editar': (BuildContext context) => Editar("", "", "", ""),
                  'search': (BuildContext context) => Search(),
                  'password': (BuildContext context) => Password(),
                  'settings': (BuildContext context) => Settings(),
                  'transition': (BuildContext context) => Transition(),
                  //'post': (BuildContext context) => Post(),
                  'upload': (BuildContext context) => Upload(),
                  'materiales': (BuildContext context) => Materiales(),
                  //'editPost': (BuildContext context) => EditPost(),
                  'home': (BuildContext context) => Home(),
                  'tienda': (BuildContext context) => Tienda(),
                  //'subirpasos': (BuildContext context) => SubirPasos(),
                  //'post_comentarios': (BuildContext context) => PostComentarios(),
                  'logros': (BuildContext context) => Logros(),
                  'loggedIn': (BuildContext context) => LoggedInWidget(),
                },
                debugShowCheckedModeBanner: false,
                home: Transition(),
                theme: ThemeData(
                  textTheme: GoogleFonts.comfortaaTextTheme(),
                )),
            child: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              // ignore: missing_return
              builder: (context, snapshot) {
                final provider = Provider.of<GoogleSignInProvider>(context);
                if (provider.isSigningIn) {
                  return buildLoading();
                } else if (snapshot.hasData) {
                  print("aaaaaaaaaaaaAAAAAaaaaaaaa");
                  Navigator.pushNamed(context, 'loggedIn');
                } else {
                  return null;
                }
              },
            )));
  }

  Widget buildLoading() => Stack(
        fit: StackFit.expand,
        children: [
          //CustomPaint(painter: BackgroundPainter()),
          Center(child: CircularProgressIndicator()),
        ],
      );
}
