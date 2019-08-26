import 'package:flutter/material.dart';
import 'package:nucteh/api_manager/api_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nucteh/TabBar.dart';
import 'package:nucteh/Utils/constant.dart';
class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();

}

class _LoginState extends State<Login> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登录"),
      ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(top: 70),
                      child: Image(
                        alignment: Alignment.topCenter,
                        image: AssetImage('images/login.png'),
                        width: 50,
                        height: 50,
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextField(
                  autofocus: true,
                  controller: _userNameController,
                  decoration: InputDecoration(
                      labelText: "用户名",
                      hintText: "用户名或手机号",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.person)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Container(
                  height: 1,
                  color: Colors.grey,
                ),
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      autofocus: true,
                      controller: _passController,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: "密码",
                          hintText: "您的登录密码",
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.lock)),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 0,right: 0),
                      child: Container(
                          width: 100,
                          height: 40,
                          child: FlatButton(
                              child: Text('忘记密码',
                                  style: TextStyle(
                                      color: Colors.grey

                                  )),
                              onPressed: () {

                              }
                          ))
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Container(
                  height: 1,
                  color: Colors.grey,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Container(
                          width: 300,
                          height: 40,
                          child: FlatButton(
                            child: Text('登录',
                                style: TextStyle(
                                    color: Colors.white
                                )),
                            onPressed: () => _login(context),
                            color: Colors.blue,
                          )))
                ],
              )


            ]
        )
    );
  }
///登录
  _login(context) async{
    if(_userNameController.text.length == 0){
//      showSnackBar("用户名不能小于6位!");
      return;
    }
    if(_passController.text.length == 0){
//      showSnackBar("请输入用户密码！！");
      return;
    }
    Map param1 = {
      'pws': _passController.text,
      'uid': _userNameController.text,
      'Language': 'zh-CN',
      'activeUid': '51D94D35-BA21-4400-ABD2-E7C71236FE2F'
    };
    Map param2 = {'': ''};
    Map params = {'Content': param2, 'Head': param1};

    DioUtil().Loginpost(Constant.LoginAccount,
        pathParams: {
        },
        data: params,
        errorCallback: (statusCode) {
//          showSnackBar('$statusCode！！');
        }
    ).then((data) async {
      print('============求情返回$data');
      var result = data;
      var ret = data['Head']['Ret'];
      var message = data['Head']['Msg'];
      if (ret == 0) {
        Map EmployeeInfo = result['Content']['EmployeeInfo'];
        Map Content = result['Content'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('Uid', Content['Uid']);
        prefs.setString('Uid', Content['Token']);
        prefs.setString('LegalUnitID', EmployeeInfo['LegalUnitID']);
        prefs.setString('pws', '123');
        prefs.setString('userName', '13401112398');
        prefs.setString('CellPhone', EmployeeInfo['CellPhone']);
        prefs.setString('EmployeeName', EmployeeInfo['EmployeeName']);
        prefs.setString('EmployeePhoto', EmployeeInfo['EmployeePhoto']);

        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return new MyHomePage();
        }));
      } else {
//        showSnackBar('$message！！');
      }

    });
  }
}
