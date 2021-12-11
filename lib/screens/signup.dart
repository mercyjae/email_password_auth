import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_authentication/model/user_model.dart';
import 'package:email_password_authentication/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  final firstNameEditingController = TextEditingController();
  final  secondNameEditingController = TextEditingController();
  final  emailEditingController = TextEditingController();
  final  passwordEditingController = TextEditingController();
  final  confirmPasswordEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold( body:
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Form(key: formKey,
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/bmilogo.png"),
                TextFormField(autofocus: false,
                  controller: firstNameEditingController,
                  keyboardType: TextInputType.name,
                  validator: (value){
                    RegExp regex = RegExp(r"^.{3,}$");
                    if (value!.isEmpty){
                      return ("First Name cannot be empty");
                    }
                    if (!regex.hasMatch(value)){
                      return ("Enter Valid Name(Min.3 Character)");
                    }
                    return null;
                  },
                  onSaved: (value){
                    firstNameEditingController.text=value!;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(hintText: "First Name",prefixIcon: Icon(Icons.account_circle),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),),
                SizedBox(height: 17,),
                TextFormField(
                  autofocus: false,
                  controller: secondNameEditingController,
                  keyboardType: TextInputType.name,
                  validator: (value){
                    RegExp regex = RegExp(r"^.{3,}$");
                    if (value!.isEmpty){
                      return ("Second Name cannot be empty");
                    }
                    return null;
                  },
                  onSaved: (value){
                    secondNameEditingController.text=value!;
                  },
                  textInputAction: TextInputAction.next,decoration: InputDecoration(hintText: "Second Name",prefixIcon: Icon(Icons.account_circle),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),),
                SizedBox(height: 17,),
                TextFormField(
                  autofocus: false,
                  controller: emailEditingController,
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
                    emailEditingController.text=value!;
                  },
                  textInputAction: TextInputAction.next,decoration: InputDecoration(hintText: "Email",prefixIcon: Icon(Icons.mail),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),),
                SizedBox(height: 17,),
                TextFormField(
                  obscureText: true,
                  autofocus: false,
                  controller: passwordEditingController,
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
                    passwordEditingController.text=value!;
                  },
                  textInputAction: TextInputAction.next,decoration: InputDecoration(hintText: "Password",prefixIcon: Icon(Icons.vpn_key),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),),
                SizedBox(height: 17,),
                TextFormField(
                  obscureText: true,
                  autofocus: false,
                  controller: confirmPasswordEditingController,
                  validator:(value){
                    if(confirmPasswordEditingController.text !=
                    passwordEditingController.text){
                      return "Password dont match";
                    }
                    return null;
                  },
                  onSaved: (value){
                    confirmPasswordEditingController.text=value!;
                  },
                  textInputAction: TextInputAction.done,decoration: InputDecoration(hintText: "Confirm Password",prefixIcon: Icon(Icons.vpn_key),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),),
                SizedBox(height: 17,),
                Material(borderRadius: BorderRadius.circular(17),color: Colors.red,
                  child: MaterialButton(minWidth: 350,
                    onPressed: (){
                    signUp(emailEditingController.text, passwordEditingController.text);
                    },
                    child: Text("SignUp",
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),),),
                ],),
          ),
        ),
      ),),
    );
  }
  void signUp(String email, String password) async{
    if (formKey.currentState!.validate()){
      await auth.createUserWithEmailAndPassword(email: email, password: password)
          .then((value) =>{postDetailsToFirestore()}).
      catchError((e)
      {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }
  postDetailsToFirestore()async {

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;
    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameEditingController.text;
    userModel.secondName = secondNameEditingController.text;

    await firebaseFirestore
    .collection("users")
    .doc(user.uid)
    .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully");
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>
        WelcomeScreen()),(route) => false);
  }
}

