import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String? _selectedCategory;
  List<String> _categories = [];
  String _text = '';

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void update(String text) {
    setState(() {
      _text = text;
    });
  }

  void fetchCategories() async {
    final url = Uri.parse('http://ridak.atwebpages.com/getCategory.php');
    final response = await http.get(url).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _categories = data.map((category) => category['name'] as String).toList();
        });
      } catch (e) {
        setState(() {
          _categories = [];
        });
        _text = 'Failed to load categories';
      }
    } else {
      setState(() {
        _categories = [];
      });
      _text = 'Failed to load categories';
    }
  }

  void getProduct() {
    if (_selectedCategory == null || _selectedCategory!.isEmpty) {
      setState(() {
        _text = 'Please select a category.';
      });
      return;
    }
    searchProduct(update, _selectedCategory!);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Products'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            SizedBox(
              width: 200,
              child: DropdownButton<String>(
                value: _selectedCategory,
                hint: const Text('Select Category'),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                    _text = '';
                  });
                },
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: getProduct,
              child: const Text('Find', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 10),
            Center(
              child: SizedBox(
                width: 200,
                child: Text(
                  _text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: catproducts.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(5),
                        width: width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Image.network(
                              catproducts[index].image,
                              width: width * 0.2,
                              height: width * 0.2,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.image_not_supported),
                            ),
                            SizedBox(width: width * 0.05),
                            Flexible(
                              child: Text(
                                catproducts[index].toString(),
                                style: TextStyle(fontSize: width * 0.045),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}