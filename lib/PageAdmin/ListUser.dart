import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_gourmet/CreateDishes/createDishes.dart';
import 'package:da_gourmet/CreateDishes/viewDetailDishes.dart';
import 'package:da_gourmet/HomePages/myListDishes.dart';
import 'package:da_gourmet/PageAdmin/CardDishAdmin.dart';
import 'package:da_gourmet/PageAdmin/viewDetailAdmin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class ListUser extends StatefulWidget {
  final String emailUser, passWord;
  const ListUser({Key? key, required this.emailUser, required this.passWord}): super(key: key);

  @override
  _ListUserState createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {

  String REmail='User';


  Future<void> deleteUser(String email, String pass) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass
      );
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
        print('Người dùng đã được xóa.');
      }
    } catch (e) {
      print('Lỗi xóa người dùng: $e');
    }
  }

  CollectionReference dataRef = FirebaseFirestore.instance.collection('RoleUser');
  Future<void> deleteUserFS(String email) async {
    dataRef.doc(email).delete();
  }





  void DeleUser(String email, String pass){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Bạn có chắc xóa người dùng không'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(onPressed: (){
                    deleteUser(email, pass);
                    deleteUserFS(email);
                    Navigator.pop(context);
                  }, child: Row(// hiển thị thẳng một hàng
                    children: [
                      Icon(Icons.restore_from_trash),
                      Text("Có"),
                    ],
                  ),
                  ),
                  ElevatedButton(onPressed: (){
                    Navigator.pop(context);// lấy nguồn ảnh ở thư viện
                  }, child: Row(// hiển thị thẳng một hàng
                    children: [
                      Icon(Icons.close_sharp),
                      Text("Không"),
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
        title: Text("Danh sách người dùng"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('RoleUser').where('Role', isEqualTo: REmail).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Đã xảy ra lỗi: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('Không có dữ liệu'),
            );
          }

          return GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.all(8.0),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;

              String Email = data.containsKey('EmailUser') ? data['EmailUser'] ?? 'Email không có' : 'Email không có';
              String nameUser = data.containsKey('NameUser') ? data['NameUser'] ?? 'Tên không có' : 'Tên không có';
              String passUser= data.containsKey('PassWord') ? data['PassWord'] ?? 'Mật khẩu không có' : 'Mật khẩu không có';

              String docId = document.id; // Lấy ID của tài liệu
              print("chay lan thu: ${data}");
              print("chay lan thu: ${docId}");

              return GestureDetector(
                onTap: () {
                  DeleUser(Email, passUser);

                },
                child: Card(
                  elevation: 4.0,
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.asset(
                          'assets/images/ImageAvatar.png',
                          fit: BoxFit.cover,
                          height: 50,
                          width: double.infinity,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              nameUser,
                              textAlign: TextAlign.center,
                              style: TextStyle(

                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),Text(
                              Email,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            // Thêm các trường dữ liệu khác cần hiển thị ở đây
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
