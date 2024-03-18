import 'package:da_gourmet/CreateDishes/viewDetailDishes.dart';
import 'package:da_gourmet/HomePages/myListDishes.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PopularCardDishes extends StatelessWidget {
  final String emailUser;
  final String passWord;
  const PopularCardDishes ({Key? key, required this.emailUser, required this.passWord}): super(key: key);
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách món ăn"),
        actions: [
          PopupMenuButton(
            itemBuilder: (context){
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text("Danh sách món ăn của tôi"),

                ),
              ];
            },
            onSelected: (value){
              for (int i =0; i <5; i++){
                print(i);
              }
              if(value == 0){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyCardDishes(emailUser: emailUser, passWord: passWord,)
                  ),
                );
              }
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').orderBy('likes', descending: true).snapshots(),
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

              String url = data.containsKey('url') ? data['url'] ?? '' : '';
              String nameDishes = data.containsKey('nameDishes') ? data['nameDishes'] ?? 'Tên không có' : 'Tên không có';
              int likes = data.containsKey('likes') ? data['likes'] ?? '?' : '?';
              String docId = document.id; // Lấy ID của tài liệu
              print("chay lan thu: ${data}");
              print("chay lan thu: ${docId}");

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => viewDetailDishes(id: docId,emailUser: emailUser,passWord: passWord,),
                    ),
                  );
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
                            ElevatedButton.icon(
                              icon: Icon(Icons.favorite),
                              onPressed: () async {
                                // Lấy tài liệu của món ăn từ Firestore
                                DocumentSnapshot<Map<String, dynamic>> document = await FirebaseFirestore.instance.collection('users').doc(docId).get();

                                // Lấy dữ liệu của món ăn
                                var disheDetail = document.data();

                                // Tăng số lượng likes lên 1
                                int currentLikes = disheDetail!['likes'];
                                int newLikes = currentLikes + 1;

                                // Cập nhật số lượng likes trong Firestore
                                await FirebaseFirestore.instance.collection('users').doc(docId).update({
                                  'likes': newLikes,
                                });
                              },
                              label: Text('$likes'),

                            ),
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
