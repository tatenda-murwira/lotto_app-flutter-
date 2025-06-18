import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lotto System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
 
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer _timer;
  Duration _timeLeft = Duration(hours: 12, minutes: 59, seconds: 59);

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft.inSeconds > 0) {
          _timeLeft = _timeLeft - Duration(seconds: 1);
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    return '${duration.inHours.toString().padLeft(2, '0')}:'
        '${(duration.inMinutes % 60).toString().padLeft(2, '0')}:'
        '${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  int getCurrentDrawDate() {
    return DateTime.now().day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
      
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpeg'), 
                fit: BoxFit.cover,
              ),
            ),
          ),
         
          Container(
            
            color: Colors.black.withOpacity(0.6), 
          ),
          
          Column(
            children: [
              SizedBox(height: 80),
              Center(
                child: Text(
                  "Welcome! LETS START BETTING !",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Next Draw Countdown:",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(height: 10),
          
              Text(
                formatDuration(_timeLeft),
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.yellowAccent),
              ),
              SizedBox(height: 20),
       
              Expanded(
                child: GridView(
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  children: [
                    DashboardCard(
                      title: "Buy Ticket",
                      icon: Icons.payment,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentPage())),
                    ),
                    DashboardCard(
                      title: "View Results",
                      icon: Icons.history,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DailyDrawsPage())),
                    ),
                    DashboardCard(
                      title: "My Profile",
                      icon: Icons.person,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage())),
                    ),
                    DashboardCard(
                      title: "Transactions",
                      icon: Icons.payment,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TransactionsPage())),
                    ),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Last Draw Results (18 Feb):",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.yellowAccent,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "${(index + 5) * 3}",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
             
              BottomNavigationBar(
                backgroundColor: Colors.blue.shade900,
                selectedItemColor: Colors.yellowAccent,
                unselectedItemColor: Colors.white,
                currentIndex: 0, 
                onTap: (index) {
                  if (index == 1) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsPage(isDarkMode: null,)));
                  } else if (index == 2)
                   {
                   
                    _confirmLogout(context); 
                  }
                },
                items: [
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                  BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
                  BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Logout"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
 
   void _confirmLogout(BuildContext context) {
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
                Navigator.pop(context); 
              },
              child: Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}






class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const DashboardCard({super.key, required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      
      color: Colors.white.withOpacity(0.8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.blue.shade900),
              SizedBox(height: 10),
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}


class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  
  String _selectedPaymentMethod = "EcoCash"; 

  final _formKey = GlobalKey<FormState>();

 
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  void _processPayment() {
    if (_formKey.currentState!.validate()) {
      
      String message = _selectedPaymentMethod == "EcoCash"
          ? "Processing EcoCash Payment for ${_phoneController.text}"
          : "Processing Card Payment for ${_accountNameController.text}";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

      
      Navigator.push(context, MaterialPageRoute(builder: (_) => NumberSelectionPage(
        paymentMethod: _selectedPaymentMethod,
        userName: _accountNameController.text,
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment Page")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Payment Method:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedPaymentMethod,
              items: ["EcoCash", "Card Payment"].map((String method) {
                return DropdownMenuItem(value: method, child: Text(method));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
            ),
            SizedBox(height: 20),

            
            Form(
              key: _formKey,
              child: _selectedPaymentMethod == "EcoCash" ? _buildEcoCashForm() : _buildCardPaymentForm(),
            ),

            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _processPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                foregroundColor: Colors.white,
                padding: EdgeInsets.all(2),
                textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              child: Text("Pay Now"),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildEcoCashForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(labelText: "Phone Number", border: OutlineInputBorder()),
          validator: (value) {
            if (value == null || value.isEmpty) return "Please enter your phone number";
            if (!RegExp(r'^\d{10}$').hasMatch(value)) return "Enter a valid 10-digit phone number";
            return null;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _pinController,
          obscureText: true,
          decoration: InputDecoration(labelText: "PIN", border: OutlineInputBorder()),
          validator: (value) {
            if (value == null || value.isEmpty) return "Please enter your PIN";
            if (value.length < 4) return "PIN must be at least 4 digits";
            return null;
          },
        ),
      ],
    );
  }

  
  Widget _buildCardPaymentForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _accountNameController,
          decoration: InputDecoration(labelText: "Account Name", border: OutlineInputBorder()),
          validator: (value) {
            if (value == null || value.isEmpty) return "Please enter account name";
            return null;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _accountNumberController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: "Account Number", border: OutlineInputBorder()),
          validator: (value) {
            if (value == null || value.isEmpty) return "Please enter account number";
            if (value.length < 10) return "Account number must be at least 10 digits";
            return null;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _cvvController,
          keyboardType: TextInputType.number,
          obscureText: true,
          decoration: InputDecoration(labelText: "CVV", border: OutlineInputBorder()),
          validator: (value) {
            if (value == null || value.isEmpty) return "Please enter CVV";
            if (value.length != 3) return "CVV must be 3 digits";
            return null;
          },
        ),
      ],
    );
  }
}


