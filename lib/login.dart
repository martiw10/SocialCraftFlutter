import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:socialcraft/provider/google_sign_in.dart';
import 'package:socialcraft/utils/widgets.dart';
import 'package:socialcraft/utils/images.dart';
import 'package:socialcraft/utils/fonts.dart';
import 'package:socialcraft/resp.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  bool showPassword = false;
  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  String user = "";
  String pass = "";
  bool correct = true;
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

  Future<Resp> loginUser(String user, String pass) async {
    var map = new Map<String, dynamic>();
    map['user'] = user;
    map['pass'] = pass;
    final response = await http.post(
      Uri.https('api.socialcraft.club', 'login'),
      body: map,
    );
    if (response.statusCode == 200) {
      return Resp.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load response');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body:
        GestureDetector(
          onTap: () {
            final FocusScopeNode focus = FocusScope.of(context);
            if (!focus.hasPrimaryFocus && focus.hasFocus) {
              FocusManager.instance.primaryFocus.unfocus();
            }
        },
          child:SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Container(
                          child: Image.asset(socialcraft_logo,
                              width: 100, height: 100),
                        ).cornerRadiusWithClipRRect(16).paddingTop(50),
                        Container(
                          child: Image.asset(socialcraft_logo_letras,
                              width: 300, height: 100),
                        ).cornerRadiusWithClipRRect(16).paddingTop(1),
                      ],
                    ),
                  ),
                  Container(
                    child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(color: Colors.grey[100]),
                            child: TextFormField(
                              cursorColor: azul_logo,
                              focusNode: emailNode,
                              autofocus: false,
                              textInputAction: TextInputAction.next,
                              style: secondaryTextStyle(
                                  color: correct ? Colors.black : Colors.red),
                              onFieldSubmitted: (term) {
                                emailNode.unfocus();
                                FocusScope.of(context).requestFocus(passwordNode);
                              },
                              onChanged: (newValue) {
                                user = newValue;
                                correct = true;
                                setState(() {});
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: (AppLocalizations.of(context).loginNombre),
                                hintStyle: secondaryTextStyle(size: 16),
                              ),
                            ).paddingOnly(left: 8, top: 2),
                          ).cornerRadiusWithClipRRect(12),
                          Container(
                            decoration: BoxDecoration(color: Colors.grey[100]),
                            child: TextFormField(
                              cursorColor: azul_logo,
                              focusNode: passwordNode,
                              autofocus: false,
                              obscureText: showPassword ? false : true,
                              keyboardType: TextInputType.emailAddress,
                              style: secondaryTextStyle(
                                  color: correct ? Colors.black : Colors.red),
                              onChanged: (newValue) {
                                pass = newValue;
                                correct = true;
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    showPassword = !showPassword;
                                    setState(() {});
                                  },
                                  child: Icon(
                                      showPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: azul_logo),
                                ),
                                border: InputBorder.none,
                                hintText: (AppLocalizations.of(context).password),
                                hintStyle: secondaryTextStyle(size: 16),
                              ),
                            ).paddingOnly(left: 8, top: 2),
                          )
                              .cornerRadiusWithClipRRect(12)
                              .paddingOnly(top: 16, bottom: 16),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text((AppLocalizations.of(context).forgotPassword),
                                style: boldTextStyle(color: azul_logo)),
                          ).onTap(() {
                            Navigator.pushNamed(context, "forgotPassword");
                          }),
                        ],
                      ),
                    ),
                  ).paddingTop(32),
                  Container(
                    child: Column(
                      children: [
                        CommonButton((AppLocalizations.of(context).login))
                            .paddingOnly(top: 16, bottom: 16)
                            .onTap(() {
                          if (user == "" || pass == "") {
                            correct = false;
                            setState(() {});
                            toast((AppLocalizations.of(context).rellearCampos), bgColor: toast_color);
                          } else {
                            loginUser(user, pass).then((respuesta) async {
                              if (respuesta.success == false) {
                                correct = false;
                                setState(() {});
                                toast((AppLocalizations.of(context).datosIncorrectos), bgColor: toast_color);
                              } else {
                                final storage = new FlutterSecureStorage();
                                await storage.write(
                                    key: 'jwt', value: respuesta.data['token']);
                                print(respuesta.data['token']);
                                finish(context);
                                Navigator.pushNamed(context, "barra");
                              }
                            });
                          }
                        }),
                        Container(
                          width: context.width(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(google_logo, width: 25, height: 25),
                              Text((AppLocalizations.of(context).google),
                                      style: TextStyle(
                                          color: Color(0xFF757575), fontSize: 16))
                                  .paddingAll(16),
                            ],
                          ).onTap(() {
                            final provider = Provider.of<GoogleSignInProvider>(context,listen: false);
                            provider.login();
                          }),
                        ).cornerRadiusWithClipRRect(12),
                      ],
                    ),
                  ).paddingTop(32),
                  Container(
                    child: createRichText(list: [
                      TextSpan(
                          text: (AppLocalizations.of(context).notReg),
                          style:
                              TextStyle(color: Color(0xFF757575), fontSize: 16)),
                      TextSpan(
                          text: (AppLocalizations.of(context).newAcount),
                          style: boldTextStyle(color: azul_logo)),
                    ]).onTap(() {
                      Navigator.pushNamed(context, "register");
                      setState(() {});
                    }),
                  ).paddingOnly(top: 32, bottom: 32)
                ],
              ),
            ),
          ).paddingOnly(top: 16, left: 16, right: 16),
        ),
      ),
    );
  }
}
