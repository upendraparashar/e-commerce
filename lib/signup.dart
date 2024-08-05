import 'dart:convert';
import 'package:e_commerce_project/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http ;
import 'package:shared_preferences/shared_preferences.dart';

class signup extends StatefulWidget {
  const signup({Key? key});

  @override
  State<signup> createState() => _signupState();
}
class _signupState extends State<signup> {
  TextEditingController _username = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  TextEditingController _address = TextEditingController();
  bool? _isMale;
  var mydata = "";

  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', _username.text);
    prefs.setString('email', _email.text);
    prefs.setString('password', _password.text);
    prefs.setString('mobile', _mobile.text);
    prefs.setString('address', _address.text);
    // Save gender as 'male' or 'female'
    prefs.setString('gender', _isMale == true ? 'male' : 'female');
  }
  void _clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    prefs.remove('email');
    prefs.remove('isMale');
    prefs.remove('password');
    prefs.remove('mobile');
    prefs.remove('address');
  }
  final formkey1 = GlobalKey<FormState>();
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formkey1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListTile(
                          title: SizedBox(
                            height: 110,
                            child: Text(
                              "Register New Account",
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        //username
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
                                return "Username is required";
                              }
                              return null;
                            },
                            controller: _username,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              icon: Icon(Icons.person, color: Colors.black),
                              border: InputBorder.none,
                              labelText: "Username",
                            ),
                          ),
                        ),
                        //email
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
                                return "Email is required";
                              }
                              return null;
                            },
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              icon:
                                  Icon(Icons.email_outlined, color: Colors.black),
                              border: InputBorder.none,
                              labelText: "Email",
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(8),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.green.withOpacity(.5),
                          ),
                          child: Row(
                            children: [
                              Text("Gender: "),
                              Checkbox(
                                value: _isMale == true,
                                onChanged: (value) {
                                  setState(() {
                                    _isMale = value!;
                                  });
                                },
                              ),
                              Text("Male"),
                              Checkbox(
                                value: _isMale == false,
                                onChanged: (value) {
                                  setState(() {
                                    _isMale = !value!;
                                  });
                                },
                              ),
                              Text("Female"),
                            ],
                          ),
                        ),

                        //password
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
                                return "Password is required";
                              }
                              return null;
                            },
                            controller: _password,
                            obscureText: !isVisible,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              icon: Icon(Icons.lock, color: Colors.black),
                              border: InputBorder.none,
                              labelText: "Password",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isVisible = !isVisible;
                                  });
                                },
                                icon: Icon(isVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                            ),
                          ),
                        ),
                        //contact
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
                                return "Mobile Number is required";
                              }
                              return null;
                            },
                            controller: _mobile,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              icon: Icon(Icons.phone, color: Colors.black),
                              border: InputBorder.none,
                              labelText: "Contact",
                            ),
                          ),
                        ),
                        //address
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
                                return "Address is required";
                              }
                              return null;
                            },
                            controller: _address,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              icon: Icon(Icons.location_on, color: Colors.black),
                              border: InputBorder.none,
                              labelText: "Address",
                            ),
                          ),
                        ),
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
                              if (formkey1.currentState!.validate()) {
                                _fetchData(_username.text,_email.text,_isMale.toString(),_password.text,_mobile.text,_address.text) ;
                              }
                            },
                            child: Text(
                              "Sign in",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("I have an account?"),
                            TextButton(
                              onPressed: () {
                                
                              Navigator.pushReplacement(
                                context,
                                 MaterialPageRoute(
                                builder: (context) => Login()));
                              },
                              child: Text("Login"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
void _fetchData(
  String userName, String email, String isMale, String password,
  String mobile, String address,
) async {
  if (_isMale == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select gender'),
      ),
    );
    return; // Stop further execution if gender is not selected
  }

  var url = Uri.http('akashsir.in', 'myapi/atecom1/api/api-signup.php');
  var response = await http.post(url, body: {
    'user_name': userName,
    'user_email': email,
    'user_password': password,
    'user_gender': isMale,
    'user_mobile': mobile,
    'user_address': address,
  });

  if (response.statusCode == 200) {
    Map<String, dynamic> mymap = json.decode(response.body);
    if (mymap['flag'] == "1") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email already exists'),
        ),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to connect to the server'),
      ),
    );
  }
}
}