class NumberSelectionPage extends StatefulWidget {
  final String paymentMethod;
  final String userName;

  const NumberSelectionPage({super.key, required this.paymentMethod, required this.userName});

  @override
 
  _NumberSelectionPageState createState() => _NumberSelectionPageState();
}

class _NumberSelectionPageState extends State<NumberSelectionPage> {
  List<int> selectedNumbers = [];

  void _selectNumber(int number) {
    setState(() {
      if (selectedNumbers.contains(number)) {
        selectedNumbers.remove(number);
      } else {
        if (selectedNumbers.length < 6) {
          selectedNumbers.add(number);
        }
      }
    });
  }

  void _submitNumbers() {
    if (selectedNumbers.length == 6) {
      
      Navigator.push(context, MaterialPageRoute(builder: (_) => TicketPage(
        userName: widget.userName,
        paymentMethod: widget.paymentMethod,
        selectedNumbers: selectedNumbers,
        moneyBet: 10.00, 
      )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select exactly 6 numbers")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Numbers")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Select 6 Numbers:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(49, (index) {
                int number = index + 1;
                return GestureDetector(
                  onTap: () => _selectNumber(number),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: selectedNumbers.contains(number) ? Colors.blue : const Color.fromRGBO(245, 241, 3, 1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "$number",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 18, 18, 18)),
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitNumbers,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14),
                textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              child: Text("Submit Numbers"),
            ),
          ],
        ),
      ),
    );
  }
}

// Ticket Page
class TicketPage extends StatelessWidget {
  final String userName;
  final String paymentMethod;
  final List<int> selectedNumbers;
  final double moneyBet;

  const TicketPage({
    super.key,
    required this.userName,
    required this.paymentMethod,
    required this.selectedNumbers,
    required this.moneyBet,
  });

