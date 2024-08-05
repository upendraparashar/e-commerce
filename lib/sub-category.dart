import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:e_commerce_project/product.dart';
class Subcategory extends StatefulWidget {
  final String categoryId;

  Subcategory({Key? key, required this.categoryId}) : super(key: key);

  @override
  State<Subcategory> createState() => _SubcategoryState();
}

class _SubcategoryState extends State<Subcategory> {
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
          'Sub-category',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      body:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Category ID: ${widget.categoryId}'),
          ),
          Expanded(
            child: ListView.builder(
        itemCount: mydatalist.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigate to Product with subcategory ID and category ID
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Product(subcategoryId: mydatalist[index]['sub_category_id'].toString(), categoryId: widget.categoryId)),
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
                  mydatalist[index]['sub_category_image'].toString(),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(mydatalist[index]['sub_category_name'].toString()),
                subtitle: Text('Sub category ID: ${mydatalist[index]['sub_category_id']}'),
                trailing: Icon(Icons.arrow_circle_right_outlined),
              ),
            ),
          );
        },
      ),
    ),
        ],
      ),);
  }

  _fetchData() async {
    try {
      var url = Uri.http('akashsir.in', 'myapi/atecom1/api/api-list-subcategory.php', {'category_id': widget.categoryId});
      var response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

 if (response.statusCode == 200) {
      Map<String, dynamic> mymap = json.decode(response.body);
      if (mymap.containsKey('sub_category_list')) {
        setState(() {
          mydatalist = mymap['sub_category_list'];
        });
      } else {
        print('Error: Response does not contain sub_category_list');
      }
    } else {
      print('Error: Failed to fetch data. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error in API Calling: $error');
  }
}
}
