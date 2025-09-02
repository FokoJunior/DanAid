import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      automaticallyImplyLeading: true, // Ensures back button is shown
      title: Row(
        children: [
          Image.asset(
            'assets/logo/logo.png',
            height: 36, // Increased logo size
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      centerTitle: false,
      iconTheme: IconThemeData(color: Colors.black87), // For back button
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
