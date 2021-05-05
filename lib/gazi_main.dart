import 'package:flutter/material.dart';
import 'package:gazimsg/core/locator.dart';
import 'package:gazimsg/screens/calls_page.dart';
import 'package:gazimsg/screens/camera_page.dart';
import 'package:gazimsg/screens/chats_page.dart';
import 'package:gazimsg/screens/status_page.dart';
import 'package:gazimsg/viewmodels/main_model.dart';

class GaziMain extends StatefulWidget {
  @override
  _GaziMainState createState() => _GaziMainState();
}

class _GaziMainState extends State<GaziMain> with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool _showMessage = true;
  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this,initialIndex: 1);
    _tabController.addListener(() {
      _showMessage = _tabController.index !=0;
      setState(() {

      });
    });

  
    super.initState();
  }
  @override

  Widget build(BuildContext context) {
    var model = getIt<GaziMainModel>();
    return Scaffold(
      

      
      body: Container(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
                child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  floating: true,
                  title: Text("Gazi Msg"),
                  actions: <Widget>[
                    IconButton(icon: Icon(Icons.search), 
                    onPressed: (){},
                    ),
                    IconButton(icon: Icon(Icons.more_vert), onPressed: (){}
                    ),
                  ],

                  
                )
              ];
            },
            body: Column(
              children: <Widget>[
                    TabBar(
                      controller: _tabController,
                      tabs: <Widget>[
                        Tab(
                          icon: Icon(Icons.camera_alt_sharp),// Kamera ikonu eklendi
                        ),
                        Tab(
                          text: "Sohbetler", //TabBara sohbetler eklendi
                        ),
                        Tab(
                          text: "Durum",//TabBara durum eklendi
                        ),
                        Tab(
                          text: "Aramalar",//TabBara Aramalar eklendi
                        ),
                     ],
                   ),
                
              Expanded(
                  child: Container(
                    color: Colors.white,
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        CameraPage(),
                        ChatsPage(),
                        StatusPage(),
                        CallsPage(),

                      ],
                    ),
                  ),
              ),
            ],
          ),
            
            ),
        ),
      ),
      floatingActionButton: _showMessage
          ? FloatingActionButton(
        child: Icon(
          Icons.message_sharp, 
          color: Colors.blue,),
        onPressed: () async{
         await model.navigateToContacts();
        },
      
      )
      : null,
    );

  }
}
