import 'dart:async';

import 'package:flutter_starter_kit/app/model/api/AppStoreAPIRepository.dart';
import 'package:flutter_starter_kit/app/model/core/AppStoreApplication.dart';
import 'package:flutter_starter_kit/app/model/pojo/Product.dart';
import 'package:flutter_starter_kit/utility/log/Log.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc {

  final AppStoreApplication _application;
  final _searchText = BehaviorSubject<String>();
  final _feedList = BehaviorSubject<List<Product>>();
  final _isShowLoading = BehaviorSubject<bool>();
  final _noticeItemUpdate = BehaviorSubject<num>();

  HomeBloc(this._application) {
    _init();
  }

  CompositeSubscription _compositeSubscription = CompositeSubscription();

  Stream<bool> get isShowLoading => _isShowLoading.stream;

  Stream<String> get searchText => _searchText.stream;

  Stream<List<Product>> get feedList => _feedList.stream;

  Stream<num> get noticeItemUpdate => _noticeItemUpdate.stream;


  var loadedMap = {};

  void _init() {

  }

  void dispose() {
    _compositeSubscription.clear();
    _searchText.close();
    _feedList.close();
    _isShowLoading.close();
    _noticeItemUpdate.close();
  }

  void changeSearchText(String searchTxt) {
    _searchText.add(searchTxt);
  }

  void loadFeedList() {
    _isShowLoading.add(true);
    AppStoreAPIRepository apiProvider = _application.appStoreAPIRepository;

    StreamSubscription subscription = apiProvider.getProducts()
        .listen((List<Product> response) {
      _feedList.add(response);
      _isShowLoading.add(false);
    },
        onError: (e, s) {
          Log.info(e);
          _isShowLoading.add(false);
        });
    _compositeSubscription.add(subscription);
  }
}