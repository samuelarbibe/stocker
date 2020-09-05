import 'dart:async';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stocker/services/firebase/auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:stocker/utilities/colors.dart';
import 'package:stocker/widgets/stocker_logo.dart';

class Login extends StatefulWidget {
  Login({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();

  AnimationController controller;
  bool keyboardOpen;

  bool passwordObscured;
  bool isRegister;

  String email;
  String fullName;
  String password;

  @override
  void initState() {
    super.initState();

    keyboardOpen = false;
    passwordObscured = true;
    isRegister = false;

    KeyboardVisibility.onChange.listen((bool visible) {
      setState(() {
        keyboardOpen = visible;
      });
    });

    controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    controller.forward();
  }

  @override
  void dispose() {
    passwordController.dispose();
    controller.dispose();
    super.dispose();
  }

  void showPassword() async {
    setState(() {
      passwordObscured = passwordObscured;
    });
  }

  bool vaildateAndSave() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      return true;
    }
    return false;
  }

  Future login() async {
    if (vaildateAndSave()) {
      await Future.delayed(Duration(seconds: 2));

      try {
        String uid = await widget.auth.signIn(email, password);
        if (uid != null) {
          print('Firebase user $uid has successfully logged in');
          widget.loginCallback();
        }
      } catch (e) {
        print('login has failed');
      }
    }
  }

  Future register() async {
    if (vaildateAndSave()) {
      await Future.delayed(Duration(seconds: 2));
      String uid = "";
      try {
        uid = await widget.auth.signUp(
            email, password, fullName.split(' ')[0], fullName.split(' ')[1]);
        print('user $uid has successfully signed up');
        login();
      } catch (e) {
        print('sign up has failed');
      }
    }
  }

  Future delay(int timeInMilliseconds) async {
    Future.delayed(Duration(milliseconds: timeInMilliseconds), () => "1");
  }

  void createAccount() {
    setState(() {
      isRegister = true;
    });
  }

  void backToLogin() {
    setState(() {
      isRegister = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: buildForm(),
        ),
      ),
    );
  }

  Widget buildForm() {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildHeader(),
          Expanded(
            flex: isRegister ? 5 : 3,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  isRegister ? buildFullNameInput() : Container(),
                  buildEmailInput(),
                  buildPasswordInput(),
                  isRegister ? buildConfirmPasswordInput() : Container(),
                  buildLoginButton(),
                  buildCreateAccountButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFullNameInput() {
    return Container(
      child: TextFormField(
        style: TextStyle(fontSize: 20.0),
        validator: (value) => (value.isEmpty) ? "Please enter a name" : null,
        onSaved: (val) => fullName = val.trim(),
        decoration: InputDecoration(
          labelText: "FULL NAME",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: TextStyle(
            fontSize: 16,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  Widget buildConfirmPasswordInput() {
    return Container(
      child: TextFormField(
        style: TextStyle(fontSize: 20.0),
        obscureText: passwordObscured,
        validator: (value) {
          if (value == null && value.length == 0) {
            return 'Empty';
          } else if (value != passwordController.text) {
            return 'Passwords must match';
          }
          print("Valid");
          return null;
        },
        decoration: InputDecoration(
            labelText: "CONFIRM PASSWORD",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelStyle: TextStyle(fontSize: 16, letterSpacing: 2)),
      ),
    );
  }

  Widget buildLoginButton() {
    return ArgonButton(
      width: 350,
      height: 56,
      minWidth: 100,
      color: AppleColors.gray6,
      roundLoadingShape: false,
      borderRadius: 4,
      child: Text(
        isRegister ? "Register" : "Login",
        style: TextStyle(
          color: AppleColors.white1,
          fontSize: 24,
        ),
      ),
      loader: Container(
        padding: EdgeInsets.all(10),
        child: SpinKitThreeBounce(
          color: Colors.white70,
          size: 25.0,
        ),
      ),
      onTap: (startLoading, stopLoading, btnState) async {
        if (btnState == ButtonState.Idle) {
          startLoading();
          isRegister ? await register() : await login();
          stopLoading();
        }
      },
    );
  }

  Widget buildCreateAccountButton() {
    return Container(
      child: FlatButton(
        onPressed: isRegister ? backToLogin : createAccount,
        child: Text(
          isRegister ? "I Already Have an Account" : "Create Account",
          style: TextStyle(
              fontSize: 15.0, color: Color.fromARGB(255, 130, 130, 130)),
        ),
      ),
    );
  }

  Widget buildPasswordInput() {
    return Container(
      child: TextFormField(
        controller: passwordController,
        style: TextStyle(fontSize: 20.0),
        obscureText: passwordObscured,
        validator: (value) =>
            (value.isEmpty) ? "Please enter a password" : null,
        onSaved: (value) => password = value.trim(),
        decoration: InputDecoration(
            suffixIcon: IconButton(
                onPressed: showPassword,
                icon: (passwordObscured)
                    ? Icon(Icons.visibility)
                    : Icon(Icons.visibility_off)),
            labelText: "PASSWORD",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelStyle: TextStyle(fontSize: 16, letterSpacing: 2)),
      ),
    );
  }

  Widget buildEmailInput() {
    return Container(
      child: TextFormField(
        style: TextStyle(fontSize: 20.0),
        validator: (val) {
          if (val.length == 0) {
            return "Email empty";
          } else if (!EmailValidator.validate(val.trim(), true)) {
            return "Email not valid";
          }
          return null;
        },
        onSaved: (val) => email = val.trim(),
        decoration: InputDecoration(
          labelText: "EMAIL",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: TextStyle(
            fontSize: 16,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      child: !keyboardOpen
          ? Expanded(
              flex: 1,
              child: OpacityAnimatedWidget.tween(
                opacityEnabled: 1.0,
                opacityDisabled: 0.0,
                enabled: !keyboardOpen,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  textDirection: TextDirection.rtl,
                  children: <Widget>[
                    StockerLogo(),
                    SizedBox(
                      height: 5.0,
                    ),
                    isRegister ? buildRegisterHeader() : buildWelcomeHeader(),
                  ],
                ),
              ),
            )
          : isRegister ? StockerLogo() : Container(),
    );
  }

  Widget buildWelcomeHeader() {
    return Text("Welcome Back",
        style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.0,
            color: AppleColors.gray1));
  }

  Widget buildRegisterHeader() {
    return Text("Create Account",
        style: TextStyle(color: AppleColors.gray2, fontSize: 25.0));
  }
}
