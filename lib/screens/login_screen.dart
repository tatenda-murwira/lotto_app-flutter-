

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottery/main.dart';
import 'package:lottery/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(LotteryApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lotto System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
        ),
      ),
      home: LoginPage(),
    );
  }
}
final FirebaseAuth auth = FirebaseAuth.instance;


Future<void> signUpWithEmailAndPassword(String email, String password) async {
  try {
   
    final UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
   
  } on FirebaseAuthException {
   
  }
}



Future<void> signInWithEmailAndPassword(String email, String password) async {
  try {
    
    final UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
     
  } on FirebaseAuthException {
   
  }
}


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  
  Color navyBlue = Color(0xFF1A237E); 
  Color lightBlue = Color(0xFF82B1FF);
  Color peach = Color(0xFFFFCC80);

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
    try {
      
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );
     
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login Successful')));
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login Failed: $e')));
    }
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: navyBlue,
        title: Text('', style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
      
          Positioned.fill(
            child: Image.asset(
              'assets/background.jpg', 
              fit: BoxFit.cover,
            ),
          ),
         
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ZimLotto',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: lightBlue,
                      ),
                    ),
                    SizedBox(height: 40),
                    
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      decoration: BoxDecoration(
                        
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.email, color: navyBlue),
                          labelText: 'Email',
                          border: OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: 'Enter your email',
                          labelStyle: TextStyle(color: navyBlue),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      decoration: BoxDecoration(
                       
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock, color: navyBlue),
                          labelText: 'Password',
                          border: OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: 'Enter your password',
                          labelStyle: TextStyle(color: navyBlue),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lightBlue, 
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(color: navyBlue, fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 20),
                 
                    TextButton(
                      onPressed: () {
                   
                      },
                      child: Text(
                        'Dont have an account? Register',
                        style: TextStyle(color: Colors.lightBlueAccent),
                        
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
