import 'package:flutter/material.dart';
import '../screens/category_meals_screen.dart';
import '../providers/categories.dart';
import '../models/category.dart';
import 'package:provider/provider.dart';

class CategoryItem extends StatelessWidget {
  final Category cat;
  
  CategoryItem(this.cat);
  void selectCategory(BuildContext ctx) {

      Navigator.of(ctx).pushNamed(
        CategoryMealsScreen.routeName,
        arguments: {'id':cat.id,'title':cat.title},
      );
  }

  @override
  Widget build(BuildContext context) {
    //cat = Provider.of<Categories>(context).getCategory();
    
    return InkWell(

        onTap: () => selectCategory(context),
        splashColor: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(15),

        child: Container(
        padding: const EdgeInsets.all(15),
        child: Text(
          cat.title,
          style: Theme.of(context).textTheme.title,
          ),
        decoration: BoxDecoration(
          gradient:LinearGradient(
            colors:[
              cat.color.withOpacity(0.7),
              cat.color
            ],
            
            begin: Alignment.topLeft,
            end:Alignment.bottomRight,
         ),
          boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0,2), // changes position of shadow
            ),
        ],
         borderRadius: BorderRadius.circular(15),
        ),
        
      ),
    );
  }
}