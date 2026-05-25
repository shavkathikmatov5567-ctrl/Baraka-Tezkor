import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Саватча хотирасини бошқарувчи класс
class CartManager {
  static final List<Map<String, dynamic>> cartItems = [];

  static void addToCart(Map<String, String> product, int quantity) {
    for (var item in cartItems) {
      if (item['product']['name'] == product['name']) {
        item['quantity'] += quantity;
        return;
      }
    }
    cartItems.add({'product': product, 'quantity': quantity});
  }
    static int getItemsCount() {
    int count = 0;
    for (var item in cartItems) {
      count += (item['quantity'] as int);
    }
    return count;
  }

  static double calculateTotal() {
    double total = 0;
    for (var item in cartItems) {
      String priceStr = item['product']['price']!.replaceAll(RegExp(r'[^0-9]'), '');
      total += double.parse(priceStr) * item['quantity'];
    }
    return total;
  }
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    double totalAmount = CartManager.calculateTotal();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Саватча", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: CartManager.cartItems.isEmpty
          ? const Center(child: Text("Саватча бўм-бўш", style: TextStyle(color: Colors.grey, fontSize: 16)))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: CartManager.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = CartManager.cartItems[index];
                      return ListTile(
                        leading: CircleAvatar(backgroundImage: AssetImage(item['product']['image']!)),
                        title: Text(item['product']['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${item['product']['price']} x ${item['quantity']}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () {
                            setState(() { CartManager.cartItems.removeAt(index); });
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Умумий ҳисоб:", style: TextStyle(fontSize: 16, color: Colors.grey)),
                          Text("${totalAmount.toStringAsFixed(0)} сўм", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                          backgroundColor: const Color(0xFF10B981),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () {
                        _showAddressAndCommentSheet(context);
                        },
                        child: const Text("Буюртма бериш", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  // 1. БОСҚИЧ: Чек ойнасини кўрсатиш
  void _showOrderDetailsDialog() {
    String orderDetails = "🛍️ **ЯНГИ БУЮРТМА! (Baraka Tezkor)**\n\n";
    for (var item in CartManager.cartItems) {
      orderDetails += "• ${item['product']['name']} (${item['quantity']} та) - ${item['product']['price']}\n";
    }
    orderDetails += "\n💰 **Умумий ҳисоб:** ${CartManager.calculateTotal().toStringAsFixed(0)} сўм";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Буюртма чеки"),
        content: SingleChildScrollView(child: Text(orderDetails)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Бекор қилиш", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
            onPressed: () {
              Navigator.pop(context); 
              _sendOrderToTelegramBot(orderDetails); // Телеграмга юбориш функциясини чақирамиз
            },
            child: const Text("Буюртмани тасдиқлаш", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  void _showAddressAndCommentSheet(BuildContext context) {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1E293B),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Етказиб бериш созламалари",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text("Етказиб бериш манзили", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              TextField(
                controller: _addressController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Масалан: Ғиждувон маркази, 12-уй",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF0F172A),
                  prefixIcon: const Icon(Icons.location_on, color: Color(0xFF10B981)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Курьер учун изоҳ (Ихтиёрий)", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              TextField(
                controller: _commentController,
                style: const TextStyle(color: Colors.white),
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: "Масалан: Кодли эшик 3, телефон қилинг...",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF0F172A),
                  prefixIcon: const Icon(Icons.comment, color: Color(0xFF10B981)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
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
                  onPressed: () {
                    if (_addressController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Илтимос, етказиб бериш манзилини киритинг!")),
                      );
                      return;
                    }
                    Navigator.pop(context);
                    _showOrderDetailsDialog(); 
                  },
                  child: const Text(
                    "Давом этиш",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}


  // 2. БОСҚИЧ: Ҳақиқий Телеграм Ботга СМС юбориш тизими
  void _sendOrderToTelegramBot(String message) async {
String botToken = dotenv.env['TELEGRAM_BOT_TOKEN'] ?? '';
String chatId = dotenv.env['ADMIN_TELEGRAM_ID'] ?? '';

    // Токен ҳавола ичига тўғри жойлаштирилди 🚀
    String s1 = "https://";
    String s2 = "api.telegram.org";
    String s3 = "/bot";
    String s4 = "/sendMessage";
    final url = Uri.parse(s1 + s2 + s3 + botToken + s4);


    try {
      final request = await HttpClient().postUrl(url);
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(json.encode({
        'chat_id': chatId,
        'text': message,
        'parse_mode': 'Markdown',
      })));
      
      final response = await request.close();
      if (response.statusCode == 200) {
        _showSuccessDialog();
      } else {
        _showErrorSnackBar();
      }
    } catch (e) {
      _showErrorSnackBar();
    }
  }


  // 3. БОСҚИЧ: Муваффақиятли якунлаш ойнаси
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF10B981), size: 28),
            SizedBox(width: 10),
            Text("Муваффақиятли!"),
          ],
        ),
        content: const Text("Буюртма қабул қилинди! Тез орада курьер сиз билан боғланади.", style: TextStyle(fontSize: 15)),
        actions: [
          TextButton(
            onPressed: () {
              setState(() { CartManager.cartItems.clear(); }); 
              Navigator.pop(context); 
              Navigator.pop(context); 
            },
            child: const Text("Aжойиб", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Буюртма юборишда хатолик бўлди. Интернетни текширинг!"), backgroundColor: Colors.red),
    );
  }
}
