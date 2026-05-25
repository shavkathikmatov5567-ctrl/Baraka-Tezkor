import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 👈 Firebase Auth кутубхонаси
import 'address_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId; // 👈 Мана шу янги параметр қўшилди

  const OtpScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId, // 👈 Бу ерда мажбурий қилинди
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  // Код киритиш учун контроллер (Одатда TextField созланади)
  final TextEditingController _otpController = TextEditingController();

  // Идти хақиқий кодни тасдиқлаш функцияси
  Future<void> verifyOTPCode() async {
      // Агар тест режимида бўлсак ва фойдаланувчи 111111 киритса, тўғридан-тўғри киргизиб юборади
  if (widget.verificationId == "test_mode_id") {
    if (_otpController.text.trim() == "111111") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AddressScreen(phoneNumber: widget.phoneNumber),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Тест коди нотўғри! (Тест коди: 111111)")),
      );
    }
    return;
  }
    String smsCode = _otpController.text.trim();

    if (smsCode.isEmpty || smsCode.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Илтимос, 6 хонали кодни тўлиқ киритинг")),
      );
      return;
    }

    // Юкланиш айланасини кўрсатиш
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFFF10B981))),
    );

    try {
      // Firebase учун СМС кодни созлаш
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: smsCode,
      );

      // Тизимга ҳақиқий кириш
      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.pop(context); // Юкланиш айланасини ёпиш

      // Код тўғри бўлса, Манзил (AddressScreen) саҳифасига ўтамиз
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AddressScreen(phoneNumber: widget.phoneNumber),
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Юкланиш айланасини ёпиш
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Код нотўғри киритилди: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Тасдиқлаш")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${widget.phoneNumber} рақамига юборилган кодни киритинг",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: "СМС Код",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF10B981),
                  ),
                  onPressed: verifyOTPCode, // 👈 Босилганда ҳақиқий код текширилади
                  child: const Text("Тасдиқлаш ва Кириш", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
