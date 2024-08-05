import 'package:e_commerce_project/orderlistpage.dart';
import 'package:e_commerce_project/welcome.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetails extends StatefulWidget {
  final String orderId;

  OrderDetails({required this.orderId});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  TextEditingController cancelOrderController = TextEditingController();
  var myDataList = [];

  @override
  void initState() {
    super.initState();
    fetchOrders(widget.orderId);
  }

  Future<void> fetchOrders(String orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userid') ?? '';
    try {
      var url = Uri.parse('https://akashsir.in/myapi/atecom1/api/api-list-order-detail.php');
      var response = await http.post(url, body: {
        'user_id': userId,
        'order_id': orderId,
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> myMap = json.decode(response.body);
        myDataList = myMap['order_details'];
        setState(() {
          myDataList = myDataList;
        });
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  Future<void> _removeOrder(String orderId, String cancelReason) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userid') ?? '';
    var url = Uri.parse('https://akashsir.in/myapi/atecom1/api/api-order-cancel.php');
    var response = await http.post(
      url,
      body: {
        'user_id': userId,
        'order_id': orderId,
        'cancel_reason': cancelReason,
      },
    );

    if (response.statusCode == 200) {
      Navigator.push(context,
      MaterialPageRoute(builder: (context)=>OrderListPage()));
      fetchOrders(widget.orderId);
    } else {
      throw Exception('Failed to cancel order');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Order Details'),
        leading: BackButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WelcomePage(
                          
                        )));
          },
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: myDataList.length,
        itemBuilder: (context, index) {
          var order = myDataList[index];
          return Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text('Order ID: ${order['order_id']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Cancel Order'),
                            content: TextField(
                              controller: cancelOrderController,
                              decoration: InputDecoration(
                                hintText: 'Enter cancel reason...',
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () async {
                                  await _removeOrder(order['order_id'], cancelOrderController.text);
                                },
                                child: Text('Cancel Order'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                ListTile(
                  leading: Image.network(
                    order['product_image'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(order['product_name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Product ID: ${order['product_id']}'),
                      Text('Price: ${order['product_price']}'),
                      Text('Quantity: ${order['product_qty']}'),
                      Text('Subtotal: ${order['sub_total']}'),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
