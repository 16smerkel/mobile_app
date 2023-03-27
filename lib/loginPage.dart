
import 'package:budgetit_app/registerPage.dart';
import 'package:flutter/material.dart';
import './auth_controller.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            width: w,
            height: h * 0.3,
            margin: EdgeInsets.only(top: 10.0),
            decoration: BoxDecoration(
              image:  DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  "img/main_logo.png" ,
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
              borderRadius: BorderRadius.all(Radius.circular(12))
            ),
            child: Column(
              children: [
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold
                  ),
                ),
                
                Divider(
                  color: Colors.black,
                ),
                
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical:10),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                      hintText: "Email",
                      suffixIcon: IconButton(
                        onPressed: () {
                          _emailController.clear();
                        } ,
                        icon: const Icon(Icons.clear),
                      )
                    ),
                  ),
                ),
                
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical:10),
                  child: TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                      hintText: "Password",
                      suffixIcon: IconButton(
                        onPressed: () {
                          _passwordController.clear();
                        } ,
                        icon: const Icon(Icons.clear),
                      )
                    ),
                  ),
                ),
                
                SizedBox(height: 10,),
                
                Row(
                  children: [
                    Expanded(child: Container(),),
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Text(
                        "Forgot your password?",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,           
                        ),
                      ),
                    )
                  ],
                ),
                
                SizedBox(height: 20,),
                
                GestureDetector(
                  onTap: () {
                    AuthController.instance.login(_emailController.text.trim(), _passwordController.text.trim());
                  },
                  child: Container(
                    width: w*0.45,
                    height: h*0.06,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.blue[300]
                    ),
                    child: Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                
                TextButton(onPressed: (){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
                  );
                }, 
                  child: Text("Register",
                  style: TextStyle(
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                      color: Colors.blue[300]
                    ),
                  ),
                ),
              ]
            ),
          ),
          
          Container(
            width: w,
            height: h * 0.25 ,
            
            decoration: BoxDecoration(
              image:  DecorationImage(
                scale: 1.6,
                image: AssetImage(
                  "img/penguins_logo.png" ,
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }
}