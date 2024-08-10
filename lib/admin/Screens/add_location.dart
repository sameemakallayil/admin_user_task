import 'package:flutter/material.dart';
import '../Services/location_service.dart';

class AddLocationScreen extends StatefulWidget {
  @override
  _AddLocationScreenState createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationService = LocationService();

  String _country = '';
  String _state = '';
  String _district = '';
  String _city = '';

  Future<void> _addLocation() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _locationService.addLocation(_country, _state, _district, _city);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location added successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding location: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextFormField('Country', (value) => _country = value!),
              SizedBox(height: 16.0),
              _buildTextFormField('State', (value) => _state = value!),
              SizedBox(height: 16.0),
              _buildTextFormField('District', (value) => _district = value!),
              SizedBox(height: 16.0),
              _buildTextFormField('City', (value) => _city = value!),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _addLocation,
                child: Text('Add Location'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, FormFieldSetter<String> onSaved) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      onSaved: onSaved,
      validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
    );
  }
}
