import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'dart:async';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:SunShine/modele/transportmodel/transportModel.dart';

import '../../modele/Event/Event.dart';
import '../../modele/activitsmodel/httpActivitesTempid.dart';
import '../../modele/activitsmodel/httpTransportid.dart';
import '../../theme.dart';

class TransportDetailSecreen extends StatefulWidget {
  String? id;

  TransportDetailSecreen(this.id, {Key? key}) : super(key: key);

  @override
  _TransportDetailSecreenState createState() => _TransportDetailSecreenState();
}

class _TransportDetailSecreenState extends State<TransportDetailSecreen> {
  HTTPHandlerTrasportId trasferhandler = HTTPHandlerTrasportId();
  late Transport transport;
  String? baseUrl = "";
  String token = "";
  bool isLoading = true;
  late Future<void> _initializeVideoPlayerFuture;

  Future<Transport> _loadData() async {
    // String? accessToken = await getAccessToken();

    final updatedData =
        await trasferhandler.fetchData("/api/transfers-mobile/${widget.id}");
    setState(() {
      transport = updatedData;

      print(updatedData.id);
      isLoading = false;
    });
    return updatedData;
  }

  final storage = const FlutterSecureStorage();
  late Transport _transport;
  ImageProvider? image;
  Future<String?> getAccessToken() async {
    final token = await storage.read(key: 'access_token');
    return token;
  }

  @override
  void initState() {
    super.initState();

    // getAccessToken();
    // _transport = widget.id;
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _refresh() async {
    print("Screen refreshed");
    setState(() {
      _transport = Transport(
        id: _transport.note,
        driverId: "New name",
        // update other properties as needed
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Screen refreshed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("transport Detail"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transport.note ?? "No name",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          " from ",
                          style: kAppTheme.textTheme.displayLarge,
                        ),
                        Text(
                          transport.from ?? "No description",
                          style: kAppTheme.textTheme.displayLarge,
                        ),
                        Text(
                          " to ",
                          style: kAppTheme.textTheme.displayLarge,
                        ),
                        Text(
                          transport.to ?? "No description",
                          style: kAppTheme.textTheme.displayLarge,
                        ),
                      ],
                    ),

                    // Add more widgets to display other properties of 'activites'
// ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => TransportEditDetails(
//                               transport,
//                               token
//                             ),
//                           ),
//                         );
//                       },
//                       child: Text("Edit Transport Details"),
//                     ),
                  ],
                ),
              ),
            ),
    );
  }
}
