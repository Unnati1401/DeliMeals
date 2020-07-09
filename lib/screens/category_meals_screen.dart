import 'package:flutter/material.dart';
import '../widgets/meal_item.dart';
import '../providers/meal.dart';
import 'package:provider/provider.dart';
import '../providers/meals.dart';
/*class CategoryMealsScreen extends StatefulWidget {

  
  
  /*final List<Meal> availableMeals;

  CategoryMealsScreen(this.availableMeals);*/

  @override
  _CategoryMealsScreenState createState() => _CategoryMealsScreenState();
}*/

class CategoryMealsScreen extends StatelessWidget {

  static const routeName = '/category-meals';
  
  
  
  
  @override
  Widget build(BuildContext context) {

    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String,String>;
    final String categoryId = routeArgs['id'];
    List<Meal> displayedMeals = Provider.of<Meals>(context).getCategoryMeals(categoryId);

    return Scaffold(
        appBar: AppBar(
          title:Text(routeArgs['title']),
        ),
        body: displayedMeals.isEmpty ? Center(child:Text('No meals yet added')) : ListView.builder(
          itemBuilder: (ctx,index) {
            return MealItem(
              id:displayedMeals[index].id,
              title:displayedMeals[index].title,
              imageUrl:displayedMeals[index].imageUrl,
              affordability:displayedMeals[index].affordability,
              complexity:displayedMeals[index].complexity,
              duration:displayedMeals[index].duration,
              
            );
          },
          itemCount: displayedMeals.length ,
        ),
    );
  }
}