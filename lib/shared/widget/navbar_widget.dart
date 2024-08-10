import 'package:flutter/material.dart';
import '../../Services/auth_service.dart';

class NavbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final AuthService _authService = AuthService();
  final String userType;

  NavbarWidget({Key? key, required this.userType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        userType == 'admin' ? 'Admin Dashboard' : 'User Dashboard',
        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
      ),
      backgroundColor: Colors.blueGrey, // Match your app's color scheme
      actions: [
        IconButton(
          icon: Icon(Icons.logout,color: Colors.white,),
          tooltip: 'Logout',
          onPressed: () async {
            bool confirmed = await _showLogoutConfirmationDialog(context);
            if (confirmed) {
              await _authService.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            }
          },
        ),
      ],
    );
  }

  Future<bool> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            ElevatedButton(
              child: Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
