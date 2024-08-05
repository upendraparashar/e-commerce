import 'package:e_commerce_project/welcome.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddFeedback extends StatefulWidget {
  const AddFeedback({Key? key}) : super(key: key);

  @override
  State<AddFeedback> createState() => _AddFeedbackState();
}

class _AddFeedbackState extends State<AddFeedback> {
  TextEditingController feedbackDetails = TextEditingController();
  int? selectedRating;

  final _formKey = GlobalKey<FormState>();

  void addFeedback() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('userid') ?? '';

      var url = Uri.parse('https://akashsir.in/myapi/atecom1/api/api-add-feedback.php');
      var response = await http.post(
        url,
        body: {
          'user_id': userId,
          'feedback_rate': selectedRating.toString(),
          'feedback_details': feedbackDetails.text,
        },
      );

      if (response.statusCode == 200) {
        print('Feedback added successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Feedback added successfully')),
        );

        // Redirect to the category screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomePage()),
        );
      } else {
        print('Failed to add feedback: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add feedback')),
        );
      }
    } catch (e) {
      print('Error adding feedback: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding feedback')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0.0,
        leading: BackButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomePage()));
          },
        ),
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
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Feedback Rate:'),
      SizedBox(height: 5),
      // Radio buttons for rating stars
      Row(
        children: [
          for (int i = 1; i <= 5; i++)
            Row(
              children: [
                Radio<int>(
                  value: i,
                  groupValue: selectedRating,
                  onChanged: (value) {
                    setState(() {
                      selectedRating = value!;
                    });
                  },
                ),
                Text('$i'),
              ],
            ),
        ],
      ),
    ],
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
                          return "Text Filled is required";
                        }
                        return null;
                      },
                      controller: feedbackDetails,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        icon: Icon(Icons.feedback, color: Colors.black),
                        border: InputBorder.none,
                        labelText: "Feedback Details",
                      ),
                    ),
                  ),
                  // Submit Button
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        addFeedback();
                      }
                    },
                    child: Text('Submit'),
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
