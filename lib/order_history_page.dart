import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const CupertinoApp(
    localizationsDelegates: [
      DefaultCupertinoLocalizations.delegate,
    ],
    supportedLocales: [Locale('en', 'US')],
    home: OrderHistoryPage(),
  ));
}

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  List<Map<String, dynamic>> orderHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrderHistory();
  }

  Future<void> _loadOrderHistory() async {
    try {
      final response = await http.get(Uri.parse('https://pharmaexpressdelivery.shop/api/history.php'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] && data['data'] is List) {
          setState(() {
            orderHistory = List<Map<String, dynamic>>.from(data['data']);
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
        }
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey5,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: const [
          Expanded(flex: 1, child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text('Phone', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildTableRow(Map<String, dynamic> order, bool isEven) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: isEven ? CupertinoColors.systemGrey6 : CupertinoColors.white,
        border: const Border(bottom: BorderSide(color: CupertinoColors.systemGrey4, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(order['id'].toString())),
          Expanded(flex: 2, child: Text(order['name'] ?? 'Unknown')),
          Expanded(flex: 1, child: Text(order['quantity'].toString())),
          Expanded(flex: 2, child: Text('\$${order['total']}')),
          Expanded(flex: 2, child: Text(order['phone_number'] ?? 'N/A')),
          Expanded(flex: 2, child: Text(order['timestamp'] ?? 'N/A')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Order History'),
      ),
      child: SafeArea(
        child: isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : orderHistory.isEmpty
            ? const Center(child: Text('No orders found.'))
            : Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.systemGrey.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildTableHeader(),
                const Divider(height: 1, thickness: 0.5),
                Expanded(
                  child: ListView.builder(
                    itemCount: orderHistory.length,
                    itemBuilder: (context, index) {
                      final order = orderHistory[index];
                      return _buildTableRow(order, index % 2 == 0);
                    },
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
