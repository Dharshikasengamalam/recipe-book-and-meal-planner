import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'meal_planner_screen.dart'; // Import the MealPlannerPage

class HomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final displayName = user?.displayName ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $displayName!'),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade200, Colors.deepPurple.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Existing cards
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildCard(
                        title: 'Recipe Book',
                        imageUrl: 'recipe_book.jpg',
                        onTap: () => Navigator.pushNamed(context, '/recipeBook'),
                      ),
                      _buildCard(
                        title: 'Meal Planner',
                        imageUrl: 'meal_planner.png',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MealPlannerPage()),
                        ),
                      ),
                      _buildCard(
                        title: 'Grocery List',
                        imageUrl: 'grocery_list.jpg',
                        onTap: () => Navigator.pushNamed(context, '/groceryList'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Card(
            color: Colors.white.withOpacity(0.9),
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: 380,
              height: 380,
              padding: EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
