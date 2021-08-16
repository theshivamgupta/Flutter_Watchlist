import 'package:flutter/material.dart';
import 'package:watchlist/db/movie_db.dart';
import 'package:watchlist/form_screen.dart';
import 'package:watchlist/model/movies.dart';
import 'package:watchlist/widgets/movieWidget.dart';

class MoviePage extends StatefulWidget {
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  late List<Movie> notes = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    // MoviesDatabase.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.notes = await MoviesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Color(0xFF2D2F41),
        appBar: AppBar(
            title: Text("Movies"),
            backgroundColor: Colors.transparent,
            elevation: 0.0),
        body: MoviesWidget(movies: notes, refreshNotes: refreshNotes),
        floatingActionButton: FloatingActionButton(
          heroTag: "addForm",
          backgroundColor: Colors.black,
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => FormScreen()),
            );

            refreshNotes();
          },
        ),
      );
}
