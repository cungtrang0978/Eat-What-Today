import 'package:flutter_eat_what_today/blocs/authentication_bloc.dart';
import 'package:flutter_eat_what_today/blocs/login_bloc.dart';
import 'package:flutter_eat_what_today/blocs/simple_bloc_observer.dart';
import 'package:flutter_eat_what_today/events/authentication_event.dart';
import 'package:flutter_eat_what_today/pages/home_page.dart';
import 'package:flutter_eat_what_today/pages/login_page.dart';
import 'package:flutter_eat_what_today/pages/splash_page.dart';
import 'package:flutter_eat_what_today/repositories/food_repository.dart';
import 'package:flutter_eat_what_today/repositories/user_repository.dart';
import 'package:flutter_eat_what_today/states/authentication_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//In this lesson, we will build User Interface(UI)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository = UserRepository();
  final FoodRepository _foodRepository = FoodRepository();
  @override
  Widget build(BuildContext context) {
    //signout for testing firstly !
    _foodRepository.getFood();
    return MaterialApp(
      title: 'Hôm Nay Ăn Gì?',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => AuthenticationBloc(userRepository: _userRepository)
          ..add(AuthenticationEventStarted()),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, authenticationState) {
            if (authenticationState is AuthenticationStateSuccess) {
              return HomePage();
            } else if (authenticationState is AuthenticationStateFailure) {
              return BlocProvider<LoginBloc>(
                  create: (context) =>
                      LoginBloc(userRepository: _userRepository),
                  child: LoginPage(
                    userRepository: _userRepository,
                  ) //LoginPage,
                  );
            }
            return SplashPage();
          },
        ),
      ),
      // FilmList(),
    );
  }
}

class FilmList extends StatefulWidget {
  @override
  _FilmListState createState() => _FilmListState();
}

class _FilmListState extends State<FilmList> {
  String _filterOrSort = "sort_year";

  _FilmListState();

  @override
  Widget build(BuildContext context) {
    Query query =
        FirebaseFirestore.instance.collection('firestore-example-app');

    void _onActionSelected(String value) async {
      if (value == "batch_reset_likes") {
        WriteBatch batch = FirebaseFirestore.instance.batch();

        await query.get().then((querySnapshot) async {
          querySnapshot.docs.forEach((document) {
            batch.update(document.reference, {'likes': 0});
          });

          await batch.commit();

          setState(() {
            _filterOrSort = "sort_year";
          });
        });
      } else {
        setState(() {
          _filterOrSort = value;
        });
      }
    }

    switch (_filterOrSort) {
      case "sort_year":

        /// Order by the production year. Set [descending] to [false] to reverse the order
        query = query.orderBy('year', descending: true);
        break;
      case "sort_likes_desc":

        /// Order by the number of likes. Set [descending] to [false] to reverse the order
        query = query.orderBy('likes', descending: true);
        break;
      case "sort_likes_asc":

        /// Order by the number of likes. Set [descending] to [false] to reverse the order
        query = query.orderBy('likes', descending: false);
        break;
      case "sort_score":

        /// Order by the score, and return only those which has one great than 90
        query = query.orderBy('score').where('score', isGreaterThan: 90);
        break;
      case "filter_genre_scifi":

        /// Return the movies which have the following categories
        query = query.where('genre', arrayContainsAny: ['Sci-Fi']);
        break;
      case "filter_genre_fantasy":

        /// Return the movies which have the following categories
        query = query.where('genre', arrayContainsAny: ['Fantasy']);
        break;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Firestore Example: Movies'),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (String value) async {
                await _onActionSelected(value);
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: "sort_year",
                    child: Text("Sort by Year"),
                  ),
                  PopupMenuItem(
                    value: "sort_score",
                    child: Text("Sort by Score"),
                  ),
                  PopupMenuItem(
                    value: "sort_likes_asc",
                    child: Text("Sort by Likes ascending"),
                  ),
                  PopupMenuItem(
                    value: "sort_likes_desc",
                    child: Text("Sort by Likes descending"),
                  ),
                  PopupMenuItem(
                    value: "filter_genre_fantasy",
                    child: Text("Filter genre Fantasy"),
                  ),
                  PopupMenuItem(
                    value: "filter_genre_scifi",
                    child: Text("Filter genre Sci-Fi"),
                  ),
                  PopupMenuItem(
                    value: "batch_reset_likes",
                    child: Text("Reset like counts (WriteBatch)"),
                  ),
                ];
              },
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: query.snapshots(),
          builder: (context, stream) {
            if (stream.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (stream.hasError) {
              return Center(child: Text(stream.error.toString()));
            }

            QuerySnapshot querySnapshot = stream.data;

            return ListView.builder(
              itemCount: querySnapshot.size,
              itemBuilder: (context, index) => Movie(querySnapshot.docs[index]),
            );
          },
        ));
  }
}

