import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kgs_app/views/kgsapp.dart';


class HomePage extends StatelessWidget {
  Future<void> main() async {
    final FirebaseApp app = await FirebaseApp.configure(
      name: '',
      options: const FirebaseOptions(
        googleAppID: '',
        gcmSenderID: '',
        apiKey: '',
        projectID: '',
      ),
    );

    final Firestore firestore = Firestore(app: app);
    await firestore.settings(timestampsInSnapshotsEnabled: true);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        /*  primaryColor: Colors.blueAccent,*/
        primarySwatch: Colors.teal,
      ),
      home: new KgsApp(),
           /*routes: <String, WidgetBuilder>{
          LabelView.routeName: (BuildContext context) =>
              new LabelView(title: 'Contacts'),
        }*/
    );
  }
}
