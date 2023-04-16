import 'package:budgetit_app/auth_controller.dart';
import 'package:budgetit_app/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Column(children: [
        Container(
          width: w,
          height: h * 0.3,
          margin: EdgeInsets.only(top: 10.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                "img/main_logo.png",
              ),
            ),
          ),
        ),
        Container(
          width: w,
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 35),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Form(
            key: formKey,
            child: Column(children: [
              Text(
                "Register",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              Divider(
                color: Colors.black,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                  controller: _emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? "Enter a valid email"
                          : null,
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                      hintText: "Email",
                      suffixIcon: IconButton(
                        onPressed: () {
                          _emailController.clear();
                        },
                        icon: const Icon(Icons.clear),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    RegExp regex = RegExp(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~()]).{8,}$');
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    } else if (value.length < 6) {
                      return "Enter a min. 6 characters";
                    } else if (!regex.hasMatch(value)) {
                      return 'Enter valid password';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                      hintText: "Password",
                      suffixIcon: IconButton(
                        onPressed: () {
                          _passwordController.clear();
                        },
                        icon: const Icon(Icons.clear),
                      )),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  final isValid = formKey.currentState!.validate();

                  if (!isValid) {
                    return;
                  } else {
                    AuthController.instance.register(
                        _emailController.text.trim(),
                        _passwordController.text.trim());
                  }
                },
                child: Container(
                  width: w * 0.45,
                  height: h * 0.06,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.blue[300]),
                  child: Center(
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                      color: Colors.blue[300]),
                ),
              )
            ]),
          ),
        ),
      ]),
    );
  }
}
