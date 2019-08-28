import 'package:flutter/material.dart';
import 'package:nucteh/api_manager/api_manager.dart';
import 'package:nucteh/Utils/toast.dart';
import 'package:nucteh/Utils/constant.dart';
class Message extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _MessagePageState();
}
class _MessagePageState extends  State<Message> with SingleTickerProviderStateMixin{
  TabController _tabController;

  List tabs = ['待办事项','审批结果','系统消息'];

  @override
  void initState() {
    super.initState();
     _tabController = TabController(length: tabs.length, vsync: this);

     requestData();
  }

  @override
  Widget build(BuildContext context) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    final height =size.height;
    return Scaffold(
        appBar: AppBar(
           title: Text('消息'),
           leading: Text(''),
           bottom: TabBar(
               controller: _tabController,
               tabs: tabs.map((e) => Tab(text: e)).toList()),
        ),
        body: ListView.builder(
            padding: EdgeInsets.all(5.0),
            itemExtent: 100.0,
            itemCount: 5,
            itemBuilder: (BuildContext context,int index){
              return listView();
            },
        ),
    );
  }
  @override
  Widget listView(){
    return(
      Row(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(top: 0,left: 5),
              child: Image(
                alignment: Alignment.topCenter,
                image: AssetImage('images/weixuanzhong.png'),
                width: 16,
                height: 16
              )
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5,left: 5),
            child: Image.network(
              '',
              width: 50,
              height: 50,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5,left: 5),
            child: Column(
              children: <Widget>[
                Padding(padding: const EdgeInsets.only(top: 5,left: 5),
                  child: Text('同方威视',
                      textAlign: TextAlign.left,
                      style: TextStyle(

                  )),
                ),
                Padding(padding: const EdgeInsets.only(top: 5,left: 5),
                  child: Text('同方威视',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                      fontSize: 10
                  )),
                ),
                Padding(padding: const EdgeInsets.only(top: 5,left: 5),
                  child: Text('同方威视',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                      fontSize: 10
                  )),
                )
              ],
            )
          ),
        ],
      )
    );
  }
  requestData() async{
    Map param = {
      'pageSize': '50',
      'msgType':'01',
      'page':'1'
    };
    DioUtil().post(context,Constant.DownloadMsgListPage,
        pathParams: {
        },
        data: param,
        errorCallback: (statusCode) {
          Toast.show(context: context, msg: '$statusCode');
        }
    ).then((data) async {

    });
  }
}