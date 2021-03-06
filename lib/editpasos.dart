import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialcraft/materiales.dart';
import 'package:socialcraft/utils/widgets.dart';
import 'package:socialcraft/utils/fonts.dart';
import 'package:socialcraft/utils/widgets.dart';
import 'package:socialcraft/utils/images.dart';
import 'package:socialcraft/utils/fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:smart_select/smart_select.dart';
import 'package:im_stepper/main.dart';
import 'package:im_stepper/stepper.dart';
import 'package:socialcraft/resp.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class editpasos extends StatefulWidget {
  static String tag = '/upload';
  final String idPost;
  List<dynamic> pasos2 = [];
  editpasos(this.idPost, this.pasos2);
  @override
  editpasosState createState() => editpasosState();
}

class editpasosState extends State<editpasos> {
  @override
  void initState() {
    super.initState();
    init();
  }

  String tutId = '';
  List<dynamic> pasos = [];
  String token = "";

  init() async {
    tutId = widget.idPost;
    pasos = widget.pasos2;
    final storage2 = new FlutterSecureStorage();
    token = await storage2.read(key: 'jwt');
    for (int i = 1; i <= pasos.length; i++) {
      numb.add(i);
    }
    upperBound = pasos.length;
    controller2.text = pasos[activeStep]['Texto'];
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  String fotopasoeditar = "";

  int activeStep = 0;
  final controller2 = TextEditingController(text: "");

  int upperBound;
  List<int> numb = [];
  List<String> textos = ["", "", "", "", "", "", "", "", "", ""];
  List<bool> cambioFoto = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  List<String> descripciones = [
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " "
  ];
  List<PickedFile> imagenes = [
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null
  ];

  var mapfoto = Map<String, dynamic>();

  Future<Resp> subirPasos(String id, int numeropaso) async {
    await subirfotopaso(tutId.toInt(), (numeropaso + 1));
    var map3 = new Map<String, dynamic>();
    map3['IdPaso'] = id;
    map3['NumPaso'] = numeropaso.toString();
    if (descripciones[numeropaso] != " ")
      map3['Text'] = descripciones[numeropaso];
    if (fotopasoeditar != null) map3['RutaFoto'] = fotopasoeditar;
    if (cambioFoto[numeropaso]) {
      map3['RutaFoto'] = "";
    }

    final response = await http.post(
      Uri.https('api.socialcraft.club', 'tutorials/editStep'),
      body: map3,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print(response.body);

      return Resp.fromJson2(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load response');
    }
  }

  Future subirfotopaso(int x, int idpaso) async {
    if (imagenes[idpaso - 1] != null) {
      final _firebaseStorage = FirebaseStorage.instance;
      var file = File(imagenes[idpaso - 1].path);
      await _firebaseStorage
          .ref()
          .child('Posts/' + x.toString() + '/paso' + idpaso.toString())
          .putFile(file);
      var ref = FirebaseStorage.instance
          .ref()
          .child('Posts/' + x.toString() + '/paso' + idpaso.toString());
      fotopasoeditar = (await ref.getDownloadURL()).toString();
      Future a;
      return a;
    } else {
      fotopasoeditar = null;
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).editarPasos),
        backgroundColor: azul_logo,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: OutlinedButton.icon(
              label: Text(AppLocalizations.of(context).editar,
                  style: primaryTextStyle(color: Colors.white)),
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                side: BorderSide(color: Colors.white, width: 1.5),
              ),
              icon: Icon(Icons.cloud_upload_outlined),
              onPressed: () async {
                for (int i = 0; i < upperBound; i++) {
                  subirPasos(pasos[i]['Id'], i);
                }
                Navigator.pop(context);

                toast(AppLocalizations.of(context).pasosEditadosCorrecamente,
                    bgColor: toast_color);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              NumberStepper(
                numbers: numb,

                // activeStep property set to activeStep variable defined above.
                activeStep: activeStep,

                // This ensures step-tapping updates the activeStep.
                onStepReached: (index) {
                  setState(() {
                    activeStep = index;
                    controller2.text = pasos[activeStep]['Texto'];
                  });
                },
              ),
              30.height,
              header(),
              //Text((activeStep + 1).toString()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [],
              ),
              20.height,
              ElevatedButton(
                child: Text(AppLocalizations.of(context).seleccionaImagen),
                style: ElevatedButton.styleFrom(
                  //minimumSize: Size(150, 40),
                  //primary: Colors.lightBlueAccent[200],
                  primary: azul_logo,
                  onPrimary: Colors.white,
                  onSurface: Colors.grey,
                ),
                onPressed: () async {
                  imagenes[activeStep] =
                      await ImagePicker().getImage(source: ImageSource.gallery);
                },
              ),
              16.height,
              IconButton(
                  icon: Icon(Icons.delete),
                  iconSize: 35,
                  color: Colors.redAccent[200],
                  onPressed: () async {
                    imagenes[activeStep] = null;
                    cambioFoto[activeStep] = true;
                  }),
            ],
          ),
        ),
      ),
    ));
  }

  /// Returns the header wrapping the header text.
  Widget header() {
    return Column(
      children: [
        /*
        Container(
          decoration: BoxDecoration(color: Colors.grey[300]),
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.name,
            cursorColor: azul_logo,
            decoration: InputDecoration(
              //icon: Icon(Icons.search, color: azul_logo),
              border: InputBorder.none,
              hintText: 'Step ' + (activeStep + 1).toString(),
            ),
            onChanged: (newValue) {
              textos[activeStep] = newValue;
            },
          ).paddingLeft(10),
        )
            .cornerRadiusWithClipRRect(12)
            .paddingOnly(top: 30, left: 30, right: 30),*/
        Container(
          decoration: BoxDecoration(color: Colors.grey[300]),
          child: TextFormField(
            controller: controller2,
            keyboardType: TextInputType.name,
            cursorColor: azul_logo,
            maxLines: 10,
            decoration: InputDecoration(
              //icon: Icon(Icons.search, color: azul_logo),
              border: InputBorder.none,
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              hintText: AppLocalizations.of(context).anadeUnaDescripcion,
            ),
            onChanged: (newValue) {
              descripciones[activeStep] = newValue;
            },
          ).paddingLeft(10),
        )
            .cornerRadiusWithClipRRect(12)
            .paddingOnly(top: 30, left: 30, right: 30),
      ],
    );
  }

  // Returns the header text based on the activeStep.
  String headerText() {
    switch (activeStep) {
      case 1:
        return 'Preface';

      case 2:
        return 'Table of Contents';

      case 3:
        return 'About the Author';

      case 4:
        return 'Publisher Information';

      case 5:
        return 'Reviews';

      case 6:
        return 'Chapters #1';

      default:
        return 'Introduction';
    }
  }
}
