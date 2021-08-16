import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:watchlist/model/movies.dart';
import 'package:watchlist/db/movie_db.dart';

class FormScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormScreenState();
  }
}

class FormScreenState extends State<FormScreen> {
  late String _name;
  late String _director;
  File? _image;
  String? imageUrl;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  uploadImage() async {
    final _storage = FirebaseStorage.instance;
    final ImagePicker _picker = ImagePicker();
    XFile? image;
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      //Select Image
      image = await _picker.pickImage(source: ImageSource.gallery);
      var file = File(image!.path);
      print('file is $file');
      // ignore: unnecessary_null_comparison
      if (image != null) {
        //Upload to Firebase
        var snapshot = await _storage
            .ref()
            .child('images/' + DateTime.now().toIso8601String())
            .putFile(file);

        var downloadUrl = await snapshot.ref.getDownloadURL();
        print(downloadUrl);
        setState(() {
          imageUrl = downloadUrl;
          _image = file;
        });
      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions and try again');
    }
  }

  // Future getImage() async {
  //   final image =
  //       await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
  //   final posterImage = File(image!.path);
  //   // print('image');
  //   setState(() => _image = posterImage);
  // }

  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Name', labelStyle: TextStyle(color: Colors.white)),
      // maxLength: 10,
      style: TextStyle(color: Colors.white),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: (String? value) {
        _name = value!;
      },
    );
  }

  Widget _buildDirector() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Director', labelStyle: TextStyle(color: Colors.white)),
      // maxLength: 10,
      style: TextStyle(color: Colors.white),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Director Name is Required';
        }

        return null;
      },
      onSaved: (String? value) {
        _director = value!;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D2F41),
      appBar: AppBar(
          title: Text("Add Movie"),
          backgroundColor: Colors.transparent,
          elevation: 0.0),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildName(),
                _buildDirector(),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                        heroTag: "image",
                        child: Icon(Icons.camera_alt),
                        onPressed: uploadImage),
                  ],
                ),
                SizedBox(height: 30),
                Center(
                    child: _image == null
                        ? Text("Select Image",
                            style: TextStyle(color: Colors.white))
                        // : Image.network(
                        //     imageUrl!,
                        //     width: 160,
                        //     height: 160,
                        //     fit: BoxFit.cover,
                        //   )
                        : Image.file(
                            _image!,
                            width: 160,
                            height: 160,
                            fit: BoxFit.cover,
                          )),
                SizedBox(height: 50),
                // ignore: deprecated_member_use
                RaisedButton(
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    _formKey.currentState!.save();
                    final movie = Movie(
                        name: _name,
                        directorName: _director,
                        // poster: _image!.toString(),
                        poster: imageUrl!,
                        createdTime: DateTime.now());
                    await MoviesDatabase.instance.create(movie);
                    // await Navigator.of(context).push(
                    //   MaterialPageRoute(builder: (context) => MoviePage()),
                    // );
                  },
                ),
                // ignore: deprecated_member_use
                RaisedButton(
                  child: Text(
                    'Query',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                  onPressed: () async {
                    final List<Movie> movies =
                        await MoviesDatabase.instance.readAllNotes();
                    print(movies.length);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
