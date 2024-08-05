import 'dart:async';
import 'dart:convert';
import 'package:e_commerce_project/welcome.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class OTPScreen extends StatefulWidget {
  OTPScreen();
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController mobile_No = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  int _countdown = 20;
  var mydatalist = ['mobile_otp'];
  Timer? _timer;
  final formKey = GlobalKey<FormState>();

  void _startTimer() {
    if (_timer == null) {
      _countdown = 20;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_countdown > 0) {
            _countdown--;
          } else {
            _timer!.cancel();
            _timer = null;
          }
        });
      });
    }
  }

void _sendCode() async {
  var url = Uri.parse('https://akashsir.in/myapi/atecom1/api/api-otp-login.php');
  try {
    if (mobile_No.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid 10-digit mobile number.'),
        ),
      );
      return;
    }

    var response = await http.post(url, body: {
      'user_mobile': mobile_No.text,
    });

    if (response.statusCode == 200) {
      var mymap = json.decode(response.body);
      if (mymap['flag'] == '1') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP sent successfully! OTP: ${mymap['mobile_otp']}'),
          ),
        );
        _startTimer();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send OTP. Please try again.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send OTP. Please try again.'),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to send OTP. Please try again.'),
      ),
    );
  }
}


  void _resendCode() async {
    var url = Uri.parse('https://akashsir.in/myapi/atecom1/api/api-otp-resend.php');
    try {
      var response = await http.post(url, body: {
        'user_mobile': mobile_No.text,
      });

      if (response.statusCode == 200) {
        var mymap = json.decode(response.body);
        if (mymap['flag'] == '1') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('OTP resend successfully! OTP: ${mymap['mobile_otp']}'),
            ),
          );
          _startTimer();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to send OTP. Please try again.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send OTP. Please try again.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send OTP. Please try again.'),
        ),
      );
    }
  }
void _verifyotp() async {
  var url = Uri.parse('https://akashsir.in/myapi/atecom1/api/api-otp-verify.php');
  try {
    var response = await http.post(url, body: {
      'user_mobile': mobile_No.text,
      'mobile_otp': _otpController.text,
    });

    if (response.statusCode == 200) {
      var mymap = json.decode(response.body);
      if (mymap['flag'] == '1') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login successful!'),
          ),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomePage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP did not match. Please try again.'),
          ),
        );
      }
    } else {
      // Handle other response status codes if needed
    }
  } catch (e) {
    // Handle network or other errors if needed
  }
}




  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton()),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Form(
              key: formKey,
              child: Container(
                padding: EdgeInsets.only(bottom: 200),
                child: Column(children: [
                  Image(
                    image: AssetImage('assets/images/forget.jpg'),
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(height: 30),
                  Text("Enter security code that we sent to",
                      style: TextStyle(fontSize: 18)),
                  Text.rich(
                    TextSpan(
                      text: 'Your mobile number ',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: '',
                          style: TextStyle(fontSize: 15, color: Colors.blue),
                        ),
                      ],
                    ),
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 25),
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(horizontal: 9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.green.withOpacity(.5),
                    ),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please fill this field with your security code";
                        } else {}
                        return null;
                      },
                      controller: _otpController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock, color: Colors.black),
                        border: InputBorder.none,
                        labelText: "Enter Code",
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(horizontal: 9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.green.withOpacity(.5),
                    ),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please fill this field with your mobile number";
                        } else {}
                        return null;
                      },
                      controller: mobile_No,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        icon: Icon(Icons.phone, color: Colors.black),
                        border: InputBorder.none,
                        labelText: "Mobile Number",
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: _countdown > 0 ? null : _resendCode,
                        child: Text(
                          _countdown > 0
                              ? 'Resend code ($_countdown s)'
                              : 'Resend OTP',
                          style: TextStyle(
                              color:
                                  _countdown > 0 ? Colors.grey : Colors.red),
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * .3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.green
),
                        child: TextButton(
                          onPressed: () {
                            _sendCode();
                          },
                          child: Text(
                            "Send code",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
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
                          _verifyotp();
                        }
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
