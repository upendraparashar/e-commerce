import 'dart:convert';
import 'package:e_commerce_project/productdetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class Product extends StatefulWidget {
  final String subcategoryId;
  final String categoryId;

  Product({Key? key, required this.subcategoryId, required this.categoryId}) : super(key: key);

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  List<dynamic> mydatalist = [];

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
          'Products',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Category ID: ${widget.categoryId} | Subcategory ID: ${widget.subcategoryId}'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: mydatalist.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(
                          productId: mydatalist[index]['product_id'].toString(),
                          productTitle: mydatalist[index]['product_name'].toString(),
                          productPrice: double.parse(mydatalist[index]['product_price'].toString()),
                          productImage: mydatalist[index]['product_image'].toString(),
                        ),
                      ),
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
                        mydatalist[index]['product_image'].toString(),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(mydatalist[index]['product_name'].toString()),
                      subtitle: Text('Price: ${mydatalist[index]['product_price'].toString()} | Product ID: ${mydatalist[index]['product_id']}'),
                      trailing: Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _fetchData() async {
  try {
    var url = Uri.parse('https://akashsir.in/myapi/atecom1/api/api-list-product.php?sub_category_id=${widget.subcategoryId}');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> mymap = json.decode(response.body);
      if (mymap.containsKey('product_list')) {
        setState(() {
          mydatalist = mymap['product_list'];
        });
      } else {
        print('Error: Response does not contain product_list');
      }
    } else {
      print('Error: Failed to fetch data. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error in API Calling: $error');
  }
}
}
