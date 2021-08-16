import 'dart:io';

import 'package:flutter/material.dart';
import 'package:watchlist/MovieList.dart';
import 'package:watchlist/db/movie_db.dart';
import 'package:watchlist/edit_movies.dart';
import 'package:watchlist/model/movies.dart';

class MoviesWidget extends StatelessWidget {
  final List<Movie> movies;
  final Function() refreshNotes;
  MoviesWidget({required this.movies, required this.refreshNotes});

  _deleteNotes(id, context) async {
    await MoviesDatabase.instance.delete(id);
    print("Delete SuccessFully");
    Navigator.pop(context);
    // Navigator.push(context, "MoviePage");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MoviePage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final edit_movie;
          final movie = movies[index];
          // var poster = movie.poster;
          // poster.substring(6);
          // print('movie.poster $poster');
          return ListTile(
              title: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.red, Colors.purple],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    // child: Container(
                    //     decoration: BoxDecoration(
                    //         image:
                    //             DecorationImage(image: FileImage(File(poster))))
                    child: Image.network(
                      movie.poster,
                      width: 140,
                      height: 180,
                      fit: BoxFit.cover,
                    )),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  movie.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: Text(
                              movie.directorName,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          SizedBox(height: 14),
                          Row(
                            children: [
                              Wrap(
                                // crossAxisAlignment: CrossAxisAlignment.end,
                                spacing: 16,
                                runSpacing: 20,
                                children: [
                                  Column(
                                    children: [
                                      FloatingActionButton(
                                          heroTag: "delete",
                                          elevation: 0.0,
                                          backgroundColor: Colors.red,
                                          child: Icon(
                                            Icons.delete,
                                          ),
                                          onPressed: () =>
                                              _deleteNotes(movie.id, context)),
                                    ],
                                  ),
                                  // Spacer(),
                                  Column(
                                    children: [
                                      FloatingActionButton(
                                          heroTag: "edit",
                                          elevation: 0.0,
                                          backgroundColor: Colors.blue,
                                          child: Icon(Icons.border_color),
                                          onPressed: () async {
                                            await Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  EditFormScreen(
                                                      editMovie: movie,
                                                      refreshNotes:
                                                          refreshNotes),
                                            ));
                                          }),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ));
        });
  }
}
