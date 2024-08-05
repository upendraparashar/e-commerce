import 'dart:convert';
import 'package:e_commerce_project/welcome.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  TextEditingController _userId = TextEditingController();
  TextEditingController _username = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  TextEditingController _address = TextEditingController();
  bool? _isMale;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }
void _fetchData() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userid') ?? '';
    print('User ID: $userId'); // Print the user ID
    var url = Uri.parse(
      'https://akashsir.in/myapi/atecom1/api/api-user-profile.php?user_id=$userId');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> mymap = json.decode(response.body);
      setState(() {
        _userId.text = mymap['user_id'];
        _email.text = mymap['user_email'];
        _mobile.text = mymap['user_mobile'];
        _address.text = mymap['user_address'];
        _username.text = mymap['user_name'];
        _isMale = mymap['user_gender']== 'male';
      });
      _userId.text = mymap['userID'];
      _email.text = mymap['user_email'];
        _mobile.text = mymap['user_mobile'];
        _address.text = mymap['user_address'];
        _username.text = mymap['user_name'];
        _isMale = mymap['user_gender'];
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error in API Calling: $error');
  }
}
void _updateData() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userid') ?? '';
    print('User ID: $userId');

    var url = Uri.parse(
        'https://akashsir.in/myapi/atecom1/api/api-user-update.php');
    var response = await http.post(url, body: {
      'user_id': userId,
      'user_name': _username.text,
      'user_email': _email.text,
      'user_gender': 'male'.toString(),
      'user_mobile': _mobile.text,
      'user_address': _address.text,
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // Update successful, navigate back to the profile page
      Navigator.push(context,
      MaterialPageRoute(builder: (Context) =>WelcomePage()));
    } else {
      print('Failed to update data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

  /*  if (response.statusCode == 200) {
   var mymap = json.decode(response.body);
     
    
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error in API Calling: $error');
  }
}*/

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("User Profile"),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.green[200],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _userId,
                      decoration: InputDecoration(labelText: "User ID"),
                      enabled: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your user ID';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      controller: _username,
                      decoration: InputDecoration(labelText: "Username"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      controller: _email,
                      decoration: InputDecoration(labelText: "Email"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Text("Gender: "),
                        Checkbox(
                          value: _isMale == true,
                          onChanged: (value) {
                            setState(() {
                              _isMale = value;
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
                    SizedBox(height: 10.0),
                    TextFormField(
                      controller: _mobile,
                      decoration: InputDecoration(labelText: "Mobile"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your mobile number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      controller: _address,
                      decoration: InputDecoration(labelText: "Address"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
           
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  _updateData();
                  _saveData();
                }
              },
              child: Text("Save"),
            ),
          ],
        ),),
    ));
  }

  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userid', _userId.text);

  }
}