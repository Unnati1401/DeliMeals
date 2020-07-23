import 'package:flutter/material.dart';
import '../widgets/category_item.dart';
import '../providers/categories.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../providers/meals.dart';
import 'package:getwidget/getwidget.dart';
import 'dart:io' show Platform;

class CategoriesScreen extends StatefulWidget {
  static const routeName = '/categories_screen';

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Meals>(context).fetchMeals().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List<Category> list = Provider.of<Categories>(context).getCategoriesList;

    return _isLoading
        ? Platform.isAndroid
            ? GFLoader(
                type: GFLoaderType.circle,
                /*child: Image(
                  image: NetworkImage(
                      'https://lh3.googleusercontent.com/proxy/uXs_SiT4Ww-5SbRlQl06sS4xVyB-VSYrKqXHNVmBr9iT-Qw0IfHouEUnwhM0IRdcoJZIO-vx3UyHiVohJ3D86jY'),
                ),*/
                //loaderIconOne: Text('Loading...'),
              )
            : GFLoader(type: GFLoaderType.ios)
        : GridView(
            padding: const EdgeInsets.all(25),
            children: list.map((catData) => CategoryItem(catData)).toList(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
          );
  }
}
