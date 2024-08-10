import 'package:cloud_firestore/cloud_firestore.dart';

import '../../User/model/location_model.dart';

class LocationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addLocation(String country, String state, String district, String city) async {
    await _firestore.collection('locations').add({
      'country': country,
      'state': state,
      'district': district,
      'city': city,
    });
  }
  Stream<List<LocationModel>> getLocations() {
    return _firestore.collection('locations').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return LocationModel(
          country: doc['country'],
          state: doc['state'],
          district: doc['district'],
          city: doc['city'],
        );
      }).toList();
    });
  }
}