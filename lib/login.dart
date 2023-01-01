import 'package:dream/homeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return LoginScreen();
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isHidden = false;
  var password = '';

  // login function
  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("No user found for this email");
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    // create the textfield controller
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Welcome नक्कली',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'म तिमीलाई माया गर्छु ! म सधै तिम्रो साथ चाहन्छु ! म तिमी बिना अपूर्ण छु ! म तिमीसँग मेरो सम्पूर्ण जीवन बाँड्न चाहन्छु !!! ',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15, color: Color.fromARGB(255, 86, 81, 81),),
            ),
             const SizedBox(
              height: 2,
            ),
            const Text(
              'You are my first love. You are my everything.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
            const SizedBox(
              height: 2,
            ),
             const Text(
              'I love you नक्कली.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 236, 29, 229),
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Image.network(
              'https://easydrawingguides.com/wp-content/uploads/2022/06/heart-locket-step-by-step-drawing-tutorial-step-10.png',
              height: 180,
              width: 300,
            ),
            const SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    hintText: "User Email",
                    filled: true,
                    fillColor: Color.fromARGB(31, 117, 113, 113),
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(12.0)))),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                obscureText: isHidden,
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(31, 117, 113, 113),
                  hintText: 'Password',
                  border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: isHidden
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                    onPressed: togglePasswordVisibility,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              width: double.infinity,
              child: RawMaterialButton(
                fillColor: Color(0xff0069fe),
                elevation: 0.0,
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                onPressed: () async {
                  // let's test the app
                  User? user = await loginUsingEmailPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                      context: context);
                  print(user);
                  if (user != null) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            HomePage())); // let's make a new screen
                  }
                },
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  void togglePasswordVisibility() => setState(() => isHidden = !isHidden);
}
