import 'package:dailydays/consts/firebase_consts.dart';
import 'package:dailydays/screens/auth/login_screen.dart';
import 'package:dailydays/screens/home_screen.dart';
import 'package:dailydays/services/global_methods.dart';
import 'package:dailydays/services/utils.dart';
import 'package:dailydays/widgets/auth_button.dart';
import 'package:dailydays/widgets/loading_manager.dart';
import 'package:dailydays/widgets/text_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/RegisterScreen';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _addressTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  bool _obscureText = true;
  @override
  void dispose() {
    _fullNameController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _addressTextController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  void _submitFormOnRegister() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });
    if (isValid) {
      _formKey.currentState!.save();

      try {
        await authInstance.createUserWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passTextController.text.trim());
        print('Succefully registered');
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
            errorMessage: '${error.message}', context: context);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        GlobalMethods.errorDialog(errorMessage: '$error', context: context);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: LoadingManager(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const SizedBox(
                height: 60.0,
              ),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () =>
                    Navigator.canPop(context) ? Navigator.pop(context) : null,
                child: Icon(
                  IconlyLight.arrowLeft2,
                  color: theme == true ? Colors.white : Colors.black,
                  size: 24,
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              TextWidget(
                text: 'Welcome',
                color: Colors.white,
                textSize: 30,
                isTitle: true,
              ),
              const SizedBox(
                height: 8,
              ),
              TextWidget(
                text: "Sign up to continue",
                color: Colors.white,
                textSize: 18,
                isTitle: false,
              ),
              const SizedBox(
                height: 30.0,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () =>
                          FocusScope.of(context).requestFocus(_emailFocusNode),
                      keyboardType: TextInputType.name,
                      controller: _fullNameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "This Field is missing";
                        } else {
                          return null;
                        }
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Full name',
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
                      height: 20,
                    ),
                    TextFormField(
                      focusNode: _emailFocusNode,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () =>
                          FocusScope.of(context).requestFocus(_passFocusNode),
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailTextController,
                      validator: (value) {
                        if (value!.isEmpty || !value.contains("@")) {
                          return "Please enter a valid Email adress";
                        } else {
                          return null;
                        }
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Email',
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
                      height: 20,
                    ),
                    //Password
                    TextFormField(
                      focusNode: _passFocusNode,
                      obscureText: _obscureText,
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passTextController,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 7) {
                          return "Please enter a valid password";
                        } else {
                          return null;
                        }
                      },
                      style: const TextStyle(color: Colors.white),
                      onEditingComplete: () => FocusScope.of(context)
                          .requestFocus(_addressFocusNode),
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          child: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                        ),
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Colors.white),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    TextFormField(
                      focusNode: _addressFocusNode,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: _submitFormOnRegister,
                      controller: _addressTextController,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 2) {
                          return "Please enter a valid country name";
                        } else {
                          return null;
                        }
                      },
                      style: const TextStyle(color: Colors.white),
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      decoration: const InputDecoration(
                        hintText: 'Country',
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
                  ],
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              AuthButton(
                buttonText: 'Sign up',
                fct: () {
                  _submitFormOnRegister();
                  Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(
                    text: 'Already a user?',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' Sign in',
                          style: const TextStyle(
                              color: Colors.lightBlue, fontSize: 18),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacementNamed(
                                  context, LoginScreen.routeName);
                            }),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
