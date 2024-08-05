import 'dart:io';
import 'package:e_commerce_project/Add_feedback.dart';
import 'package:e_commerce_project/Allproduct.dart';
import 'package:e_commerce_project/Resetpass.dart';
import 'package:e_commerce_project/allsubcategory.dart';
import 'package:e_commerce_project/cardlist.dart';
import 'package:e_commerce_project/category.dart';
import 'package:e_commerce_project/login.dart';
import 'package:e_commerce_project/orderlistpage.dart';
import 'package:e_commerce_project/profile.dart';
import 'package:e_commerce_project/view_feedback.dart';
import 'package:e_commerce_project/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
 
  const WelcomePage({Key? key, }) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  var mydatalist = [];
   File? selectedImage;
  bool isLoading = false;
  var myText = "";
 


 @override
  void initState() {
    super.initState();
    _fetchuserdata();
    fetchSliderImages();
  }

    
    
  void _fetchuserdata() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('name');
  setState(() {
     myText = username! ;
  });

  }
    
   
  Future<void> fetchSliderImages() async {
    try {
      var url = Uri.http('akashsir.in', 'myapi/atecom1/api/api-list-slider.php');
      var response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      Map<String, dynamic> mymap = json.decode(response.body);
      mydatalist = mymap['banner_list'];
      setState(() {
        mydatalist;
      });
    } catch (error) {
      print("Error in API Calling");
    }
  }
void showSnackbar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: FutureBuilder<String?>(
        future: getUsername(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text('Username: ${snapshot.data}');
          } else if (snapshot.hasError) {
            return Text('Error retrieving username');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      duration: Duration(seconds: 2),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $myText'),
        centerTitle: true,
        
      ),
       
      
      drawer: Drawer(
  child: Container(
    color: Colors.white,
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.green,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => pickImage(ImageSource.gallery),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: selectedImage != null ? FileImage(selectedImage!) : null,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Hi, $myText ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20), // Add space between the header and the first ListTile
        ListTile(
          leading: Icon(Icons.person),
          title: Text('User Profile'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileEdit()));
          },
        ),
        ListTile(
          leading: Icon(Icons.category),
          title: Text('Category'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => category()));
          },
        ),
        ListTile(
          leading: Icon(Icons.shopping_cart),
          title: Text('Product'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Allproduct()));
          },
        ),
        Divider(color: Colors.green), // Add a white divider
        ListTile(
          leading: Icon(Icons.category),
          title: Text('Sub-category'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AllSubcategory()));
          },
        ),
        ListTile(
          leading: Icon(Icons.favorite),
          title: Text('Wishlist'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => WishlistPage()));
          },
        ),
        Divider(color: Colors.green), // Add a white divider
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
          },
        ),
        ListTile(
          leading: Icon(Icons.lock),
          title: Text('Change password'),
          onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Resetpass()));
          },
        ),
        Divider(color: Colors.green), // Add a white divider
        ListTile(
          leading: Icon(Icons.list),
          title: Text('Order List'),
          onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OrderListPage()));
          },
        ),
        ListTile(
          leading: Icon(Icons.shopping_cart),
          title: Text('Cart List'),
          onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CartListPage()));
          },
        ),
        Divider(color: Colors.green), // Add a white divider
        ListTile(
          leading: Icon(Icons.feedback),
          title: Text('Give feedback'),
          onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddFeedback()));
          },
        ),
        ListTile(
          leading: Icon(Icons.feedback),
          title: Text('View feedback'),
          onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => viewfeedback()));
          },
        ),
      ],
    ),
  ),
),

      body: mydatalist.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : CarouselSlider.builder(
              itemCount: mydatalist.length,
              itemBuilder: (BuildContext context, int index, _) {
                return Image.network(
                  mydatalist[index]['banner_image'],
                  fit: BoxFit.cover,
                );
              },
              options: CarouselOptions(
                height: 200,
                viewportFraction: 1.0,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 5),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                pauseAutoPlayOnTouch: true,
                enlargeCenterPage: false,
                onPageChanged: (index, reason) {
                  // Your logic here
                },
              ),
            ),
    );
  }
  
   void pickImage(ImageSource _source) async {
    final fetchedimage = await ImagePicker().pickImage(source: _source);
    if (fetchedimage != null) {
      setState(() {
        selectedImage =
 File(fetchedimage.path);
      });
    }
  }
  Future<String?> getUsername() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('username');
}
}
