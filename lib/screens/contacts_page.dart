import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gazimsg/core/locator.dart';
import 'package:gazimsg/models/profile.dart';
import 'package:gazimsg/viewmodels/contacts_model.dart';
import 'package:gazimsg/viewmodels/sign_in_model.dart';
import 'package:provider/provider.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yeni Mesaj"),//Ekranın başlığına Yeni Mesaj yazıldı
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search), //arama butonu eklendi
            onPressed: () {
              showSearch(context: context, delegate: ContactSearchDelegate());//Arama butonuna tıklandığında çalışması sağlandı
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert), 
            
            onPressed: () {},
            ),


        ],
      ),
      body:  ContactsList(),
    );
  }
}

class ContactsList extends StatelessWidget {
  final String query;
  const ContactsList({
    Key key, this.query,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = getIt<ContactsModel>();
    var user = Provider.of<SignInModel>(context).currentUser;
    return FutureBuilder(
      future: model.getContacts(query),
          builder: (BuildContext context, AsyncSnapshot<List<Profile>> snapshot) {  
            if(snapshot.hasError) 
            return Center(
              child: Text(
                snapshot.error.toString()
              ),
            );

            if(!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
               );
          return  ListView(
        children: <Widget>[
          ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.group_add_sharp, color: Colors.white),//ikon şekli ve rengi ayarlandı
          ),
          title: Text("Yeni grup"),//Yeni grup yazısı ve ikonu eklendi
        ),
        ListTile(
           leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.person_add, color: Colors.white),//ikon şekli ve rengi ayarlandı
          ),
          title: Text("Yeni kişi"),//Yeni kişi yazısı ver ikonu eklendi
        ),
        ]..addAll(snapshot.data
        .map((Profile) => ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).accentColor,
            backgroundImage: NetworkImage(Profile.image),
          ),
          title: Text(Profile.userName),
          onTap: () => model.startConversation(user,Profile),

        ),
        )
        .toList()));
    },
    );
  }
}

class ContactSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: Colors.redAccent,
    );
  }


  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
    }
  
    @override
    Widget buildLeading(BuildContext context) {
      return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        },
        );
    }
  
    @override
    Widget buildResults(BuildContext context) {
      return ContactsList(
        query: query,
        );
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {
      return Center(
        child: Text("Kişiyi arayın"), 
        );
  }
}