import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:to_do/auth.dart';

class LoginRegesterPage extends StatefulWidget {
  const LoginRegesterPage({super.key});

  @override
  State<LoginRegesterPage> createState() => _LoginRegesterPageState();
}

class _LoginRegesterPageState extends State<LoginRegesterPage> {
  final TextEditingController _emailCtl = TextEditingController();
  final TextEditingController _passwordCtl = TextEditingController();
  String? errorMessage;

  bool isLogin = true;

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _emailCtl.text,
        password: _passwordCtl.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.message ==
            "The supplied auth credential is incorrect, malformed or has expired.") {
          errorMessage = "Sai mật khẩu hoặc chưa có tài khoản";
        } else if (e.message == "The email address is badly formatted.") {
          errorMessage = "Sai định dạng email";
        } else {
          errorMessage = "Vui lòng nhập mật khẩu";
        }
        print(e.message);
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _emailCtl.text,
        password: _passwordCtl.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        print(e.message);
        errorMessage = "Sai mật khẩu";
      });
    }
  }

  Widget _errorMessage() {
    return Text(errorMessage ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 220, 220),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Todo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 2.0,
                      color: const Color.fromARGB(255, 116, 124, 131)),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  controller: _emailCtl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: "Email",
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 2.0,
                      color: const Color.fromARGB(255, 116, 124, 131)),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _passwordCtl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: "Password",
                  ),
                  obscureText: true,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                isLogin
                    ? signInWithEmailAndPassword()
                    : createUserWithEmailAndPassword();
              },
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.blue)),
              child: Text(
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
                isLogin ? "Login" : "Register",
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                isLogin = !isLogin;
                setState(() {});
              },
              child: Text(isLogin ? "Regester instead?" : "Login instead?"),
            ),
            _errorMessage()
          ],
        ),
      ),
    );
  }
}
