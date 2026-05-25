import 'package:flutter/material.dart';
import 'otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _phoneController = TextEditingController(text: "+998 ");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Baraka Tezkor",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
              ),
              const SizedBox(height: 40),
              const Text("Хуш келибсиз!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Тизимга кириш учун телефон рақамингизни киритинг", style: TextStyle(fontSize: 15, color: Colors.grey)),
              const SizedBox(height: 32),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Телефон рақам",
                  prefixIcon: const Icon(Icons.phone, color: Color(0xFF10B981)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
onPressed: () async {
    if (kIsWeb) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpScreen(
          phoneNumber: _phoneController.text.trim(),
          verificationId: "test_mode_id",
        ),
      ),
    );
    return;
  }

  // Телефон рақамини оламиз ва бўш жойларни тозалаймиз
  String phone = _phoneController.text.trim();

  // Агар фойдаланувчи рақамни киритмаган бўлса, огоҳлантирамиз
  if (phone.isEmpty || phone == "+998") {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Илтимос, телефон рақамингизни киритинг")),
    );
    return;
  }

  // Экранда юкланиш (прогресс) айланасини кўрсатиш учун
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFFF10B981))),
  );

  try {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Агар Android СМСни автоматик ушласа, тўғридан-тўғри тизимга киради
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        Navigator.pop(context); // Юкланиш айланасини ёпиш
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Хатолик: ${e.message}")),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.pop(context); // Юкланиш айланасини ёпиш
        
        // Код муваффақиятли кетди, энди OTP ойнасига ўтамиз
        // Бу ерда хам телефон рақамни, хам Firebase берган verificationId ни узатамиз
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(
              phoneNumber: phone,
              verificationId: verificationId, // 👈 Буни OTP ойнасига бериб юборамиз
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  } catch (e) {
    Navigator.pop(context); // Юкланиш айланасини ёпиш
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Тизимда хатолик: $e")),
    );
  }
},
                  child: const Text("Код олиш", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
