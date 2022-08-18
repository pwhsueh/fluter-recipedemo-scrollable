
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class EmptyGroceryScreen extends StatelessWidget {
  const EmptyGroceryScreen({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //TODO 4: Add empty image
              Flexible(child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Image.asset('assets/fooderlich_assets/empty_list.png'),
              )),
              //TODO 5. Add empty screen title
              Text(
                'No Groceries',
                style: Theme.of(context).textTheme.headline6,
              ),
              //TODO 6. Add empty screent subtitle
              const SizedBox(height: 16.0,),
              //TODO 7. Add browse recipes button
              const Text(
                'Shopping for ingredients?\n'
                    'Tap the + button to write them down!',
                textAlign: TextAlign.center,
              ),
              MaterialButton(
                onPressed: () {
                  Provider.of<TabManager>(context, listen: false).goToRecipes();
                },
                textColor: Colors.white,
                child: const Text('Browse Recipes'),
                color: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)
                ),
              )
            ],
          ),
        ),
    );
  }
  
  
  
}