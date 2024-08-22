import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paprika_app/providers/meal_planner_provider.dart';

class MealPlannerScreen extends StatelessWidget {
  const MealPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mealPlannerProvider = Provider.of<MealPlannerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planejamento de Refeições'),
        backgroundColor: const Color.fromARGB(255, 135, 32, 27),
      ),
      backgroundColor: const Color(0xFFC7372F),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Número de Dias:',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                Slider(
                  value: mealPlannerProvider.numberOfDays.toDouble(),
                  min: 1,
                  max: 7,
                  divisions: 6,
                  label: '${mealPlannerProvider.numberOfDays} dias',
                  onChanged: (value) {
                    mealPlannerProvider.setNumberOfDays(value.toInt());
                  },
                ),
                ElevatedButton(
                  onPressed: mealPlannerProvider.generateMealPlan,
                  child: const Text('Gerar Planejamento de Refeições'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 135, 32, 27),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 24.0),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: mealPlannerProvider.mealPlan,
              builder: (context, snapshot) {
                if (mealPlannerProvider.mealPlan == null) {
                  return const Center(
                      child: Text(
                          'Clique no botão para gerar um planejamento de refeições.'));
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData ||
                    snapshot.data!['meals'] == null) {
                  return const Center(
                      child: Text('Nenhum planejamento encontrado.'));
                } else {
                  final meals = snapshot.data!['meals'] as List<dynamic>;
                  return ListView.builder(
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      final meal = meals[index];
                      return ListTile(
                        title: Text(meal['title']),
                        subtitle: meal['readyInMinutes'] != null
                            ? Text(
                                'Tempo de preparo: ${meal['readyInMinutes']} minutos')
                            : null,
                        leading: meal['image'] != null
                            ? Image.network(meal['image'])
                            : null,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}