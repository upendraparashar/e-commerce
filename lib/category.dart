import 'dart:convert';
import 'package:e_commerce_project/cardlist.dart';
import 'package:e_commerce_project/search.dart';
import 'package:e_commerce_project/sub-category.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(category());
}

class Item {
  final String name;
  final String image;

  Item({required this.name, required this.image});
}

class category extends StatelessWidget {
  const category({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getUsername(), // Assuming you have a function to retrieve the username
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return MyHomePage(username: snapshot.data!);
        } else {
          return MyHomePage();
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String? username;

  const MyHomePage({Key? key, this.username}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var mydatalist = [];


  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Home',
          style: TextStyle(fontSize: 20, color: Colors.black),
          
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage()));
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CartListPage()));
            },
            icon: Icon(Icons.shopping_cart),
          ),
        ],
      ),
      
      body: ListView.builder(
        itemCount: mydatalist.length,
        itemBuilder: (context, index) {
          return Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                // Navigate to Subcategory with category ID
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Subcategory(categoryId: mydatalist[index]['category_id'].toString())),
                );
              },
              child: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(8),
                  leading: Image.network(
                    mydatalist[index]['category_image'].toString(),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(mydatalist[index]['category_name'].toString()),
                  subtitle: Text('Category ID: ${mydatalist[index]['category_id']}'),
                  trailing: Icon(Icons.arrow_circle_right_outlined),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _fetchData() async {
    try {
      var url = Uri.http('akashsir.in', 'myapi/atecom1/api/api-list-category.php');
      var response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      Map<String, dynamic> mymap = json.decode(response.body);
      mydatalist = mymap['category_list'];
      setState(() {
        mydatalist;
      });
    } catch (error) {
      print("Error in API Calling");
    }
  }


  void _fetchcartlist() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('userid') ?? '';

      var url = Uri.parse('https://akashsir.in/myapi/atecom1/api/api-cart-list.php');
      var response = await http.post(
        url,
        body: {
          'user_id': userId,
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> mymap = json.decode(response.body);
        _fetchData();
        if (mymap['flag'] == "1") {
        setState(() {
          mydatalist = mymap['cart_list'];
        });
      } else {
        throw Exception('Failed to fetch cart items: ${response.statusCode}');
      }
      }
    } catch (e) {
      print('Error fetching cart items: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

Future<String?> getUsername() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('username');
}
