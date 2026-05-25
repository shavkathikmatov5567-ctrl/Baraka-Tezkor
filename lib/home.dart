import 'package:flutter/material.dart';
import 'food_detail_screen.dart'; 
import 'cart.dart'; 
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  final String userAddress; final String userPhone; 
  const HomeScreen({super.key, required this.userAddress, required this.userPhone});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; String _currentLangCode = "uz"; String _selectedAvatar = ""; 
  String _selectedCategory = "Ресторан"; String _searchQuery = ""; 
  late String _currentAddress = widget.userAddress;

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardDateController = TextEditingController();

  final Map<String, Map<String, String>> _localizedText = {
    "uz": {
      "home": "Home", "history": "History", "wallet": "Wallet", "profile": "Profile",
      "search": "Қидириш...", "name": "Исм", "surname": "Фамилия", "phone": "Телефон",
      "lang": "Илова тили", "support": "Қўллаб-қувватлаш", "logout": "Чиқиш",
      "add_card_title": "Янги карта қўшиш", "card_number": "Карта рақами", "card_date": "Муддати",
      "save_card": "Сақлаш", "change_address": "Манзилни ўзгартириш", "new_address_hint": "Янги манзил киритинг",
      "cat_rest": "Ресторан", "cat_pharm": "Дорихона", "cat_prod": "Озиқ-овқатлар"
    },
    "ru": {
      "home": "Home", "history": "History", "wallet": "Wallet", "profile": "Profile",
      "search": "Поиск...", "name": "Имя", "surname": "Фамилия", "phone": "Телефон",
      "lang": "Язык", "support": "Поддержка", "logout": "Выйти",
      "add_card_title": "Добавить карту", "card_number": "Номер карты", "card_date": "Срок",
      "save_card": "Сохранить", "change_address": "Изменить адрес", "new_address_hint": "Введите новый адрес",
      "cat_rest": "Ресторан", "cat_pharm": "Аптека", "cat_prod": "Продукты"
    },
    "en": {
      "home": "Home", "history": "History", "wallet": "Wallet", "profile": "Profile",
      "search": "Search...", "name": "Name", "surname": "Surname", "phone": "Phone",
      "lang": "Language", "support": "Support", "logout": "Logout",
      "add_card_title": "Add Card", "card_number": "Card Number", "card_date": "Expiry",
      "save_card": "Save", "change_address": "Change Address", "new_address_hint": "Enter new address",
      "cat_rest": "Restaurant", "cat_pharm": "Pharmacy", "cat_prod": "Grocery"
    }
  };

  String _t(String key) => _localizedText[_currentLangCode]?[key] ?? key;
  final TextEditingController _nameController = TextEditingController(text: "Ислом");
  final TextEditingController _surnameController = TextEditingController(text: "Ражабов");

  final List<Map<String, String>> orderHistory = [];
  final List<Map<String, String>> myCards = [];

  final List<Map<String, String>> allProducts = [
    {"name": "Burger", "price": "15,000 so'm", "image": "assets/burger1.jpg", "cat": "Ресторан", "discount": "-20%"},
    {"name": "Lavash", "price": "15,000 so'm", "image": "assets/burger2.jpg", "cat": "Ресторан", "discount": "-20%"},
    {"name": "Shashlik", "price": "15,000 so'm", "image": "assets/burger3.jpg", "cat": "Ресторан", "discount": "-20%"},
    {"name": "Цитрамон", "price": "5 000 сўм", "image": "assets/sitramon.jpg", "cat": "Дорихона", "discount": ""},
    {"name": "Пишлоқ (Сыр)", "price": "35 000 сўм", "image": "assets/pshloq.jpg", "cat": "Продукты", "discount": ""},
  ];
  Widget _buildHome() {
    List<Map<String, String>> filteredList = allProducts.where((p) => p['cat'] == _selectedCategory).toList();
    // Ҳақиқий қидирув тизими (Поиск) мантиқи 🚀
    if (_searchQuery.isNotEmpty) {
      filteredList = allProducts.where((p) => p['name']!.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 45, left: 20, right: 20, bottom: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF1E4620), Color(0xFF143016)]), 
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.telegram, color: Colors.white, size: 20), 
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Telegram очилмоқда..."), backgroundColor: Color(0xFF2D6A30), duration: Duration(seconds: 1)),
                        );
                      },
                    ),
                    Expanded(
                      child: Container(
                        height: 85,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Image.asset(
                          "assets/logo.png", 
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) => const Text("BARAKA TEZKOR", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                        ),
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 20), onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Instagram: @baraka_tezkor")))),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_currentAddress.length > 18 ? "${_currentAddress.substring(0, 18)}..." : _currentAddress, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    GestureDetector(
                      onTap: _showAddressEditDialog,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), 
                        decoration: BoxDecoration(color: Colors.white.withAlpha(30), borderRadius: BorderRadius.circular(10)),
                        child: const Row(children: [Icon(Icons.location_on, color: Colors.white, size: 14), SizedBox(width: 4), Icon(Icons.edit, color: Colors.white, size: 10)]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value), 
              decoration: InputDecoration(hintText: _t("search"), prefixIcon: const Icon(Icons.search)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF2D6A30), Color(0xFF1E4620)]), borderRadius: BorderRadius.circular(20)),
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("AKSIYA", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text("50% chegirmada ulgurib qoling\nHamkorlik uchun +998906127747", style: TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_circle_right, color: Color(0xFFFFD700), size: 40),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _buildItem(_t("cat_rest"), Icons.restaurant, Colors.orange),
                const SizedBox(width: 10),
                _buildItem(_t("cat_pharm"), Icons.local_pharmacy, Colors.blue),
                const SizedBox(width: 10),
                _buildItem(_t("cat_prod"), Icons.shopping_basket, Colors.green),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Text("Kategorits", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))),
          const SizedBox(height: 12),
          SizedBox(
            height: 230, 
            child: ListView.builder(
              scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final item = filteredList[index];
                return Container(
                  width: 140, margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FoodDetailScreen(foodItem: item))),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                width: 140, height: 140, color: const Color(0xFF143016),
                                child: Image.asset(item['image']!, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.fastfood, color: Colors.grey, size: 40)),
                              ),
                            ),
                          ),
                          if (item['discount']!.isNotEmpty)
                            Positioned(
                              top: 8, left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(6)),
                                child: Text(item['discount']!, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          Positioned(
                            bottom: 8, right: 8,
                            child: GestureDetector(
                              onTap: () {
                                CartManager.addToCart(item, 1);
                                setState(() {}); // Саватча сонини тезкор янгилаш учун
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${item['name']} qo'shildi!"), backgroundColor: const Color(0xFF2D6A30), duration: const Duration(seconds: 1)));
                              },
                              child: const CircleAvatar(radius: 14, backgroundColor: Color(0xFF2D6A30), child: Icon(Icons.add, size: 16, color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(item['name']!, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text(item['price']!, style: const TextStyle(fontSize: 13, color: Colors.white70)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildHistory() {
    return Scaffold(
      backgroundColor: const Color(0xFF143016),
      appBar: AppBar(title: const Text("History"), backgroundColor: const Color(0xFF1E4620), automaticallyImplyLeading: false),
      body: const Center(child: Text("No history yet", style: TextStyle(color: Colors.grey))),
    );
  }

  Widget _buildWallet() {
    return Scaffold(
      backgroundColor: const Color(0xFF143016),
      appBar: AppBar(title: const Text("Wallet"), backgroundColor: const Color(0xFF1E4620), automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: myCards.isEmpty
                  ? const Center(child: Text("No cards added yet", style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      itemCount: myCards.length,
                      itemBuilder: (context, index) => Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(24),
                        height: 160,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2D6A30), Color(0xFF1E4620)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black.withAlpha(80), blurRadius: 8, offset: const Offset(0, 4))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(myCards[index]['type']!, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
                                const Icon(Icons.credit_card, color: Colors.white70, size: 28),
                              ],
                            ),
                            const Row(
                              children: [
                                Icon(Icons.sim_card_outlined, color: Color(0xFFFFD700), size: 32), // Карта чипи 💳
                              ],
                            ),
                            Text(
                              myCards[index]['number']!, 
                              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 3),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            ElevatedButton(style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56), backgroundColor: const Color(0xFF2D6A30)), onPressed: _showAddCardBottomSheet, child: Text(_t("add_card_title"), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile() {
    return Scaffold(
      backgroundColor: const Color(0xFF143016),
      appBar: AppBar(title: Text(_t("profile")), backgroundColor: const Color(0xFF1E4620), automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(onTap: _showAvatarDialog, child: CircleAvatar(radius: 45, backgroundImage: _selectedAvatar.isNotEmpty ? AssetImage(_selectedAvatar) : null, child: _selectedAvatar.isEmpty ? const Icon(Icons.person, size: 45) : null)),
            const SizedBox(height: 20),
            TextField(controller: _nameController, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: _t("name"))),
            TextField(controller: _surnameController, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: _t("surname"))),
            TextField(enabled: false, controller: TextEditingController(text: widget.userPhone), style: const TextStyle(color: Colors.white70), decoration: InputDecoration(labelText: _t("phone"))),
            ListTile(leading: const Icon(Icons.language, color: Colors.white), title: Text(_t("lang"), style: const TextStyle(color: Colors.white)), onTap: _showLanguageDialog),
            ListTile(leading: const Icon(Icons.headset_mic, color: Colors.white), title: Text(_t("support"), style: const TextStyle(color: Colors.white)), onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Telegram ID: 5148467828")))),
            ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: Text(_t("logout"), style: const TextStyle(color: Colors.red)), onTap: () {}),
          ],
        ),
      ),
    );
  }
  void _showAddressEditDialog() {
    final TextEditingController addressController = TextEditingController(text: _currentAddress);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF143016),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("G'ijduvon Canli Xaritasi", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: addressController, style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(hintText: "Manzilni kiriting...", hintStyle: TextStyle(color: Colors.white54), prefixIcon: Icon(Icons.search, color: Color(0xFFFFD700))),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity, height: 250, color: const Color(0xFF1A3A1C),
                  child: Image.network(
                    "https://yandex.ru",
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => const Center(child: Icon(Icons.map, color: Colors.white30, size: 50)),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2D6A30)), onPressed: () { if (addressController.text.trim().isNotEmpty) { setState(() { _currentAddress = addressController.text.trim(); }); } Navigator.pop(context); }, child: const Text("OK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

void _showAddCardBottomSheet() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Янги карта қўшиш", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          TextField(
            controller: _cardNumberController,
            keyboardType: TextInputType.number,
            maxLength: 19,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CardNumberFormatter(),
            ],
            decoration: const InputDecoration(
              labelText: "Карта рақами",
              hintText: "8600 1234 1234 1234",
              counterText: "",
            ),
          ),
          TextField(
            controller: _cardDateController,
            keyboardType: TextInputType.number,
            maxLength: 5,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CardDateFormatter(),
            ],
            decoration: const InputDecoration(
              labelText: "Амал қилиш муддати",
              hintText: "MM/YY",
              counterText: "",
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: const Color(0xFFF2D6A30),
            ),
            onPressed: () {
              String cardNum = _cardNumberController.text.trim();
              String cardDate = _cardDateController.text.trim();
              if (cardNum.length < 19 || cardDate.length != 5) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Карта маълумотлари хато!")),
                );
                return;
              }
              setState(() {
                myCards.add({
                  "type": cardNum.startsWith("9860") ? "HUMO CARD" : "UZCARD",
                  "number": cardNum,
                  "date": cardDate,
                });
              });
              Navigator.pop(context);
            },
            child: const Text("Сақлаш", style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}

  void _showLanguageDialog() {
    showModalBottomSheet(context: context, builder: (context) => Column(mainAxisSize: MainAxisSize.min, children: [ListTile(title: const Text("Ўзбекча"), onTap: () { setState(() => _currentLangCode = "uz"); Navigator.pop(context); }), ListTile(title: const Text("Русский"), onTap: () { setState(() => _currentLangCode = "ru"); Navigator.pop(context); }), ListTile(title: const Text("English"), onTap: () { setState(() => _currentLangCode = "en"); Navigator.pop(context); })]));
  }

  void _showAvatarDialog() {
    showModalBottomSheet(context: context, builder: (context) => Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: ["assets/burger1.jpg", "assets/burger2.jpg", "assets/burger3.jpg"].map((path) => GestureDetector(onTap: () { setState(() => _selectedAvatar = path); Navigator.pop(context); }, child: Padding(padding: const EdgeInsets.all(20), child: CircleAvatar(radius: 30, backgroundImage: AssetImage(path))))).toList()));
  }

  @override
  Widget build(BuildContext context) {
    Widget body = _currentIndex == 0 ? _buildHome() : _currentIndex == 1 ? _buildHistory() : _currentIndex == 2 ? _buildWallet() : _buildProfile();
    return Scaffold(
      backgroundColor: const Color(0xFF143016), 
      body: body,
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF1E4620),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(icon: Icon(Icons.home, color: _currentIndex == 0 ? const Color(0xFFFFD700) : Colors.grey), onPressed: () => setState(() => _currentIndex = 0)),
              IconButton(icon: Icon(Icons.history, color: _currentIndex == 1 ? const Color(0xFFFFD700) : Colors.grey), onPressed: () => setState(() => _currentIndex = 1)),
              const SizedBox(width: 40),
              IconButton(icon: Icon(Icons.account_balance_wallet, color: _currentIndex == 2 ? const Color(0xFFFFD700) : Colors.grey), onPressed: () => setState(() => _currentIndex = 2)),
              IconButton(icon: Icon(Icons.person, color: _currentIndex == 3 ? const Color(0xFFFFD700) : Colors.grey), onPressed: () => setState(() => _currentIndex = 3)),
            ],
          ),
        ),
      ),
      // Сиз айтгандек: Саватча тугмаси устида чиройли қизил рангли сонли Бадге уланди 🛍️🔴
      floatingActionButton: Stack(
        clipBehavior: Clip.none,
        children: [
          FloatingActionButton(
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
              setState(() {}); // Саватчадан қайтганда сонини янгилаш учун
            },
            backgroundColor: const Color(0xFFFFD700),
            child: const Icon(Icons.shopping_cart, color: Colors.black),
          ),
          if (CartManager.getItemsCount() > 0)
            Positioned(
              right: -4, top: -4,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                child: Text(
                  '${CartManager.getItemsCount()}',
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildItem(String title, IconData icon, Color color) {
    bool isSelected = _selectedCategory == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() { _selectedCategory = title; _searchQuery = ""; }),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14), margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(color: isSelected ? color.withAlpha(40) : color.withAlpha(15), borderRadius: BorderRadius.circular(16), border: isSelected ? Border.all(color: color, width: 1.5) : null),
          child: Column(children: [Icon(icon, size: 26, color: color), const SizedBox(height: 6), Text(title, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: Colors.white))]),
        ),
      ),
    );
  }
}

class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll(' ', '');
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}
class CardDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll('/', '');
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != text.length) {
        buffer.write('/');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}

