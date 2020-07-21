import 'package:flutter/material.dart';
import './screens/trending_screen.dart';
import './screens/add_meal_screen.dart';
import './screens/tabs_screen.dart';
import './screens/meal_detail_screen.dart';
import './screens/category_meals_screen.dart';
import './screens/save_meal_screen.dart';
import './screens/filters_screen.dart';
import './providers/meals.dart';
import './providers/filters.dart';
import 'package:provider/provider.dart';
import 'providers/categories.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';
import './screens/user_meals_screen.dart';
import './screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {



@override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    
  @override
  Widget build(BuildContext context) {
    //List<Meal> _availableMeals = Provider.of<Meals>(context).getMealsList;
    return MultiProvider(
      providers: [

        ChangeNotifierProvider.value(
          value: Auth(),
        ),

        ChangeNotifierProxyProvider<Auth,Meals>(
          create: (_) => Meals(null,[],null),
          update: (ctx,auth,previousMeals) => 
            Meals(auth.token,previousMeals == null ? [] : previousMeals.getMealsList,auth.userId),
        ),

        ChangeNotifierProvider.value(
          value: Filters(),
        ),


        ChangeNotifierProvider.value(
          value: Categories(),
        ),
        
        
      ],
      //child only rebuilds when auth object changes
        child: Consumer<Auth>(
          builder:(ctx,auth,_) => MaterialApp(
        title: 'DeliMeals',
        theme: ThemeData(
          primarySwatch:Colors.blue,
          accentColor: Color.fromRGBO(166, 216, 245, 1),
          canvasColor: Colors.white,
          //accentTextTheme: Color.fromRGBO(255, 255, 255, 1),
          fontFamily: 'Raleway',
          textTheme: ThemeData.light().textTheme.copyWith(
            body1: TextStyle(
              color:Color.fromRGBO(20, 51, 51, 1),
            ),
            body2: TextStyle(
              color:Color.fromRGBO(20, 51, 51, 1),
            ),
            title: TextStyle(
              fontSize:20,
              fontFamily:'Raleway',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        //initialRoute: '/',
        home: auth.isAuth ? TabScreen() : 
            FutureBuilder(
              future: auth.tryAutoLogin(), 
              builder: (ctx,authResultSnapShot) => authResultSnapShot.connectionState==ConnectionState.waiting ? SplashScreen() : AuthScreen(),
            ),
        routes: {
          //'/':(ctx) => TabScreen(),
          CategoryMealsScreen.routeName: (ctx) => CategoryMealsScreen(),
          MealDetailScreen.routeName: (ctx) => MealDetailScreen(),
          FiltersScreen.routeName:(ctx) => FiltersScreen(),
          AddMeal.routeName:(ctx) => AddMeal(),
          SaveMeal.routeName: (ctx) => SaveMeal(),
          AuthScreen.routeName: (ctx) => AuthScreen(),
          UserMealsScreen.routeName: (ctx) => UserMealsScreen(),
          TrendingScreen.routeName: (ctx) =>TrendingScreen(),
        },
        onGenerateRoute: (settings){
          
          return MaterialPageRoute(builder: (ctx) => TabScreen(),
          );

        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (ctx) => TabScreen(),);
        },
      ),
    ),
    );
  }
}
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('DeliMeals'),
      ),     

      body: Center(
        child:Text('Navigation Time!'),
      ),
    );
  }
}