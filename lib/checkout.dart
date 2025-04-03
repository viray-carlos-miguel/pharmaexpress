import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'order_history_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Checkout App',
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.systemBlue,
        brightness: Brightness.light,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(fontFamily: 'Helvetica Neue', fontSize: 16),
        ),
      ),
      home: const CheckoutPage(
        medicine: {'name': 'Example Medicine', 'price': '10.99'},
        quantity: '2',
      ),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  final Map<String, dynamic> medicine;
  final String quantity;

  const CheckoutPage({super.key, required this.medicine, required this.quantity});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _submitPayment() async {
    final String paymentApiUrl = 'http://192.168.1.251/api/card_info.php';


    final response = await http.post(
      Uri.parse(paymentApiUrl),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'name': _nameController.text,
        'card_number': _cardNumberController.text,
        'address': _addressController.text,
        'phone_number': _phoneNumberController.text,
      }),
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      print(responseData['message']);

      await _saveOrderHistory();

      _showSuccessDialog('Payment Successful', responseData['message']);
    } else {
      final responseData = json.decode(response.body);
      _showErrorDialog('Error', responseData['message']);
    }
  }

  Future<void> _saveOrderHistory() async {
    final String orderApiUrl = 'http://192.168.1.251/api/orders.php';

    await http.post(
      Uri.parse(orderApiUrl),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'name': widget.medicine['name'],
        'quantity': widget.quantity,
        'total': (double.parse(widget.medicine['price']) * int.parse(widget.quantity)).toStringAsFixed(2),
        'timestamp': DateTime.now().toString(),
        'address': _addressController.text,
        'phone_number': _phoneNumberController.text,
      }),
    );
  }

  void _showSuccessDialog(String title, String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  CupertinoPageRoute(builder: (context) => const OrderHistoryPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String title, String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = (double.parse(widget.medicine['price']) * int.parse(widget.quantity));

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Checkout')),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Medicine: ${widget.medicine['name']}'),
              Text('Quantity: ${widget.quantity}'),
              Text('Total: \$${totalAmount.toStringAsFixed(2)}'),

              CupertinoTextField(controller: _nameController, placeholder: 'Name on Card'),
              CupertinoTextField(controller: _cardNumberController, placeholder: 'Card Number'),
              CupertinoTextField(controller: _addressController, placeholder: 'Address'),
              CupertinoTextField(controller: _phoneNumberController, placeholder: 'Phone Number'),

              CupertinoButton.filled(
                onPressed: _submitPayment,
                child: const Text('Submit Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
