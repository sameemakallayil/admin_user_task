import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import '../model/location_model.dart';

class ExcelService {
  Future<List<LocationModel>> uploadAndParseExcel() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        var bytes = file.readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);

        List<LocationModel> locations = [];
        for (var table in excel.tables.keys) {
          var sheet = excel.tables[table];
          if (sheet == null) continue;

          // Find column indices
          var headers = sheet.rows.first;
          int countryIndex = headers.indexWhere((cell) => cell?.value.toString().toLowerCase() == 'country');
          int stateIndex = headers.indexWhere((cell) => cell?.value.toString().toLowerCase() == 'state');
          int districtIndex = headers.indexWhere((cell) => cell?.value.toString().toLowerCase() == 'district');
          int cityIndex = headers.indexWhere((cell) => cell?.value.toString().toLowerCase() == 'city');

          // Parse rows
          for (int i = 1; i < sheet.rows.length; i++) {
            var row = sheet.rows[i];
            String country = countryIndex >= 0 ? row[countryIndex]?.value.toString() ?? '' : '';
            String state = stateIndex >= 0 ? row[stateIndex]?.value.toString() ?? '' : '';
            String district = districtIndex >= 0 ? row[districtIndex]?.value.toString() ?? '' : '';
            String city = cityIndex >= 0 ? row[cityIndex]?.value.toString() ?? '' : '';

            if (country.isNotEmpty || state.isNotEmpty || district.isNotEmpty || city.isNotEmpty) {
              locations.add(LocationModel(
                country: country,
                state: state,
                district: district,
                city: city,
              ));
            }
          }
        }

        return locations;
      } else {
        // User canceled the picker
        return [];
      }
    } catch (e) {
      print('Error parsing Excel: $e');
      rethrow;
    }
  }
}