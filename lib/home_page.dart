import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var data;
  Future<void> getUserApi() async {
    final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
    if(response.statusCode == 200) {
       data = jsonDecode(response.body.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Tutorial 4'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
                future: getUserApi(),
                builder: (context,snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(backgroundColor: Colors.green,),);
                  } else {
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context,index) {
                          return Card(
                            child: Column(
                              children: [
                                ReusableRow(title: 'Name', value: data[index]['name']),
                                ReusableRow(title: 'Username', value: data[index]['username']),
                                ReusableRow(title: 'Address', value: data[index]['address']['street']),
                                ReusableRow(title: 'Geo', value: data[index]['address']['geo']['lat']),
                              ],
                            ),
                          );
                        }
                    );
                  }
                },
              )
          )
        ],
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  String title;
  String value;
  ReusableRow({Key? key,required this.title,required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value)
        ],
      ),
    );
  }
}
