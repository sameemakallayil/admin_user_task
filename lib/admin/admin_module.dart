import 'package:flutter/material.dart';
import '../shared/widget/footer_widget.dart';
import '../shared/widget/navbar_widget.dart';
import 'Screens/add_location.dart';
import 'Screens/admin_dashboard.dart';

class AdminModule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavbarWidget(userType: 'admin'),
      body: AdminDashboardScreen(),
      bottomNavigationBar: FooterWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddLocationScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}