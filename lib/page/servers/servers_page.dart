import 'package:admin/model/server_model.dart';
import 'package:admin/page/servers/servers_detail_page.dart';
import 'package:admin/page/servers/servers_list_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ServersPage extends StatefulWidget {
  const ServersPage({Key? key}) : super(key: key);

  @override
  _ServersPageState createState() => _ServersPageState();
}

class _ServersPageState extends State<ServersPage> {
  ServerModel? serverDetail;
  DatabaseReference? serverReference;

  @override
  Widget build(BuildContext context) {
    return serverDetail != null
        ? ServersDetailPage(
            server: serverDetail!,
            onTapBack: () {
              setState(() {
                serverDetail = null;
                serverReference = null;
              });
            },
            reference: serverReference!,
          )
        : ServersListPage(
            onSelectServer: (server, reference) {
              setState(
                () {
                  serverDetail = server;
                  serverReference = reference;
                },
              );
            },
          );
  }
}
