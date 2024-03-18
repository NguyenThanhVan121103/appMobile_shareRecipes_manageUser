
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_gourmet/homePage.dart';
import 'package:da_gourmet/utils_and_reusable_widget/reusable_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:da_gourmet/utils_and_reusable_widget/color_util.dart';
import '';



class SignUpScreen extends StatefulWidget{
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();


}

class _SignUpScreenState extends State<SignUpScreen> {

  CollectionReference collRef= FirebaseFirestore.instance.collection('account_users');

  TextEditingController _NameUser = TextEditingController();
  TextEditingController _EmailUser = TextEditingController();
  TextEditingController _PasswoodUser = TextEditingController();


  @override
  void SaveRoleUser(){
    CollectionReference collRef= FirebaseFirestore.instance.collection('RoleUser');
    String NameUser= _NameUser.text;
    String EmailUser= _EmailUser.text;
    String PaswordUser = _PasswoodUser.text;
    String Role= 'User';
    final Email_ID= _EmailUser.text;
    collRef.doc(Email_ID).set({
      'NameUser': NameUser,
      'EmailUser': EmailUser,
      'Role': Role,
      'PassWord':PaswordUser,
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient:LinearGradient(colors:[
              hexStringToColor("FFFFFF"),
              hexStringToColor("FFFFFF"),
              hexStringToColor("FFFFFF")
            ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.2, 20,0 ),
            child: Column(
              children: <Widget>[
                logoWidget('assets/images/LogoApp.jpg'),
                SizedBox(height:10),

                reusableTextField("Tên đăng nhập:", Icons.person, true, _NameUser),
                SizedBox(height: 7,),

                reusableTextField("Email:", Icons.email, true, _EmailUser),
                SizedBox(height: 7,),

                reusableTextField("Mật khẩu", Icons.lock, false, _PasswoodUser),
                SizedBox(height: 7,),

                signInSignUpButton(context, false, () {
                  FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: _EmailUser.text, password: _PasswoodUser.text)
                      .then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => homePage(emailUser: _EmailUser.text,passWord: _PasswoodUser.text)));
                    SaveRoleUser();
                  });

                  SizedBox(height: 5,);
                })
              ],
            ),
          ),
        ),

      ),
    );
  }
}


