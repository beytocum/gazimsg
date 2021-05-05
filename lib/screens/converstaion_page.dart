
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gazimsg/core/locator.dart';
import 'package:gazimsg/models/conversation.dart';
import 'package:gazimsg/viewmodels/convarsation_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ConversationPage extends StatefulWidget {
  final String userId;
  final Conversation conversation;

  const ConversationPage({Key key, this.userId, this.conversation}) : super(key: key);

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final TextEditingController _editingController = TextEditingController();
 
 CollectionReference _ref;
 FocusNode _focusNode;
 ScrollController _scrollController;

  @override
  void initState() {
    _ref = FirebaseFirestore.instance.collection('conversations/${widget.conversation.id}/messages');
    _focusNode = FocusNode();
    _scrollController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var model = getIt<ConversationModel>();
    return ChangeNotifierProvider(

          create: (BuildContext context) => model,
          child: Scaffold(
        appBar: AppBar(
          titleSpacing: -5,
          title: Row(children: <Widget>[
            CircleAvatar(backgroundImage: 
            NetworkImage(widget.conversation.profileImage),//profil fotoğrafı eklendi
            ), 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.conversation.name),//kişinin ismi eklendi
            )
          ],
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                child: Icon(Icons.phone_enabled), // Arama ikonu eklendi
              onTap: (){},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                child: Icon(Icons.videocam),//Kamera ikonu eklendi
                 onTap: (){}
                 ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                  child: Icon(Icons.more_vert)//3 nokta eklentisi yapıldı
                  ,),
            )
              
          ],
        ),
        body: Container(
          decoration: BoxDecoration(image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage("https://i.pinimg.com/564x/a3/64/2f/a3642fb7a90e072cb32e88a84dec2c8b.jpg")//sohbet arkaplan resmi eklendi
          )),
          child: Column(
            children: [
              Expanded(
                  child: GestureDetector(
                    onTap: () => _focusNode.unfocus(),//klavye dışında bi alana tıklandığında klavyenin kapatılması sağlandı
                    child: StreamBuilder(
                      stream: model.getConversation(widget.conversation.id),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) => !snapshot.hasData 
                        ? CircularProgressIndicator()
                        : ListView(
                          controller: _scrollController,
                          children: snapshot.data.docs
                          .map(
                            (document) => ListTile(
                              title: document['media'] == null || 
                                      document['media'].isEmpty
                                      ? Container()
                                      :Align(
                                        alignment: Alignment.bottomRight,
                                        child: SizedBox(
                                          height: 125,
                                          child: Image.network(document['media'])),
                                      ),
                          subtitle: Align(
                            alignment:
                             widget.userId != document['senderId']
                            ? Alignment.centerLeft //kullanıcı gönderene eşitse mesajlar sola
                            : Alignment.centerRight, //kullanıcı gönderene eşit değilse mesajlar sağa yaslanması sağlandı
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(10),
                                  right: Radius.circular(10)
                                  )),
                              child: Text(
                                document['message'], 
                                style: TextStyle(color: Colors.white), //mesaj rengi ayarlandı
                              ))),
                          ),
                          )
                          .toList(),
                          ),
                    ),
                  ),
              ),
              Consumer<ConversationModel>(builder: (BuildContext context,ConversationModel value, 
              Widget child) { 
                  return model.mediaUrl.isEmpty
                  ? Container()
                  : Align(
                    alignment: Alignment.bottomRight,
                      child: SizedBox(
                      width: 125,
                      child: Image.network(model.mediaUrl)),
                  );
               },
               ),
                           
              Row
              (children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(color: Colors.white,
                    borderRadius: BorderRadius.horizontal(
                      
                      left: Radius.circular(25),
                      right: Radius.circular(25),
                    ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Icon(Icons.tag_faces, color: Colors.black87,),
                          ),
                        ),
                        Expanded(
                            child: TextField(
                              focusNode: _focusNode,
                              controller: _editingController,
                            decoration: 
                            InputDecoration(hintText: "Bir mesaj yaz",//Mesaj başlatma metini eklendi
                            border: InputBorder.none
                            ),
                            ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(child: Icon(
                            Icons.attach_file_sharp
                          ),
                          onTap: () async => 
                          await model.uploadMedia(ImageSource.gallery),
                          ),
                        ),
                        InkWell(child: Icon(
                          Icons.camera_alt_rounded //fotoğraf göndermek için kamera ikonu eklendi
                        ),
                        onTap: () => model.uploadMedia(ImageSource.camera),
                        ),
                      ],
                    ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                        ),//mesaj gönderme butonu eklendi ve buton aktif edildi
                      onPressed: () async {
                         await model.add({
                          'senderId': widget.userId,
                          'message': _editingController.text,
                          'timeStamp': DateTime.now(), //mesajlara zaman eklentisi yapıldı
                          'media': model.mediaUrl,
                        });

                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent, //yeni mesaj yazıldığında sohbet ekranı en alta inmesi sağlandı
                          duration: Duration(milliseconds: 200), 
                          curve: Curves.easeIn,
                        );
                        _editingController.text = '';
                      },
                      ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}