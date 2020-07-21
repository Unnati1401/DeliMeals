import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart';

class TrendingScreen extends StatefulWidget {
  static const routeName = '/trending';

  @override
  _TrendingScreenState createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
       title: Text('Trending Meals'), 
      ),
      body: Center(
        child: Text('Trending Screen'),
      ),
    );
  }
}