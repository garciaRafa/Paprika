import 'package:flutter/material.dart';
import 'package:paprika_app/services/spoonacular.dart';

class MealPlannerProvider with ChangeNotifier {
  final SpoonacularService _spoonacularService = SpoonacularService();
  Future<Map<String, dynamic>>? _mealPlan;
  int _numberOfDays = 1;

  Future<Map<String, dynamic>>? get mealPlan => _mealPlan;
  int get numberOfDays => _numberOfDays;

  void setNumberOfDays(int days) {
    _numberOfDays = days;
    notifyListeners();
  }

  void generateMealPlan() {
    _mealPlan = _spoonacularService.fetchMealPlan(_numberOfDays);
    notifyListeners();
  }
}