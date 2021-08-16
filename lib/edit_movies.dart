import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:watchlist/model/movies.dart';
import 'package:watchlist/db/movie_db.dart';

class EditFormScreen extends StatefulWidget {
  final Movie? editMovie;
  final Function() refreshNotes;
  const EditFormScreen({this.editMovie, required this.refreshNotes}) : super();
  @override
  State<StatefulWidget> createState() {
    return EditFormScreenState();
  }
}

class EditFormScreenState extends State<EditFormScreen> {
  late String _name;
  late String _director;
  File? _image;
  String? imageUrl;
  String? movieId;

  @override
  void initState() {
    super.initState();

    // refreshNotes();
  }

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

  Widget _buildName() {
    return TextFormField(
      initialValue: widget.editMovie!.name,
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
      initialValue: widget.editMovie!.directorName,
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
          title: Text("Edit Movie"),
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
                        ? Image.network(
                            widget.editMovie!.poster,
                            width: 140,
                            height: 180,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            _image!,
                            width: 160,
                            height: 160,
                            fit: BoxFit.cover,
                          )),
                SizedBox(height: 50),
                // ignore: deprecated_member_use
                FloatingActionButton(
                  heroTag: "check",
                  child: Icon(Icons.check),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    _formKey.currentState!.save();
                    final movie = Movie(
                        id: widget.editMovie!.id,
                        name: _name,
                        directorName: _director,
                        // poster: _image!.toString(),
                        poster: imageUrl == null
                            ? widget.editMovie!.poster
                            : imageUrl!,
                        createdTime: DateTime.now());
                    // await MoviesDatabase.instance.create(movie);
                    print(_name);
                    print(_director);
                    await MoviesDatabase.instance.update(movie);
                    widget.refreshNotes();
                    Navigator.of(context).pop();
                  },
                ),
                // ignore: deprecated_member_use
                // FloatingActionButton(
                //     heroTag: "editImage",
                //     child: Icon(Icons.check),
                //     onPressed: uploadImage),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
