import 'package:flutter/material.dart';
import './save_meal_screen.dart';
import '../models/category.dart';
import '../providers/categories.dart';
import 'package:provider/provider.dart';
import '../widgets/main_drawer.dart';


class AddMeal extends StatefulWidget {
  static const routeName = '/add-meal';
  @override
  _AddMealState createState() => _AddMealState();
}

class _AddMealState extends State<AddMeal> {
  
  final _form = GlobalKey<FormState>();

  //FocusNodes
  final  _titleFocusNode = FocusNode();
  final _imageUrlFocusNode= FocusNode();
  final _numberOfingredientsFocusNode = FocusNode();
  final  _numberOfstepsFocusNode = FocusNode();
  final _durationFocusNode = FocusNode();
  
  //Variables
  var _isLoading = false;
  var timeDilation = 5;
  var _isGlutenFree = false;
  var _isLactoseFree = false;
  var _isVegan = false;
  var _isVegetarian = false;
  var _isSimple = false;
  var __isChallenging = false;
  var _isHard = false;
  var _isAffordable = false;
  var _isPricey = false;
  var _isLuxurious = false;
  var categoriesSelected = [];
  
  //TextEditingControlers
  final _numberOfStepsController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _numberOfIngredientsController = TextEditingController();
  final _titleController = TextEditingController();
  final _durationController = TextEditingController();

  String setAffordability(){
    if(_isAffordable)
      return 'Affordable';
    if(_isPricey)
      return 'Pricey';
    return 'Luxurious';
  }

  String setComplexity(){
    if(_isSimple)
      return 'Simple';
    if(__isChallenging)
      return 'Challenging';
    return 'Hard';
  }

  @override
  void didChangeDependencies() {
    
    for(int i=0;i<10;i++)
      categoriesSelected.add(false);
    super.didChangeDependencies();
  }

  void _submitForm(BuildContext ctx){
    if(!_form.currentState.validate())
      return;
    

    List<String> listToPass = [];
    for(int i=1;i<=10;i++){
      if(categoriesSelected[i-1]==true)
        listToPass.add('c'+i.toString());
    }

   


    Navigator.of(ctx).pushNamed(
        SaveMeal.routeName,
        arguments: {
          'isGlutenFree':_isGlutenFree,
          'isLactoseFree':_isLactoseFree,
          'isVegan':_isVegan,
          'isVegetarian':_isVegetarian,
          'affordability': setAffordability(),
          'complexity': setComplexity(),
          'numberOfSteps':int.parse(_numberOfStepsController.text),
          'numberOfIngredients':int.parse(_numberOfIngredientsController.text),
          'title':_titleController.text,
          'imageUrl':_imageUrlController.text,
          'duration':int.parse(_durationController.text),
          'categories':listToPass,
        },
      );
  }
  
