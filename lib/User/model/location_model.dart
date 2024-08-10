class LocationModel {
  final String country;
  final String state;
  final String district;
  final String city;
  Map<String, dynamic>? weatherData;

  LocationModel({required this.country, required this.state, required this.district, required this.city, this.weatherData,});
}