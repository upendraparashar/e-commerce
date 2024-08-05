import 'dart:convert';
import 'package:e_commerce_project/code.dart';
import 'package:e_commerce_project/welcome.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'forgetpass.dart';
import 'signup.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool _isVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _login(String text, String text2) async {
    var url = Uri.http('akashsir.in', 'myapi/atecom1/api/api-login.php');
    var response = await http.post(url, body: {
      'user_email': _email.text,
      'user_password': _password.text,
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    Map<String, dynamic> mymap = json.decode(response.body);

    if (mymap['flag'] == "1") {
      var username = mymap['user_name'];
      var id = mymap['user_id'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('name', username);
      prefs.setString('userid', id);

      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WelcomePage()),
    );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login successful!'),
        ),
      );
      _email.clear();
      _password.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid email or password'),
        ),
      );
    }
  }

 

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
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
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
                          return "Email is required";
                        }
                        return null;
                      },
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        icon: Icon(Icons.mail, color: Colors.black),
                        border: InputBorder.none,
                        labelText: "Email",
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
                          return "Password is required";
                        }
                        return null;
                      },
                      controller: _password,
                      obscureText: !_isVisible,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock, color: Colors.black),
                        border: InputBorder.none,
                        labelText: "Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isVisible = !_isVisible;
                            });
                          },
                          icon: Icon(_isVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
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
                        if (_formKey.currentState!.validate()) {
                          _login(_email.text, _password.text);
                        }
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue,
                    ),
                    child: TextButton(
                      onPressed:(){
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>OTPScreen()));
                      },
                      child: Text(
                        "Login with OTP",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => signup()));
                          },
                          child: Text("Sign up here..")),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => forget()));
                          },
                          child: Text(
                            "Forget Password?",
                            style: TextStyle(color: Colors.red),
                          )),
                    ],
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
