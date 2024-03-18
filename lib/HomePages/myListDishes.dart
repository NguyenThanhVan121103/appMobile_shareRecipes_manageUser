import 'package:da_gourmet/CreateDishes/ViewMyDetailDishes.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class MyCardDishes extends StatefulWidget {
  final String emailUser, passWord;
  const MyCardDishes({Key? key, required this.emailUser, required this.passWord}): super(key: key);

  @override
  _MyCardDishesState createState() => _MyCardDishesState();
}

class _MyCardDishesState extends State<MyCardDishes> {


  String UEmail='';

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
          // nameUser = doc.data()['NameUser']; // Lưu tên người dùng vào biến nameUser

          if (email == widget.emailUser) {
            setState(() {
              UEmail= email;

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
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách món ăn"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').where('EmailUser', isEqualTo: UEmail).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Đã xảy ra lỗi: ${snapshot.error}'),
            );
          }
          //
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

              String url = data.containsKey('url') ? data['url'] ?? '' : '';
              String nameDishes = data.containsKey('nameDishes') ? data['nameDishes'] ?? 'Tên không có' : 'Tên không có';

              String IDdoc = document.id; // Lấy ID của tài liệu
              String docId= '';
              print("chay lan thu: ${data}");
              print("chay lan thu: ${docId}");


              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => viewDetailDishes(id: IDdoc,emailUser: widget.emailUser,passWord: widget.passWord,),
                    ),
                  );
                  if(IDdoc == widget.emailUser){
                    docId= IDdoc;
                  }else{
                    print("lỗi tung chảo");
                  }
                  print("chay : ${docId}");
                },
                child: Card(
                  elevation: 4.0,
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.network(
                          url,
                          fit: BoxFit.cover,
                          height: 100,
                          width: double.infinity,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              nameDishes,
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
