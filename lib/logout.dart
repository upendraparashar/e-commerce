import 'package:e_commerce_project/login.dart';
import 'package:flutter/material.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Image(
                  image: AssetImage('assets/images/myimage.jpg'),
                  width: 250,
                  height: 250,
                ),
                SizedBox(height: 30),
                Text(
                  "Are you sure you want to logout?",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.green,
                  ),
                  child: TextButton(
                    onPressed: () {
                      // Perform logout action here
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>Login())); // Go back to previous screen
                    },
                    child: Text(
                      "Logout",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