  @override
  Widget build(BuildContext context) {
     List<Category> catlist = Provider.of<Categories>(context).getCategoriesList;
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title:Text('Add Meal'),
      ),
      body: _isLoading ? 
      Center(child: CircularProgressIndicator(),): 
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 20,),
              TextFormField(
                decoration: InputDecoration(
                  labelText:'Title',
                  border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(50.0),
                  ),
                  ),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                focusNode: _titleFocusNode,
                controller: _titleController,
                onFieldSubmitted: (_){
                    FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                },
                validator: (value){
                  if(value.isEmpty)
                    return 'Please specify a title.';
                  return null;
                },
              ),
              SizedBox(height: 20,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Add image Url',
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(50.0),
                    ),
                  ),
                ),
                textInputAction: TextInputAction.next,
                focusNode: _imageUrlFocusNode,
                controller: _imageUrlController,
                onFieldSubmitted: (_){
                    FocusScope.of(context).requestFocus(_numberOfstepsFocusNode);
                },
                validator: (value){
                  if(value.isEmpty)
                    return 'Please enter a value.';
                  if((!value.startsWith('https') && !value.startsWith('http')) 
                        || (!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('.jpeg')))
                                return 'Please enter a valid url.';
                  return null;
                  },
              ),
              SizedBox(height: 20,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter the number of steps',
                  border: new OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      const Radius.circular(50.0),
                    ),
                  ),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _numberOfstepsFocusNode,
                controller: _numberOfStepsController,
                onFieldSubmitted: (_){
                    FocusScope.of(context).requestFocus(_numberOfingredientsFocusNode);
                },
                validator: (value){
                  if(value.isEmpty)
                    return 'Please enter a value.';
                  
                  return null;
                },
              ),
              SizedBox(height: 20,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter the number of ingredients',
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(50.0),
                    ),
                  ),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _numberOfingredientsFocusNode,
                controller: _numberOfIngredientsController,
                onFieldSubmitted: (_){
                    FocusScope.of(context).requestFocus(_durationFocusNode);
                },
                validator: (value){
                  if(value.isEmpty)
                    return 'Please enter a value.';
                  return null;
                },
              ),

              SizedBox(height: 40,),
              Text(
                'Select all that apply :',style: TextStyle(fontSize: 20,foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 1.5
                      ..color = Colors.blue[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
              
                      CheckboxListTile(
                        title: const Text('Gluten Free'),
                        value: _isGlutenFree,
                        onChanged: (bool value) {
                          setState(() {
                            _isGlutenFree = !_isGlutenFree;
                          });
                        },
                        secondary: const Icon(Icons.room_service),
                      ),
                      CheckboxListTile(
                        title: const Text('Lactose Free'),
                        value: _isLactoseFree,
                        onChanged: (bool value) {
                          setState(() {
                            _isLactoseFree = !_isLactoseFree;
                          });
                        },
                        secondary: const Icon(Icons.free_breakfast),
                      ),
                      CheckboxListTile(
                        title: const Text('Vegan'),
                        value: _isVegan,
                        onChanged: (bool value) {
                          setState(() {
                            _isVegan = !_isVegan;
                          });
                        },
                        secondary: const Icon(Icons.restaurant_menu),
                        
                      ),
                      CheckboxListTile(
                        title: const Text('Vegetarian'),
                        value: _isVegetarian,
                        onChanged: (bool value) {
                          setState(() {
                            _isVegetarian = !_isVegetarian;
                          });
                        },
                        secondary: const Icon(Icons.spa),
                      ),              

                    
              //affordability
              SizedBox(height: 40,),
              Text('Select affordability of the meal :',style: TextStyle(fontSize: 20,foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 1.5
                      ..color = Colors.blue[700],),
                      textAlign: TextAlign.center,
                      ),
              CheckboxListTile(
                    title: const Text('Affordable'),
                    value: _isAffordable,
                    onChanged: (bool value) {
                      setState(() {
                        _isAffordable = !_isAffordable;
                        _isPricey = false;
                        _isLuxurious = false;
                      });
                    },
                    secondary: const Icon(Icons.money_off),
                  ),
                  CheckboxListTile(
                    title: const Text('Pricey'),
                    value: _isPricey,
                    onChanged: (bool value) {
                      setState(() {
                        _isPricey = !_isPricey;
                        _isAffordable = false;
                        _isLuxurious = false;
                      });
                    },
                    secondary: const Icon(Icons.thumbs_up_down),
                  ),
                  CheckboxListTile(
                    title: const Text('Luxurious'),
                    value: _isLuxurious,
                    onChanged: (bool value) {
                      setState(() {
                        _isLuxurious = !_isLuxurious;
                        _isAffordable = false;
                        _isPricey = false;
                      });
                    },
                    secondary: const Icon(Icons.monetization_on),
                    
                  ),
                  
                
              //Complexity
              SizedBox(height: 40,),
              Text('Select complexity of the meal :',style: TextStyle(fontSize: 20,foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 1.5
                      ..color = Colors.blue[700],),
                      textAlign: TextAlign.center,
                      ),
              
                  CheckboxListTile(
                    title: const Text('Simple'),
                    value: _isSimple,
                    onChanged: (bool value) {
                      setState(() {
                        _isSimple = !_isSimple;
                        __isChallenging = false;
                        _isHard = false;
                      });
                    },
                    secondary: const Icon(Icons.star_border),
                  ),
                  CheckboxListTile(
                    title: const Text('Challenging'),
                    value: __isChallenging,
                    onChanged: (bool value) {
                      setState(() {
                        __isChallenging = !__isChallenging;
                        _isSimple = false;
                        _isHard = false;
                      });
                    },
                    secondary: const Icon(Icons.school),
                  ),
                  CheckboxListTile(
                    title: const Text('Hard'),
                    value: _isHard,
                    onChanged: (bool value) {
                      setState(() {
                        _isHard = !_isHard;
                        _isSimple = false;
                        __isChallenging = false;
                      });
                    },
                    secondary: const Icon(Icons.security),
                    
                  ),
                             

                
              SizedBox(height: 20,),
              Text('Select all the categories that apply :',style: TextStyle(fontSize: 20,foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 1.5
                      ..color = Colors.blue[700],),
                      textAlign: TextAlign.center,
                      ),
               //_categoriesCheckBoxList(),
              
              for(int i=1;i<=10;i++)
                CheckboxListTile(
                  title: Text(catlist[i-1].title),
                  value: categoriesSelected[i-1],
                  onChanged: (bool value) {
                    setState(() {
                      categoriesSelected[i-1] = !categoriesSelected[i-1];
                    });
                  },
                  secondary: const Icon(Icons.free_breakfast),
                ),
              SizedBox(height:40),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter the duration in minutes',
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(50.0),
                    ),
                  ),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _durationFocusNode,
                controller: _durationController,
                onFieldSubmitted: (_){
                    _submitForm(context);
                },
                validator: (value){
                  if(value.isEmpty)
                    return 'Please enter a value.';
                  return null;
                },
              ),
              const SizedBox(height: 40,),
              Padding(
                padding: EdgeInsets.all(10),
                    child: RaisedButton(
                
                    onPressed: () {
                      
                      /*if (_form.currentState.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.

                        Scaffold
                            .of(context)
                            .showSnackBar(SnackBar(content: Text('Processing Data')));
                      }*/
                      _submitForm(context);
                    },
                    textColor: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFF0D47A1),
                              Color(0xFF1976D2),
                              Color(0xFF42A5F5),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child:
                            const Text('Next', style: TextStyle(fontSize: 20)),
                      ),
                   ),
              ),
            ],
            
          ),
          
        ),
      ),
    );
  }
}