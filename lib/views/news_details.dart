import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewsDetails extends StatefulWidget {
  final DocumentSnapshot document;

  NewsDetails({Key key, this.document}) : super(key: key);

  @override
  _MyNewsDetails createState() => new _MyNewsDetails();
}

class _MyNewsDetails extends State<NewsDetails> {
  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAvatar(),
          _buildInfo(),
          /*_buildVideoScroller(),*/
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 110.0,

      /*decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white30),
      ),*/
      margin: const EdgeInsets.only(top: 32.0, left: 16.0),
      padding: const EdgeInsets.all(3.0),
      /*child: ClipOval(
        child: Image.asset(widget.document['imageUrl']),
      ),*/
    );
  }

  Widget _buildInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.document['title'],
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
            ),
          ),
          Text(
            widget.document['shortDesc'],
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            color: Colors.white.withOpacity(0.85),
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            width: 225.0,
            height: 1.0,
          ),
          Text(
            widget.document['desc'],
            style: TextStyle(
              color: Colors.white,
              height: 1.5,
              fontSize: 15.0,
            ),
          ),
          Container(
            color: Colors.white.withOpacity(0.85),
            margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 100),
            width: 225.0,
            height: 1.0,
          ),
        ],
      ),
    );
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('News in Detail'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Image(
              image:
                  new CachedNetworkImageProvider(widget.document['imageUrl']),
              fit: BoxFit.cover),
          /*CachedNetworkImage(imageUrl: widget.document['imageUrl']),*/
          BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0.7),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }
}
