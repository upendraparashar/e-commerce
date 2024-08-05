import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  var mydatalist = [];

_searchProducts(String query) async {
  print("Searched for: $query");

  final response = await http.get(
    Uri.parse('https://akashsir.in/myapi/atecom1/api/api-list-search-product.php?product_name=$query'),
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> mymap = json.decode(response.body);
    setState(() {
      mydatalist = mymap['product_list'];
    });

    if (mydatalist.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item not found for: $query')),
      );
    }
  } else {
    print('Product is not available. Status code: ${response.statusCode}');
  }
}


 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.green, // Set app bar color to green
      title: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search Products...',
            border: InputBorder.none, // Remove the border of the text field
          ),
          onSubmitted: (value) {
            _searchProducts(value);

            _searchController.clear(); // Clear the text field after search
          },
        ),
      ),
    ),
    body: ListView.builder(
      itemCount: mydatalist.length,
      itemBuilder: (context, index) {
        var product = mydatalist[index];
        return ListTile(
          leading: Image.network(product['product_image']),
          title: Text(product['product_name']),
          subtitle: Text('Price: \$${product['product_price']}'),
          onTap: () {
            Navigator.pop(context);
            // Navigate to the product details page
            // You can pass the product details to the next screen if needed
          },
        );
      },
    ),
  );
}
}
