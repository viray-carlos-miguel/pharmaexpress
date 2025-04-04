import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'add_product.dart'; // Ensure this line is present
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'checkout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Medicines App',
      home: MedicinesPage(),
    );
  }
}

class MedicinesPage extends StatefulWidget {
  const MedicinesPage({super.key});

  @override
  State<MedicinesPage> createState() => _MedicinesPageState();
}

class _MedicinesPageState extends State<MedicinesPage> {
  final String _server = "https://pharmaexpressdelivery.shop/api/";
  final String _defaultImage = "https://pharmaexpressdelivery.shop/api/uploads/default_image.jpg";

  bool _isLoading = true;
  bool _hasError = false;
  List _medicines = [];

  @override
  void initState() {
    super.initState();
    _fetchMedicines();
  }

  Future<void> _fetchMedicines() async {
    try {
      final response = await http.get(Uri.parse("$_server/medicines.php"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] && data['medicines'] != null) {
          setState(() {
            _medicines = data['medicines'];
            _isLoading = false;
            _hasError = false;
          });
        } else {
          setState(() {
            _hasError = true;
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void _goToAddProduct() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const AddProductPage(),
      ),
    );
  }

  void _showProductDetails(Map<String, dynamic> medicine) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => ProductDetailsPage(medicine: medicine),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Medicines Shop"),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _goToAddProduct,
          child: const Icon(CupertinoIcons.add_circled, color: CupertinoColors.activeBlue),
        ),
      ),
      child: Column(
        children: [
          _isLoading
              ? const Center(child: CupertinoActivityIndicator())
              : _hasError
              ? const Center(child: Text("Failed to load medicines"))
              : Expanded(
            child: ListView.builder(
              itemCount: _medicines.length,
              itemBuilder: (context, index) {
                final medicine = _medicines[index];
                final imageUrl = medicine['image_url'] ?? _defaultImage;

                return GestureDetector(
                  onTap: () => _showProductDetails(medicine),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: CupertinoColors.systemGrey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                _defaultImage,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                medicine['name'] ?? '',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "\$${medicine['price']} - ${medicine['quantity_available']} Available",
                                style: const TextStyle(color: CupertinoColors.systemGrey),
                              ),
                            ],
                          ),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => _showProductDetails(medicine),
                          child: const Icon(CupertinoIcons.right_chevron, color: CupertinoColors.activeBlue),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic> medicine;

  const ProductDetailsPage({super.key, required this.medicine});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _selectedQuantity = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.medicine['name'] ?? ''),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.medicine['image_url'] ?? "https://pharmaexpressdelivery.shop/api/uploads/default_image.jpg",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    width: double.infinity,
                    color: CupertinoColors.systemGrey4, // Placeholder color
                    child: const Center(
                      child: Text(
                        'Image not available',
                        style: TextStyle(color: CupertinoColors.systemGrey),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.medicine['name'] ?? '',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "\$${double.tryParse(widget.medicine['price'].toString())?.toStringAsFixed(2) ?? '0.00'}",  // Safely parsing price
              style: const TextStyle(fontSize: 20, color: CupertinoColors.activeBlue),
            ),
            const SizedBox(height: 8),
            Text(
              "Quantity Available: ${int.tryParse(widget.medicine['quantity_available'].toString()) ?? 0}",  // Safely parsing quantity
              style: const TextStyle(fontSize: 16, color: CupertinoColors.systemGrey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton(
                  onPressed: () {
                    setState(() {
                      if (_selectedQuantity > 0) {
                        _selectedQuantity--;
                      }
                    });
                  },
                  child: const Icon(CupertinoIcons.minus, color: CupertinoColors.activeBlue),
                ),
                const SizedBox(width: 10),
                Text(
                  '$_selectedQuantity',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 10),
                CupertinoButton(
                  onPressed: () {
                    setState(() {
                      int availableQuantity = int.tryParse(widget.medicine['quantity_available'].toString()) ?? 0;
                      if (_selectedQuantity < availableQuantity) {
                        _selectedQuantity++;
                      }
                    });
                  },
                  child: const Icon(CupertinoIcons.add, color: CupertinoColors.activeBlue),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CupertinoButton(
              onPressed: () {
                if (_selectedQuantity > 0) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => CheckoutPage(
                        medicine: widget.medicine,
                        quantity: _selectedQuantity.toString(),
                      ),
                    ),
                  );
                } else {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: const Text('Invalid Quantity'),
                        content: const Text('Please select a valid quantity'),
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
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: CupertinoColors.activeBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'Checkout',
                    style: TextStyle(fontSize: 18, color: CupertinoColors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


