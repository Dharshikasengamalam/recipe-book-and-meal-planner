import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';  // For printing/PDF generation

class GroceryListPage extends StatefulWidget {
  const GroceryListPage({super.key});

  @override
  _GroceryListPageState createState() => _GroceryListPageState();
}

class _GroceryListPageState extends State<GroceryListPage> {
  List<String> ingredients = []; // List of ingredients
  Map<String, bool> ingredientStatus = {}; // Map to store checkbox status

  @override
  void initState() {
    super.initState();
    fetchMealIngredients();
  }

  // Fetch ingredients from Firestore (from the meal plans)
  Future<void> fetchMealIngredients() async {
    // Fetch meal plans from Firestore
    final mealPlansSnapshot = await FirebaseFirestore.instance.collection('meal_planner').get();
    List<String> allIngredients = [];

    // Aggregate ingredients from meal plans
    mealPlansSnapshot.docs.forEach((doc) {
      if (doc['breakfast'] != null) allIngredients.add(doc['breakfast']);
      if (doc['lunch'] != null) allIngredients.add(doc['lunch']);
      if (doc['dinner'] != null) allIngredients.add(doc['dinner']);
    });

    // Remove duplicates and update state
    setState(() {
      ingredients = allIngredients.toSet().toList();
      ingredientStatus = {for (var ingredient in ingredients) ingredient: false}; // All unchecked initially
    });
  }

  // Function to generate PDF for the grocery list
  void exportToPDF() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Ingredients of the Menu List', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.ListView.builder(
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                  return pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(ingredients[index]),
                      pw.Text(ingredientStatus[ingredients[index]]! ? 'Bought' : 'Not Bought'),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );

    // Send the PDF to the printer or save it
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
    Fluttertoast.showToast(msg: "Grocery list exported as PDF!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Grocery List',
          style: TextStyle(fontFamily: 'Pacifico', fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Heading for the ingredients list
            Text(
              'Menu List Included with Ingredients',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurpleAccent,
              ),
            ),
            const SizedBox(height: 20),
            
            // Displaying the aggregated ingredient list with checkboxes
            Expanded(
              child: ListView.builder(
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5), // Apply margin here
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                      title: Text(
                        ingredients[index],
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                      trailing: Checkbox(
                        value: ingredientStatus[ingredients[index]]!,
                        onChanged: (bool? value) {
                          setState(() {
                            ingredientStatus[ingredients[index]] = value!;
                          });
                        },
                        activeColor: Colors.deepPurpleAccent,
                      ),
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Floating Action Button to export/download the list
            FloatingActionButton(
              onPressed: exportToPDF,
              backgroundColor: Colors.deepPurpleAccent,
              child: Icon(Icons.download, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}
