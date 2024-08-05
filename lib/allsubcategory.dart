import 'dart:convert';
import 'package:e_commerce_project/allsubcat_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class AllSubcategory extends StatefulWidget {
  @override
  State<AllSubcategory> createState() => _AllSubcategoryState();
}

class _AllSubcategoryState extends State<AllSubcategory> {
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
        title:  Text(
          'Subcategories',
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
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>AllSubcategoryDetail(
                          subcategoryId: mydatalist[index]['sub_category_id'].toString(),
                          subcategoryName: mydatalist[index]['sub_category_name'].toString(),
                          subcategoryImage: mydatalist[index]['sub_category_image'].toString(),
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
                        mydatalist[index]['sub_category_image'].toString(),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(mydatalist[index]['sub_category_name'].toString()),
                      subtitle: Text('Subcategory ID: ${mydatalist[index]['sub_category_id']}'),
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
          var url = Uri.http('akashsir.in', 'myapi/atecom1/api/api-list-subcategory.php');
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
