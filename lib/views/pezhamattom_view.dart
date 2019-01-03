import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PezhamattomView extends StatefulWidget {
  final String title;

  PezhamattomView({this.title});

  @override
  _PezhamattomViewState createState() => _PezhamattomViewState();
}

class _PezhamattomViewState extends State<PezhamattomView> {
  String _phone = '';
  List allContacts = [];

  bool contactsloaded = false;

  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.teal,
          centerTitle: true,
        ),
        body: new StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('pezhamattomContacts')
                .orderBy('name', descending: false)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');

              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: new CircularProgressIndicator());
                default:
                  return new ListView(
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      return new ListTile(
                        title: new Text(document['name'],
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: new Text(document['desc'],
                            style: TextStyle(fontStyle: FontStyle.italic)),
                        leading: new CircleAvatar(
                          backgroundColor: Colors.teal.shade200,
                          backgroundImage: new CachedNetworkImageProvider(
                              document['picUrl']),
                        ),
                        onTap: () {
                          showContact(context, document);
                          /* Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailScreen(document: document),
                            ),
                          );*/
                        },
                      );
                    }).toList(),
                  );
              }
            }));
  }

  Future<bool> showContact(context, contact) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                  height: 600.0,
                  width: 500.0,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                  child: SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(height: 250.0),
                          Container(
                            height: 270.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                ),
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        contact['picUrl']),
                                    fit: BoxFit.cover)),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            contact['name'],
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      SizedBox(height: 5.0),
                      Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            contact['desc'],
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              height: 1.0,
                              wordSpacing: 2.0,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w300
                            ),
                          )),

                      SizedBox(height: 10.0),
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Phonenumber - '+contact['phoneNumber'],
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 18.0,
                              fontWeight: FontWeight.w100,
                            ),
                          )),
                      SizedBox(height: 30.0),
                      Container(
                          height: 40.0,
                          width: 95.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.greenAccent,
                            color: Colors.deepOrangeAccent,
                            elevation: 7.0,
                            child: GestureDetector(
                              onTap: () => setState(() {
                                    _launched = _makePhoneCall(
                                        'tel://' + contact['phoneNumber']);
                                  }),
                              child: Center(
                                child: Text(
                                  'Call',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            ),
                          )),
                      SizedBox(height: 15.0),
                      Container(
                          height: 40.0,
                          width: 130.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.greenAccent,
                            color: Colors.green,
                            elevation: 7.0,
                            child: GestureDetector(
                              onTap: () => setState(() {
                                    _launched = _makePhoneCall(
                                        'whatsapp://send?phone=' +
                                            contact['phoneNumber']);
                                  }),
                              child: Center(
                                child: Text(
                                  'Whatsapp',
                                  style: TextStyle(


                                      color: Colors.white,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            ),
                          ))
                    ],
                  ))));
        });
  }
}

Future<void> _launched;

Future<void> _makePhoneCall(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
