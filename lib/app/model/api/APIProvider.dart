import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_starter_kit/app/model/pojo/Product.dart';
//import 'package:flutter_starter_kit/app/model/pojo/response/LookupResponse.dart';
//import 'package:flutter_starter_kit/app/model/pojo/response/TopAppResponse.dart';
import 'package:flutter_starter_kit/config/Env.dart';
import 'package:flutter_starter_kit/utility/http/HttpException.dart';
import 'package:flutter_starter_kit/utility/log/DioLogger.dart';
import 'package:flutter_starter_kit/utility/log/Log.dart';
import 'package:sprintf/sprintf.dart';

class APIProvider{
  static const String TAG = 'APIProvider';

  static String baseUrl = 'http://192.168.1.107:8080';
  static const String _TOP_FREE_APP_API = '/rss/topfreeapplications/limit=%d/json';
  static const String _TOP_FEATURE_APP_API = '/rss/topgrossingapplications/limit=%d/json';
  static const String _APP_DETAIL_API = '/lookup/json';

  Dio _dio;

  APIProvider(){
    BaseOptions dioOptions = BaseOptions()
      ..baseUrl = APIProvider.baseUrl;

    _dio = Dio(dioOptions);

    if(EnvType.DEVELOPMENT == Env.value.environmentType || EnvType.STAGING == Env.value.environmentType){

      _dio.interceptors.add(InterceptorsWrapper(
          onRequest:(RequestOptions options) async{
            DioLogger.onSend(TAG, options);
            return options;
          },
          onResponse: (Response response){
            DioLogger.onSuccess(TAG, response);
            return response;
          },
          onError: (DioError error){
            DioLogger.onError(TAG, error);
            return error;
          }
      ));
    }
  }

  Future<List<Product>> getProduct() async{
    Response response = await _dio.get("/api/products");
    throwIfNoSuccess(response);

    print(response.data[1].runtimeType);
    return (response.data as List).map((e) => Product.fromJson(e)).toList();
//    response.data.map((Map<String, dynamic> e) => e);
//    return [];
    //    List<dynamic> json = jsonDecode(response.data);
//    List<Product> producs = response.data.map((e) => Product.fromJson(e));
//    List<Product> producs = List<Product>.from(response.data).map((dynamic model)=> Product.fromJson(model)).toList();
  }

  void throwIfNoSuccess(Response response) {
    if(response.statusCode < 200 || response.statusCode > 299) {
      throw new HttpException(response);
    }
  }

}