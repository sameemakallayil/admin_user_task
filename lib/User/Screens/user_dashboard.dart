import 'package:admin_user_task/User/Screens/upload_excel.dart';
import 'package:flutter/material.dart';

import '../../admin/Services/location_service.dart';
import '../model/location_model.dart';

class UserDashboardScreen extends StatelessWidget {
  final LocationService _locationService = LocationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: StreamBuilder<List<LocationModel>>(
        stream: _locationService.getLocations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No locations added yet. Tap the button below to upload an Excel file.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final location = snapshot.data![index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: Icon(Icons.location_city, color: Colors.blue),
                  title: Text(
                    location.city,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    '${location.district}, ${location.state}, ${location.country}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UploadExcelScreen()),
          );
        },
        child: Icon(Icons.upload_file),
        tooltip: 'Upload Excel',
        backgroundColor: Colors.blue,
      ),
    );
  }
}