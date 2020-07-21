import 'package:flutter/material.dart';
import '../providers/meals.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class MealDetailScreen extends StatefulWidget {
  static const routeName = '/meal-detail';

  @override
  _MealDetailScreenState createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget buildSectionTitle(String text, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
      ),
    );
  }

  Widget buildContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      height: 200,
      width: 300,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context).settings.arguments as String;
    final String mealId = routeArgs;
    final selectedMeal = Provider.of<Meals>(context).getMeal(mealId);
    final authData = Provider.of<Auth>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('${selectedMeal.title}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                selectedMeal.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            buildSectionTitle('Ingredients', context),
            buildContainer(
              ListView.builder(
                itemBuilder: (ctx, index) => Card(
                  color: Theme.of(context).accentColor,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text(
                      selectedMeal.ingredients[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                itemCount: selectedMeal.ingredients.length,
              ),
            ),
            buildSectionTitle('Steps', context),
            buildContainer(
              ListView.builder(
                itemCount: selectedMeal.steps.length,
                itemBuilder: (ctx, index) => Column(
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          '#${index + 1}',
                          style: TextStyle(color: Colors.black),
                        ),
                        backgroundColor: Theme.of(context).accentColor,
                      ),
                      title: Text(selectedMeal.steps[index]),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
            buildSectionTitle('Reviews', context),
            buildContainer(
              ListView.builder(
                itemBuilder: (ctx, index) => Card(
                  color: Theme.of(context).accentColor,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text(
                      selectedMeal.reviews[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                itemCount: selectedMeal.reviews.length,
              ),
            ),
            Divider(
              height: 80,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Container(
        height: 60,
        color: Theme.of(context).accentColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.thumb_up,
                size: 40,
              ),
              //color: Theme.of(context).accentColor,
              onPressed: () async {
                await Provider.of<Meals>(context, listen: false)
                    .like(selectedMeal.id);
                final snackBar = SnackBar(content: Text('You liked the meal'));
                _scaffoldKey.currentState.showSnackBar(snackBar);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.thumb_down,
                size: 40,
              ),
              //color: Theme.of(context).accentColor,
              onPressed: () async {
                await Provider.of<Meals>(context, listen: false)
                    .dislike(selectedMeal.id);
                final snackBar =
                    SnackBar(content: Text('You disliked the meal'));
                _scaffoldKey.currentState.showSnackBar(snackBar);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.share,
                size: 40,
              ),
              //color: Theme.of(context).accentColor,
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.add_comment,
                size: 40,
              ),
              //color: Theme.of(context).accentColor,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Form(
                        child: ListView(
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Your name',
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(50.0),
                                  ),
                                ),
                              ),
                              keyboardType: TextInputType.multiline,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Add your review here',
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(50.0),
                                  ),
                                ),
                              ),
                              maxLines: 3,
                              keyboardType: TextInputType.multiline,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RaisedButton(
                              color: Colors.lightBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                //side: BorderSide(color: Colors.red)
                              ),
                              onPressed: () {},
                              textColor: Colors.white,
                              padding: const EdgeInsets.all(0.0),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                child: const Text('Add',
                                    style: TextStyle(fontSize: 20)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            Consumer<Meals>(
              builder: (ctx, meal, child) => IconButton(
                  icon: Icon(
                    selectedMeal.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    size: 40,
                  ),
                  //color: Theme.of(context).accentColor,
                  onPressed: () {
                    setState(() {
                      meal.toggleFavoriteStatus(
                          selectedMeal.id, authData.token, authData.userId);
                    });
                    final snackBar = SnackBar(
                        content: selectedMeal.isFavorite
                            ? Text('Meal added to favorites')
                            : Text('Meal removed from favorites'));
                    _scaffoldKey.currentState.showSnackBar(snackBar);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
