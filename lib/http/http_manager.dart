
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_app_wanandroid/http/api.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class HttpManager{
  Dio _dio;

  static HttpManager _instance;

  PersistCookieJar _persistCookieJar;

  factory HttpManager.getInstance(){
    if(null == _instance) {
      _instance = new HttpManager._internal();
    }
    return _instance;
  }

  HttpManager._internal();

  init() async {
    BaseOptions options = new BaseOptions(
      baseUrl: Api.baseUrl,
      connectTimeout: 5000,
      receiveTimeout: 3000
    );
    _dio = new Dio(options);

    Directory directory = await getApplicationDocumentsDirectory();
    var path = Directory(join(directory.path, "cookie")).path;
    _persistCookieJar = PersistCookieJar(ignoreExpires: true,
    storage: FileStorage(path));
    _dio.interceptors.add(CookieManager(_persistCookieJar));
  }


  request(url,{data,String method = "get"}) async{
    try{
      Options options = new Options(method: method);
      // options.responseType = ResponseType.plain;
      Response response = await _dio.request(url,data: data,options: options);
      print(response.requestOptions.headers);
      print(response.data);
      return response.data;

    }catch(e){
      print(e);
      return null;
    }

  }

  clearCookie(){
    _persistCookieJar.deleteAll();
  }
}