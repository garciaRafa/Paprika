import 'package:cloud_firestore/cloud_firestore.dart';

class IngredientStorageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveIngredients(List<String> ingredients) async {
    try {
      await _firestore.collection('user_ingredients').doc('your_user_id').set({
        'ingredients': ingredients,
      });
    } catch (e) {
      print('Erro ao salvar ingredientes: $e');
    }
  }

  Future<List<String>> getIngredients() async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('user_ingredients')
          .doc('your_user_id')
          .get();
      if (doc.exists) {
        return List<String>.from(doc['ingredients']);
      }
    } catch (e) {
      print('Erro ao recuperar ingredientes: $e');
    }
    return [];
  }
}
