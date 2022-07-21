import 'package:flutter/material.dart';

import '../api/mock_fooderlich_service.dart';
import '../components/components.dart';
import '../models/explore_data.dart';

class ExploreScreen extends StatelessWidget {

  final mockService = MockFooderlichService();

  ExploreScreen({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      builder: (context, AsyncSnapshot<ExploreData> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final recipes = snapshot.data?.todayRecipes ?? [];
          return ListView(
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