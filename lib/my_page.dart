import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_way/account_setting_screen.dart';

import 'add_screen.dart';
import 'entity/account.dart';
import 'entity/manual.dart';
import 'main.dart';
import 'manual_view.dart';

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

  Account? account;
  List<Manual> manuals = [];

  @override
  void initState(){
    debugPrint("aaa");
    getAccountInfo();
    getManuals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("${account?.accountName}'s Page"),
        actions: [IconButton(onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => AccountSettingScreen(widget.token, account)));
          resend();
        }, icon: const Icon(Icons.settings))]
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          const SizedBox(height: 30,),
          Padding(padding: const EdgeInsets.only(left: 10),child: circle(),),
          const SizedBox(height: 10,),
          Padding(padding: const EdgeInsets.only(left: 20),child: Text(account!.accountName, style: const TextStyle(fontSize: 20),),),
          Padding(padding: const EdgeInsets.only(left: 20),child: Text(account!.introduction)),
          const SizedBox(height: 10,),
          Flexible(
            child: ListView(
              children:manualShow(manuals, context)
            )
          )
        ]
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

  void resend(){
    getAccountInfo();
    getManuals();
  }

  void getAccountInfo() async{
    var response = await http.get(Uri.parse("${MyApp.address}/accounts/${widget.accountId}"));
    var data = json.decode(utf8.decode(response.bodyBytes));
    setState(() {
      account = Account.fromJson(data, widget.token);
    });
  }

  void getManuals() async{
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

  Widget circle(){
    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.yellow
      ),
    );
  }

  List<Widget> manualShow(List<Manual> manuals, context){
    List<Widget> res = [];
    for(Manual manual in manuals){
      res.add(Card(child: ListTile(title: Text(manual.title), onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ManualScreen(manual)));
      })));
    }
    return res;
  }

}