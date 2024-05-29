import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_way/account_setting_screen.dart';

import 'add_screen.dart';
import 'entity/account.dart';
import 'entity/manual.dart';
import 'main.dart';
import 'manual_view.dart';

import 'dart:io';

class MyPageScreen extends StatefulWidget{

  String token;
  String accountId;


  MyPageScreen(this.token ,this.accountId, {super.key});

  @override
  State<StatefulWidget> createState() {
    return MyPageState();
  }

}

class MyPageState extends State<MyPageScreen>{

  late Account account;
  List<Manual> manuals = [];

  Uint8List? image;

  @override
  void initState() {
    account = Account("","","", "", "");
    getAccountInfo();
    getManuals();
    getImage();
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> screen = accountInfo();
    screen.add(Flexible(
        child: ListView(
            children:manualShow(manuals, context)
        )
      )
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("${account?.accountName}'s Page"),
        actions: settingButton()
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:screen
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: ()async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => AddScreen(widget.token, widget.accountId)));
          resend();
        }
      ),
    );
  }

  List<Widget> accountInfo(){
    return [
      const SizedBox(height: 30,),
      Padding(padding: const EdgeInsets.only(left: 10),child: circle(),),
      const SizedBox(height: 10,),
      Padding(padding: const EdgeInsets.only(left: 20),child: Text(account!.accountName, style: const TextStyle(fontSize: 20),),),
      Padding(padding: const EdgeInsets.only(left: 20),child: Text(account!.introduction)),
      const SizedBox(height: 10,),
    ];
  }

  List<Widget>? settingButton(){
    if(widget.accountId == account.accountId){
      return [IconButton(onPressed: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) => AccountSettingScreen(widget.token, account, image)));
        resend();
      }, icon: const Icon(Icons.settings))];
    }
    return null;
  }

  void resend() async {
    await getAccountInfo();
    await getImage();
    await getManuals();
  }

  Future getAccountInfo() async{
    var response = await http.get(Uri.parse("${MyApp.address}/accounts/${widget.accountId}"));
    var data = json.decode(utf8.decode(response.bodyBytes));
    setState(() {
      account.fromJson(data);
    });
  }

  Future getManuals() async{
    var response = await http.get(
      Uri.parse("${MyApp.address}/accounts/${widget.accountId}/manuals"),
      headers: {"Authorization": widget.token},
    );
    Map<String, dynamic> manualsJson = json.decode(utf8.decode(response.bodyBytes));
    List<Manual> tmp = [];
    for(String manualId in manualsJson.keys){
      Manual m = Manual.fromJson(manualId, manualsJson[manualId]);
      tmp.add(m);
    }
    setState(() {
      manuals = tmp;
    });
  }

  Future getImage() async {
    var response = await http.get(Uri.parse("${MyApp.address}/accounts/${widget.accountId}/icon"));
    setState(() {
      image = response.bodyBytes;
    });
  }

  Widget circle(){
    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.yellow
      ),
      child: imageFile(),
    );
  }

  Widget? imageFile(){
    if(image != null){
      return CircleAvatar(
        backgroundColor: Colors.blue,
        backgroundImage: MemoryImage(image!),
      );
    }else{
      return null;
    }
  }

  Widget thumbnailFile(Uint8List? image){
    if(image != null){
      return Image.memory(image);
    }else{
      return Container();
    }
  }

  List<Widget> manualShow(List<Manual> manuals, context){
    List<Widget> res = [];
    for(Manual manual in manuals){
      res.add(Card(
          child: ListTile(
            title: Column(
              children: [
                Text(manual.title),
                thumbnailFile(manual.thumbnail),
              ],
            ),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ManualScreen(manual)));
            }
          )
        )
      );
    }
    return res;
  }

}