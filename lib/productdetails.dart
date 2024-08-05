import 'dart:convert';
import 'package:e_commerce_project/cardlist.dart';
import 'package:e_commerce_project/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;
  final String productTitle;
  final double productPrice;
  final String productImage;

  const ProductDetailPage({
    Key? key,
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.productImage,
  }) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
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
          'product_id': widget.productId,
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
          'product_id': widget.productId,
          'action': 'add',
        },
      );

      if ( wishlistResponse.statusCode == 200) {

        Map<String, dynamic> wishlistData = jsonDecode(wishlistResponse.body);

        if ( wishlistData['flag'] == '1') {
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
              widget.productImage,
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              'Product ID: ${widget.productId}',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              ' ${widget.productTitle}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Product Price: \$${widget.productPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
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
