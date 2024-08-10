import 'package:admin_user_task/User/Screens/weather_report.dart';
import 'package:flutter/material.dart';
import '../../admin/Services/location_service.dart';
import '../Services/weather_service.dart';
import '../model/location_model.dart';
import '../services/excel_service.dart';

class UploadExcelScreen extends StatefulWidget {
  @override
  _UploadExcelScreenState createState() => _UploadExcelScreenState();
}

class _UploadExcelScreenState extends State<UploadExcelScreen> {
  final ExcelService _excelService = ExcelService();
  final LocationService _locationService = LocationService();
  final WeatherService _weatherService = WeatherService();

  bool _isLoading = false;
  List<LocationModel> _parsedLocations = [];

  Future<void> _uploadExcel() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _parsedLocations = await _excelService.uploadAndParseExcel();
      // Step 2: Fetch weather reports for each location
      for (var location in _parsedLocations) {
        try {
          // Fetch weather data for the current location
          final weatherData = await _weatherService.getWeatherReport(location.city, location.country);

          // Store the weather data in the location object
          setState(() {
            location.weatherData = weatherData;
          });
        } catch (e) {
          print('Error fetching weather for ${location.city}, ${location.country}: $e');
          // Optionally, handle errors (e.g., set default values or show error messages)
        }
      // for (var i = 0; i < _parsedLocations.length; i++) {
      //   setState(() {
      //     _parsedLocations[i] = LocationModel(
      //       country: _parsedLocations[i].country,
      //       state: _parsedLocations[i].state,
      //       district: _parsedLocations[i].district,
      //       city: _parsedLocations[i].city,
      //       weatherData: {'report': i % 5},
      //     );
      //   });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Excel file parsed successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error parsing Excel file: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveLocations() async {
    if (_parsedLocations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No locations to save. Please upload an Excel file first.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      for (var location in _parsedLocations) {
        await _locationService.addLocation(
          location.country,
          location.state,
          location.district,
          location.city,
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Locations saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving locations: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _viewWeatherReport() {
    if (_parsedLocations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No weather data available. Please upload an Excel file first.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeatherReportScreen(locations: _parsedLocations),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Excel and Weather'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _uploadExcel,
              child: _isLoading
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 8),
                  Text('Processing...'),
                ],
              )
                  : Text('Select and Parse Excel File'),
            ),
            SizedBox(height: 16),
            if (_parsedLocations.isNotEmpty) ...[
              Text(
                'Parsed Locations:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _parsedLocations.length,
                  itemBuilder: (context, index) {
                    final location = _parsedLocations[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(
                          location.city.isNotEmpty ? location.city : 'N/A',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${location.district.isNotEmpty ? location.district + ', ' : ''}'
                              '${location.state.isNotEmpty ? location.state + ', ' : ''}'
                              '${location.country}',
                        ),
                        leading: Icon(Icons.location_city),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveLocations,
                child: _isLoading
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 8),
                    Text('Saving...'),
                  ],
                )
                    : Text('Save Locations'),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: _viewWeatherReport,
                child: Text('View Weather Report'),
              ),
            ],
            if (_isLoading && _parsedLocations.isEmpty)
              Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}