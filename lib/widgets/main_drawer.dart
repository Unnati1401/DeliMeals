import 'package:flutter/material.dart';
import '../screens/user_meals_screen.dart';
import '../screens/filters_screen.dart';
import '../screens/add_meal_screen.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';
import '../screens/trending_screen.dart';

class MainDrawer extends StatelessWidget {
  Widget buildListTile(String title, IconData icon, Function tapHandler) {
    return ListTile(
        leading: Icon(
          icon,
          size: 26,
        ),
        title: Text(title,
            style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )),
        onTap: tapHandler);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).accentColor,
            child: Text(
              'Cooking Up!',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 30,
                fontFamily: 'Raleway',
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          buildListTile('Meals', Icons.restaurant, () {
            Navigator.of(context).pushReplacementNamed('/');
          }),
          Divider(),
          buildListTile('Settings', Icons.settings, () {
            Navigator.of(context).pushReplacementNamed(FiltersScreen.routeName);
          }),
          Divider(),
          buildListTile('Add Meal', Icons.fastfood, () {
            Navigator.of(context).pushReplacementNamed(AddMeal.routeName);
          }),
          Divider(),
          buildListTile('Your Meals', Icons.account_circle, () {
            Navigator.of(context)
                .pushReplacementNamed(UserMealsScreen.routeName);
          }),
          Divider(),
          buildListTile('Trending Meals', Icons.trending_up, () {
            Navigator.of(context).pop();
            //Navigator.of(context).pushReplacementNamed('/');
            Navigator.of(context)
                .pushReplacementNamed(TrendingScreen.routeName);
          }),
          Divider(),
          buildListTile('Logout', Icons.exit_to_app, () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/');
            Provider.of<Auth>(context, listen: false).logout();
          }),
        ],
      ),
    );
  }
}
