import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';
import 'package:movies_flutter/model/cast.dart';
import 'package:movies_flutter/model/mediaitem.dart';
import 'package:movies_flutter/util/api_client.dart';
import 'package:movies_flutter/util/mediaproviders.dart';
import 'package:movies_flutter/util/styles.dart';
import 'package:movies_flutter/widgets/movie_detail/cast_section.dart';
import 'package:movies_flutter/widgets/movie_detail/meta_section.dart';
import 'package:movies_flutter/widgets/movie_detail/similar_section.dart';
import 'package:movies_flutter/widgets/utilviews/bottom_gradient.dart';
import 'package:movies_flutter/widgets/utilviews/text_bubble.dart';


class MovieDetailScreen extends StatelessWidget {

  final MediaItem _mediaItem;
  final MediaProvider provider;
  final ApiClient _apiClient = ApiClient.get();

  MovieDetailScreen(this._mediaItem, this.provider);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: primary,
        body: new CustomScrollView(
          slivers: <Widget>[
            _buildAppBar(_mediaItem),
            _buildContentSection(_mediaItem),
          ],
        )
    );
  }

  Widget _buildAppBar(MediaItem movie) {
    return new SliverAppBar(
      expandedHeight: 240.0,
      pinned: true,
      flexibleSpace: new FlexibleSpaceBar(
        background: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Hero(
              tag: "Movie-Tag-${_mediaItem.id}",
              child: new FadeInImage.assetNetwork(
                  fit: BoxFit.cover,
                  width: double.INFINITY,
                  placeholder: "assets/placeholder.jpg",
                  image: _mediaItem.getBackDropUrl()),
            ),
            new BottomGradient(),
            _buildMetaSection(movie)
          ],
        ),
      ),
    );
  }


  Widget _buildMetaSection(MediaItem movie) {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Row(
            children: <Widget>[
              new TextBubble(movie.getReleaseYear().toString(),
                backgroundColor: new Color(0xffF47663),),
              new Container(width: 8.0,),
              new TextBubble(movie.voteAverage.toString(),
                  backgroundColor: new Color(0xffF47663)),
            ],
          ),
          new Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: new Text(movie.title,
                style: new TextStyle(
                    color: new Color(0xFFEEEEEE), fontSize: 20.0)),
          ),
          new Row(
            children: <Widget>[
              new TextBubble("Animation"),
              new Container(width: 8.0,),
              new TextBubble("Adventure"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildContentSection(MediaItem media) {
    return new SliverList(
      delegate: new SliverChildListDelegate(
          <Widget>[
            new Container(
              decoration: new BoxDecoration(color: const Color(0xff222128)),
              child: new Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      "SYNOPSIS", style: const TextStyle(color: Colors.white),),
                    new Container(height: 8.0,),
                    new Text(media.overview, style: const TextStyle(
                        color: Colors.white, fontSize: 12.0)),
                    new Container(height: 8.0,),
                  ],
                ),
              ),
            ),
            new Container(
              decoration: new BoxDecoration(color: primary),
              child: new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new FutureBuilder(
                  future: provider.loadCast(_mediaItem.id),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Actor>> snapshot) {
                    return snapshot.hasData
                        ? new CastSection(snapshot.data)
                        : new Center(child: new CircularProgressIndicator());
                  },
                ),
              ),
            ),
            new Container(
              decoration: new BoxDecoration(color: primaryDark),
              child: new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new FutureBuilder(
                  future: provider.getDetails(media.id),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return snapshot.hasData
                        ? new MetaSection(snapshot.data)
                        : new Container();
                  },
                ),
              ),
            ),
            (_mediaItem.type == MediaType.show)
                ? new Container(
              decoration: new BoxDecoration(color: primary),
              child: new AsyncLoader(
                  initState: () async =>
                  await _apiClient.getShowSeasons(_mediaItem.id),
                  renderLoad: () => new CircularProgressIndicator(),
                  renderError: ([error]) =>
                  new Text('Sorry, couldn\'t load seasons.'),
                  renderSuccess: ({data}) => null
              ),
            )
                : new Container(),
            new Container(
              decoration: new BoxDecoration(color: primary),
              child: new FutureBuilder(
                future: provider.getSimilar(media.id),
                builder: (BuildContext context,
                    AsyncSnapshot<List<MediaItem>> snapshot) {
                  return snapshot.hasData
                      ? new SimilarSection(snapshot.data)
                      : new Container();
                },
              ),
            )
          ]
      ),
    );
  }

}
