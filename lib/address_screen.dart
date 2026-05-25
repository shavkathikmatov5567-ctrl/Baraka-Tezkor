import 'package:flutter/material.dart';
import 'home.dart';

class AddressScreen extends StatefulWidget {
  final String phoneNumber; // Телефон рақамни қабул қиламиз
  const AddressScreen({super.key, required this.phoneNumber});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  String? selectedCity;
  String? selectedDistrict;
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();

  final List<String> cities = ["Ғиждувон", "Бухоро", "Тошкент"];
  final List<String> districts = ["Марказ", "Дезбод", "Чағаллоқ", "Гаждумак"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, 
        elevation: 0, 
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Етказиб бериш манзили", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
                hint: const Text("Шаҳарни танланг"),
                items: cities.map((city) => DropdownMenuItem(value: city, child: Text(city))).toList(),
                onChanged: (val) => setState(() => selectedCity = val),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
                hint: const Text("Туманни танланг"),
                items: districts.map((dist) => DropdownMenuItem(value: dist, child: Text(dist))).toList(),
                onChanged: (val) => setState(() => selectedDistrict = val),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _streetController, 
                decoration: InputDecoration(labelText: "Кўча номи", border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _houseController, 
                decoration: InputDecoration(labelText: "Уй рақами", border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    String fullAddress = "${_streetController.text} ${_houseController.text}";
                    if (fullAddress.trim().isEmpty) fullAddress = "Ғиждувон маркази";
                    
                    // Бош саҳифага манзил билан бирга ТЕЛЕФОН рақамни ҳам узатамиз
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(userAddress: fullAddress, userPhone: widget.phoneNumber),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text("Сақлаш ва кириш", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