/// A single movie row.
class Movie extends StatelessWidget {
  /// Contains all snapshot data for a given movie.
  final DocumentSnapshot snapshot;

  /// Initialize a [Move] instance with a given [DocumentSnapshot].
  Movie(this.snapshot);

  /// Returns the [DocumentSnapshot] data as a a [Map].
  Map<String, dynamic> get movie {
    return snapshot.data();
  }

  /// Returns the movie poster.
  Widget get poster {
    return Container(
      width: 100,
      child: Center(child: Image.network(movie['poster'])),
    );
  }

  /// Returns movie details.
  Widget get details {
    return Padding(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            metadata,
            genres,
            Likes(
              reference: snapshot.reference,
              currentLikes: movie['likes'],
            )
          ],
        ));
  }

  /// Return the movie title.
  Widget get title {
    return Text("${movie['title']} (${movie['year']})",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  /// Returns metadata about the movie.
  Widget get metadata {
    return Padding(
        padding: EdgeInsets.only(top: 8),
        child: Row(children: [
          Padding(
              child: Text('Rated: ${movie['rated']}'),
              padding: EdgeInsets.only(right: 8)),
          Text('Runtime: ${movie['runtime']}'),
        ]));
  }

  /// Returns a list of genre movie tags.
  List<Widget> genreItems() {
    List<Widget> items = <Widget>[];
    movie['genre'].forEach((genre) {
      items.add(Padding(
        child: Chip(
            label: Text(genre, style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.lightBlue),
        padding: EdgeInsets.only(right: 2),
      ));
    });
    return items;
  }

  /// Returns all genres.
  Widget get genres {
    return Padding(
        padding: EdgeInsets.only(top: 8), child: Wrap(children: genreItems()));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 4, top: 4),
        child: Container(
          child: Row(
            children: [poster, Flexible(child: details)],
          ),
        ));
  }
}

/// Displays and manages the movie "like" count.
class Likes extends StatefulWidget {
  /// The [DocumentReference] relating to the counter.
  final DocumentReference reference;

  /// The number of current likes (before manipulation).
  final num currentLikes;

  /// Constructs a new [Likes] instance with a given [DocumentReference] and
  /// current like count.
  Likes({Key key, this.reference, this.currentLikes}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Likes();
  }
}

class _Likes extends State<Likes> {
  int _likes;

  _onLike(int current) async {
    // Increment the "like" count straight away to show feedback to the user.
    setState(() {
      _likes = current + 1;
    });

    try {
      // Return and set the updated "likes" count from the transaction
      int newLikes = await FirebaseFirestore.instance
          .runTransaction<int>((transaction) async {
        DocumentSnapshot txSnapshot = await transaction.get(widget.reference);

        if (!txSnapshot.exists) {
          throw Exception("Document does not exist!");
        }

        int updatedLikes = (txSnapshot.data()['likes'] ?? 0) + 1;
        transaction.update(widget.reference, {'likes': updatedLikes});
        return updatedLikes;
      });

      // Update with the real count once the transaction has completed.
      setState(() {
        _likes = newLikes;
      });
    } catch (e) {
      print("Failed to update likes for document! $e");

      // If the transaction fails, revert back to the old count
      setState(() {
        _likes = current;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int currentLikes = _likes ?? widget.currentLikes ?? 0;

    return Row(children: [
      IconButton(
          icon: Icon(Icons.favorite),
          iconSize: 20,
          onPressed: () {
            _onLike(currentLikes);
          }),
      Text("$currentLikes likes"),
    ]);
  }
}
