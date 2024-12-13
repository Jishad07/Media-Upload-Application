import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  // ignore: prefer_const_constructors_in_immutables
  CustomAppBar({required this.title, super.key});

  @override
  final Size preferredSize =
      const Size.fromHeight(56.0); 

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
        onPressed: () {
          // Navigator.of(context).push(MaterialPageRoute(builder: ()=>HomeScreen()))
        },
        icon: const Icon(Icons.arrow_back),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.teal,
    );
  }
}
