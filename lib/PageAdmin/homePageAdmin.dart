import 'package:da_gourmet/CreateDishes/createDishes.dart';
import 'package:da_gourmet/CreateDishes/viewDetailDishes.dart';
import 'package:da_gourmet/HomePages/AddDishes.dart';
import 'package:da_gourmet/HomePages/SetUser.dart';
import 'package:da_gourmet/PageAdmin/CardDishAdmin.dart';
import 'package:da_gourmet/PageAdmin/ListUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'SetAdmin.dart';


class homePageAdmin extends StatelessWidget {
  final String emailUser,passWord;
  const homePageAdmin({Key? key, required this.emailUser, required this.passWord}): super(key: key);

  @override
  Widget build(BuildContext context) {



    return MaterialApp(
      initialRoute: 'homePageAdmin',
      routes: {
        'myHomePage': (context) => myHomePageAdmin(emailUser: emailUser,passWord: passWord,),
        'createDishes': (context) => createDishes(emailUser: emailUser,),
      },
    );
  }
}

class myHomePageAdmin extends StatefulWidget{
  final String emailUser, passWord;
  const myHomePageAdmin({Key? key, required this.emailUser, required this.passWord}): super(key: key);
  @override
  _myHomePageAdminState createState() => _myHomePageAdminState();
}

class _myHomePageAdminState extends State<myHomePageAdmin>{
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions; // Khai báo danh sách widget này ở đây

  @override
  void initState() {
    super.initState();
    _widgetOptions = [
      CardDishesAdmin(emailUser: widget.emailUser, passWord: widget.passWord,),
      ListUser(emailUser: widget.emailUser,passWord: widget.passWord,),
      SetAdmin(emailUser: widget.emailUser), // Truyền emailUser từ widget
    ];
  }
  void _onItemTapped(int index){// nhận giá trị index
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/images/LogoApp.jpg'),
        leadingWidth: 100,
        title: Text('Trang của Admin'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),// list tạo trước đó
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Trang chủ'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Quản lý người dùng'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Admin'
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

