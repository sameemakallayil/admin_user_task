import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.blueGrey[800], // Background color of the footer
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '© 2024 Your Company', // Example footer text
              style: TextStyle(
                color: Colors.white, // Text color
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.info_outline, color: Colors.white),
                  tooltip: 'About Us',
                  onPressed: () {
                    // Add functionality to navigate to About Us page
                  },
                ),
                IconButton(
                  icon: Icon(Icons.contact_mail, color: Colors.white),
                  tooltip: 'Contact Us',
                  onPressed: () {
                    // Add functionality to navigate to Contact Us page
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
