import 'package:flutter/material.dart';
import '../providers/meal.dart';
import '../providers/meals.dart';
import 'package:provider/provider.dart';
import '../screens/categories_screen.dart';

class SaveMeal extends StatefulWidget {
  static const routeName = '/save-meal';
  @override
  _SaveMealState createState() => _SaveMealState();
}

class _SaveMealState extends State<SaveMeal> {

  List<TextEditingController> stepsController = [];
  List<TextEditingController> ingredientsController = [];
  var _isLoading = false;
  final _form = GlobalKey<FormState>();


  List<Widget> listOfTextFormFields(int numberOfSteps,int numberOfIngredients,final routeArgs){

      List<Widget> list = [];
      for(int i=1;i<=numberOfSteps;i++){
        stepsController.add(TextEditingController());
      }

      for(int i=1;i<=numberOfIngredients;i++){
        ingredientsController.add(TextEditingController());
      }
      
      
    list.add(Text('Enter the ingredients:',style: TextStyle(fontSize: 20,foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 1.5
                      ..color = Colors.blue[700],),
                      textAlign: TextAlign.center,
                      ));
    for(int i=1;i<=numberOfIngredients;i++){
      list.add(const SizedBox(height:20));
        list.add(
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Ingredient $i:',
              border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(50.0),
                    ),
              ),
            ),
            keyboardType: TextInputType.text,
            controller: ingredientsController[i-1],
            validator: (value){
                if(value.isEmpty)
                  return 'Please enter the ingredient.';
                return null;
              },
        )
      );
    }
    list.add(const SizedBox(height:20));
    list.add(Text('Enter the steps:',style: TextStyle(fontSize: 20,foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 1.5
                      ..color = Colors.blue[700],),
                      textAlign: TextAlign.center,
                      ));
      for(int i=1;i<=numberOfSteps;i++){
        list.add(const SizedBox(height:20));
        list.add(
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Step $i:',
              border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(50.0),
                    ),
              ),
            ),
            keyboardType: TextInputType.text,
            controller: stepsController[i-1],
            validator: (value){
                if(value.isEmpty)
                  return 'Please enter the step.';
                return null;
              },
        )
      );
    }
    list.add(const SizedBox(height:20));
    list.add(RaisedButton(
      splashColor: Colors.lightBlue,
      onPressed: () {
        /*// Validate returns true if the form is valid, otherwise false.
        if (_formKey.currentState.validate()) {
          // If the form is valid, display a snackbar. In the real world,
          // you'd often call a server or save the information in a database.

          Scaffold
              .of(context)
              .showSnackBar(SnackBar(content: Text('Processing Data')));
        }*/
       _submitForm(routeArgs,numberOfSteps,numberOfIngredients);
      },
      child:const Text('Submit'),
    ));
    
    return list;
  }

  Future<void> _submitForm(final routeArgs,int numberOfSteps,int numberOfIngredients) async {

    final isValid = _form.currentState.validate();
    if(!isValid)
      return;

    setState(() {
      _isLoading = true;
    });

    List<String> steps = [];
    List<String> ingredients = [];

    for(int i=1;i<=numberOfSteps;i++)
      steps.add(stepsController[i-1].text);
    
    for(int i=1;i<=numberOfIngredients;i++)
      ingredients.add(ingredientsController[i-1].text);

     Meal meal = Meal(
          id:"1",
          categories: routeArgs['categories'] ,
          title: routeArgs['title'],
          imageUrl: routeArgs['imageUrl'],
          ingredients: ingredients,
          steps: steps, 
          duration: routeArgs['duration'],
          complexity:Complexity.values.firstWhere((e) => e.toString() == 'Complexity.'+routeArgs['complexity']),
          affordability: Affordability.values.firstWhere((e) => e.toString() == 'Affordability.'+ routeArgs['affordability']),
          isGlutenFree: routeArgs['isGlutenFree'],
          isLactoseFree : routeArgs['isLactoseFree'],
          isVegan : routeArgs['isVegan'],
          isVegetarian : routeArgs['isVegetarian'],
         
        );
        try{
          await Provider.of<Meals>(context,listen: false).addMeal(meal);
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title:Text('Meal Saved!'),
              content: Text('Your meal has been added.',
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, CategoriesScreen.routeName);
                  }, 
                  child: Text('Okay')
                ),
              ],
            ),
          );
        }
        catch(error){
          print(error);
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title:Text('An error occured'),
              content: Text('Something went wrong',
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, CategoriesScreen.routeName);
                  }, 
                  child: Text('Okay')
                ),
              ],
            ),
          );
        }
        finally{
          setState(() {
            _isLoading = false;
            
          });
        }
       
  }
  

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String,dynamic>;
    
    return Scaffold(
      appBar: AppBar(
        title:Text('Save Meal'),
      ),
      body: _isLoading ? Center(child:CircularProgressIndicator()) : 
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: listOfTextFormFields(routeArgs['numberOfSteps'],routeArgs['numberOfIngredients'],routeArgs),
          ),
          
    ),
      ),
    );
  }
}

