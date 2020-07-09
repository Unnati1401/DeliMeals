import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart';
import '../providers/meals.dart';
import 'package:provider/provider.dart';
import '../widgets/user_meal_item.dart';


class UserMealsScreen extends StatelessWidget {

  static const routeName = '/user-meals';
  Future<void> _refreshMeals(BuildContext context) async{

    await Provider.of<Meals>(context,listen: false).fetchMeals(true);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title:Text('Your Meals'),
      ),
      body: FutureBuilder(
        future: _refreshMeals(context),
        builder: (ctx,snapshot) => snapshot.connectionState ==  ConnectionState.waiting ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
            child: Consumer<Meals>(
                  builder: (ctx,mealsData,_) => Padding(
                    padding: EdgeInsets.all(8),
                    child: ListView.builder(
                      itemBuilder: (ctx,i) =>Column(
                          children: <Widget>[
                            UserMealItem(mealsData.getMealsList[i].id),
                            Divider(),
                          ],
                      ),
                      itemCount: mealsData.getMealsList.length,
                      ),
                    ),
                ),
            onRefresh: () =>_refreshMeals(context)),
        ),
    );
  }
}