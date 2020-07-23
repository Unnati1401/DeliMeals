import 'package:flutter/material.dart';
import '../providers/meals.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'package:getwidget/getwidget.dart';

class MealDetailScreen extends StatefulWidget {
  static const routeName = '/meal-detail';

  @override
  _MealDetailScreenState createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _reviewController = TextEditingController();

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
              child: GFAvatar(
                  backgroundImage: NetworkImage(
                    selectedMeal.imageUrl,
                  ),
                  shape: GFAvatarShape.square),
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
                _scaffoldKey.currentState.hideCurrentSnackBar();
                await Provider.of<Meals>(context, listen: false)
                    .like(selectedMeal.id);
                final snackBar = SnackBar(
                    elevation: 6.0,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    content: Text('You liked the meal'));
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
                _scaffoldKey.currentState.hideCurrentSnackBar();
                await Provider.of<Meals>(context, listen: false)
                    .dislike(selectedMeal.id);
                final snackBar = SnackBar(
                    elevation: 6.0,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    content: Text('You disliked the meal'));
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
                            Column(children: [
                              Stack(children: [
                                Container(
                                  width: double.infinity,
                                  height: 56.0,
                                  child: Center(
                                    child: Text("Add Review",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                Positioned(
                                    left: 0.0,
                                    top: 0.0,
                                    child: IconButton(
                                        icon: Icon(Icons.arrow_back),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }))
                              ]),
                            ]),
                            SizedBox(
                              height: 30,
                            ),
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
                              height: 20,
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
                              controller: _reviewController,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GFButton(
                                  color: GFColors.SUCCESS,
                                  shape: GFButtonShape.square,
                                  splashColor: GFColors.SUCCESS,
                                  size: GFSize.LARGE,
                                  type: GFButtonType.outline,
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    final snackBar = SnackBar(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        elevation: 6.0,
                                        behavior: SnackBarBehavior.floating,
                                        content: Text('Your review is added'));
                                    _scaffoldKey.currentState
                                        .showSnackBar(snackBar);

                                    await Provider.of<Meals>(context,
                                            listen: false)
                                        .addReview(selectedMeal.id,
                                            _reviewController.text.toString());
                                    setState(() {});
                                    _scaffoldKey.currentState
                                        .hideCurrentSnackBar();
                                  },
                                  text: 'Add',
                                ),
                                GFButton(
                                  color: GFColors.DANGER,
                                  shape: GFButtonShape.square,
                                  splashColor: GFColors.DANGER,
                                  size: GFSize.LARGE,
                                  type: GFButtonType.outline,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  text: 'Cancel',
                                ),
                              ],
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
                        elevation: 6.0,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
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
