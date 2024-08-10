import 'package:flutter/material.dart';
import '../Services/weather_service.dart';
import '../model/location_model.dart';

class WeatherReportScreen extends StatelessWidget {
  final WeatherService _weatherService = WeatherService();
  final List<LocationModel> locations;

  WeatherReportScreen({required this.locations});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Report'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _weatherLayout1(locations),
            _weatherLayout2(locations),
            _weatherLayout3(locations),
            _weatherLayout4(locations),
            _weatherLayout5(locations),
          ],
        ),
      ),
    );
  }

  Widget _weatherLayout1(List<LocationModel> locations) {
    return _buildWeatherCard(
      title: 'Weather Layout 1',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: locations.map((location) => ListTile(
          title: Text(location.city.isNotEmpty ? location.city : 'N/A'),
          subtitle: Text('${location.district}, ${location.state}, ${location.country}'),
          trailing: Text('Temp: ${location.weatherData?['temperature'] ?? 'N/A'}°C'),
        )).toList(),
      ),
    );
  }

  Widget _weatherLayout2(List<LocationModel> locations) {
    return _buildWeatherCard(
      title: 'Weather Layout 2',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: locations.map((location) => ListTile(
          title: Text(location.city.isNotEmpty ? location.city : 'N/A'),
          subtitle: Text('Weather: ${location.weatherData?['description'] ?? 'N/A'}'),
        )).toList(),
      ),
    );
  }

  Widget _weatherLayout3(List<LocationModel> locations) {
    return _buildWeatherCard(
      title: 'Weather Layout 3',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: locations.map((location) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('City: ${location.city}', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Humidity: ${location.weatherData?['humidity'] ?? 'N/A'}%'),
              Text('Wind Speed: ${location.weatherData?['windSpeed'] ?? 'N/A'} m/s'),
              Divider(),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _weatherLayout4(List<LocationModel> locations) {
    return _buildWeatherCard(
      title: 'Weather Layout 4',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: locations.map((location) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${location.city}, ${location.country}'),
            Text('${location.weatherData?['temperature'] ?? 'N/A'}°C, ${location.weatherData?['description'] ?? 'N/A'}'),
          ],
        )).toList(),
      ),
    );
  }

  Widget _weatherLayout5(List<LocationModel> locations) {
    return _buildWeatherCard(
      title: 'Weather Layout 5',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: locations.map((location) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Location: ${location.city}, ${location.state}, ${location.country}', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Temp: ${location.weatherData?['temperature'] ?? 'N/A'}°C'),
              Text('Conditions: ${location.weatherData?['description'] ?? 'N/A'}'),
              Divider(),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildWeatherCard({required String title, required Widget child}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
