import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  final String _apiKey = '1e87a76ae6b119dc2ec11dabcb84c052'; // Replace with your actual API key
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> getWeatherReport(String city, String country) async {
    final response = await http.get(Uri.parse('$_baseUrl?q=$city,$country&appid=$_apiKey&units=metric'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return {
        'location': '$city, $country',
        'temperature': data['main']['temp'],
        'description': data['weather'][0]['description'],
        'humidity': data['main']['humidity'],
        'windSpeed': data['wind']['speed'],
      };
    } else {
      throw Exception('Failed to load weather data for $city, $country');
    }
  }

  Future<List<Map<String, dynamic>>> getWeatherReports(List<Map<String, dynamic>> locations) async {
    List<Map<String, dynamic>> weatherReports = [];

    for (var location in locations) {
      String city = location['city'];
      String country = location['country'];

      try {
        Map<String, dynamic> report = await getWeatherReport(city, country);
        weatherReports.add(report);
      } catch (e) {
        print('Error fetching weather for $city, $country: $e');
        // You might want to add an error entry to weatherReports here
      }
    }

    return weatherReports;
  }
}