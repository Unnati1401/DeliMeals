import 'package:flutter/cupertino.dart';
import 'package:mealsApp/models/http_exception.dart';
import './meal.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Meals with ChangeNotifier{

  final String authToken;
  final String userId;
  List<Meal> _mealsList = [];

  Meals(this.authToken,this._mealsList,this.userId);

  

  List<Meal> get getMealsList{
    return [..._mealsList];
  }

  List<Meal> get getFavoriteMealsList{
    return _mealsList.where((element) => element.isFavorite ).toList();
  }

  Meal getMeal(String id){
    return _mealsList.firstWhere((meal) => meal.id==id);
  }
  
  Future<void> toggleFavoriteStatus(String id,String token,String userId) async{
    
    final url = 'https://mealsapp-8267e.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';

    final mealIndex = _mealsList.indexWhere((element) => element.id==id);
    Meal meal = _mealsList[mealIndex];
    final oldStatus = meal.isFavorite;
    meal.isFavorite = !meal.isFavorite;
    notifyListeners();   
    //print(meal);
    /*if(mealIndex < 0)
    {
      return;
    }*/
    try{
      final response = await http.put(
        url,
        body: json.encode(
          meal.isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        meal.isFavorite = oldStatus;
        _mealsList[mealIndex] = meal;
        
      }
    }
        catch (error) {
          meal.isFavorite = oldStatus;
          _mealsList[mealIndex] = meal;
          throw error;
        }
    }

    bool isFavorite(Meal meal){
      return meal.isFavorite;
    }

    Future<void> addMeal(Meal meal) async{
      final url = 'https://mealsapp-8267e.firebaseio.com/meals.json?auth=$authToken';
      try{
        final response = await http.post(
          url,
          body:json.encode({
            'categories':meal.categories,
            'title':meal.title,
            'imageUrl':meal.imageUrl,
            'ingredients':meal.ingredients,
            'steps':meal.steps,
            'duration':meal.duration,
            'complexity':meal.complexity.toString(),
            'affordability':meal.affordability.toString(),
            'isGlutenFree':meal.isGlutenFree,
            'isLactoseFree':meal.isLactoseFree,
            'isVegan':meal.isVegan,
            'isVegetarian':meal.isVegetarian,
            'createId':userId,
            'numberOfLikes':0,
            'numberOfDislikes':0,
            'reviews':[],
            }),
        );
        final newMeal = Meal(
          id: json.decode(response.body)['name'],
          categories: meal.categories,
          title: meal.title,
          imageUrl:meal.imageUrl,
          ingredients: meal.ingredients,
          steps: meal.categories,
          duration: meal.duration,
          complexity:meal.complexity,
          affordability: meal.affordability,
          isGlutenFree: meal.isGlutenFree,
          isLactoseFree:meal.isLactoseFree,
          isVegan: meal.isVegan,
          isVegetarian: meal.isVegetarian,
          isFavorite: false,
          numberOfLikes: 0,
          numberOfDislikes: 0,
          reviews:[],
        );
        _mealsList.add(newMeal);
        notifyListeners();
        //print("Success");
    }
    catch(error){
      print(error);
      throw error;
      
    }
  }
    Future<void> fetchMeals([bool filterByUser = false]) async{

      var filterString = filterByUser ? 'orderBy="createId"&equalTo="$userId"' : '';
      var url = 'https://mealsapp-8267e.firebaseio.com/meals.json?auth=$authToken&$filterString';

      var url2 = 'https://mealsapp-8267e.firebaseio.com/userFilters/$userId.json?auth=$authToken';

      try{

        
        final response = await http.get(url);
        final extractedData = json.decode(response.body) as Map<String, dynamic>;

        final response2 = await http.get(url2);
        final extractedData2 = json.decode(response2.body) as Map<String,dynamic>;

        final List<Meal> loadedMeals = [];
        if(extractedData==null)
          return;

        url = 'https://mealsapp-8267e.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
        final favoriteResponse = await http.get(url);

        final favoriteData = json.decode(favoriteResponse.body);

        //when the current user has no filters saved
        if(extractedData2==null) {
          extractedData.forEach((mealId, mealData) {
          loadedMeals.add(
            Meal(
              id :  mealId,
              categories: List<String>.from(mealData['categories']),
              steps:  List<String>.from(mealData['steps']),
              title: mealData['title'],
              imageUrl: mealData['imageUrl'],
              ingredients:  List<String>.from(mealData['ingredients']),
              affordability: Affordability.values.firstWhere((e) => e.toString() == mealData['affordability'],orElse: () => null),
              complexity: Complexity.values.firstWhere((e) => e.toString() == mealData['complexity'],orElse: () => null),
              isGlutenFree: mealData['isGlutenFree'],
              isLactoseFree: mealData['isLactoseFree'],
              isVegan: mealData['isVegan'],
              isVegetarian:mealData['isVegetarian'],
              duration:mealData['duration'],
              isFavorite: favoriteData == null ? false : favoriteData[mealId] ?? false, 
              numberOfLikes: mealData['numberOfLikes'],
              numberOfDislikes: mealData['numberOfDislikes'],
              reviews: List<String>.from(mealData['reviews']),
            ),
            
          );
            _mealsList = loadedMeals;
            notifyListeners();

         });
        }
        //adds meals to _mealsList according to filters
        else{
          extractedData.forEach((mealId, mealData) {
          
          
            loadedMeals.add(
            Meal(
              id :  mealId,
              categories: List<String>.from(mealData['categories']),
              steps:  List<String>.from(mealData['steps']),
              title: mealData['title'],
              imageUrl: mealData['imageUrl'],
              ingredients:  List<String>.from(mealData['ingredients']),
              affordability: Affordability.values.firstWhere((e) => e.toString() == mealData['affordability'],orElse: () => null),
              complexity: Complexity.values.firstWhere((e) => e.toString() == mealData['complexity'],orElse: () => null),
              isGlutenFree: mealData['isGlutenFree'],
              isLactoseFree: mealData['isLactoseFree'],
              isVegan: mealData['isVegan'],
              isVegetarian:mealData['isVegetarian'],
              duration:mealData['duration'],
              isFavorite: favoriteData == null ? false : favoriteData[mealId] ?? false, 
              numberOfLikes: mealData['numberOfLikes'],
              numberOfDislikes: mealData['numberOfDislikes'],
              reviews: List<String>.from(mealData['reviews']),
            ),
            
            );
            
            loadedMeals.removeWhere((element) => (extractedData2['isGlutenFree']==true && element.isGlutenFree==false||
                      extractedData2['isLactoseFree']==true && element.isLactoseFree==false||
                      extractedData2['isVegan']==true && element.isVegan==false||
                      extractedData2['isVegetarian']==true && element.isVegetarian==false
                      ));
           _mealsList = loadedMeals;
            notifyListeners(); 

         });
          
        }
      }
      catch(error){
        throw error;
      }
      _mealsList.forEach((element) {print(element.title);print(element.numberOfLikes);});

    }

    Future<void> deleteMeal(String id) async{
      final url = 'https://mealsapp-8267e.firebaseio.com/meals/$id.json?auth=$authToken';

      final mealIndex = _mealsList.indexWhere((element) => element.id==id);
      var meal = _mealsList[mealIndex];
      _mealsList.removeAt(mealIndex);
      notifyListeners();
      try{
        final response = await http.delete(url);
        
        if(response.statusCode >= 400){
          _mealsList.insert(mealIndex,meal);
          notifyListeners();
          throw HttpException('Could not delete the meal');
        }
      }
      catch(error){
         _mealsList.insert(mealIndex,meal);
          notifyListeners();
          //throw HttpException('Could not delete the meal');
        throw error;
      }
      meal = null;
     

    }

    List<Meal> getCategoryMeals(String categoryId){
        if(_mealsList.isEmpty)
          return [];
        List<Meal> list = _mealsList.where((meal) {

          return meal.categories.contains(categoryId);
        
        }).toList(); 
        
    return list;
  }
    
  Future<void> setMealsByFilters() async{
    final url = 'https://mealsapp-8267e.firebaseio.com/userFilters/$userId.json?auth=$authToken';     
    try{
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String,dynamic>;
      if(extractedData==null)
        return;
      print(extractedData);
      _mealsList.removeWhere(
        (element) => (extractedData['isGlutenFree']==true && element.isGlutenFree==false||
                      extractedData['isLactoseFree']==true && element.isLactoseFree==false||
                      extractedData['isVegan']==true && element.isVegan==false||
                      extractedData['isVegetarian']==true && element.isVegetarian==false
                      )
      );
      notifyListeners();
    }   
    catch(error){
      throw error;
    }
  }
  Future<void> like(String id) async{
    final url = 'https://mealsapp-8267e.firebaseio.com/meals/$id/numberOfLikes.json?auth=$authToken';
    final mealIndex = _mealsList.indexWhere((element) => element.id==id);
    print(mealIndex);
    Meal meal = _mealsList[mealIndex];
    print(meal.numberOfLikes);
    meal.numberOfLikes = meal.numberOfLikes + 1;
    
    notifyListeners();   
    //print(meal);
    /*if(mealIndex < 0)
    {
      return;
    }*/
    try{
      final response = await http.put(
        url,
        body: json.encode(
          meal.numberOfLikes,
        ),
      );
      if (response.statusCode >= 400) {
        meal.numberOfLikes = meal.numberOfLikes - 1;
        
      }
    }
        catch (error) {
          meal.numberOfLikes = meal.numberOfLikes - 1;
          throw error;
        }
  }

  Future<void> dislike(String id) async{
    final url = 'https://mealsapp-8267e.firebaseio.com/meals/$id/numberOfDislikes.json?auth=$authToken';
    final mealIndex = _mealsList.indexWhere((element) => element.id==id);
    print(mealIndex);
    Meal meal = _mealsList[mealIndex];
    print(meal.numberOfDislikes);
    meal.numberOfDislikes = meal.numberOfDislikes + 1;
    
    notifyListeners();   
    //print(meal);
    /*if(mealIndex < 0)
    {
      return;
    }*/
    try{
      final response = await http.put(
        url,
        body: json.encode(
          meal.numberOfDislikes,
        ),
      );
      if (response.statusCode >= 400) {
        meal.numberOfDislikes = meal.numberOfDislikes - 1;
        
      }
    }
        catch (error) {
          meal.numberOfDislikes = meal.numberOfDislikes - 1;
          throw error;
        }
  }
  
} 