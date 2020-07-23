import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart';
import '../providers/filters.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/meals.dart';
import 'package:getwidget/getwidget.dart';
import 'dart:io' show Platform;

class FiltersScreen extends StatefulWidget {
  static const routeName = '/filters';

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  var _glutenFree = false;
  var _vegetarian = false;
  var _vegan = false;
  var _lactoseFree = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Filters>(context, listen: false)
          .fetchFilters(Provider.of<Auth>(context).userId,
              Provider.of<Auth>(context).token)
          .then((_) {
        _glutenFree = Provider.of<Filters>(context, listen: false).glutenFilter;
        _lactoseFree =
            Provider.of<Filters>(context, listen: false).lactoseFilter;
        _vegan = Provider.of<Filters>(context, listen: false).veganFilter;
        _vegetarian =
            Provider.of<Filters>(context, listen: false).vegetarianFilter;
        Provider.of<Meals>(context, listen: false)
            .setMealsByFilters()
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  /*void setUpFilters()async{
      /*setState(() {
        _isLoading = true;
        print("yes");
      });*/
      
      final response = await Provider.of<Filters>(context,listen: false).fetchFilters(Provider.of<Auth>(context).userId, Provider.of<Auth>(context).token);
      if(response)
      { _glutenFree = Provider.of<Filters>(context,listen: false).glutenFilter;
        _lactoseFree = Provider.of<Filters>(context,listen: false).lactoseFilter;
        _vegan = Provider.of<Filters>(context,listen: false).veganFilter;
        _vegetarian = Provider.of<Filters>(context,listen: false).vegetarianFilter;
      }
      else{
        _glutenFree = false;
        _lactoseFree = false;
        _vegan = false;
        _vegetarian = false;
      }

      /*setState(() {
        _isLoading = false;
        print("no");
      });*/
   }   */

  Widget _buildSwitchTile(String title, String description, bool currentValue,
      Function updateValue) {
    return SwitchListTile(
      title: Text(title),
      value: currentValue,
      subtitle: Text(description),
      onChanged: updateValue,
    );
  }

  Widget _buildIOSSwicthTile(
      String title, String subtitle, bool currentValue, Function updateValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(subtitle),
          ],
        ),
        GFToggle(
          onChanged: updateValue,
          value: currentValue,
          type: GFToggleType.ios,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtersProvider = Provider.of<Filters>(context);

    final authData = Provider.of<Auth>(context);
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
        : Scaffold(
            drawer: MainDrawer(),
            appBar: AppBar(
              title: Text('Your filters'),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.save),
                    onPressed: () {
                      setState(() {
                        filtersProvider.setFilterForUser(
                            authData.userId,
                            authData.token,
                            _glutenFree,
                            _lactoseFree,
                            _vegan,
                            _vegetarian);
                      });
                    })
              ],
            ),
            body: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Adjust your meal selection',
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
                Expanded(
                  child: Platform.isAndroid
                      ? ListView(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  _buildIOSSwicthTile(
                                      'Gluten-Free',
                                      'Only gluten-free meals',
                                      _glutenFree, (newValue) {
                                    setState(() {
                                      _glutenFree = newValue;
                                    });
                                  }),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  _buildIOSSwicthTile(
                                      'Lactose-Free',
                                      'Only lactose-free meals',
                                      _lactoseFree, (newValue) {
                                    setState(() {
                                      _lactoseFree = newValue;
                                    });
                                  }),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  _buildIOSSwicthTile(
                                      'Vegan', 'Only vegan meals', _vegan,
                                      (newValue) {
                                    setState(() {
                                      _vegan = newValue;
                                    });
                                  }),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  _buildIOSSwicthTile(
                                      'Vegetarian',
                                      'Only vegetarian meals',
                                      _vegetarian, (newValue) {
                                    setState(() {
                                      _vegetarian = newValue;
                                    });
                                  }),
                                ],
                              ),
                            ),
                          ],
                        )
                      : ListView(
                          children: <Widget>[
                            _buildSwitchTile(
                                'Gluten-Free',
                                'Only gluten-free meals',
                                _glutenFree, (newValue) {
                              setState(() {
                                _glutenFree = newValue;
                              });
                            }),
                            _buildSwitchTile(
                                'Lactose-Free',
                                'Only lactose-free meals',
                                _lactoseFree, (newValue) {
                              setState(() {
                                _lactoseFree = newValue;
                              });
                            }),
                            _buildSwitchTile(
                                'Vegetarian',
                                'Only vegetarian meals',
                                _vegetarian, (newValue) {
                              setState(() {
                                _vegetarian = newValue;
                              });
                            }),
                            _buildSwitchTile(
                                'Vegan', 'Only vegan meals', _vegan,
                                (newValue) {
                              setState(() {
                                _vegan = newValue;
                              });
                            }),
                          ],
                        ),
                ),
              ],
            ),
          );
  }
}
