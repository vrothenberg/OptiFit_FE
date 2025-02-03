import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    // Basic validation: ensure fields are not empty
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showErrorDialog('Please enter both your email and password.');
      return;
    }
    // You could add more sophisticated validation here if needed.
    Provider.of<OptiFitAppState>(context, listen: false).login();
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Login'),
      ),
      child: SafeArea(
        child: GestureDetector(
          // Dismiss the keyboard when tapping outside
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Optionally, add a logo or welcome message here
                // Image.asset('assets/logo.png', height: 100),
                const SizedBox(height: 40),
                // Email Input
                CupertinoTextField(
                  controller: emailController,
                  placeholder: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  clearButtonMode: OverlayVisibilityMode.editing,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                // Password Input
                CupertinoTextField(
                  controller: passwordController,
                  placeholder: 'Password',
                  obscureText: true,
                  clearButtonMode: OverlayVisibilityMode.editing,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 32),
                // Login Button
                CupertinoButton.filled(
                  onPressed: _login,
                  child: const Text('Login'),
                ),
                const SizedBox(height: 20),
                // Optional "Forgot Password?" link
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    // Navigate to the forgot password page
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
