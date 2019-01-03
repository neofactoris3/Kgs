import 'package:flutter/material.dart';
import 'package:kgs_app/views/edakkara_view.dart';
import 'pezhamattom_view.dart';

const String _AccountName = '';
const String _AccountEmail = '';

class MainDrawer extends StatelessWidget {
  final List<String> drawerLabels;

  MainDrawer({this.drawerLabels});

  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: new ListView(
            padding: const EdgeInsets.only(top: 0.0),
            children: _buildDrawerList(context)));
  }

  _onListTileTapPezhamattom(BuildContext context, String title) {
    Navigator.of(context).popUntil(ModalRoute.withName('/'));
    Navigator.of(context)
        .push(new PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
      return new PezhamattomView(title: title);
    }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
      return new FadeTransition(opacity: animation, child: child);
    }));
  }

  _onListTileTapEdakkara(BuildContext context, String title) {
    Navigator.of(context).popUntil(ModalRoute.withName('/'));
    Navigator.of(context)
        .push(new PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
      return new EdakkaraView(title: title);
    }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
      return new FadeTransition(opacity: animation, child: child);
    }));
  }

  List<Widget> _buildDrawerList(BuildContext context) {
    List<Widget> children = [];
    children
      ..addAll(_buildUserAccounts(context))
      ..addAll(_Admin(context))
      ..addAll([new Divider()])
      ..addAll(_buildContactWidgets(context))
      ..addAll([new Divider()]);

    return children;
  }

  List<Widget> _buildUserAccounts(BuildContext context) {
    return [
      new UserAccountsDrawerHeader(
        accountName: Text(_AccountName),
        accountEmail: Text(_AccountEmail),
        currentAccountPicture: new CircleAvatar(
            backgroundColor: Colors.brown,
            backgroundImage: new AssetImage('images/thirumeni.png')),
      )
    ];
  }

  List<Widget> _buildContactWidgets(BuildContext context) {
    List<Widget> ContactListTiles = [];
    ContactListTiles.add(new ListTile(
      leading: new Text('Contacts'),
    ));
    ContactListTiles.add(new ListTile(
      leading: new Icon(Icons.account_circle),
      title: new Text('Pezhamattom'),
      onTap: () => _onListTileTapPezhamattom(context, ' Contacts'),
    ));

    ContactListTiles.add(new ListTile(
      leading: new Icon(Icons.account_circle),
      title: new Text('Edakkara'),
      onTap: () => _onListTileTapEdakkara(context, ' Contacts'),
    ));

    return ContactListTiles;
  }


}
