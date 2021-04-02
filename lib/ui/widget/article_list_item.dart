
import 'package:flutter/material.dart';
import 'package:flutter_app_wanandroid/ui/page/article_webview.dart';

class ArticleItem extends StatelessWidget {
  final itemData;


  ArticleItem(this.itemData);

  @override
  Widget build(BuildContext context) {
    Row author = new Row(
      children: <Widget>[
        new Expanded(child:
        Text.rich(TextSpan(children: [
          TextSpan(text: "作者："),
          TextSpan(
            text: itemData["shareUser"],
            style: new TextStyle(color: Theme.of(context).primaryColor)
          )
        ]))),
        new Text(itemData["niceDate"])
      ],
    );

    Text title = new Text(itemData["title"],
    style: new TextStyle(fontSize: 16.0),
    textAlign: TextAlign.left,);

    Text chapterName = new Text(itemData["chapterName"],
    style: new TextStyle(color: Theme.of(context).primaryColor),);

    Column column = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Padding(padding: EdgeInsets.all(10.0),
        child: author,),
        new Padding(padding: EdgeInsets.fromLTRB(10.0,5.0,10.0,5.0),
        child: title,),
        new Padding(padding: EdgeInsets.fromLTRB(10.0,5.0,10.0,5.0),
          child: chapterName,),
      ],
    );
    return Card(
      elevation: 4.0,
      child:InkWell(
        child: column,
        onTap: (){
          Navigator.of(context).push(new MaterialPageRoute(builder: (context){
            itemData["url"] = itemData["link"];
            return new WebViewPage(itemData);
          }));
        },
      ),
    );
  }
}
