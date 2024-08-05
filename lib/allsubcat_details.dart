import 'dart:convert';
import 'package:e_commerce_project/cardlist.dart';
import 'package:e_commerce_project/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AllSubcategoryDetail extends StatefulWidget {
  final String subcategoryId;
  final String subcategoryName;
  final String subcategoryImage;

  const AllSubcategoryDetail({
    Key? key,
    required this.subcategoryId,
    required this.subcategoryName,
    required this.subcategoryImage,
  }) : super(key: key);

  @override
  _AllSubcategoryDetailState createState() => _AllSubcategoryDetailState();
}

class _AllSubcategoryDetailState extends State<AllSubcategoryDetail> {
  int _quantity = 1; // Quantity variable

  Future<void> _addtocart() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('userid') ?? '';

      var cartUrl = Uri.parse('https://akashsir.in/myapi/atecom1/api/api-add-cart.php');
      var cartResponse = await http.post(
        cartUrl,
        body: {
          'user_id': userId,
          'product_id': widget.subcategoryId, // Use subcategory ID for demonstration
          'product_qty': _quantity.toString(),
          
        },
      );

      if (cartResponse.statusCode == 200 ) {
        Map<String, dynamic> cartData = jsonDecode(cartResponse.body);

        if (cartData['flag'] == '1' ) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Product added to cart.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add product to cart. Please try again.'),
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

  Future<void> _wishlist() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('userid') ?? '';

      var wishlistUrl = Uri.parse('https://akashsir.in/myapi/atecom1/api/api-add-wishlist.php');
      var wishlistResponse = await http.post(
        wishlistUrl,
        body: {
          'user_id': userId,
          'product_id': widget.subcategoryId, // Use subcategory ID for demonstration
          'action': 'add',
        },
      );

      if (wishlistResponse.statusCode == 200) {
        Map<String, dynamic> wishlistData = jsonDecode(wishlistResponse.body);

        if (wishlistData['flag'] == '1') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Product added to wishlist.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add product to wishlist. Please try again.'),
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

  void _decreaseQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              widget.subcategoryImage,
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              'Subcategory ID: ${widget.subcategoryId}',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Subcategory Name: ${widget.subcategoryName}',
              style: TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _decreaseQuantity,
                  child: Icon(Icons.remove),
                ),
                SizedBox(width: 10),
                Text('$_quantity', style: TextStyle(fontSize: 18)),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _increaseQuantity,
                  child: Icon(Icons.add),
                ),
              ],
            ),
             ElevatedButton(
              onPressed: () async {
                await _addtocart();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartListPage(
                      ),
                  ),
                );
              },
              child: Text('Add to Cart'),
            ),
            ElevatedButton(onPressed: (){
              _wishlist();
              Navigator.push(context, 
              MaterialPageRoute(builder: (context)=>WishlistPage(
               
                      ),
              ));
            }, child: Text("Add to Wishlist"),
            ),
          ],
        ),
      ),
    );
  }
}
