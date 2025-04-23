import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Plan History'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('meal_planner').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No meal plans saved.'));
          }

          final mealPlans = snapshot.data!.docs;
          return ListView.builder(
            itemCount: mealPlans.length,
            itemBuilder: (context, index) {
              final mealPlan = mealPlans[index];
              final date = (mealPlan['date'] as Timestamp).toDate();
              final breakfast = mealPlan['breakfast'] ?? 'Not Provided';
              final lunch = mealPlan['lunch'] ?? 'Not Provided';
              final dinner = mealPlan['dinner'] ?? 'Not Provided';

              return ListTile(
                title: Text('${date.year}-${date.month}-${date.day}'),
                subtitle: Text('Breakfast: $breakfast\nLunch: $lunch\nDinner: $dinner'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to a detailed view if necessary
                },
              );
            },
          );
        },
      ),
    );
  }
}
