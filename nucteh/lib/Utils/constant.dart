import 'dart:ui' as ui show window;
import 'package:flutter/material.dart';
class Constant {
  ///BaseUrl
  static final BaseUrl = 'http://tongfangapi.feikongbao.net/';
//  static final BaseUrl = 'https://nrsapi.nuctech.com/';

  ///APP登录urlsh
  static final LoginAccount = 'api/Account/LoginAccount';
  static final loginOutCode = 3030;
  ///APP退出账号
  static final LoginOutAccount = 'api/Account/LoginOutAccount';
  ///APP待办列表
  static final DownloadMsgListPage = 'api/Message/DownloadMsgListPage';
}
class unifiedColors {
  ///主基色
  static final Color BasicsColor = Color(0X0f9aef);
  ///背景色
  static final Color BackgroundColor = Color(0XF8FAF9);
}