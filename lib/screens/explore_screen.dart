import 'package:flutter/material.dart';

import '../api/mock_fooderlich_service.dart';
import '../components/components.dart';
import '../models/explore_data.dart';

class ExploreScreen extends StatefulWidget {


  ExploreScreen({Key? key}): super(key: key);



  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}


class _ExploreScreenState extends State<ExploreScreen> {
  // bool _isFavorited = false;
  late ScrollController _controller;
  final mockService = MockFooderlichService();

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      print('reached the bottom');
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      print('reached the top!');
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      builder: (context, AsyncSnapshot<ExploreData> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final recipes = snapshot.data?.todayRecipes ?? [];

          return ListView(
            controller: _controller,
            scrollDirection: Axis.vertical,

            children: [
              TodayRecipeListView(recipes: recipes),
              const SizedBox(height: 16,),
              Container(
                color: Colors.transparent,
                child: FriendPostListView(friendPosts:
                snapshot.data?.friendPosts ?? []),
              )
            ],
          );
        }else {
          return Center(child: Container(
              child: CircularProgressIndicator()
          ),);
        }
      },
      future: mockService.getExploreData(),
    );
  }
}
