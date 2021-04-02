import 'package:flutter/material.dart';
import 'package:flutter_app_wanandroid/ui/page/article_home_page.dart';
import 'package:flutter_app_wanandroid/ui/page/page_splash.dart';

void main()=>runApp(ArticleApp());

class ArticleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      routes: {
        '/': (context) => SplashPage(),
      },
    );
  }
}
