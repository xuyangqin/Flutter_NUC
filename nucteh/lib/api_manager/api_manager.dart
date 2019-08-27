import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nucteh/Utils/constant.dart';
import 'package:nucteh/Utils/toast.dart';
class Method {
  static final String get = "GET";
  static final String post = "POST";
  static final String put = "PUT";
  static final String head = "HEAD";
  static final String delete = "DELETE";
  static final String patch = "PATCH";
}

class DioUtil {
  static final DioUtil _instance = DioUtil._init();
  static Dio _dio;
  static BaseOptions _options = getDefOptions();
  factory DioUtil() {
    return _instance;
  }

  DioUtil._init() {
    _dio = new Dio();
  }

  static BaseOptions getDefOptions() {
    BaseOptions options = BaseOptions();
    options.connectTimeout = 10 * 1000;
    options.receiveTimeout = 20 * 1000;
    options.contentType = ContentType.parse('application/x-www-form-urlencoded');

    Map<String, dynamic> headers = Map<String, dynamic>();
    headers['Accept'] = 'application/json';

    String platform;
    if(Platform.isAndroid) {
      platform = "Android";
    } else if(Platform.isIOS) {
      platform = "IOS";
    }
    headers['OS'] = platform;
    options.headers = headers;

    return options;
  }

  setOptions(BaseOptions options) {
    _options = options;
    _dio.options = _options;
  }

  Future<Map<String, dynamic>> get(context,String path, {pathParams, data, Function errorCallback}) {
    return request(context,path, method: Method.get, pathParams: pathParams, data: data, errorCallback: errorCallback);
  }
  ///登录请求
  Future<Map<String, dynamic>> Loginpost(context,String path, {pathParams, data, Function errorCallback}) async{
    String pathUrl = Constant.BaseUrl + path;

    return request(context,pathUrl, method: Method.post, pathParams: pathParams, data: data, errorCallback: errorCallback);
  }
  ///退出登录
  Future<Map<String, dynamic>> LoginOut(context,String path, {pathParams, data, Function errorCallback}) async{
    String pathUrl = Constant.BaseUrl + path;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String LegalUnitID = await prefs.get('LegalUnitID');
    String pws = await prefs.get('pws');
    String uid = await prefs.get('Uid');
    Map param1 = {
      'pws':pws,
      'uid':uid,
      'LegalUnitID':LegalUnitID,
      'Version':'1.0.1',
      'Language':'zh-CN',
      'activeUid':'51D94D35-BA21-4400-ABD2-E7C71236FE2F'};
    var param2;
    if(data == ''){
      param2 = '';
    }else{
      param2 = Map();
      param2.addAll(data);
    }
    Map params = {'Content':param2,'Head':param1};
    return request(context,pathUrl, method: Method.post, pathParams: params, data: data, errorCallback: errorCallback);
  }
  Future<Map<String, dynamic>> post(context,String path, {pathParams, var data, Function errorCallback}) async {
    String pathUrl = Constant.BaseUrl + path;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String LegalUnitID = await prefs.get('LegalUnitID');
    String pws = await prefs.get('pws');
    String uid = await prefs.get('Uid');
    Map param1 = {
      'pws':pws,
      'uid':uid,
      'LegalUnitID':LegalUnitID,
      'Version':'1.0.1',
      'Language':'zh-CN',
      'activeUid':'51D94D35-BA21-4400-ABD2-E7C71236FE2F'};
    var param2;
    if(data == ''){
      param2 = '';
    }else{
      param2 = Map();
      param2.addAll(data);
    }
    Map params = {'Content':param2,'Head':param1};
    return request(context,pathUrl, method: Method.post, pathParams: pathParams, data: params, errorCallback: errorCallback);
  }

  ///网络请求
  Future<Map<String, dynamic>> request(context,String path,{String method, Map pathParams, data, Function errorCallback}) async {
    print('============请求$path=======请求入参$data');
    ///restful请求处理
    if(pathParams != null) {
      pathParams.forEach((key, value) {
        if(path.indexOf(key) != -1) {
          path = path.replaceAll(":$key", value.toString());
        }
      });
    }
    ///弹出loading
    if(context != null){

    }

    Response response = await _dio.request(path, data: data, options: Options(method: method));

    ///关闭loading
    if(response != null){

    }
    if(response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
      try {
        if(response.data is Map) {

          Map responseData = response.data;

          print('============求情返回$responseData');

          Map headmap = response.data['Head'];
          if(headmap['Code'] == Constant.loginOutCode || headmap['Code'] == 203){
            ///退出登录
            LoginOut(context,Constant.LoginOutAccount,
                pathParams: {
                },
                data: null,
                errorCallback: (statusCode) {
                  Toast.show(context: context, msg: '$statusCode');
                }
            ).then((data) async {

            });
            return null;
          }
          if(headmap['Ret'] == 0){
            return response.data;
          }else{
            String msg = response.data['Head']['Msg'];
            if(msg.length > 0) {
              errorCallback('$msg');
            }else{
              if(errorCallback != null) {
                errorCallback('请求失败，请稍后重试');
              }
            }
            return null;
          }
        } else {
          String msg = response.data['Head']['Msg'];
          if(msg.length > 0) {
            errorCallback('$msg');
          }else{
            if(errorCallback != null) {
              errorCallback('请求失败，请稍后重试');
            }
          }
          return null;

        }
      } catch(e) {
         String msg = response.data['Head']['Msg'];
        if(msg.length > 0) {
          errorCallback('$msg');
        }else{
          if(errorCallback != null) {
            errorCallback('请求失败，请稍后重试');
          }
        }
        return null;
      }
    } else {
      String msg = response.data['Head']['Msg'];
      if(msg.length > 0) {
        errorCallback('$msg');
      }else{
        if(errorCallback != null) {
          errorCallback('请求失败，请稍后重试');
        }
      }
      return null;
    }
  }

  ///处理Http错误码
  void _handleHttpError(int errorCode) {

  }

}