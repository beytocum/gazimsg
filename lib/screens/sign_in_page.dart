import 'package:flutter/material.dart';
import 'package:gazimsg/viewmodels/sign_in_model.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _editingController = TextEditingController();
    return ChangeNotifierProvider(
      create: (BuildContext context) => GetIt.instance<SignInModel>(),
          child: Consumer<SignInModel>(
            builder: (BuildContext context, SignInModel model, Widget child) => Scaffold(
        appBar: AppBar(
          title: Text('Giriş Yapınız'),
        ),
        body: Container(
          padding: EdgeInsets.all(8),
          child: model.busy 
          ? CircularProgressIndicator()
          : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Text('Kullanıcı Adı'),
            TextField(
              controller: _editingController,
            ),
            RaisedButton(
              child: Text('Giriş Yap'),
              onPressed: () async { 
              await model.signIn(_editingController.text);
              }
            )
            ],
          ),
        ),
      ),
            ),
    );
    
  }
}