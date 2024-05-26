
import 'dart:convert';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'main.dart';

class AddScreen extends StatefulWidget{

  String token;
  String accountId;

  AddScreen(this.token, this.accountId, {super.key});

  @override
  State<StatefulWidget> createState() {
    return AddScreenState();
  }

}

class AddScreenState extends State<AddScreen>{

  TextEditingController titleController = TextEditingController();
  
  
  List<Widget> steps = [];


  List<TextEditingController> stepTitleControllers = [];
  List<String> stepTitles = [];
  List<TextEditingController> stepDetailControllers = [];


  int stepNum = 0;

  @override
  void initState() {
    super.initState();
    steps.add(
      ElevatedButton(
        onPressed: addStep,
        child: const Text("ステップ追加")
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Create New Manual"),
      ),
      body:Center(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            titleForm(),
            const SizedBox(height: 40,),
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index){
                  return steps[index];
                },
                itemCount: steps.length,
              )
            ),
            ElevatedButton(onPressed: ()async {
              await postManuals();
              Navigator.pop(context);
              }, child: const Text("確定"))
          ],
        )
      )
    );
  }

  void addStep(){
    TextEditingController titleController = TextEditingController();
    TextEditingController detailController = TextEditingController();
    stepTitles.add("step");
    stepTitleControllers.add(titleController);
    stepDetailControllers.add(detailController);
    setState(() {
      steps.insert(stepNum, stepForm(stepNum, titleController, detailController));
    });
    stepNum += 1;
  }

  Widget stepForm(int i, TextEditingController titleController, TextEditingController detailController){
    return Card(
        child: ExpandablePanel(
          header: SizedBox(
            height: 50,
            child: Padding(
                padding: const EdgeInsets.only(left: 2, top: 10, bottom: 5),
                child: stepTitleForm(i, titleController)
            )
        ),
          collapsed: Container(),
          expanded: Column(
            children: [
              stepDetailForm(detailController),
              const SizedBox(height: 10,),
            ],
          ),
      )
    );
  }

  Future<void> postManuals() async {
    List<Map<String, dynamic>> steps = [];
    for(int i = 0; i < stepNum; i++){
      steps.add(
        {
          "stepNum": i,
          "title": stepTitleControllers[i].text,
          "detail": stepDetailControllers[i].text
        }
      );
    }
    Map<String, dynamic> data = {
      "title": titleController.text,
      "steps": steps
    };
    var jsonText = json.encode(data);
    var response = await http.post(Uri.parse("${MyApp.address}/accounts/${widget.accountId}/manuals"),
      headers: {"Authorization": widget.token, "Content-Type": "application/json"}, body: jsonText,);
  }

  Widget stepTitleForm(int i, TextEditingController titleController){
    titleController.text = "step$i";
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          controller: titleController,
          decoration: const InputDecoration(hintText: "title"),
        )
    );
  }

  Widget stepDetailForm(TextEditingController detailController){
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: detailController,
          decoration: const InputDecoration(hintText: "detail"),
        )
    );
  }
  
  Widget titleForm(){
   return Padding(
     padding: const EdgeInsets.symmetric(horizontal: 20),
    child: TextField(
          controller: titleController,
          decoration: const InputDecoration(hintText: "Manual title"),
    )
   );
  }

}
