import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_gourmet/CreateDishes/createDishes.dart';
import 'package:da_gourmet/CreateDishes/viewDetailDishes.dart';
import 'package:flutter/material.dart';

class AddDishes extends StatelessWidget{
  final String emailUser;
  const AddDishes({Key? key, required this.emailUser}): super(key: key);




  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 350,
                  height: 200,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/imageinMonMOi.jpg'),
                          fit: BoxFit.fill
                      )
                  ),
                ),
                Text('Lưu giữ tất cả món bạn nấu ở cùng một nơi',
                  style: TextStyle(
                    fontSize: 25,

                  ),),
                SizedBox(height: 50),

                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('và chia sẻ cùng với gia đình của bạn',
                      style: TextStyle(
                          fontSize: 15
                      ),),
                    ElevatedButton.icon(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => createDishes(emailUser: emailUser,)),
                        );
                      },
                      icon: Icon(Icons.dinner_dining),
                      label: Text('Viết món mới'),),
                  ],
                ),

              ],
            ),
          )

      ),
    );
  }
}