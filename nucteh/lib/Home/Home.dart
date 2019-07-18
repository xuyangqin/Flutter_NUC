import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Home extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _HomePageState();
}
class _HomePageState extends  State<Home> {
  ScrollController _controller = ScrollController();
  String EmployeePhoto = '';
  String EmployeeName = '';
  String CellPhone = '';
  List MenuList = ['我的企业','推荐给好友','消息免打扰','建议反馈','关于威视网报','多语言'];
  @override
  void initState() {
    super.initState();
    _getData();
  }
  @override
  Widget build(BuildContext context) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    final height =size.height;
    return Scaffold(
        body: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Expanded(
                flex: 3,
                child: Container(
                  color: Colors.blue,
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Image(
                          image: NetworkImage('http://tongfangapi.feikongbao.net'+EmployeePhoto),
                          width: 50,
                          height: 50,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(EmployeeName,style: TextStyle(
                              color: Colors.white,fontSize: 20
                          ),)
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(CellPhone,style: TextStyle(fontSize: 16,color: Colors.white),)
                      ),
                    ],
                  ),
                )),
            Expanded(
              flex: MenuList.length,
              child:ListView.builder(
                itemCount: 5,
                itemExtent: 60.0,
                controller: _controller,
                //列表项构造器
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      title: Text(MenuList[index]),
                      trailing: new Icon(Icons.chevron_right),
                      onTap: (){
//                            Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
//                              return new AddressbookDetails(addressModel: model);
//                            }));
                      }
                  );
                },
              ),
            ),
            Expanded(
                flex: 1,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        width: 200,
                        height: 40,
                        child: FlatButton(
                          child: Text('退出当前账户',
                              style: TextStyle(
                                  color: Colors.red,fontSize: 16
                              )),
                          onPressed: () => {
                          Navigator.pop(context),
                          },
                        )),
                  ],
                )),
          ],
        )
    );
  }
  //每个item的建造
  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cellPhone = await prefs.get('CellPhone');
    String employeePhoto = await prefs.get('EmployeePhoto');
    String employeeName = await prefs.get('EmployeeName');

    print(cellPhone+employeePhoto+employeeName);
    setState(() {
      CellPhone = cellPhone;
      EmployeeName = employeeName;
      EmployeePhoto = employeePhoto;
    });
  }
}