import 'package:flutter/material.dart';
import 'package:nucteh/Addressbook/Addressbook.dart';
import 'package:nucteh/Home/Home.dart';
import 'package:nucteh/Message/Message.dart';
import 'package:nucteh/Mine/Mine.dart';
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  int _currentIndex = 1;
  final List<Widget> _children = [
    Message(),
    Home(),
    Addressbook(),
    Mine()
  ];
  final _bottomNavigationColor = Colors.blue;
  //生命周期方法构建Widget时调用
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: onTabTapped,
            unselectedItemColor: Colors.blue,
            selectedItemColor: Colors.red,
            showUnselectedLabels:true,
            type: BottomNavigationBarType.fixed,
            items: [
            BottomNavigationBarItem(
                title: Text("消息"), icon: Icon(Icons.message)),
            BottomNavigationBarItem(
                  title: Text("工作台"), icon: Icon(Icons.menu)),
            BottomNavigationBarItem(
                title: Text("通讯录"), icon: Icon(Icons.list)),
            BottomNavigationBarItem(
                title: Text("我的"), icon: Icon(Icons.perm_identity)),
          ],
        ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}