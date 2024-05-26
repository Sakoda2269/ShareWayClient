
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class SignupScreen extends StatefulWidget{
  const SignupScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return SignupScreenState();
  }

}

class SignupScreenState extends State{

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordAgainController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  String message = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Share Way Signup"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child:SingleChildScrollView(
          child: Column(
            children: [
              const Text("Signup", style: TextStyle(fontSize: 30),),
              const SizedBox(height: 10,),
              Text(message, style: const TextStyle(fontSize: 15, color: Colors.red),),
              const SizedBox(height: 40),
              nameForm(),
              const SizedBox(height: 20,),
              emailForm(),
              const SizedBox(height: 20,),
              passwordForm(),
              const SizedBox(height: 20,),
              passwordAgainForm(),
              const SizedBox(height: 50,),
              ElevatedButton(onPressed: signup, child: const Text("signup"))
            ],
          )
      ),
    )
    );
  }

  void signup() async {
    if(!(nameController.text.isNotEmpty && emailController.text.isNotEmpty &&
    passwordController.text.isNotEmpty && passwordAgainController.text.isNotEmpty)){
      setState(() {
        message = "フォームをすべて埋めてください";
      });
      return;
    }
    if(passwordController.text != passwordAgainController.text){
      setState(() {
        message = "パスワードが一致しません";
        return;
      });
    }
    var response = await http.post(Uri.parse("${MyApp.address}/accounts/signup"),
      body: {"email": emailController.text, "password": passwordController.text, "name": nameController.text},
    );
    Navigator.pop(context);
  }

  Widget nameForm(){
    return SizedBox(
      width: 300,
      child: TextField(
        controller: nameController,
        decoration: const InputDecoration(hintText: "name"),
      )
    );
  }

  Widget emailForm(){
    return SizedBox(
        width: 300,
        child: TextField(
          controller: emailController,
          decoration: const InputDecoration(hintText: "email"),
        )
    );
  }

  Widget passwordForm(){
    return SizedBox(
        width: 300,
        child: TextField(
          controller: passwordController,
          decoration: const InputDecoration(hintText: "password"),
          obscureText: true,
        )
    );
  }

  Widget passwordAgainForm(){
    return SizedBox(
        width: 300,
        child: TextField(
          controller: passwordAgainController,
          decoration: const InputDecoration(hintText: "password again"),
          obscureText: true,
        )
    );
  }

}
