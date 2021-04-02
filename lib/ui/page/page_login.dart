

import 'package:flutter/material.dart';
import 'package:flutter_app_wanandroid/event/events.dart';
import 'package:flutter_app_wanandroid/http/api.dart';
import 'package:flutter_app_wanandroid/manager/app_manager.dart';
import 'package:flutter_app_wanandroid/ui/page/page_register.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  FocusNode _pwdNode = new FocusNode();
  String _username,_password;
  bool _isObscure = true;
  Color _pwdIconColor;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _pwdNode.dispose();
    super.dispose();
  }

  Widget _buildRegister(){
    return Padding(padding: EdgeInsets.only(top: 10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(("没有账号？")),
        GestureDetector(
          child: Text("点击注册",
          style: TextStyle(color: Colors.green),
          ),
          onTap: ()async{
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return RegisterPage();
            }));
          },
        ),

      ],
    ),);

  }

  Widget _buildLogin(){
    return Container(
      height: 45.0,
      margin: EdgeInsets.only(top:18.0,left: 8.0,right: 8.0),
      child: ElevatedButton(
        child: Text("登录",
        style: TextStyle(fontSize: 18.0,color: Colors.white),
        ),
        onPressed:_doLogin,
      ),
      color: Theme.of(context).primaryColor,
    );
  }
  Widget _buildPwd(){
    return TextFormField(
      focusNode: _pwdNode,
      obscureText: _isObscure,
      validator: (String value){
        if(value.trim().isEmpty){
          return '请输入密码';
        }
        _password = value;
      },
      textInputAction: TextInputAction.done,
      onEditingComplete: _doLogin,
      decoration: InputDecoration(
        labelText: '密码',
        // 尾部图标
        suffixIcon: IconButton(
          icon: Icon(
            Icons.remove_red_eye,
            color: _pwdIconColor,
            // color: ,
          ),
          onPressed: (){
            setState(() {
              _isObscure = !_isObscure;

              _pwdIconColor = _isObscure
              ?Colors.grey:Theme.of(context).iconTheme.color;
            });
          },
        )
      ),
    );

  }
  Widget _buildUserName(){
    return TextFormField(
      autofocus: true,
      decoration: InputDecoration(
        labelText: '用户名'
      ),
      initialValue: _username,
      textInputAction: TextInputAction.next,
      onEditingComplete: (){
        FocusScope.of(context).requestFocus(_pwdNode);
      },
      validator: (String value){
        if (value.trim().isEmpty) {
          return '请输入用户名';
        }
        _username = value;
      },
    );
  }

  void _doLogin() async{
    _pwdNode.unfocus();
    if(_formKey.currentState.validate()){
      showDialog(context: context,barrierDismissible: false, builder: (_){
        return Center(child: CircularProgressIndicator(),);
      });

      var result =await Api.login(_username,_password);

      Navigator.pop(context);
      if(result["errorCode"] == -1){
        Toast.show(result["errorMsg"], context,duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
      }else{
        AppManager.eventBus.fire(LoginEvent(_username));
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登录"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 22.0),
          children: [
            _buildUserName(),
            _buildPwd(),
            _buildLogin(),
            _buildRegister()
          ],
        ),
      ) ,
    );
  }
}
