import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialcraft/utils/widgets.dart';
import 'package:socialcraft/utils/fonts.dart';
import 'package:socialcraft/utils/widgets.dart';
import 'package:socialcraft/utils/images.dart';
import 'package:socialcraft/utils/fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:smart_select/smart_select.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Materiales extends StatefulWidget {
  static String tag = '/materiales';

  @override
  MaterialesState createState() => MaterialesState();
}

class MaterialesState extends State<Materiales> {
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

  final controller = TextEditingController(text: "");
/*
  void addItemToList() {
    setState(() {
      a.insert(0, nameController.text);
      msgCount.insert(0, 0);
    });
  }
  */
  String material = "";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).materiales),
          backgroundColor: azul_logo,
          leading: Icon(Icons.arrow_back).onTap(() {
            Navigator.pop(context, b);
            a.clear();
            b = "";
            //finish(context);
            //Navigator
          }),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              30.height,
              Text(
                AppLocalizations.of(context).anadirLosMateriales,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ).paddingLeft(15),
              20.height,
              Row(
                children: [
                  Container(
                    width: 270,
                    decoration: BoxDecoration(color: Colors.grey[100]),
                    child: TextFormField(
                      controller: controller,
                      cursorColor: azul_logo,
                      autofocus: false,
                      textInputAction: TextInputAction.next,
                      style: secondaryTextStyle(color: Colors.black),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: AppLocalizations.of(context).escribeElMaterial,
                        hintStyle: secondaryTextStyle(size: 16),
                      ),
                      onChanged: (newValue) {
                        material = newValue;
                        setState(() {});
                      },
                    ).paddingOnly(left: 8, top: 2),
                  ).cornerRadiusWithClipRRect(12).paddingLeft(15),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      tooltip: 'x',
                      onPressed: () {
                        if (a.length < 15 && material.length > 0) {
                          if (!a.contains(material)) {
                            controller.clear();
                            if (b == "") {
                              b += material;
                            } else {
                              b += ", " + material;
                            }
                            a.insert(0, material);
                            setState(() {});
                          }
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: 'y',
                    onPressed: () {
                      a.clear();
                      b = "";
                      setState(() {});
                    },
                  ),
                ],
              ),
              10.height,
              Divider(
                height: 20,
                thickness: 3,
                indent: 20,
                endIndent: 20,
              ),
              20.height,
              Column(
                children: <Widget>[
                  for (var item in a)
                    CommonButton(item)
                        .paddingOnly(left: 20, right: 20, top: 5, bottom: 5),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<String> a = [];
String b = "";
