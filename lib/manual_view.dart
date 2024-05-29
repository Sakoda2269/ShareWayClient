

import 'dart:typed_data';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'entity/manual.dart';
import 'entity/step.dart' as s;

class ManualScreen extends StatefulWidget{
  
  Manual manual;
  
  ManualScreen(this.manual, {super.key});
  
  @override
  State<StatefulWidget> createState() {
    return ManualState();
  }
  
}

class ManualState extends State<ManualScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.manual.title),),
      body: Column(children: [
        Text("作成者 : ${widget.manual.accountName}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 40,),
        Expanded(child: ListView(children: stepsShow(widget.manual.steps),))
      ],)
      );
  }
  
  List<Widget> stepsShow(List<s.Step> steps){
    List<Widget> res = [];
    for(s.Step step in steps){
      // res.add(Card(child: ListTile(title: Text("${step.stepNum + 1}: ${step.title}"))));

      res.add(
          Card(
            child: ExpandablePanel(
              header: SizedBox(
                  height: 50,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 30, top: 10),
                      child: Text("${step.stepNum + 1}: ${step.title}", style: const TextStyle(fontSize: 20),)
                  )
              ),
              collapsed: Container(),
              expanded:
                Column(
                  children: [
                    thumbnailFile(step.image),
                    Padding(
                      padding:const EdgeInsets.only(left: 30),
                      child: Text("\n${step.detail}\n", style: const TextStyle(fontSize: 16), )
                    ),
                  ],
                )
            ),
          ),
      );
    }
    return res;
  }
  Widget thumbnailFile(Uint8List? image){
    if(image != null){
      return Image.memory(image);
    }else{
      return Container();
    }
  }

  
}