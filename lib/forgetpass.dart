import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

class forget extends StatefulWidget {
 const forget({Key? key}) : super(key: key);

  @override
  State<forget> createState() => _forgetState();
}

class _forgetState extends State<forget> {
   TextEditingController forget_email = TextEditingController();



    final formKey= GlobalKey<FormState>();
    void _login(String text) async {
    var url = Uri.http('akashsir.in', 'myapi/atecom1/api/api-user-forgot-password.php');
    var response = await http.post(url, body: {
      'user_email': forget_email.text,
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    Map<String, dynamic> mymap=json.decode(response.body);
   
    if (mymap['flag'] == "1") {
     forget_email.clear();
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Password "),
          content: Text("${mymap['message']}"),
        );
      }
    );
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
              key: formKey,
              child: Container(
                padding: EdgeInsets.only(bottom: 200),
              child:Column(children: [
                Image(image: AssetImage('assets/images/forget.jpg',
                ),width: 200,
                height: 200,
                ),
                 SizedBox(height: 30,),
                Text("Enter your email and we will send",
                  style: TextStyle(fontSize: 18),),
               Text("you a code to reset your password",
                    style: TextStyle(fontSize: 18),),
                SizedBox(
                   height: 40,),
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(horizontal: 9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.green.withOpacity(.5),
                    ),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty){
                         return "Email is required";
                      }
                      return null;
                      },
                      controller: forget_email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        icon: Icon(Icons.email_outlined, color: Colors.black),
                        border: InputBorder.none,
                        labelText: "Email",
                      ),
                    ),
                ),
                 Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width* .9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.green),
                    child: TextButton(
                      onPressed:(){
                        if (formKey.currentState!.validate()){
                         _login(forget_email.text);
                      }
                      },
                      child: Text("Submit",
                      style: TextStyle(color: Colors.white),),
                    ) ,
                  ),
              ],
                ),), ),
            ),
      ),),
    );
  }
  
}