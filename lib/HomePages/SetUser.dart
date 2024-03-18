import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_gourmet/CreateDishes/createDishes.dart';
import 'package:da_gourmet/Login_Logout_Signup/SignIn_screen.dart';
import 'package:da_gourmet/homePage.dart';
import 'package:da_gourmet/utils_and_reusable_widget/color_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SetUser extends StatefulWidget {
  final String emailUser;
  const SetUser({Key? key, required this.emailUser}): super(key: key);

  @override
  _SetUserState createState() => _SetUserState();
}

class _SetUserState extends State<SetUser> {
  final ref= FirebaseDatabase.instance.ref();
  String nameUser='';
  String UName='';



  XFile? _image; // tạo biến có dạng XFile

  @override
  void initState() {
    super.initState();
    fetchData(); // Gọi hàm fetchData ở đây khi widget được khởi tạo
  }

  Future<void> fetchData() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection("RoleUser")
          .where('EmailUser', isEqualTo: widget.emailUser)
          .get();

      if (snapshot.docs.isNotEmpty) {
        snapshot.docs.forEach((doc) {
          var email = doc.data()['EmailUser'];
          nameUser = doc.data()['NameUser']; // Lưu tên người dùng vào biến nameUser

          if (email == widget.emailUser) {
            setState(() {
              UName= nameUser;

            }); // Cập nhật lại giao diện khi có dữ liệu
          } else {
            print("Lỗi");
          }
        });
      }
    } catch (e) {
      print('Lỗi: $e');
    }
  }



  final ImagePicker picker = ImagePicker();
  Future<void> getImage(ImageSource media) async {
    XFile? img = await picker.pickImage(source: media);// source ảnh

    if (img != null) {
      setState(() {
        _image = img;
      });
    }
  }

  // nơi lấy source ảnh
  void myAlert(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Vui lòng chọn nguồn ảnh'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(onPressed: (){
                    Navigator.pop(context);
                    getImage(ImageSource.gallery); // lấy nguồn ảnh ở thư viện
                  }, child: Row(// hiển thị thẳng một hàng
                    children: [
                      Icon(Icons.image_rounded),
                      Text("Thư viện"),
                    ],
                  ),
                  ),
                  ElevatedButton(onPressed: (){
                    Navigator.pop(context);
                    getImage(ImageSource.camera); // lấy nguồn ảnh ở thư viện
                  }, child: Row(// hiển thị thẳng một hàng
                    children: [
                      Icon(Icons.camera_alt_outlined),
                      Text("Máy ảnh"),
                    ],
                  ))
                ],
              ),
            ),
          );
        });
  }




      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(
                color: Colors.black
            ),
            elevation: 0.0,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 50),
                    ElevatedButton.icon(

                      onPressed: () {
                        FirebaseAuth.instance.signOut().then((value) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => SignInScreen()));
                        });
                      },
                      icon: Icon(Icons.login),
                      label: Text('Đăng xuất'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      children: [
                        _image != null ?
                        CircleAvatar(
                          radius: 64,
                          backgroundImage: _image != null // avatar
                              ? FileImage(File(_image!.path))
                              : AssetImage(
                              'assets/images/ImageAvatar.png') as ImageProvider,
                        )
                            : const CircleAvatar(
                          radius: 64,
                          backgroundColor: Colors.cyanAccent,
                          backgroundImage: AssetImage(
                              'assets/images/ImageAvatar.png'),
                        ),
                        // Positioned(child: IconButton(
                        //   onPressed: () {
                        //     myAlert();
                        //   },
                        //   icon: const Icon(Icons.add_a_photo),
                        // ),
                        //   bottom: -10,
                        //   left: 80,)
                      ],
                    ),

                    Text('$UName',
                      style: TextStyle(
                        fontSize: 25,
                      ),),
                    SizedBox(height: 50),


                  ],
                ),
              )

          ),
        );
      }
    }