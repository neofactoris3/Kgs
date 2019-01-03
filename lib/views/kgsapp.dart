import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kgs_app/views/drawer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'news_details.dart';

class KgsApp extends StatefulWidget {
  final List<String> labels = ['Pezhamattom', 'Edakkara'];

  @override
  _KgsAppState createState() => new _KgsAppState();
}

class _KgsAppState extends State<KgsApp> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

//to do - notifications
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.getToken().then((token){
      print(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    ListTile makeListTile(DocumentSnapshot document) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.white24))),
            child: Icon(Icons.notifications_active, color: Colors.white),
          ),
          title: Text(
            document['title'],
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(document['shortDesc'].toString(),
              style: TextStyle(color: Colors.white)),

          /*subtitle: new Text(document['date'],style: TextStyle(fontStyle: FontStyle.italic)),*/
          trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewsDetails(document: document)));
          },
        );

    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Colors.teal,
      title: Text('Family News'),
        centerTitle: true,
    );

    Card makeCard(DocumentSnapshot document) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.teal),
            child: makeListTile(document),
          ),
        );

    Card makeUnreadCard(DocumentSnapshot document) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.deepOrangeAccent),
            child: makeListTile(document),
          ),
        );

    return new Scaffold(
      appBar: topAppBar,
      drawer: new MainDrawer(labels: widget.labels),
      body: new StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('news')
              .orderBy('date', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            final int itemsCount = snapshot.data.documents.length;
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new CircularProgressIndicator();
              default:
                return new ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: itemsCount,
                  itemBuilder: (BuildContext context, int index) {
                    final DocumentSnapshot document =
                        snapshot.data.documents[index];

                    if (document['color'] == true) {
                      return makeUnreadCard(snapshot.data.documents[index]);
                    }
                    return makeCard(snapshot.data.documents[index]);
                  },
                );
            }
          }),
    );
  }

}
