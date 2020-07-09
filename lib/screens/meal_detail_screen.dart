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
  Widget buildSectionTitle(String text,BuildContext context){
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10)
      ),
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
    child:Text(
      text,
      style: TextStyle(color: Colors.black,fontWeight:FontWeight.bold,fontSize:24 ),
      
      
    ),
  );
    
  }

  Widget buildContainer(Widget child){
    return  Container(

                decoration: BoxDecoration(
                 boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
      
                  color:Colors.white,
                  border:Border.all(
                    color:Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(20),
                height:200,
                width:300,
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

          appBar: AppBar(
            title:Text('${selectedMeal.title}'),
          ),
          body:SingleChildScrollView(
              child: Column(children: <Widget>[
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
                    itemBuilder: (ctx,index)=> Card(
                      color:Theme.of(context).accentColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical:5,horizontal:10),
                        child: Text(selectedMeal.ingredients[index],
                                    style: TextStyle(fontWeight: FontWeight.bold,),
                              ),
                      ),
                    ),
                    itemCount: selectedMeal.ingredients.length,
                  ),
                
                ),
                  
                buildSectionTitle('Steps', context),
                buildContainer(ListView.builder(
                  itemCount: selectedMeal.steps.length,
                  itemBuilder: (ctx,index) => Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(child: Text('#${index+1}',style: TextStyle(color: Colors.black),),backgroundColor: Theme.of(context).accentColor,),
                        title: Text(selectedMeal.steps[index]),),
                        Divider(),
                    ],
                  )
                    ),
                  ),
            ],
            ),
          ),
          floatingActionButton: Consumer<Meals>(
              builder: (ctx,meal,child) => IconButton(
              icon: Icon(selectedMeal.isFavorite ? Icons.favorite : Icons.favorite_border,size: 50,), 
              color: Theme.of(context).accentColor,
              onPressed: () {
                setState(() {
                  meal.toggleFavoriteStatus(selectedMeal.id,authData.token,authData.userId);  
                });
                
              }
            ),
            child: Text(''),
            ),
    );
  }
}