  // Function to save the ticket to Firestore
  Future<void> saveTicket(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final String userId = auth.currentUser!.uid;

    
    Map<String, dynamic> ticketData = {
      'userName': userName,
      'paymentMethod': paymentMethod,
      'selectedNumbers': selectedNumbers,
      'moneyBet': moneyBet,
      'ticketDate': Timestamp.now(), 
      'drawNumber': '#12345', 
    };

    try {
      
      await firestore.collection('users').doc(userId).collection('tickets').add(ticketData);
      
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ticket saved successfully!')),
      );
    } catch (e) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving ticket: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Ticket"),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.blue.shade700],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Here is your Ticket...",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 10),
                  Text("Name: $userName", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("Payment Method: $paymentMethod", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text("Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text("Time: ${DateFormat('HH:mm:ss').format(DateTime.now())}", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text("Draw Number: #12345", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text("Money Bet: \$${moneyBet.toStringAsFixed(2)}", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                  Text("Your Numbers:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: selectedNumbers.map((number) {
                      return Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            "$number",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                       
                        saveTicket(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Print Ticket"),
                    ),
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

class DailyDrawsPage extends StatelessWidget {
 
  final List<Map<String, dynamic>> dailyDraws = [
    {"drawNumber": "#12345", "date": "2025-02-18", "winningNumbers": [12, 25, 33, 41, 45, 49]},
    {"drawNumber": "#12344", "date": "2025-02-17", "winningNumbers": [5, 14, 23, 32, 40, 44]},
    {"drawNumber": "#12343", "date": "2025-02-16", "winningNumbers": [8, 19, 27, 34, 42, 50]},
  ];

   DailyDrawsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daily Draws")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: dailyDraws.length,
          itemBuilder: (context, index) {
            final draw = dailyDraws[index];
            return Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Draw Number: ${draw['drawNumber']}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
                    ),
                    SizedBox(height: 10),
                    Text("Date: ${draw['date']}", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text("Winning Numbers:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: draw['winningNumbers'].map<Widget>((number) {
                        return Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.yellowAccent,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "$number",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


class SettingsPage extends StatefulWidget {
  final bool? isDarkMode;
  const SettingsPage({super.key, this.isDarkMode});

  @override
 
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool isDarkMode = false;
  String selectedLanguage = 'English';
  final List<String> languages = ['English', 'Shona', 'Ndebele', 'Swahili'];
  
  
  get SharedPreferences => null;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  
  _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = prefs.getBool('notifications') ?? true;
      isDarkMode = prefs.getBool('darkMode') ?? false;
      selectedLanguage = prefs.getString('language') ?? 'English';
    });
  }

  
  _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('notifications', notificationsEnabled);
    prefs.setBool('darkMode', isDarkMode);
    prefs.setString('language', selectedLanguage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            
            SwitchListTile(
              title: Text("Enable Notifications"),
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                  _saveSettings();
                });
              },
              secondary: Icon(Icons.notifications_active, color: Colors.blue),
            ),
            Divider(),

           
            SwitchListTile(
              title: Text("Dark Mode"),
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                  _saveSettings();
                });
              },
              secondary: Icon(Icons.dark_mode, color: Colors.blueGrey),
            ),
            Divider(),

           
            ListTile(
              title: Text("Select Language"),
              leading: Icon(Icons.language, color: Colors.green),
              trailing: DropdownButton<String>(
                value: selectedLanguage,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedLanguage = newValue;
                      _saveSettings();
                    });
                  }
                },
                items: languages.map((language) {
                  return DropdownMenuItem(
                    value: language,
                    child: Text(language),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
 
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    if (_user != null) {
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(_user!.uid).get();
    if (userDoc.exists) {
      _nameController.text = userDoc['name'] ?? '';
      _emailController.text = userDoc['email'] ?? '';
      _phoneController.text = userDoc['phone'] ?? '';
    }
  }

  Future<void> _saveUserData() async {
    if (_user != null) {
      await _firestore.collection('users').doc(_user!.uid).set({
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
      });
     
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile Updated!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Profile")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
        
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      _user?.photoURL ?? "https://example.com/default-avatar.jpg", 
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.camera_alt, color: Colors.white),
                        onPressed: () {
                         
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

           
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 10),

           
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              enabled: false, 
            ),
            SizedBox(height: 10),

           
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            SizedBox(height: 20),

            
            ElevatedButton(
              onPressed: _saveUserData,
              child: Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}


class TransactionsPage extends StatelessWidget {
   final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String selectedFilter = "All";

  TransactionsPage({super.key}); 

  @override
  Widget build(BuildContext context) {
    String? userId = auth.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Transactions")),
        body: const Center(child: Text("Please log in to view transactions.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Transactions")),
      body: Column(
        children: [
       
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedFilter,
              items: ["All", "Deposit", "Withdrawal"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedFilter = newValue!;
                });
              },
            ),
          ),

       
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('transactions')
                  .where('userId', isEqualTo: userId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No transactions found.'));
                }

                
                List<Transaction> transactions = snapshot.data!.docs.map((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  return Transaction.fromMap(data, doc.id);
                }).toList();

               
                if (selectedFilter != "All") {
                  transactions = transactions
                      .where((tx) => tx.type.toLowerCase() == selectedFilter.toLowerCase())
                      .toList();
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return TransactionCard(transaction: transactions[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  void setState(Null Function() param0) {}
}


class Transaction {
  final String id;
  final double amount;
  final String type; 
  final String status; 
  final DateTime timestamp;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.status,
    required this.timestamp,
  });

  
  factory Transaction.fromMap(Map<String, dynamic> data, String id) {
    return Transaction(
      id: id,
      amount: data['amount']?.toDouble() ?? 0.0,
      type: data['type'] ?? 'unknown',
      status: data['status'] ?? 'pending',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}


class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.timestamp.toLocal().toString(),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  transaction.type.toUpperCase(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: transaction.type == "deposit" ? Colors.green : Colors.red,
                  ),
                ),
                Text(
                  transaction.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    color: transaction.status == "completed" ? Colors.blue : Colors.orange,
                  ),
                ),
              ],
            ),
            Text(
              "\$${transaction.amount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}