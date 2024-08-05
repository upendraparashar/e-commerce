import 'dart:convert';
import 'package:e_commerce_project/category.dart';
import 'package:e_commerce_project/welcome.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class Resetpass extends StatefulWidget {
  const Resetpass({Key? key}) : super(key: key);

  @override
  State<Resetpass> createState() => _ResetpassState();
}

class _ResetpassState extends State<Resetpass> {
  TextEditingController user_id = TextEditingController();
  TextEditingController opass = TextEditingController();
  TextEditingController npass = TextEditingController();
  TextEditingController cpass = TextEditingController();
  bool isVisible1 = false;
  bool isVisible2 = false;
  bool isVisible3 = false;


  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userid', user_id.text);
    prefs.setString('opass', opass.text);
    prefs.setString('npass', npass.text);
    prefs.setString('cpass', cpass.text);
  }

  final formKey = GlobalKey<FormState>();

  void _change() async {
      if (opass.text == npass.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Old password and new password cannot be the same'),
      ),
    );
    return;
  }
    var url = Uri.http('akashsir.in', 'myapi/atecom1/api/api-change-password.php');
    var response = await http.post(url, body: {
      'user_id': user_id.text,
      'opass': opass.text,
      'npass': npass.text,
      'cpass': cpass.text,
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    Map<String, dynamic> mymap = json.decode(response.body);

    if (mymap['flag'] == "1") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password changed successful!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password does not match'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => category()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
         backgroundColor: Colors.green,
          elevation: 0.0,
          leading: BackButton(
            onPressed: () {
              Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => WelcomePage()));
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Image(
                      image: AssetImage('assets/images/myimage.jpg'),
                      width: 250,
                      height: 250,
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
                            return "User ID is required";
                          }
                          return null;
                        },
                        controller: user_id,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          icon: Icon(Icons.person, color: Colors.black),
                          border: InputBorder.none,
                          labelText: "User ID",
                        ),
                      ),
                    ),
                    // Old Password
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
                            return "Old Password is required";
                          }
                          return null;
                        },
                        controller: opass,
                        obscureText: !isVisible1,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock, color: Colors.black),
                          border: InputBorder.none,
                          labelText: "Old Password",
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisible1 = !isVisible1;
                              });
                            },
                            icon: Icon(
                                isVisible1 ? Icons.visibility : Icons.visibility_off),
                          ),
                        ),
                      ),
                    ),
                    // New Password
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
                            return "New Password is required";
                          }
                          return null;
                        },
                        controller: npass,
                        obscureText: !isVisible2,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock, color: Colors.black),
                          border: InputBorder.none,
                          labelText: "New Password",
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisible2 = !isVisible2;
                              });
                            },
                            icon: Icon(
                                isVisible2 ? Icons.visibility : Icons.visibility_off),
                          ),
                        ),
                      ),
                    ),
                    // Confirm Password
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
                            return "Confirm Password is required";
                          } else if (value != npass.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                        controller: cpass,
                        obscureText: !isVisible3,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock, color: Colors.black),
                          border: InputBorder.none,
                          labelText: "Confirm Password",
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisible3 = !isVisible3;
                              });
                            },
                            icon: Icon(
                                isVisible3 ? Icons.visibility : Icons.visibility_off),
                          ),
                        ),
                      ),
                    ),
                    // Submit Button
                    SizedBox(height: 10),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * .9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.green,
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            _change();
                          }
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}