import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeBookPage extends StatefulWidget {
  const RecipeBookPage({Key? key}) : super(key: key);

  @override
  _RecipeBookPageState createState() => _RecipeBookPageState();
}

class _RecipeBookPageState extends State<RecipeBookPage> {
  List<Map<String, dynamic>> recipes = [];
  List<Map<String, dynamic>> filteredRecipes = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  void fetchRecipes() async {
    final snapshot = await FirebaseFirestore.instance.collection('recipes').get();
    setState(() {
      recipes = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
      filteredRecipes = List.from(recipes);
    });
  }

  void deleteRecipe(String id) async {
    await FirebaseFirestore.instance.collection('recipes').doc(id).delete();
    fetchRecipes();
  }

  void showEditDialog(Map<String, dynamic> recipe) {
    TextEditingController titleController = TextEditingController(text: recipe['title']);
    TextEditingController ingredientsController = TextEditingController(text: recipe['ingredients']);
    TextEditingController instructionsController = TextEditingController(text: recipe['instructions']);
    TextEditingController imageUrlController = TextEditingController(text: recipe['imageUrl']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Recipe'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: titleController, decoration: InputDecoration(labelText: 'Title')),
                TextField(controller: ingredientsController, decoration: InputDecoration(labelText: 'Ingredients')),
                TextField(controller: instructionsController, decoration: InputDecoration(labelText: 'Instructions')),
                TextField(controller: imageUrlController, decoration: InputDecoration(labelText: 'Image URL')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('recipes').doc(recipe['id']).update({
                  'title': titleController.text,
                  'ingredients': ingredientsController.text,
                  'instructions': instructionsController.text,
                  'imageUrl': imageUrlController.text,
                });
                Navigator.of(context).pop();
                fetchRecipes();
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            )
          ],
        );
      },
    );
  }

  void showAddDialog() {
    TextEditingController titleController = TextEditingController();
    TextEditingController ingredientsController = TextEditingController();
    TextEditingController instructionsController = TextEditingController();
    TextEditingController imageUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Recipe'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: titleController, decoration: InputDecoration(labelText: 'Title')),
                TextField(controller: ingredientsController, decoration: InputDecoration(labelText: 'Ingredients')),
                TextField(controller: instructionsController, decoration: InputDecoration(labelText: 'Instructions')),
                TextField(controller: imageUrlController, decoration: InputDecoration(labelText: 'Image URL')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('recipes').add({
                  'title': titleController.text,
                  'ingredients': ingredientsController.text,
                  'instructions': instructionsController.text,
                  'imageUrl': imageUrlController.text,
                });
                Navigator.of(context).pop();
                fetchRecipes();
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            )
          ],
        );
      },
    );
  }

  void filterRecipes(String query) {
    final result = recipes.where((recipe) {
      final title = recipe['title'].toString().toLowerCase();
      return title.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredRecipes = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Book'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          TextButton.icon(
            onPressed: showAddDialog,
            icon: Icon(Icons.add, color: Colors.white),
            label: Text("Add Recipe", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Search Recipes",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: filterRecipes,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: filteredRecipes.isEmpty
                  ? Center(child: Text("No recipes found"))
                  : ListView.builder(
                      itemCount: filteredRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = filteredRecipes[index];
                        return GestureDetector(
                          onTap: () => showEditDialog(recipe),
                          child: Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    recipe['imageUrl'] ?? '',
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          recipe['title'] ?? '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Ingredients:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          recipe['ingredients'] ?? '',
                                          style: TextStyle(fontSize: 11),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Steps:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          recipe['instructions'] ?? '',
                                          style: TextStyle(fontSize: 11),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => deleteRecipe(recipe['id']),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
