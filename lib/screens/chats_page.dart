import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gazimsg/models/conversation.dart';
import 'package:gazimsg/screens/converstaion_page.dart';
import 'package:gazimsg/viewmodels/chats_model.dart';
import 'package:gazimsg/viewmodels/sign_in_model.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatelessWidget {
  final String userId= "C21RctD21DWjtwUUWuvxkHkmEkp2";
  const ChatsPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var model = GetIt.instance<ChatsModel>();
    var user = Provider.of<SignInModel>(context).currentUser;


    return ChangeNotifierProvider(
      create: (BuildContext context)=>model,
          child: StreamBuilder<List<Conversation>>(
        stream: model.conversations(user.uid),
      
      
        builder: (BuildContext context, AsyncSnapshot<List<Conversation>> snapshot){

          if (snapshot.hasError){
            return Text('Error: ${snapshot.error}');//yüklenme olmadığında hata mesajı eklendi
          }

          if(snapshot.connectionState == ConnectionState.waiting){
            return Text('Yükleniyor'); //bağlantıda gecikme olduğunda yükleniyor yazısı eklendi
          }

          return ListView(
            children: snapshot.data
                .map((doc) => ListTile(
                     leading: CircleAvatar(
                     backgroundImage: NetworkImage(doc.profileImage),//kişilere profil fotoğrafı eklendi
                    ),
                    title: Text(doc.name),//Listeye isimler eklendi
                    subtitle: Text(doc.displayMessage),//isimlerin altına mesajlar eklendi
                    trailing: Column(
                      children: <Widget>[Text("19.26"),//mesaj zamanı eklendi
                      Container(
                        width: 20,
                        height: 20,
                        margin: EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                           color: Colors.blue//Yeni mesaj ikonu oluşturuldu
                        ),
                        child: Center(
                          child: Text(
                            "17",
                            textScaleFactor: 0.8,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white ),//Mesaj ikonu düzenlendi
                            ),
                        ),
                      )],
                      ),
                      onTap: (){
                        Navigator.push(context, 
                        MaterialPageRoute(
                          builder: (content)=>ConversationPage(
                          userId: user.uid, 
                          conversation: doc,
                          )));

                      },
                  ))
            .toList(),
          );
        },
      ),
    );
  }
}
