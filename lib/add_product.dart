import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    CupertinoApp(
      debugShowCheckedModeBanner: false,
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
    if (value == null || value.isEmpty) return 'Please enter a name';
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a price';
    if (double.tryParse(value) == null) return 'Please enter a valid price';
    return null;
  }

  String? _validateQuantity(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a quantity';
    if (int.tryParse(value) == null) return 'Please enter a valid quantity';
    return null;
  }

  Future<String> _uploadImage(File image) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.251/api/upload_image.php'),
      );
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

      final responseJson = jsonDecode(response.body);
      final isSuccess = responseJson['success'];

      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text(isSuccess ? 'Success' : 'Error'),
          content: Text(isSuccess
              ? 'Product added successfully'
              : 'Failed to add product: ${responseJson['message']}'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                if (isSuccess) Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    } catch (e) {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text('An error occurred while adding the product: $e'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
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
        builder: (_) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text('Error selecting image: $e'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
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
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CupertinoTextField(
                  controller: _nameController,
                  placeholder: 'Product Name',
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey5,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 16),
                CupertinoTextField(
                  controller: _priceController,
                  placeholder: 'Price (\$)',
                  keyboardType: TextInputType.number,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey5,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 16),
                CupertinoTextField(
                  controller: _quantityController,
                  placeholder: 'Quantity Available',
                  keyboardType: TextInputType.number,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey5,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 20),
                CupertinoButton(
                  onPressed: _selectImage,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: CupertinoColors.activeBlue,
                  borderRadius: BorderRadius.circular(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(CupertinoIcons.cloud_upload, color: CupertinoColors.white),
                      const SizedBox(width: 8),
                      Text(
                        _imageFile == null ? "Upload Image Here" : "Change Image",
                        style: const TextStyle(color: CupertinoColors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                if (_imageFile != null)
                  Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: CupertinoColors.systemGrey3),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemGrey.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 30),
                CupertinoButton.filled(
                  borderRadius: BorderRadius.circular(8),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _addProduct();
                    }
                  },
                  child: const Text("Add Product"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
