import 'package:flutter/material.dart';
import 'package:paprika_app/services/spoonacular.dart';

class RecipeProvider with ChangeNotifier {
  final SpoonacularService _spoonacularService = SpoonacularService();
  Future<List<dynamic>>? _recipes;

  Future<List<dynamic>>? get recipes => _recipes;

  void loadRecipes() {
    _recipes = _spoonacularService.fetchData('recipes/random');
    notifyListeners();
  }
}