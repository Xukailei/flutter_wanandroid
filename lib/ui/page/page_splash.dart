import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_wanandroid/manager/app_manager.dart';
import 'package:flutter_app_wanandroid/ui/page/article_home_page.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async{
    Iterable<Future> futures = [AppManager.initApp(),Future.delayed(Duration(seconds: 5))];
    await Future.wait(futures);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
      return ArticlePage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset("assets/images/splash.png"),
      // body: Image.network("https://www.wanandroid.com/blogimgs/62c1bd68-b5f3-4a3c-a649-7ca8c7dfabe6.png",),

    );
  }

}
