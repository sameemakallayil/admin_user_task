import 'package:flutter/material.dart';


import '../shared/widget/footer_widget.dart';
import '../shared/widget/navbar_widget.dart';
import 'Screens/upload_excel.dart';
import 'Screens/user_dashboard.dart';

class UserModule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavbarWidget(userType: 'user'),
      body: UserDashboardScreen(),
      bottomNavigationBar: FooterWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => UploadExcelScreen()),
          );
        },
        child: Icon(Icons.file_upload),
      ),
    );
  }
}