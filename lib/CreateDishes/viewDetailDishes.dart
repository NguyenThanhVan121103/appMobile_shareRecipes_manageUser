import 'dart:ffi';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_gourmet/CreateDishes/updateDishes.dart';
import 'package:da_gourmet/homePage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:readmore/readmore.dart';

class viewDetailDishes extends StatefulWidget {
  final String id;
  final String emailUser;
  final String passWord;

  const viewDetailDishes({Key? key, required this.id, required this.emailUser, required this.passWord}) : super(key: key);


  @override
  State<viewDetailDishes> createState() => _viewDetailDishesState();
}

class _viewDetailDishesState extends State<viewDetailDishes> {
  final int numberSeen= 0;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  late TextEditingController Diashesname = TextEditingController();


  @override
  Widget build(BuildContext context) {
    CollectionReference dataRef = FirebaseFirestore.instance.collection('users');
    Future<void> deleteDishe(String id, String urls) async {
      dataRef.doc(id).delete();
      await FirebaseStorage.instance.refFromURL(urls).delete();// xóa dữ liệu
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết sản phẩm'),
        actions: [
          Form(
            key: _formKey,
            child: FutureBuilder<DocumentSnapshot<Map<String,dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('users').doc(widget.id).get(),
              builder: (_, snapshot){
                if(snapshot.hasError){
                  print("có lỗi bạn ê");
                }
                if(snapshot.connectionState== ConnectionState.waiting){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var disheDetail = snapshot.data!.data();
                return PopupMenuButton(
                  itemBuilder: (context){
                    return [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text("Quay về trang chủ"),

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
                            builder: (context) => homePage(emailUser: widget.emailUser, passWord: widget.passWord,)
                        ),
                      );
                    }
                  },
                );
              },
            ),



          )
        ],
      ),
      body:Form(
        key: _formKey2,
        child: FutureBuilder<DocumentSnapshot<Map<String,dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('users').doc(widget.id).get(),
          builder: (_, snapshot){
            if(snapshot.hasError){
              print("có lỗi bạn ê");
            }
            if (snapshot.connectionState== ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var disheDetail = snapshot.data!.data();
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (disheDetail!['url'] != null) // Kiểm tra xem hình ảnh có tồn tại không
                    Image.network(disheDetail!['url'],
                      width: 350,
                      height: 250,
                      fit: BoxFit.fill,),
                  Text('${disheDetail!['nameDishes']}',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),),
                  ReadMoreText('${disheDetail!['inforDishes']}',
                    trimLines: 3,
                    colorClickableText: Colors.grey,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Xem thêm',
                    trimExpandedText: '...Ẩn bớt',
                    moreStyle: TextStyle(fontSize: 15),

                  ),
                  Divider(
                    height: 50,
                    color: Colors.black,
                    thickness: 1,
                    indent : 5,
                    endIndent : 1,
                  ),
                  if(disheDetail!['timeCooking'] != null && disheDetail!['timeCooking'].isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Wrap(crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Icon(Icons.timer_outlined),
                            Text('${disheDetail!['timeCooking']}'),
                          ],)
                      ],
                    ),
                  SizedBox(height: 20,),
                  Text('Nguyên liệu',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    ),),
                  if(disheDetail!['rationDishes'] != null && disheDetail['rationDishes'].isNotEmpty)
                    Wrap(crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(Icons.person_2_outlined),
                        Text('${disheDetail!['rationDishes']}'),
                      ],),

                  SizedBox(height: 20,),
                  ListView.builder(
                    shrinkWrap: true,// có kích thước của list con
                    physics: NeverScrollableScrollPhysics(),// không cho người dùng cuộn
                    itemCount: disheDetail!['ingredient'].length,
                    itemBuilder: (BuildContext context, int index){
                      return Text(
                        '- ${disheDetail!['ingredient'][index]}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30,),
                  Text('Cách làm',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    ),),
                  SizedBox(height: 20,),
                  ListView.builder(
                    shrinkWrap: true,// có kích thước của list con
                    physics: NeverScrollableScrollPhysics(),// không cho người dùng cuộn
                    itemCount: disheDetail!['step'].length,
                    itemBuilder: (BuildContext context, int index){
                      return Text(
                        'Bước ${index +1 }: ${disheDetail!['step'][index]}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30,),

                ],
              ),
            );
          },
        ),


      )




    );
  }
}

