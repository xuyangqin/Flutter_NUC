import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nucteh/Utils/constant.dart';
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

  Future<Map<String, dynamic>> get(String path, {pathParams, data, Function errorCallback}) {
    return request(path, method: Method.get, pathParams: pathParams, data: data, errorCallback: errorCallback);
  }
  Future<Map<String, dynamic>> Loginpost(String path, {pathParams, data, Function errorCallback}) {
    String pathUrl = Constant.BaseUrl + path;

    return request(pathUrl, method: Method.post, pathParams: pathParams, data: data, errorCallback: errorCallback);
  }
  Future<Map<String, dynamic>> post(String path, {pathParams, var data, Function errorCallback}) async {
    String pathUrl = Constant.BaseUrl + path;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String LegalUnitID = await prefs.get('LegalUnitID');
//    String token = await prefs.get('token');
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
    print('请求url:$pathUrl请求入参:$params');
    return request(pathUrl, method: Method.post, pathParams: pathParams, data: params, errorCallback: errorCallback);
  }

  Future<Map<String, dynamic>> request(String path,{String method, Map pathParams, data, Function errorCallback}) async {
    ///restful请求处理
    if(pathParams != null) {
      pathParams.forEach((key, value) {
        if(path.indexOf(key) != -1) {
          path = path.replaceAll(":$key", value.toString());
        }
      });
    }

    Response response = await _dio.request(path, data: data, options: Options(method: method));

    if(response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
      try {
        if(response.data is Map) {
          return response.data;

        } else {

          return json.decode(response.data.toString());

        }
      } catch(e) {
        return null;
      }
    } else {

      var str = json.decode(response.statusCode.toString());

      _handleHttpError(response.statusCode);
      if(errorCallback != null) {
        errorCallback(response.statusCode);
      }
      return null;
    }
  }

  ///处理Http错误码
  void _handleHttpError(int errorCode) {

  }

}