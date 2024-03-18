import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_gourmet/CreateDishes/createDishes.dart';
import 'package:da_gourmet/Login_Logout_Signup/SignUp_Screen.dart';
import 'package:da_gourmet/PageAdmin/homePageAdmin.dart';
import 'package:da_gourmet/homePage.dart';
import 'package:da_gourmet/utils_and_reusable_widget/reusable_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:da_gourmet/utils_and_reusable_widget/color_util.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    home: SignInScreen(),
  ));
}
class SignInScreen extends StatefulWidget{
  const SignInScreen({Key? key}): super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();

}

class _SignInScreenState extends State<SignInScreen>{



  TextEditingController _EmailUser = TextEditingController();
  TextEditingController _PasswoodUser = TextEditingController();

  void ChestRole(String userEmail) async{
    try{
      var user= FirebaseAuth.instance.currentUser;

      if (user != null){
        var snapshot= await FirebaseFirestore.instance
            .collection("RoleUser").where('EmailUser', isEqualTo: userEmail).get();
        if (snapshot.docs.isNotEmpty){
          snapshot.docs.forEach((doc) {
            var role= doc.data()['Role'];
            print("Đây là role: ${role}");

            if(role== 'User'){
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => homePage(emailUser: _EmailUser.text,passWord: _PasswoodUser.text,)));
            }
            else if(role =='Admin'){
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => myHomePageAdmin(emailUser: _EmailUser.text, passWord: _PasswoodUser.text,)));
            }
          });
              }
      }


      
    }catch(e){
      print('Lỗi: ${e}');
    }

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
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0.2, 20, 0),
              child: Column(
                children: <Widget>[
                  logoWidget('assets/images/LogoApp.jpg'),
                  SizedBox(height:10),

                  reusableTextField("Tên đăng nhập", Icons.person, true, _EmailUser),
                  SizedBox(height: 20,),
                  reusableTextField("Mật khẩu", Icons.lock, false, _PasswoodUser),
                  SizedBox(height: 15,),
                  signInSignUpButton(context, true, () {
                    FirebaseAuth.instance.signInWithEmailAndPassword(email: _EmailUser.text, password: _PasswoodUser.text).then((value){

                      ChestRole(_EmailUser.text);

                    }).onError((error, stackTrace) {
                      print("Lỗi: ${error.toString()}");
                    });
                  }),
                  signUpOption()
                ],
              ),
            ),
          ),
        )
    );
  }
  Row signUpOption(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Không có tài khoản? ",
          style: TextStyle(
              color: Colors.black38
          ),),
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            "Đăng ký",
            style: TextStyle(color: Colors.blueGrey,
                fontWeight: FontWeight.bold),

          ),
        )
      ],
    );
  }
}