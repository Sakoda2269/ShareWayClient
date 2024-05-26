import 'dart:ui';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'entity/account.dart';
import 'main.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class AccountSettingScreen extends StatefulWidget{

  String token;
  Account? account;

  AccountSettingScreen(this.token,this.account, {super.key});

  @override
  State<StatefulWidget> createState() {
    return AccountSettingScreenState();
  }

}

class AccountSettingScreenState extends State<AccountSettingScreen>{

  TextEditingController nameController = TextEditingController();
  TextEditingController introController = TextEditingController();

  late File _file;
  final _picker = ImagePicker();

  @override
  void initState(){
    nameController.text = widget.account!.accountName;
    introController.text = widget.account!.introduction;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("${widget.account?.accountName}'s Page"),
      ),
      body:SingleChildScrollView(
        child: Column(
        children: [
          const SizedBox(height: 10,),
          Padding(padding: const EdgeInsets.only(left: 10),child: circle(),),
          const SizedBox(height: 20,),
          nameField(),
          const SizedBox(height: 20,),
          introField(),
          const SizedBox(height: 30,),
          ElevatedButton(onPressed: putAccountData, child: const Text("確定"))
        ],
      ),
    ));
  }

  void putAccountData() async {
    await http.put(
      Uri.parse("${MyApp.address}/accounts/${widget.account?.accountId}"),
      headers: {"Authorization": widget.token},
      body: {"account_name": nameController.text, "introduction": introController.text}
    );
    Navigator.pop(context);
  }

  Widget circle(){
    return SizedBox( height: 120,
      child:Stack(
        children: [
          Container(),
          Center(child: Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.yellow
            ),
          )),
          Positioned(
            top: 70,
            left: 200,
            child: ElevatedButton(
              onPressed: () async {
                await selectImage();
                await _cropImage();
                await sendImage();
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(
                  side: BorderSide(
                    color: Colors.black,
                    width: 1,
                    style: BorderStyle.solid,
                  )
                )
              ),
              child: const Icon(Icons.add),
            )
          ),
        ],
      )
    );
  }

  Future selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _file = File(image!.path);
    });
  }

  Future _cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _file!.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
        CropAspectRatioPreset.square,
      ]
          : [
        CropAspectRatioPreset.square,
      ],
    );
    setState(() {
      _file = File(croppedFile!.path);
    });
  }

  Future sendImage() async {
    final request =  http.MultipartRequest(
      "PUT",
      Uri.parse("${MyApp.address}/accounts/${widget.account!.accountId}/icon"),
    );
    request.files.add(http.MultipartFile.fromBytes("new_icon", _file.readAsBytesSync()));
    request.headers["Authorization"] = widget.token;
    final res = await request.send();
    debugPrint(res.statusCode.toString());
  }

  Widget nameField(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(controller: nameController, decoration: const InputDecoration(
        labelText: "Name"
      ),)
    );
  }

  Widget introField(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        decoration: const InputDecoration(
          labelText: "introduction"
        ),
        controller: introController,
        keyboardType: TextInputType.multiline,
        maxLines: null,
      )
    );
  }

}