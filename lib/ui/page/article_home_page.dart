import 'package:banner_view/banner_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_wanandroid/event/events.dart';
import 'package:flutter_app_wanandroid/http/api.dart';
import 'package:flutter_app_wanandroid/manager/app_manager.dart';
import 'package:flutter_app_wanandroid/ui/page/article_webview.dart';
import 'package:flutter_app_wanandroid/ui/widget/article_list_item.dart';
import 'package:flutter_app_wanandroid/ui/widget/main_drawer.dart';
import 'package:toast/toast.dart';

class ArticlePage extends StatefulWidget {
  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  ScrollController _controller = new ScrollController();

  bool _isHide = true;

  List articles = [];

  List banners = [];

  var listTotalSize = 0;

  var curPage = 0;

  DateTime _lastClick;
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;

      var pixels = _controller.position.pixels;

      if (maxScroll == pixels && curPage > listTotalSize) {
        _getArticlelist();
      }
    });
    AppManager.eventBus.on<LoginEvent>().listen((event) {
      if (mounted) {
        setState(() {
          _pullToRefresh();
        });
      }
    });
    AppManager.eventBus.on<LogoutEvent>().listen((event) {
      if (mounted) {
        setState(() {
          _pullToRefresh();
        });
      }
    });
    AppManager.eventBus.on<CollectEvent>().listen((event) {
      if (mounted) {
        articles.every((item) {
          if (item["id"] == event.id) {
            item["collect"] = event.collect;
            return false;
          }
        });
      }
    });
    _pullToRefresh();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pullToRefresh() async {
    curPage = 0;
    Iterable<Future> futures = [_getArticlelist(), _getBanner()];
    await Future.wait(futures);
    _isHide = false;
    setState(() {});
    return null;
  }

  _getBanner([bool update = true]) async {
    var data = await Api.getBanner();
    if (data != null) {
      banners.clear();
      banners.addAll(data["data"]);

      if (update) {
        setState(() {});
      }
    }
  }

  _getArticlelist([bool update = true]) async {
    var data = await Api.getArticleList(curPage);
    if (data != null) {
      var map = data["data"];
      var datas = map["datas"];

      listTotalSize = map["total"];

      if (curPage == 0) {
        articles.clear();
      }
      curPage++;
      articles.addAll(datas);
      if (update) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
        child: Scaffold(
          appBar: new AppBar(
            title: Text(
              "文章",
              style: const TextStyle(color: Colors.white),
            ),
          ),
          drawer: Drawer(
            child: MainDrawer(),
          ),
          body: Stack(
            children: <Widget>[
              Offstage(
                offstage: !_isHide,
                child: new Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              Offstage(
                offstage: _isHide,
                child: new RefreshIndicator(
                    child: ListView.builder(
                      itemCount: articles.length + 1,
                      itemBuilder: (context, i) => _buildItem(i),
                      controller: _controller,
                    ),
                    onRefresh: _pullToRefresh),
              )
            ],
          ),
        ),
        onWillPop: () async {
          if(_lastClick == null || DateTime.now().difference(_lastClick)>Duration(seconds: 2)){
            _lastClick = DateTime.now();
            Toast.show("请再按一次退出！", context,gravity: Toast.BOTTOM,duration: Toast.LENGTH_LONG);
            return false;
          }
          return true;
        });
  }

  Widget _buildItem(int i) {
    if (i == 0) {
      return new Container(
        height: 180,
        child: _bannerView(),
      );
    }
    var itemData = articles[i - 1];
    return new ArticleItem(itemData);
  }

  Widget _bannerView() {
    var list = banners.map((item) {
      return InkWell(
        child: Image.network(
          item['imagePath'],
          fit: BoxFit.cover,
        ),
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return new WebViewPage(item);
          }));
        },
      );
    }).toList();

    return list.isNotEmpty
        ? BannerView(
            list,
            intervalDuration: const Duration(seconds: 3),
          )
        : null;
  }
}
