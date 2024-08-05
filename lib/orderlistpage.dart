import 'package:e_commerce_project/orderdetails.dart';
import 'package:e_commerce_project/welcome.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class OrderListPage extends StatefulWidget {
  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
 var mydatalist = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userid') ?? '';
    try {
      var url = Uri.parse('https://akashsir.in/myapi/atecom1/api/api-list-order.php');
      var response = await http.post(
        url,
        body: {'user_id': userId,},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> mymap = json.decode(response.body);
        mydatalist=mymap['order_list'];
        setState(() {
          mydatalist = mydatalist;
        });
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.green,
      title: Text('Order List'),
      leading: BackButton(
        onPressed: (){
          Navigator.push(context,
          MaterialPageRoute(builder: (context)=>WelcomePage()));
        },
      ),
       automaticallyImplyLeading: false,
    ),
    body: mydatalist.isEmpty
      ? Center(child: Text('Order list is empty'))
      : ListView.builder(
          itemCount: mydatalist.length,
          itemBuilder: (context, index) {
            var order = mydatalist[index];
            return Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                title: Text('Order ID: ${order['order_id']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order Date: ${order['order_date']}'),
                    Text('Order Status: ${order['order_status']}'),
                    Text('Total Amount: ${order['total_amount']}'),
                    Text('Shipping Name: ${order['shipping_name']}'),
                    Text('Shipping Mobile: ${order['shipping_mobile']}'),
                    Text('Shipping Address: ${order['shipping_address']}'),
                    Text('Payment Method: ${order['payment_method']}'),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetails(orderId: order['order_id'])));
                  },
                  child: Text('View'),
                ),
              ),
            );
          },
        ),
  );
}
}