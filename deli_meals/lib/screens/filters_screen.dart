import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = '/filters';

  final Map<String, bool> currentFilters;
  final Function saveFilters;

  FiltersScreen(this.currentFilters, this.saveFilters);

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  bool _glutenFree = false;
  bool _vegeterian = false;
  bool _vegan = false;
  bool _lactoseFree = false;

  @override
  initState() {
    super.initState();
    _glutenFree = widget.currentFilters['gluten'] as bool;
    _lactoseFree = widget.currentFilters['lactose'] as bool;
    _vegeterian = widget.currentFilters['vegetarian'] as bool;
    _vegan = widget.currentFilters['vegan'] as bool;
  }

  Widget _buildSwitchListTile(
    String title,
    String description,
    bool currentValue,
    Function updateValue,
  ) {
    return SwitchListTile(
      title: Text(
        title,
      ),
      value: currentValue,
      subtitle: Text(
        description,
      ),
      onChanged: (newValue) {
        setState(() {
          updateValue(newValue);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Filters',
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.save,
            ),
            onPressed: () {
              final selectedFilters = {
                'gluten': _glutenFree,
                'lactose': _lactoseFree,
                'vegan': _vegan,
                'vegetarian': _vegeterian,
              };
              widget.saveFilters(selectedFilters);
            },
          )
        ],
      ),
      drawer: MainDrawer(),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Adjust your meal section.',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                _buildSwitchListTile(
                  'Gluten-free',
                  'Only-include gluten-free meals.',
                  _glutenFree,
                  (newValue) {
                    _glutenFree = newValue;
                  },
                ),
                _buildSwitchListTile(
                  'Vegetarian',
                  'Only-include vegetarian meals.',
                  _vegeterian,
                  (newValue) {
                    _vegeterian = newValue;
                  },
                ),
                _buildSwitchListTile(
                  'Vegan',
                  'Only-include vegan meals.',
                  _vegan,
                  (newValue) {
                    _vegan = newValue;
                  },
                ),
                _buildSwitchListTile(
                  'Lactose-free',
                  'Only-include lactose-free meals.',
                  _lactoseFree,
                  (newValue) {
                    _lactoseFree = newValue;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
