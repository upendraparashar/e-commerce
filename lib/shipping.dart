import 'package:e_commerce_project/orderlistpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class shipping extends StatefulWidget {
  const shipping({super.key});

  @override
  State<shipping> createState() => _shippingState();
}

class _shippingState extends State<shipping> {
  TextEditingController user_id = TextEditingController();
  TextEditingController shipping_name = TextEditingController();
  TextEditingController shipping_mobile = TextEditingController();
  TextEditingController shipping_address = TextEditingController();
  TextEditingController payment_method = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _submitShippingInfo() {
    if (_formKey.currentState!.validate()) {
      String selectedPaymentMethod = payment_method.text;
      _submitShippingDataToAPI(selectedPaymentMethod);
       Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderListPage()),
    );
    }
  }

  void _submitShippingDataToAPI(String selectedPaymentMethod) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('userid') ?? '';

      var url = Uri.parse('https://akashsir.in/myapi/atecom1/api/api-add-order.php');
      var response = await http.post(
        url,
        body: {
          'user_id': userId,
          'shipping_name': shipping_name.text,
          'shipping_mobile': shipping_mobile.text,
          'shipping_address': shipping_address.text,
          'payment_method': selectedPaymentMethod,
        },
      );

      if (response.statusCode == 200) {
        
        print('Order added successfully');
      } else {
    
        print('Failed to add order: ${response.body}');
      }
    } catch (e) {
      print('Error adding order: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor: Colors.green,
        elevation: 0.0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.green.withOpacity(.5),
                    ),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Shipping Name is required";
                        }
                        return null;
                      },
                      controller: shipping_name,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        icon: Icon(Icons.person, color: Colors.black),
                        border: InputBorder.none,
                        labelText: "Shipping Name",
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.green.withOpacity(.5),
                    ),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Shipping contact is required";
                        }
                        return null;
                      },
                      controller: shipping_mobile,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        icon: Icon(Icons.phone, color: Colors.black),
                        border: InputBorder.none,
                        labelText: "Shipping contact",
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.green.withOpacity(.5),
                    ),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Shipping Address is required";
                        }
                        return null;
                      },
                      controller: shipping_address,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        icon: Icon(Icons.location_on, color: Colors.black),
                        border: InputBorder.none,
                        labelText: "Shipping Address",
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.green.withOpacity(.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Payment Method",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Radio(
                              value: "Cash on Delivery",
                              groupValue: payment_method.text,
                              onChanged: (value) {
                                setState(() {
                                  payment_method.text = value.toString();
                                });
                              },
                            ),
                            Text("Cash on Delivery"),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: "Online Payment",
                              groupValue: payment_method.text,
                              onChanged: (value) {
                                setState(() {
                                  payment_method.text = value.toString();
                                });
                              },
                            ),
                            Text("Online Payment"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _submitShippingInfo,
                    child: Text("Submit"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
