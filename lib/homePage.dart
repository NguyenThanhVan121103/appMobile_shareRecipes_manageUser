import 'package:da_gourmet/HomePages/AddDishes.dart';
import 'package:da_gourmet/CreateDishes/createDishes.dart';
import 'package:da_gourmet/CreateDishes/viewDetailDishes.dart';
import 'package:da_gourmet/HomePages/ListDishes.dart';
import 'package:da_gourmet/PageAdmin/ListUser.dart';
import 'package:da_gourmet/HomePages/SetUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';




class homePage extends StatelessWidget {
  final String emailUser;
  final String passWord;
  const homePage({Key? key, required this.emailUser, required this.passWord}): super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'myHomePage',
      routes: {
        'myHomePage': (context) => myHomePage(emailUser: emailUser, passWord: passWord,),
        'createDishes': (context) => createDishes(emailUser:emailUser ,),
      },
    );
  }
}

class myHomePage extends StatefulWidget{
  final String emailUser;
  final String passWord;
  const myHomePage({Key? key, required this.emailUser, required this.passWord}): super(key: key);
  @override
  _myHomePageState createState() => _myHomePageState();
}

class _myHomePageState extends State<myHomePage>{


  int _selectedIndex = 0;
  late List<Widget> _widgetOptions; // Khai báo danh sách widget này ở đây

  @override
  void initState() {
    super.initState();
    _widgetOptions = [
      CardDishes(emailUser: widget.emailUser, passWord: widget.passWord,),
      AddDishes(emailUser: widget.emailUser,),
      SetUser(emailUser: widget.emailUser), // Truyền emailUser từ widget
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
        title: Text('Gourmet'),
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
              icon: Icon(Icons.add_circle),
              label: 'Món mới'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Người dùng'
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

