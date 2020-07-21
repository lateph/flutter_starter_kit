import 'package:flutter_starter_kit/app/model/api/APIProvider.dart';
import 'package:flutter_starter_kit/app/model/db/DBAppStoreRepository.dart';
//import 'package:flutter_starter_kit/app/model/pojo/AppContent.dart';
//import 'package:flutter_starter_kit/app/model/pojo/Entry.dart';
import 'package:flutter_starter_kit/app/model/pojo/Product.dart';
//import 'package:flutter_starter_kit/app/model/pojo/response/LookupResponse.dart';
//import 'package:flutter_starter_kit/app/model/pojo/response/TopAppResponse.dart';
import 'package:flutter_starter_kit/utility/log/Log.dart';
import 'package:rxdart/rxdart.dart';

class AppStoreAPIRepository{
  static const int TOP_100 = 100;
  static const int TOP_10 = 10;

  APIProvider _apiProvider;
  DBAppStoreRepository _dbAppStoreRepository;

  AppStoreAPIRepository(this._apiProvider, this._dbAppStoreRepository);

  Observable<List<Product>> getProducts(){
    return Observable.fromFuture(_apiProvider.getProduct());
  }
}