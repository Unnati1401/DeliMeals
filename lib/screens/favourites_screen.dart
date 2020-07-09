import 'package:flutter/material.dart';
import 'package:mealsApp/widgets/main_drawer.dart';
import '../providers/meal.dart';
import '../widgets/meal_item.dart';
import 'package:provider/provider.dart';
import '../providers/meals.dart';

class FavouritesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final List<Meal> favoriteMeals = Provider.of<Meals>(context).getFavoriteMealsList;
    if(favoriteMeals.isEmpty){
        return Center(
      child: Text("You have no favourites yet - start adding some"),
      
    );

    }
    else{
      return  ListView.builder(
          itemBuilder: (ctx,index) {
            return MealItem(
              id:favoriteMeals[index].id,
              title:favoriteMeals[index].title,
              imageUrl:favoriteMeals[index].imageUrl,
              affordability:favoriteMeals[index].affordability,
              complexity:favoriteMeals[index].complexity,
              duration:favoriteMeals[index].duration,
              
            );
          },
          itemCount: favoriteMeals.length ,
        );
      
    }
    
  }
}