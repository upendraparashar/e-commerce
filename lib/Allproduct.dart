import 'dart:convert';
import 'package:e_commerce_project/allproductdetail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class Allproduct extends StatefulWidget {
  Allproduct({Key? key}) : super(key: key);

  @override
  State<Allproduct> createState() => _AllproductState();
}

class _AllproductState extends State<Allproduct> {
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
          'Products',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: mydatalist.length,
              itemBuilder: (context, index) {
                if (mydatalist.isNotEmpty) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllProductDetail(
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
                } else {
                  return CircularProgressIndicator(); // Or any other loading indicator
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  _fetchData() async {
    try {
      var url = Uri.http('akashsir.in', 'myapi/atecom1/api/api-list-product.php');
      var response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> myMap = json.decode(response.body);
        setState(() {
          mydatalist = myMap['product_list'];
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print("Error in API Calling: $error");
    }
  }
}
