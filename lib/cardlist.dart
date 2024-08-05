import 'dart:convert';
import 'package:e_commerce_project/shipping.dart';
import 'package:e_commerce_project/welcome.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartListPage extends StatefulWidget {
  @override
  _CartListPageState createState() => _CartListPageState();
}

class _CartListPageState extends State<CartListPage> {
  var mydatalist = [];

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  void _fetchCartItems() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('userid') ?? '';

      var url = Uri.parse('https://akashsir.in/myapi/atecom1/api/api-list-cart.php');
      var response = await http.post(
        url,
        body: {
          'user_id': userId,
        },
      );

      Map<String, dynamic> mymap = json.decode(response.body);

      if (mymap['flag'] == "1") {
        setState(() {
          mydatalist = mymap['cart_list'];
        });
      } else {
        throw Exception('Failed to fetch cart items: ${response.statusCode}');
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

  Future<void> _removecartlist(BuildContext context, cart_id) async {
    try {
      var url = Uri.parse('https://akashsir.in/myapi/atecom1/api/api-delete-cart.php');
      var response = await http.post(
        url,
        body: {
          'cart_id': cart_id,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> mymap = json.decode(response.body);
        _fetchCartItems();
        if (mymap['flag'] == "1") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Product removed from the cart.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove the product. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  double _calculateTotalPrice() {
    double total = 0.0;
    mydatalist.forEach((item) {
      int quantity = int.tryParse(item['product_qty'] ?? '') ?? 0;
      double price = double.tryParse(item['product_price'] ?? '') ?? 0.0;
      total += quantity * price;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Cart list'),
        leading: BackButton(
          onPressed: (){
            Navigator.push(context,
            MaterialPageRoute(builder: (context)=>WelcomePage ()));
          },
        ),
         automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                // Do something when total price is tapped
              },
              child: Row(
                children: [
                  Text(
                    'Total: \$${_calculateTotalPrice().toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: mydatalist.length,
        itemBuilder: (context, index) {
          if (index < mydatalist.length && mydatalist[index] != null) {
            int quantity = int.tryParse(mydatalist[index]['product_qty'] ?? '') ?? 0;
            double price = double.tryParse(mydatalist[index]['product_price'] ?? '') ?? 0.0;
            double total = quantity * price;

            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              leading: Image.network(mydatalist[index]['product_image'] ?? ''),
              title: Text(mydatalist[index]['product_name'] ?? ''),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price: \$${price.toStringAsFixed(2)}'),
                  Text('Quantity: $quantity'),
                  Text('Total: \$${total.toStringAsFixed(2)} | cart ID: ${mydatalist[index]['cart_id']}'),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _removecartlist(context, mydatalist[index]['cart_id']);
                },
              ),
            );
          } else {
            return SizedBox(); // Return an empty widget or loading indicator
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => shipping()));
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}
