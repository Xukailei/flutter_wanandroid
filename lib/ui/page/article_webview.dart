import 'package:flutter/material.dart';
import 'package:flutter_app_wanandroid/event/events.dart';
import 'package:flutter_app_wanandroid/http/api.dart';
import 'package:flutter_app_wanandroid/manager/app_manager.dart';
import 'package:flutter_app_wanandroid/ui/page/page_login.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewPage extends StatefulWidget {
  final data;

  ///是否允許收藏
  final supportCollect;

  WebViewPage(this.data, {this.supportCollect = true});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool isLoad = true;
  FlutterWebviewPlugin flutterWebViewPlugin;

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin = new FlutterWebviewPlugin();
    flutterWebViewPlugin.onStateChanged.listen((event) {
      if (event.type == WebViewState.finishLoad) {
        setState(() {
          isLoad = false;
        });
      } else if (event.type == WebViewState.startLoad) {
        setState(() {
          isLoad = true;
        });
      }
    });
  }

  @override
  void dispose() {
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    bool isCollect = widget.data["collect"]??false;

    return WebviewScaffold(
      appBar: AppBar(
        title: Text(widget.data["title"]),
        actions: <Widget>[
          Offstage(
            offstage: !widget.supportCollect,
            child: IconButton(
              icon: Icon(Icons.favorite,
              color: isCollect?Colors.red
                  :Colors.white,),
              onPressed: ()=>{
                _collect()
              },
            ),
          )
        ],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: const LinearProgressIndicator(),
        ),
        bottomOpacity: isLoad ? 1.0 : 0.0,
      ),
      withLocalStorage: true,
      url: widget.data["url"],
      withJavascript: true,
    );
  }

  _collect() async{
    var result;
    bool isLogin = AppManager.isLogin();
    if(isLogin){
      if(widget.data["collect"]){
        result = await Api.unCollectArticle(widget.data["id"]);
      }else{
        result = await Api.collectArticle(widget.data["id"]);
      }
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
    }

    if(result["errorCode"] ==0){
      setState(() {
        widget.data["collect"] = !widget.data["collect"];
        AppManager.eventBus.fire(CollectEvent(widget.data["id"], widget.data["collect"]));
      });
    }
  }
}
