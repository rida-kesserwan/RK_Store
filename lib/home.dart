import 'package:flutter/material.dart';
import 'product.dart';
import 'search.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _load = false; 

  void update(bool success) {
    setState(() {
      _load = true; 
      if (!success) { 
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('failed to load data')));
      }
    });
  }


  @override
  void initState() {
    // update data when the widget is added to the tree the first tome.
    updateProducts(update);
    super.initState();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      actions: [
        IconButton(
          onPressed: !_load
              ? null
              : () {
                  setState(() {
                    _load = false; // show progress bar
                    updateProducts(update); // update data asynchronously
                  });
                },
          icon: const Icon(Icons.refresh),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              // open the search product page
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const Search()),
              );
            });
          },
          icon: const Icon(Icons.search),
        ),
      ],
      title: const Text('RK Store'),
      centerTitle: true,
    ),
    body: _load
    ? Column(
        children: [
          const SizedBox(height: 20),
          Expanded(child: ShowProducts()),
        ],
      )
    : const Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(),
        ),
      ),
  );
}
}
