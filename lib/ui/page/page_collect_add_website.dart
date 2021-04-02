import 'package:flutter/material.dart';
import 'package:flutter_app_wanandroid/http/api.dart';
import 'package:toast/toast.dart';

class WebsiteAddPage extends StatefulWidget {
  @override
  _WebsiteAddPageState createState() => _WebsiteAddPageState();
}

class _WebsiteAddPageState extends State<WebsiteAddPage> {
  String _name;
  String _link;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("收藏网址"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(22.0, 18.0, 22.0, 0),
          children: [
            TextFormField(
              autofocus: true,
              decoration: InputDecoration(labelText: "名称"),
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return "请输入收藏网址名";
                }
                _name = value;
              },
            ),
            TextFormField(
              initialValue: "http://",
              decoration: InputDecoration(
                labelText: "地址"
              ),
              keyboardType: TextInputType.url,
              validator: (value){
                if(value.trim().isEmpty){
                  return "请输入收藏网站地址";
                }
                _link = value;
              },
            ),
            Container(
              height: 45.0,
              margin: EdgeInsets.only(top: 18.0,left: 8.0,right: 8.0,),
              child: ElevatedButton(
                child: Text("收藏",
                style: TextStyle(fontSize:18.0,color: Colors.white ),
                ),
                onPressed:()=> _doAdd(context),
              ),
              color: Theme.of(context).primaryColor,
            )
          ],
        ),
      ),
    );
  }

  _doAdd(context) async {
    if (_formKey.currentState.validate()) {
      showDialog(
          context: context,
          builder: (_) {
            return Center(child: CircularProgressIndicator());
          },
          barrierDismissible: false);

      var result = await Api.collectWebsite(_name, _link);
      Navigator.pop(context);

      if (result["errorCode"] != 0) {
        Toast.show(result["errorMsg"], context,
            gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
      } else {
        Navigator.pop(context);
      }
    }
  }
}
