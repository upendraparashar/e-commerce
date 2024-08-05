import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  var mydatalist = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('userid') ?? '';

      var url = Uri.parse('https://akashsir.in/myapi/atecom1/api/api-list-wishlist.php');
      var response = await http.post(
        url,
        body: {
          'user_id': userId,
        },
      );

      if (response.statusCode == 200) {
         Map<String, dynamic> mymap = json.decode(response.body);
         mydatalist = mymap['wishlist'];
        setState(() {
          mydatalist;
        });
      }
    } catch (e) {
      print('An error occurred while loading wishlist: $e');
    }
  }
  Future<void> _removewishlist(wishlist_id) async {
    try {

      var url = Uri.parse('https://akashsir.in/myapi/atecom1/api/api-delete-wishlist.php');
      var response = await http.post(
        url,
        body: {
          'wishlist_id':wishlist_id,
        },
      );

      if (response.statusCode == 200) {
         Map<String, dynamic> mymap = json.decode(response.body);
     _fetchData();
     if ( mymap['flag'] == '1') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Product remove from the wishlist.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Wishlist'),
         
      ),
      body: ListView.builder(
        itemCount: mydatalist.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(mydatalist[index]['product_image']),
            title: Text(mydatalist[index]['product_name']),
            subtitle: Text('\$${double.parse(mydatalist[index]['product_price']).toStringAsFixed(2)} | Product ID: ${mydatalist[index]['product_id']}|| WishlistID: ${mydatalist[index]['wishlist_id']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _removewishlist(mydatalist[index]['wishlist_id']);
              },
            ),
          );
        },
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

