import 'package:dailydays/services/utils.dart';
import 'package:dailydays/widgets/auth_button.dart';
import 'package:dailydays/widgets/back_widget.dart';
import 'package:dailydays/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const routeName = '/ForgetPasswordScreen';
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _emailTextController = TextEditingController();
  // bool _isLoading = false;
  @override
  void dispose() {
    _emailTextController.dispose();

    super.dispose();
  }

  void _forgetPassFCT() async {}

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      // backgroundColor: Colors.blue,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.1,
            ),
            const BackWidget(),
            const SizedBox(
              height: 20,
            ),
            TextWidget(
              text: 'Forget password',
              color: Colors.white,
              textSize: 30,
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: _emailTextController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Email address',
                hintStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            AuthButton(
              buttonText: 'Reset now',
              fct: () {
                _forgetPassFCT();
              },
            ),
          ],
        ),
      ),
    );
  }
}
