import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_loginn/presentation/product_detail/pages/product_detail_detail.dart';


// Get Data JSON

class Mobildata {
  int id;
  String merk;
  String model;
  String type;
  String bahan_bakar;
  String transmisi;
  String image;
  String description;

  Mobildata({
    this.id,
    this.merk,
    this.model,
    this.type,
    this.bahan_bakar,
    this.transmisi,
    this.image,
    this.description
  });

  factory Mobildata.fromJson(Map<String, dynamic> json) {
    return Mobildata(
      id: json['id'],
      merk: json['merk'],
      model: json['model'],
      type: json['type'],
      bahan_bakar: json['bahan_bakar'],
      transmisi: json['transmisi'],
      image: json['image'],
      description: json['description']
    );
  }
}


class ImageDetail extends StatefulWidget {
  static Route<dynamic> route() => MaterialPageRoute(
    builder: (context) => ImageDetail(),
  );
  @override
  _ImageDetailState createState() => _ImageDetailState();
}

class _ImageDetailState extends State<ImageDetail> {

  //JSON Future

  final String apiJSON = 'http://192.168.43.212/image_upload_php_mysql/viewAll.php';

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
        title: Text('Image Data'),
      ),

      // Body
      body: FutureBuilder <List<Mobildata>>(
        future: fetchMobil(),
        builder: (context, snapshot) {

          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator()
          );
          return ListView(
            children: snapshot.data.map((data) =>
                Column(
              children: <Widget>[
                GestureDetector(
                    onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => details_details(),),);
          },
                  child:
                  Row(
                      children: [
                        Container(
                            width: 200,
                            height: 100,
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child:
                            ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(data.image, width: 200, height: 100, fit: BoxFit.cover,)
                            )),
                        Flexible(
                            child: Center(
                        child: Column(
                        children: [
                        Text(data.merk),
                        Text(data.model),
                        Text(data.type),
                        Text(data.bahan_bakar),
                        Text(data.transmisi),
                        Text(data.description),
                      ],
                  ),
            ),
          )
                      ]),
                ),
                Divider(color: Colors.black),
              ],))
                .toList(),
          );},
      )
    );
  }
}