// lib/main.dart
import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';

void main() {
  runApp(const ExpenseMateApp());
}

class ExpenseMateApp extends StatelessWidget {
  const ExpenseMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ExpenseMate",
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const HomePage(),
      routes: {
        '/profile': (ctx) => const ProfilePage(),
        '/settings': (ctx) => const SettingsPage(),
      },
    );
  }
}


// void main() {
//   runApp(ExpenseMateApp());
// }

// class ExpenseMateApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: true, // hides the red debug banner
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MainApp(),
//     );
//   }
// }

// class MainApp extends StatefulWidget {
//   @override
//   _MainAppState createState() => _MainAppState();
// }

// class _MainAppState extends State<MainApp> {
//   int _currentIndex = 0;

//   final List<Widget> _pages = [
//     HomeScreen(),
//     TransactionsScreen(),
//     CategoriesScreen(),
//     ProfileScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("ExpenseMate"),
//         leading: IconButton(
//           icon: Icon(Icons.home),
//           onPressed: () {
//             setState(() {
//               _currentIndex = 0; // Always go back to Home
//             });
//           },
//         ),
//         // actions: [
//         //   IconButton(
//         //     icon: Icon(Icons.settings),
//         //     onPressed: () {
//         //       Navigator.push(
//         //         context,
//         //         MaterialPageRoute(builder: (context) => SettingsScreen()),
//         //       );
//         //     },
//         //   ),
//         // ],
//       ),
//       body: _pages[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.list), label: "Transactions"),
//           BottomNavigationBarItem(icon: Icon(Icons.category), label: "Categories"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: () {
//           // Add new expense (future feature)
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Add Expense Clicked")),
//           );
//         },
//       ),
//     );
//   }
// }

// //
// // SCREENS
// //
// class HomeScreen extends StatelessWidget {
//   final List<Map<String, dynamic>> transactions = [
//     {"title": "Groceries", "amount": -1200, "date": "Sep 10"},
//     {"title": "Salary", "amount": 25000, "date": "Sep 09"},
//     {"title": "Electricity Bill", "amount": -1800, "date": "Sep 08"},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Balance Card
//           Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15),
//             ),
//             color: Colors.blueAccent,
//             elevation: 4,
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Total Balance",
//                       style: TextStyle(color: Colors.white70, fontSize: 16)),
//                   SizedBox(height: 5),
//                   Text("₹23,500",
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold)),
//                   SizedBox(height: 15),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         children: [
//                           Text("Income",
//                               style:
//                                   TextStyle(color: Colors.white70, fontSize: 14)),
//                           Text("₹25,000",
//                               style: TextStyle(
//                                   color: Colors.greenAccent,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold)),
//                         ],
//                       ),
//                       Column(
//                         children: [
//                           Text("Expenses",
//                               style:
//                                   TextStyle(color: Colors.white70, fontSize: 14)),
//                           Text("₹1,500",
//                               style: TextStyle(
//                                   color: Colors.redAccent,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold)),
//                         ],
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),

//           SizedBox(height: 20),

//           // Recent Transactions
//           Text("Recent Transactions",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           SizedBox(height: 10),
//           Column(
//             children: transactions.map((tx) {
//               return Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: ListTile(
//                   leading: CircleAvatar(
//                     backgroundColor: tx["amount"] > 0
//                         ? Colors.greenAccent
//                         : Colors.redAccent,
//                     child: Icon(
//                       tx["amount"] > 0 ? Icons.arrow_downward : Icons.arrow_upward,
//                       color: Colors.white,
//                     ),
//                   ),
//                   title: Text(tx["title"]),
//                   subtitle: Text(tx["date"]),
//                   trailing: Text(
//                     "₹${tx["amount"]}",
//                     style: TextStyle(
//                         color: tx["amount"] > 0 ? Colors.green : Colors.red,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),

//           SizedBox(height: 20),

//           // Quick Categories
//           Text("Quick Categories",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildCategoryCard(Icons.fastfood, "Food", Colors.orange),
//               _buildCategoryCard(Icons.directions_car, "Travel", Colors.blue),
//               _buildCategoryCard(Icons.receipt_long, "Bills", Colors.purple),
//               _buildCategoryCard(Icons.shopping_cart, "Shopping", Colors.green),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   // Reusable category card widget
//   Widget _buildCategoryCard(IconData icon, String label, Color color) {
//     return Column(
//       children: [
//         CircleAvatar(
//           radius: 25,
//           backgroundColor: color.withOpacity(0.2),
//           child: Icon(icon, color: color, size: 28),
//         ),
//         SizedBox(height: 6),
//         Text(label, style: TextStyle(fontSize: 14)),
//       ],
//     );
//   }
// }


// class TransactionsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         "Your Transactions will appear here.",
//         style: TextStyle(fontSize: 18),
//       ),
//     );
//   }
// }

// class CategoriesScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         "Expense Categories (Food, Travel, Bills, etc.)",
//         style: TextStyle(fontSize: 18),
//       ),
//     );
//   }
// }

// class ProfileScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         "User Profile & Bank Accounts",
//         style: TextStyle(fontSize: 18),
//       ),
//     );
//   }
// }

