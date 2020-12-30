import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Mobildata {
  int id;
  String merk;
  String url_foto_mobil;

  Mobildata({
    this.id,
    this.merk,
    this.url_foto_mobil
  });

  factory Mobildata.fromJson(Map<String, dynamic> json) {
    return Mobildata(
        id: json['id'],
        merk: json['merk'],
        url_foto_mobil: json['url_foto_mobil']

    );
  }
}

class details_details extends StatefulWidget {
  static Route<dynamic> route() => MaterialPageRoute(
    builder: (context) => details_details(),
  );
  @override
  _details_detailsState createState() => _details_detailsState();
}

class _details_detailsState extends State<details_details> {

  final String apiJSON = 'http://34.101.156.50/sewaaja/readImageText.php';

  Future<List<Mobildata>> fetchMobil() async {

    var response = await http.get(apiJSON);
    if (response.statusCode == 200) {

      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      List<Mobildata> listOfFruits = items.map<Mobildata>((json) {
        return Mobildata.fromJson(json);
      }).toList();
      return listOfFruits;
    }
    else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body:

      FutureBuilder<List<Mobildata>>(
        future: fetchMobil(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) return Center(
              child: CircularProgressIndicator());

          return ListView(children: snapshot.data
              .map((data) => Column(children: <Widget>[
                GestureDetector(
                  onTap: (){},

                  child: Row(
                      children: [
                        Container(
                            width: 200,
                            height: 100,
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child:
                                Image.network(data.url_foto_mobil,
                                  width: 200, height: 100, fit: BoxFit.cover,))),

                        Flexible(child:
                        Text(data.merk,
                            style: TextStyle(fontSize: 18)))]),),

            Divider(color: Colors.black),
          ],))
              .toList(),
          );},
      )
    );
  }
}
