import 'package:flutter/material.dart';
import 'package:flutter_app_wanandroid/http/api.dart';
import 'package:toast/toast.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<FormState>();

  FocusNode _userNameNode = new FocusNode();
  FocusNode _pwdNode = new FocusNode();
  FocusNode _pwd2Node = new FocusNode();

  String _username, _pwd, _pwd2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("注册"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(22.0, 18.0, 22.0, 0),
          children: [
            _buildUserName(),
            _buildPwd(),
            _buildPwd2(),
            _buildRegister()
          ],
        ),
      ),
    );
  }

  Widget _buildUserName() {
    return TextFormField(
      focusNode: _userNameNode,
      decoration: InputDecoration(labelText: "用户名"),
      textInputAction: TextInputAction.next,
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(_pwdNode);
      },
      validator: (String value) {
        if (value.trim().isEmpty) {
          return "请输入用户名";
        }
        _username = value;
      },
    );
  }

  Widget _buildPwd() {
    return TextFormField(
      obscureText: true,
      focusNode: _pwdNode,
      decoration: InputDecoration(labelText: "密码"),
      textInputAction: TextInputAction.next,
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(_pwd2Node);
      },
      validator: (String valur) {
        if (valur.trim().isEmpty) {
          return "请输入密码";
        }
        _pwd = valur;
      },
    );
  }

  Widget _buildPwd2() {
    return TextFormField(
      obscureText: true,
      focusNode: _pwd2Node,
      decoration: InputDecoration(labelText: "密码"),
      textInputAction: TextInputAction.go,
      onEditingComplete: () {
        _click();
      },
      validator: (String valur) {
        if (valur.trim().isEmpty) {
          return "请输入密码";
        }
        if (_pwd != valur) {
          return "两次密码输入不一直致";
        }
        _pwd2 = valur;
      },
    );
  }

  Widget _buildRegister() {
    return Container(
      height: 52.0,
      margin: EdgeInsets.only(top: 18.0),
      child: ElevatedButton(
        child: Text(
          "注册",
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        onPressed: _click,
      ),
      color: Theme.of(context).primaryColor,
    );
  }

  void _click() async {
    _userNameNode.unfocus();
    _pwdNode.unfocus();
    _pwd2Node.unfocus();

    if (_formKey.currentState.validate()) {
      showDialog(
          context: context,
          builder: (_) {
            return Center(
              child: CircularProgressIndicator(),
            );
          },
          barrierDismissible: false);

      var result = await Api.register(_username, _pwd);

      Navigator.pop(context);
      if (result['errorCode'] == -1) {
        Toast.show(result['errorMsg'], context,
            gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
      } else {
        Toast.show("注册成功", context,
            gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
        Navigator.pop(context);
      }
    }
  }
}
