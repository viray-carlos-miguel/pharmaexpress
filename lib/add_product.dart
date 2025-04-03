import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    CupertinoApp(
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
      ],
      home: const AddProductPage(),
    ),
  );
}

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  File? _imageFile;

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a price';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid price';
    }
    return null;
  }

  String? _validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a quantity';
    }
    if (int.tryParse(value) == null) {
      return 'Please enter a valid quantity';
    }
    return null;
  }

  Future<String> _uploadImage(File image) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('http://192.168.1.251/api/upload_image.php'));
      var multipartFile = await http.MultipartFile.fromBytes(
        'image',
        await image.readAsBytes(),
        filename: image.path.split('/').last,
      );

      request.files.add(multipartFile);

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var responseJson = jsonDecode(responseData);
        return responseJson['success'] ? responseJson['image_url'] ?? '' : '';
      } else {
        throw Exception('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  Future<void> _addProduct() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.251/api/add_medicines.php'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'name': _nameController.text,
          'price': _priceController.text,
          'quantity_available': _quantityController.text,
          'image_url': _imageFile != null ? await _uploadImage(_imageFile!) : '',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = jsonDecode(response.body);
        if (responseJson['success']) {
          showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text('Success'),
                content: const Text('Product added successfully'),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                      Navigator.pop(context); // Close the AddProductPage
                    },
                  ),
                ],
              );
            },
          );
        } else {
          showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text('Error'),
                content: Text('Failed to add product: ${responseJson['message']}'),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('Error'),
              content: Text('An error occurred while adding the product. Status code: ${response.statusCode}'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Error'),
            content: Text('An error occurred while adding the product: $e'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _selectImage() async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Error'),
            content: Text('Error selecting image: $e'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Add New Product"),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CupertinoFormRow(
                error: Text(_validateName(_nameController.text) ?? ''),
                child: CupertinoTextField(
                  controller: _nameController,
                  placeholder: 'Product Name',
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  style: TextStyle(fontSize: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: CupertinoColors.systemGrey5,
                    border: Border.all(color: CupertinoColors.systemGrey2),
                  ),
                ),
              ),
              CupertinoFormRow(
                error: Text(_validatePrice(_priceController.text) ?? ''),
                child: CupertinoTextField(
                  controller: _priceController,
                  placeholder: 'Price (\$)',
                  keyboardType: TextInputType.number,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  style: TextStyle(fontSize: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: CupertinoColors.systemGrey5,
                    border: Border.all(color: CupertinoColors.systemGrey2),
                  ),
                ),
              ),
              CupertinoFormRow(
                error: Text(_validateQuantity(_quantityController.text) ?? ''),
                child: CupertinoTextField(
                  controller: _quantityController,
                  placeholder: 'Quantity Available',
                  keyboardType: TextInputType.number,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  style: TextStyle(fontSize: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: CupertinoColors.systemGrey5,
                    border: Border.all(color: CupertinoColors.systemGrey2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CupertinoButton(
                onPressed: _selectImage,
                child: const Text("Select Image"),
                color: CupertinoColors.activeBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              if (_imageFile != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _imageFile!,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              CupertinoButton.filled(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addProduct();
                  }
                },
                child: const Text("Add Product"),
                borderRadius: BorderRadius.circular(8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
