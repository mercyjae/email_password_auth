import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_authentication/model/user_model.dart';
import 'package:email_password_authentication/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
    .collection("users")
    .doc(user!.uid)
    .get()
    .then((value){
    this.loggedInUser = UserModel.fromMap(value.data());
    setState(() {
    });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(backgroundColor: Colors.purple,
      title: Text("Welcome",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
      centerTitle: true,),
        body:Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Image.asset("assets/images/bmilogo.png"),
              Text("Welcome Back",style: TextStyle(fontWeight:FontWeight.bold,color: Colors.black),),
              SizedBox(height: 10,),
              Text("${loggedInUser.firstName} ${loggedInUser.secondName}"),
              SizedBox(height: 5,),
              Text("${loggedInUser.email}"),
              SizedBox(height: 15,),
              ActionChip(label: Text("LogOut",style: TextStyle(fontWeight: FontWeight.bold),),
                  onPressed: (){
                logout(context);
                  })

            ],),
        ));
  }

  Future<void> logout(BuildContext context)async{
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LogIn()));
  }
}
