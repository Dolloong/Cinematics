import 'package:flutter/material.dart';
import 'package:movies_flutter/model/cast.dart';
import 'package:movies_flutter/util/api_client.dart';
import 'package:movies_flutter/util/styles.dart';
import 'package:movies_flutter/widgets/utilviews/fitted_circle_avatar.dart';


class ActorDetailScreen extends StatelessWidget {
  final Actor _actor;
  final ApiClient _apiClient = ApiClient.get();

  ActorDetailScreen(this._actor);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: primary,
        body: new CustomScrollView(
          slivers: <Widget>[
            _buildAppBar(context, _actor),
          ],
        )
    );
  }

  Widget _buildAppBar(BuildContext context, Actor actor) {
    return new SliverAppBar(
      expandedHeight: 240.0,
      pinned: true,
      flexibleSpace: new FlexibleSpaceBar(
        background: new Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    const Color(0xff2b5876),
                    const Color(0xff4e4376),
                  ]
              )
          ),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(height: MediaQuery.of(context).padding.top,),
              new Hero(
                  tag: 'Cast-Hero-${actor.id}',
                  child: new Container(
                    width: 128.0,
                    height: 128.0,
                    child: new FittedCircleAvatar(
                      backgroundImage: new NetworkImage(
                          actor.getProfilePicture()
                      ),
                    ),
                  )
              ),
              new Container(height: 8.0,),
              new Text(actor.name, style: whiteBody.copyWith(fontSize: 22.0),)
            ],
          ),
        ),
      ),
    );
  }

}