import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/app/bloc/HomeBloc.dart';
import 'package:flutter_starter_kit/app/model/api/APIProvider.dart';
import 'package:flutter_starter_kit/app/model/core/AppProvider.dart';
//import 'package:flutter_starter_kit/app/model/pojo/AppContent.dart';
import 'package:flutter_starter_kit/app/model/pojo/Product.dart';
//import 'package:flutter_starter_kit/app/ui/page/AppDetailPage.dart';
import 'package:flutter_starter_kit/generated/i18n.dart';
import 'package:flutter_starter_kit/utility/widget/StreamListItem.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class HomePage extends StatefulWidget {
  static const String PATH = '/';

  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  HomeBloc bloc;
  final TextEditingController _searchBoxController = new TextEditingController();
  Color greyColor = Color.fromARGB(255, 163, 163, 163);
  var _keys = {};
  var listViewKey = UniqueKey();

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _init();

    return Scaffold(
      appBar: AppBar(
        title: Text("test koneksi")
      ),
      body: buildFeedList()
    );
  }

  Widget buildSearchBar(){
    return StreamBuilder(
      stream: bloc.searchText,
      builder: (context, snapshot) {
        String searchText = snapshot.data;

        return TextField(
          controller: _searchBoxController,
          onChanged: bloc.changeSearchText,
          decoration: InputDecoration(
              fillColor: Colors.white70,
              filled: true,
              hasFloatingPlaceholder: false,
              prefixIcon: Icon(Icons.search),
              suffixIcon: null != searchText && searchText.isNotEmpty ? IconButton(
                icon:Icon(Icons.clear),
                onPressed: () {
                  _searchBoxController.clear();
                  bloc.changeSearchText('');
                },
              ) : null,
              border: InputBorder.none,
              hintText: S.of(context).homeSearchHint
          ),
        );
      },
    );
  }

  void _init(){
    if(null == bloc){
      bloc = HomeBloc(AppProvider.getApplication(context));
      bloc.isShowLoading.listen((bool isLoading){
        if(isLoading){
          _showLoading();
        }
        else{
          Navigator.pop(context);
        }
      });
      bloc.loadFeedList();
    }
  }

  void _showLoading() {
    showDialog(
        context: context,
        barrierDismissible: false,
        child: Dialog(
            child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    Container(
                        margin: EdgeInsets.only(top: 8),
                        child: Text(S.of(context).dialogLoading)
                    )
                  ],
                )
            )
        )
    );
  }

  Widget buildFeedList(){
    return StreamBuilder(
      stream: bloc.feedList,
      builder: (context, snapshot) {
        switch(snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:{
            return Center(
              child: Text(S.of(context).dialogLoading)
            );
          }
          case ConnectionState.done:
          case ConnectionState.active:{

            List<Product> feedList = snapshot.data;
            if(0 == feedList.length){
              return Center(
                child: Text(S.of(context).homeEmptyList)
              );
            }

            return ListView.builder(
                key: listViewKey,
                scrollDirection: Axis.vertical,
                itemCount: null != feedList ? feedList.length : 0,
                itemBuilder: (context, index) {
                  Product a = feedList[index];
                  return buildTopAppListItem(a, index, false);
                }
            );
          }
        }
        return Container();
      }
    );
  }

  Widget buildTopAppListItem(Product product, int index, bool isFeatureListItemExist){
    String name = product.name;
    String category = product.kode;
    double rating = product.rating.toDouble();
    num userCount = product.total;

    int order = index + 1;

    String heroTag = 'freeAppIcon_$order';
    String titleTag = 'freeAppTitle_$order';

    return Column(
      children: <Widget>[
        Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: InkWell(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 20, right: 5),
                        width: 40,
                        child:  Text(
                          "$order",
                          style: Theme.of(context).textTheme.title,
                        )
                    ),
                    Container(
                        height: 70,
                        width:  70,
                        child: Hero(
                            tag: heroTag,
                            child: buildAppIcon(index, product.image)
                        )
                    ),
                    Expanded(
                        child: Container(
                            margin: EdgeInsets.only(left: 12, right: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Hero(
                                  tag: titleTag,
                                  child: Text(
                                      name,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1
                                  ),
                                ),
                                Text(
                                  category,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: greyColor
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    SmoothStarRating(
                                      allowHalfRating: false,
                                      starCount: 5,
                                      rating: rating,
                                      size: 15.0,
                                      color: Colors.orange,
                                      borderColor: Colors.orange,
                                    ),
                                    Text(
                                        "($userCount)"
                                    )
                                  ],
                                )

                              ],
                            )
                        )
                    )

                  ],
                )
            )
        ),
        Container(
          margin: EdgeInsets.only(left: 20),
          child: Divider(height: 4, color: greyColor),
        )
      ],
    );

  }

  Widget buildAppIcon(int index, String iconUrl){
    BorderRadius radius;
    if(0 == index % 2){
      // Rounded
      radius = BorderRadius.circular(16.0);
    }
    else{
      // Circle
      radius = BorderRadius.circular(35.0);
    }

    return ClipRRect(
        borderRadius: radius,
        child: CachedNetworkImage(
            imageUrl: APIProvider.baseUrl + "/api/image/" + iconUrl,
            errorWidget: (context, url, error) => new Icon(Icons.error),
            fadeOutDuration: new Duration(seconds: 1),
            fadeInDuration: new Duration(seconds: 1)
        )
    );
  }


}