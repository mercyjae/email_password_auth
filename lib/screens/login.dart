
import 'package:email_password_authentication/screens/signup.dart';
import 'package:email_password_authentication/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Form(
        key: formKey,
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/bmilogo.png"),
            TextFormField(
              autofocus: false,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value){
                if(value!.isEmpty){
                  return("Please Enter Your Email");
                }
                if( !RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                  return("Please Enter a valid email");
                }
                return null;
              },
              onSaved: (value){
                emailController.text=value!;
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(hintText: "Email",prefixIcon: Icon(Icons.mail),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),),
            SizedBox(height: 17,),
            TextFormField(autofocus: false,
              obscureText: true,
              controller: passwordController,
              validator: (value){
              RegExp regex = RegExp(r"^.{6,}$");
              if (value!.isEmpty){
                return ("Password is required for login");
              }
              if (!regex.hasMatch(value)){
                return ("Enter Valid Password(Min.6 Character)");
              }
              },
              onSaved: (value){
                passwordController.text=value!;
              },
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(hintText: "Password",prefixIcon: Icon(Icons.vpn_key),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),),
            SizedBox(height: 17,),
            Material(borderRadius: BorderRadius.circular(17),color: Colors.red,
              child: MaterialButton(minWidth: 350,
                onPressed: (){signIn(emailController.text, passwordController.text);},
                child: Text("Login",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),),),
            SizedBox(height: 10,),
            Center(
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don\'t have an account?",style:  TextStyle(fontWeight: FontWeight.bold),),
                  InkWell(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));},
                      child: Text("SignUp",style:  TextStyle(color: Colors.red,fontWeight: FontWeight.bold)))
                ],),
            )
          ],),
      ),
    ),);
  }

  void signIn(String email, String password)async{
    if(formKey.currentState!.validate()){
      await auth.signInWithEmailAndPassword(email: email, password: password).then((uid) => {
        Fluttertoast.showToast(msg: "Login Successful"),
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>WelcomeScreen()))
      }).catchError((e){
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }
}

