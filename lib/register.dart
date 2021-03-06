// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialcraft/resp.dart';
import 'package:socialcraft/utils/fonts.dart';
import 'package:socialcraft/utils/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:socialcraft/utils/images.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() => runApp(Register());
FocusNode nameNode;

class Register extends StatefulWidget {
  @override
  RegisterW createState() => RegisterW();
}
class RegisterW extends State<Register> {

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

  Future<Resp> registerUser(
      String user, String name, String mail, String city, String pwd) async {
    var map = new Map<String, dynamic>();
    map['name'] = name;
    map['userName'] = user;
    map['email'] = mail;
    map['city'] = city;
    map['password'] = pwd;
    final response = await http.post(
      Uri.https('api.socialcraft.club', 'register'),
      body: map,
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return Resp.fromJson2(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load response');
    }
  }

  String name = "";
  String user = "";
  String pwd = "";
  String pwd2 = "";
  String mail = "";
  String city = "";
  bool correct = true;
  bool correctMail = true;
  bool wrongName = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: azul_logo),
          backgroundColor: Colors.white,
          //appStore.cardColor,
          //iconTheme: IconThemeData(color: appStore.isDarkModeOn ? appBarBackgroundColor : scaffoldColorDark),
          elevation: 0,
          leading: Icon(Icons.arrow_back).onTap(() {
            finish(context);
          }),
        ),
        body: GestureDetector(
          onTap: () {
            final FocusScopeNode focus = FocusScope.of(context);
            if (!focus.hasPrimaryFocus && focus.hasFocus) {
              FocusManager.instance.primaryFocus.unfocus();
            }
          },
          child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: [
                              Container(
                                child: Image.asset(socialcraft_logo,
                                    width: 100, height: 100),
                              ).cornerRadiusWithClipRRect(16).paddingTop(5),
                              Container(
                                child: Image.asset(socialcraft_logo_letras,
                                    width: 300, height: 100),
                              ).cornerRadiusWithClipRRect(16).paddingTop(1),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(color: Colors.grey[100]),
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            cursorColor: azul_logo,
                            decoration: InputDecoration(
                              icon: Icon(Icons.portrait, color: azul_logo),
                              border: InputBorder.none,
                              hintText: AppLocalizations.of(context).nombre,
                            ),
                            onChanged: (texto) {
                              name = texto;
                            },
                          ).paddingOnly(left: 8, top: 2),
                        ).cornerRadiusWithClipRRect(12).paddingOnly(bottom: 8),
                        Container(
                          decoration: BoxDecoration(color: Colors.grey[100]),
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            cursorColor: azul_logo,
                            decoration: InputDecoration(
                              icon: Icon(Icons.person, color: wrongName ? Colors.red[600] : azul_logo),
                              border: InputBorder.none,
                              hintText: AppLocalizations.of(context).nombreDeUsuario,
                            ),
                            onChanged: (texto) {
                              user = texto;
                            },
                          ).paddingOnly(left: 8, top: 2),
                        )
                            .cornerRadiusWithClipRRect(12)
                            .paddingOnly(top: 8, bottom: 8),
                        Container(
                          decoration: BoxDecoration(color: Colors.grey[100]),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            cursorColor: azul_logo,
                            decoration: InputDecoration(
                              icon: Icon(Icons.lock, color: azul_logo),
                              border: InputBorder.none,
                              hintText: AppLocalizations.of(context).password,
                            ),
                            obscureText: true,
                            onChanged: (texto) {
                              pwd = texto;
                            },
                          ).paddingOnly(left: 8, top: 2),
                        )
                            .cornerRadiusWithClipRRect(12)
                            .paddingOnly(top: 8, bottom: 8),
                        Container(
                          decoration: BoxDecoration(color: Colors.grey[100]),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            cursorColor: azul_logo,
                            decoration: InputDecoration(
                              icon: Icon(
                                  Icons.lock, color: correct ? azul_logo : Colors.red[600]),
                              border: InputBorder.none,
                              hintText: AppLocalizations.of(context).repetirContrasena,
                            ),
                            obscureText: true,
                            onChanged: (texto) {
                              pwd2 = texto;
                            },
                          ).paddingOnly(left: 8, top: 2),
                        )
                            .cornerRadiusWithClipRRect(12)
                            .paddingOnly(top: 8, bottom: 8),
                        Container(
                          decoration: BoxDecoration(color: Colors.grey[100]),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: azul_logo,
                            decoration: InputDecoration(
                              icon: Icon(Icons.email, color: correctMail ? azul_logo : Colors.red[600]),
                              border: InputBorder.none,
                              hintText: AppLocalizations.of(context).email,
                            ),
                            onChanged: (texto) {
                              mail = texto;
                            },
                          ).paddingOnly(left: 8, top: 2),
                        )
                            .cornerRadiusWithClipRRect(12)
                            .paddingOnly(top: 8, bottom: 8),
                        Container(
                          decoration: BoxDecoration(color: Colors.grey[100]),
                          child: TextFormField(
                            keyboardType: TextInputType.streetAddress,
                            cursorColor: azul_logo,
                            decoration: InputDecoration(
                              icon: Icon(Icons.location_on, color: azul_logo),
                              border: InputBorder.none,
                              hintText: AppLocalizations.of(context).ciudad,
                            ),
                            onChanged: (texto) {
                              city = texto;
                            },
                          ).paddingOnly(left: 8, top: 2),
                        )
                            .cornerRadiusWithClipRRect(12)
                            .paddingOnly(top: 8, bottom: 8),
                        Container(
                          child: CommonButton(AppLocalizations.of(context).newAcount)
                              .paddingOnly(top: 16, bottom: 16)
                              .onTap(
                            () {
                              if(user.length < 3 || user.contains('/')){
                                wrongName= true;
                                setState(() {});
                                if(user.length < 3) {
                                  toast(
                                      AppLocalizations.of(context).caracterNoPermitido,
                                          bgColor: toast_color);
                                }
                                else {
                                  toast(
                                      AppLocalizations.of(context).minimoDeCaracters,
                                      bgColor: toast_color);
                                }
                              }
                              else{
                                wrongName= false;
                                setState(() {});
                              }
                              if(pwd == pwd2){
                                correct = true;
                                setState(() {});
                              }
                              else {
                                correct = false;
                                setState(() {});
                                toast(AppLocalizations.of(context).contrasenaNoCoinciden, bgColor: toast_color);
                              }
                              if(mail.validateEmail()){
                                correctMail=true;
                                setState(() {});
                              }
                              if(mail.isNotEmpty & !mail.validateEmail()){
                                correctMail=false;
                                setState(() {});
                                toast(AppLocalizations.of(context).emailIncorrecto, bgColor: toast_color);
                              }
                              if(user.isNotEmpty & name.isNotEmpty & pwd.isNotEmpty & pwd2.isNotEmpty  & mail.isNotEmpty & city.isNotEmpty){
                                if(correct & correctMail & (user.length >= 3)){
                                  //enviar la info a la base de datos
                                  registerUser(user, name, mail, city, pwd)
                                       .then((answer){
                                  Navigator.pushNamed(context, "login");
                                  },
                                );
                              }
                            }
                              else{
                                toast(AppLocalizations.of(context).rellearCampos, bgColor: toast_color);
                            }
                          },
                        ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
