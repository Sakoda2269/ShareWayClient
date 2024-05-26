import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_way/signup.dart';

import 'home.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static String address = "http://192.168.3.50:8000";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShareWay',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'NotoSansJP'
      ),
      home: const MyHomePage(title: 'Share Way login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String message = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child:SingleChildScrollView(
          child: Column(
            children: [
              const Text("Login", style: TextStyle(fontSize: 30),),
              const SizedBox(height: 20,),
              Text(message, style: const TextStyle(fontSize: 15, color: Colors.red),),
              const SizedBox(height: 50),
              emailForm(),
              const SizedBox(height: 30,),
              passwordForm(),
              const SizedBox(height: 100,),
              ElevatedButton(onPressed: login, child: const Text("Login")),
              ElevatedButton(onPressed:() async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
                setState(() {
                  emailController.text = "";
                  passwordController.text = "";
                  message = "";
                });

              }, child: const Text("Sign up")),
            ],
          )
        )
      )
    );
  }

  void login() async{
    var response = await http.post(Uri.parse("${MyApp.address}/accounts/login"),
      body: {"email": emailController.text, "password": passwordController.text},
    );
    if(response.statusCode == 200){
      String? token = response.headers["x-auth-token"];
      String? accountId = response.headers["id"];
      debugPrint(response.statusCode.toString());
      if(token != null && accountId != null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
            Home(token, accountId)));
      }

    } else{
      setState(() {
        message = "メールアドレスまたはパスワードが違います";
      });
    }
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

}
