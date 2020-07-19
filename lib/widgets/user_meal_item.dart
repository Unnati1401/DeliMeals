import 'package:flutter/material.dart';
import '../providers/meals.dart';
import 'package:provider/provider.dart';

class UserMealItem extends StatelessWidget {

  final String mealId;
  UserMealItem(this.mealId);

  @override
  Widget build(BuildContext context) {
    final meal = Provider.of<Meals>(context).getMeal(mealId);
    return ListTile(
      title:Text(meal.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(meal.imageUrl),
      ),
      trailing: Container(
        width:50,
        child:Row(
          children: <Widget>[
            IconButton(
            icon: Icon(Icons.delete),
            onPressed: (){
              try{
                Provider.of<Meals>(context,listen: false).deleteMeal(mealId);
              }catch(error){
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    content: Text('An error occured!'),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: (){
                          Navigator.of(ctx).pop();
                        },
                       child: Text('Okay'),
                       ),
                    ],
                  ),
                );
              }
            },
            color: Theme.of(context).accentColor,
            ),
        ],
        ),
      ),
    );
  }
}