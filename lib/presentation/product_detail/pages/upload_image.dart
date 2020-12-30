import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_loginn/presentation/product_detail/pages/Image_detail.dart';


class DemoUploadImage extends StatefulWidget {
  static Route<dynamic> route() => MaterialPageRoute(
    builder: (context) => DemoUploadImage(),
  );
  @override
  _DemoUploadImageState createState() => _DemoUploadImageState();
}

class _DemoUploadImageState extends State<DemoUploadImage> {

  File _image;
  final picker = ImagePicker();
  TextEditingController merkController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController bahan_bakarController = TextEditingController();
  TextEditingController transmisiController = TextEditingController();
  TextEditingController descController = TextEditingController();


  Future choiceImage()async{
    var pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedImage.path);
    });
  }

  Future uploadImage()async{
    final uri = Uri.parse("http://192.168.43.212/image_upload_php_mysql/upload.php");
    var request = http.MultipartRequest('POST',uri);
    request.fields['merk'] = merkController.text;
    request.fields['model'] = modelController.text;
    request.fields['type'] = typeController.text;
    request.fields['bahan_bakar'] = bahan_bakarController.text;
    request.fields['transmisi'] = transmisiController.text;
    request.fields['description'] = descController.text;
    var pic = await http.MultipartFile.fromPath("image", _image.path);
    request.files.add(pic);
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image Uploded');
    }else{
      print('Image Not Uploded');
    }
    setState(() {

    });
  }

  String _mySelection;
  List<Map> _myJson = [{"id":0,"merk":"<New>"},{"id":1,"merk":"Test Practice"}];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: merkController,
                decoration: InputDecoration(labelText: 'Merk'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: modelController,
                decoration: InputDecoration(labelText: 'Model'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: typeController,
                decoration: InputDecoration(labelText: 'Type'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: bahan_bakarController,
                decoration: InputDecoration(labelText: 'Bahan Bakar'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: transmisiController,
                decoration: InputDecoration(labelText: 'Transmisi'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: descController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.camera),
              onPressed: () {
                choiceImage();
              },
            ),
            Container(
              child: _image == null ? Text('No Image Selected') : Image.file(_image),
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              child: Text('Upload Image'),
              onPressed: () {
                uploadImage();
                Navigator.push(context, MaterialPageRoute(builder: (context) => ImageDetail(),),);
              },
            ),

            Center(
              child: new DropdownButton(
                isDense: true,
                hint: new Text("Select"),
                value: _mySelection,
                onChanged: ( newValue) {

                  setState(() {
                    _mySelection = newValue;
                  });

                  print (_mySelection);
                },
                items: _myJson.map((Map map) {
                  return new DropdownMenuItem(
                    value: map["id"].toString(),
                    child: new Text(
                      map["merk"],
                    ),
                  );
                }).toList(),
              ),
            ),

            Center(
              child: FlatButton(
                onPressed: () => Navigator.of(context).push(
                  ImageDetail.route(),
                ),
                child: Text("Navigate to Product Detail Page"),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
