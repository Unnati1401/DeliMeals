import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class Filters with ChangeNotifier{
  var _glutenFree = false;
  var _vegetarian = false;
  var _vegan = false;
  var _lactoseFree = false;

  bool get glutenFilter{
    return _glutenFree;
  }
  bool get vegetarianFilter{
    return _vegetarian;
  }
  bool get veganFilter{
    return _vegan;
  }
  bool get lactoseFilter{
    return _lactoseFree;
  }
  Future<void> fetchFilters(String userId,String token) async{
    final url = 'https://mealsapp-8267e.firebaseio.com/userFilters/$userId.json?auth=$token';
    try{
     final response = await http.get(url);
     final extractedData = json.decode(response.body) as Map<String,dynamic>;
     print(extractedData);
     if(extractedData==null)
      return;
      _glutenFree = extractedData['isGlutenFree'];
        _lactoseFree = extractedData['isLactoseFree'];
        _vegan = extractedData['isVegan'];
        _vegetarian = extractedData['isVegetarian'];  
      
      
      notifyListeners();
      

    } catch(error){
      throw error;
      
    }
    return;
  }
  Future<void> setFilterForUser(String userId,String token,bool isGlutenFree,bool isLactoseFree,bool isVegan,bool isVegetarian,) async{
    final url = 'https://mealsapp-8267e.firebaseio.com/userFilters/$userId.json?auth=$token';
    try{
      final response = await http.get(url);
     final extractedData = json.decode(response.body) as Map<String,dynamic>;
     if(extractedData==null)
       {
         await http.post(
        url,
        body: json.encode({
          'isGlutenFree':isGlutenFree,
          'isLactoseFree':isLactoseFree,
          'isVegan':isVegan,
          'isVegetarian':isVegetarian,
        }),

      );
       }
       else{
         await http.put(
           url,
          body: json.encode({
            'isGlutenFree':isGlutenFree,
            'isLactoseFree':isLactoseFree,
            'isVegan':isVegan,
            'isVegetarian':isVegetarian, 
          }),
         );
       }
       notifyListeners();
    }
        catch (error) {
         
          throw error;
        }
  }
}