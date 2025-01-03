import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


const String _baseURL = 'ridak.atwebpages.com';

class Product {
  final int pid;
  final String name;
  final int quantity;
  final double price;
  final String category;
  final String image;

  Product(this.pid, this.name, this.quantity, this.price, this.category, this.image);

  @override
  String toString() {
    return '$name\nQuantity: $quantity\nPrice: \$$price';
  }
}


List<Product> _products = [];
List<Product> catproducts = [];


void updateProducts(Function(bool success) update) async {
  try {
    final url = Uri.parse('http://ridak.atwebpages.com/getProducts.php');

    final response = await http.get(url).timeout(const Duration(seconds: 5));

    _products.clear();
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      for (var row in jsonResponse) {
        Product p = Product(
          int.parse(row['pid']), 
          row['name'], 
          int.parse(row['qty']), 
          double.parse(row['price']), 
          row['category_name'], 
          row['image'], 
        );
        _products.add(p);
      }
      update(true);
    } else {
      update(false);
    }
  } catch (e) {
    update(false);
  }
}

void searchProduct(Function(String text) update, String cat) async {
  try {
    final url = Uri.http(_baseURL, 'getPrdByCat.php', {'category': cat});
    final response = await http.get(url).timeout(const Duration(seconds: 5));
    catproducts.clear();
    
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      
        for (var row in jsonResponse) {
          Product p = Product(
            int.parse(row['pid'].toString()), 
            row['name'].toString(), 
            int.parse(row['qty'].toString()), 
            double.parse(row['price'].toString()), 
            row['category_name'].toString(), 
            row['image'].toString(),
            
          );
          catproducts.add(p);
        }
        update('Products loaded successfully');
    } else {
      update('Failed to load products');
    }
  } catch (e) {
    print("Error: $e");
    update("Can't load data");
  }
}


class ShowProducts extends StatelessWidget {
  const ShowProducts({super.key});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: _products.length + 1,  
      itemBuilder: (context, index) {
        if (index == 0) {  
          return Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Browse our latest products',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        }
        
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
                    _products[index - 1].image,  
                    width: width * 0.2,
                    height: width * 0.2,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported),
                  ),
                  SizedBox(width: width * 0.05),
                  Flexible(
                    child: Text(
                      _products[index - 1].toString(),  
                      style: TextStyle(fontSize: width * 0.045),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}