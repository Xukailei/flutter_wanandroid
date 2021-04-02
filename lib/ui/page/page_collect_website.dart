import 'package:flutter/material.dart';
import 'package:flutter_app_wanandroid/http/api.dart';
import 'package:flutter_app_wanandroid/ui/page/page_collect_add_website.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:toast/toast.dart';

class WebsiteCollectPage extends StatefulWidget {
  @override
  _WebsiteCollectPageState createState() => _WebsiteCollectPageState();
}

class _WebsiteCollectPageState extends State<WebsiteCollectPage>
    with AutomaticKeepAliveClientMixin {
  bool _isHide = false;

  List _collects = [];

  @override
  void initState() {
    super.initState();
    _getCollects();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Offstage(
          offstage: _isHide,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        Offstage(
          offstage: _collects.isNotEmpty | !_isHide,
          child: Center(
            child: Text("(>_<) 你还没有收藏任何内容......"),
          ),
        ), Offstage(
          offstage: _collects.isEmpty,
          child: RefreshIndicator(
            onRefresh: () => _getCollects(),
            child: ListView.separated(

              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(22.0),
              itemBuilder: (context, i) => _buildItem(context, i),
              separatorBuilder: (context, i) {
                return Padding(padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Divider(color: Colors.grey,),);
              },
              itemCount: _collects.length,
            ),

          ),
        ),
        Positioned(
            bottom: 18.0,
            right: 18.0,
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: _addCollect,
            )
        )

      ],
    );
  }

  _getCollects() async {
    var result = await Api.getWebSiteCollects();
    if (result != null) {
      var data = result["data"];
      _collects.clear();
      _collects.addAll(data);
      _isHide = true;
      setState(() {

      });
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  _buildItem(BuildContext context, int i) {
    var item = _collects[i];

    return Slidable(
      secondaryActions: [
        IconSlideAction(
          caption: "删除",
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _delCollect(item),
        )
      ],
      actionExtentRatio: 0.25,
      actionPane: SlidableDrawerActionPane(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item["name"], style: TextStyle(fontSize: 22.0),),
          Padding(padding: EdgeInsets.only(top: 8.0),
            child: Text(
              item["link"],
              style: TextStyle(color: Theme
                  .of(context)
                  .primaryColor),
            ),)
        ],
      ),);
  }

  _addCollect() async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => WebsiteAddPage()));
    if (result != null) {
      _collects.add(result);
    }
  }

  _delCollect(item) async {
    showDialog(context: context,
        barrierDismissible: false,
        builder: (_) {
          return Center(child: CircularProgressIndicator(),);
        });
    var result = await Api.unCollectArticle(item["id"]);
    Navigator.pop(context);

    if (result["errorCode"] != 0) {
      Toast.show(result["errorMsg"], context, duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM);
    } else {
      setState(() {
        _collects.remove(item);
      });
    }
  }

}
