import 'dart:convert';

import 'package:e_commerce_project/welcome.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class viewfeedback extends StatefulWidget {
  const viewfeedback({Key? key}) : super(key: key);

  @override
  State<viewfeedback> createState() => _viewfeedbackState();
}

class _viewfeedbackState extends State<viewfeedback> {
  var feedbackList = [];
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchFeedback();
  }

  Future<void> fetchFeedback() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('userid') ?? '';

      var url = Uri.parse('https://akashsir.in/myapi/atecom1/api/api-list-feedback.php');
      var response = await http.post(
        url,
        body: {
          'user_id': userId,
        },
      );

      if (response.statusCode == 200) {
        var feedbackData = json.decode(response.body);
        setState(() {
          feedbackList = feedbackData['feedback_list'];
          isLoading = false;
        });
      } else {
        print('Failed to fetch feedback: ${response.body}');
        isLoading = false;
      }
    } catch (e) {
      print('Error fetching feedback: $e');
      isLoading = false;
    }
  }

  Future<void> deleteFeedback(String feedbackId) async {
    try {
      var url = Uri.parse('https://akashsir.in/myapi/atecom1/api/api-delete-feedback.php');
      var response = await http.post(
        url,
        body: {
          'feedback_id': feedbackId,
        },
      );

      if (response.statusCode == 200) {
        // Feedback deleted successfully
        print('Feedback deleted successfully');
        // Refresh the feedback list
        fetchFeedback();
      } else {
        print('Failed to delete feedback: ${response.body}');
      }
    } catch (e) {
      print('Error deleting feedback: $e');
    }
  }

  Future<void> updateFeedback(String feedbackId, String feedbackRate, String feedbackDetails) async {
    try {
      var url = Uri.parse('https://akashsir.in/myapi/atecom1/api/api-update-feedback.php');
      var response = await http.post(
        url,
        body: {
          'feedback_id': feedbackId,
          'feedback_rate': feedbackRate,
          'feedback_details': feedbackDetails,
        },
      );

      if (response.statusCode == 200) {
        // Feedback updated successfully
        print('Feedback updated successfully');
        // Refresh the feedback list
        fetchFeedback();
      } else {
        print('Failed to update feedback: ${response.body}');
      }
    } catch (e) {
      print('Error updating feedback: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0.0,
        leading: BackButton(
          onPressed: (){
            Navigator.push(context,
            MaterialPageRoute(builder: (context)=>WelcomePage()));
          },
        ),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : SingleChildScrollView(
          child: Column(
            children: feedbackList.map<Widget>((feedback) {
              return Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.green.withOpacity(.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User ID: ${feedback['user_id']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text('User Name: ${feedback['user_name']}'),
                    SizedBox(height: 5),
                    Text('Feedback ID: ${feedback['feedback_id']}'),
                    SizedBox(height: 5),
                    Text('Feedback Date: ${feedback['feedback_date']}'),
                    SizedBox(height: 5),
                    Text('Feedback Date Time: ${feedback['feedback_date_time']}'),
                    SizedBox(height: 5),
                    Text('Feedback Rate: ${feedback['feedback_rate']}'),
                    SizedBox(height: 5),
                    Text('Feedback Details: ${feedback['feedback_details']}'),
                    SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () {
                        // Call deleteFeedback method with feedback_id parameter
                        deleteFeedback(feedback['feedback_id']);
                      },
                      child: Text('Delete Feedback'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Call updateFeedback method with feedback_id, feedback_rate, and feedback_details parameters
                        updateFeedback(feedback['feedback_id'], 'new_rate_value', 'new_details_value');
                      },
                      child: Text('Update Feedback'),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
